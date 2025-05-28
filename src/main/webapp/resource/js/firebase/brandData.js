import { getFirestore, Timestamp, collection, query, where, getDocs } from "https://www.gstatic.com/firebasejs/11.8.1/firebase-firestore.js";
import { db } from './firebase-init.js';

// 오늘 날짜 포맷
function getTodayString() {
	const today = new Date();
	return today.toLocaleDateString('ko-KR', { year: 'numeric', month: '2-digit', day: '2-digit' });
}

// 색상 배열 (기존과 동일)
const colorPalette = [
	{ bg: "#fee4cb", bar: "#ff942e" },
	{ bg: "#e9e7fd", bar: "#4f3ff0" },
	{ bg: "#dbf6fd", bar: "#096c86" },
	{ bg: "#ffd3e2", bar: "#df3670" },
	{ bg: "#c8f7dc", bar: "#34c471" },
	{ bg: "#d5deff", bar: "#4067f9" }
];

// Firestore에서 승인된 conclusion 데이터 가져오기
async function fetchApprovedConclusions() {
	try {
		const managerId = sessionStorage.getItem('managerUid'); // 현재 세션 관리자 UID
		const filter = new URLSearchParams(window.location.search).get('filter');
		const today = new Date();
		today.setHours(0, 0, 0, 0);
		const tomorrow = new Date(today);
		tomorrow.setDate(today.getDate() + 1);

		let q;
		if (filter === "send" || filter === null) {
			// 오늘 날짜만 필터링
			q = query(
				collection(db, "Conclusion"),
				where('result', '==', '승인'),
				where('managerId', '==', managerId),
				where('processingDate', '>=', today),
				where('processingDate', '<', tomorrow)
			);
		} else if (filter === "list") {
			// 전체 승인된 데이터
			q = query(
				collection(db, 'Conclusion'),
				where('result', '==', '승인'),
				where('managerId', '==', managerId)
			);
		}

		const querySnapshot = await getDocs(q);
		const conclusions = [];
		querySnapshot.forEach((doc) => {
			conclusions.push({ id: doc.id, ...doc.data() });
		});

		return conclusions;
	} catch (error) {
		console.error('데이터 가져오기 실패:', error);
		return [];
	}
}

// 다음 날 계산 (날짜 범위 쿼리용)
function getNextDay(dateStr) {
	const date = new Date(dateStr);
	date.setDate(date.getDate() + 1);
	return date.toLocaleDateString('ko-KR', { year: 'numeric', month: '2-digit', day: '2-digit' });
}

// 데이터를 날짜+브랜드별로 그룹화
function groupByDateAndBrand(conclusions) {
	const groups = {};

	conclusions.forEach(conclusion => {
		// Timestamp → Date → 문자열 변환
		let dateStr;
		if (conclusion.processingDate?.toDate) {
			const dateObj = conclusion.processingDate.toDate();
			dateStr = dateObj.toLocaleDateString('ko-KR', {
				year: 'numeric',
				month: '2-digit',
				day: '2-digit'
			});
		} else {
			// 이미 문자열인 경우 (예: "2025. 05. 28")
			dateStr = conclusion.processingDate?.split(' ')[0] || '';
		}

		const brand = conclusion.detectedBrand || '알 수 없음';
		const key = `${dateStr}_${brand}`;

		if (!groups[key]) {
			groups[key] = { date: dateStr, brand: brand, count: 0, conclusions: [] };
		}
		groups[key].count++;
		groups[key].conclusions.push(conclusion);
	});

	return Object.values(groups);
}

// HTML 렌더링
function renderBrandData(groupedData, totalCount) {
	const container = document.getElementById('brand-data-list');

	if (groupedData.length === 0) {
		container.innerHTML = '<div class="no-data">승인된 데이터가 없습니다.</div>';
		return;
	}

	let html = '';
	groupedData.forEach((group, index) => {
		const color = colorPalette[index % 6];
		const percentage = Math.round((group.count / totalCount) * 100);
		const encodedBg = encodeURIComponent(color.bg);
		const encodedBar = encodeURIComponent(color.bar);

		html += `
        <div class="project-box-wrapper">
            <div class="project-box" style="background-color: ${color.bg};">
                <div class="project-box-header">
                    <span>${group.date}</span>
                    <div class="more-wrapper">
                        <button class="project-btn-more">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24"
                                viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                stroke-width="2" stroke-linecap="round"
                                stroke-linejoin="round" class="feather feather-check-circle">
                                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                <polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                        </button>
                    </div>
                </div>
                <div class="project-box-content-header">
                    <p class="box-content-header">${group.brand}</p>
                    <p class="box-content-subheader">${group.date}일자 접수 내역</p>
                </div>
                <div class="box-progress-wrapper">
                    <p class="box-progress-header">신고 점유율</p>
                    <div class="box-progress-bar">
                        <span class="box-progress" style="width: ${percentage}%; background-color: ${color.bar}"></span>
                    </div>
                    <p class="box-progress-percentage">${percentage}%</p>
                </div>
                <div class="project-box-footer">
                    <div class="days-left" style="color: ${color.bar}; cursor: pointer;" 
                         onclick="downloadExcel('${group.brand}', '${group.date}');">다운로드</div>
                </div>
            </div>
        </div>`;
	});

	container.innerHTML = html;
}

// 엑셀 다운로드 (새로운 Firestore 기반)
window.downloadExcel = async function(brand, date) {
	try {
		const managerId = sessionStorage.getItem('managerId');
		const managerName = sessionStorage.getItem('managerName') || '';
		const managerRegion = sessionStorage.getItem('managerRegion') || '';

		// 해당 브랜드+날짜의 conclusion 데이터 가져오기
		const q = query(
			collection(db, 'Conclusion'),
			where('result', '==', '승인'),
			where('managerId', '==', managerId),
			where('detectedBrand', '==', brand),
			where('processingDate', '>=', date),
			where('processingDate', '<', getNextDay(date))
		);

		const querySnapshot = await getDocs(q);
		const data = [];

		querySnapshot.forEach((doc) => {
			const docData = doc.data();
			data.push({
				id: doc.id,
				detectedBrand: docData.detectedBrand || '',
				gpsInfo: docData.gpsInfo || '',
				region: docData.region || '',
				date: docData.date || '',
				reseon: docData.reseon || '',
				fine: docData.fine || 0
			});
		});

		// 엑셀 생성 및 다운로드 (별도 함수)
		generateExcel(data, brand, date, managerName, managerRegion);

	} catch (error) {
		console.error('엑셀 다운로드 실패:', error);
		alert('엑셀 다운로드에 실패했습니다.');
	}
};

// 엑셀 생성 함수 (SheetJS 라이브러리 사용 권장)
function generateExcel(data, brand, date, managerName, managerRegion) {
	// SheetJS 라이브러리가 필요함
	// <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>

	const worksheet = XLSX.utils.json_to_sheet(data, {
		header: ['id', 'detectedBrand', 'gpsInfo', 'region', 'date', 'reseon', 'fine']
	});

	const workbook = XLSX.utils.book_new();
	XLSX.utils.book_append_sheet(workbook, worksheet, '요청명단');

	const fileName = `${brand}_${date.replace(/\. /g, '')}.xlsx`;
	XLSX.writeFile(workbook, fileName);
}

// 메인 렌더링 함수
async function loadAndRenderBrandData() {
	try {
		const todayElement = document.getElementById('todayDate');
		const containerElement = document.getElementById('brand-data-list');

		// todayDate 요소가 존재하는지 확인
		if (todayElement) {
			todayElement.textContent = getTodayString();
		} else {
			console.warn('todayDate 요소를 찾을 수 없습니다.');
		}

		// brand-data-list 요소가 존재하는지 확인
		if (!containerElement) {
			console.error('brand-data-list 요소를 찾을 수 없습니다.');
			return;
		}

		// Firestore에서 데이터 가져오기
		const conclusions = await fetchApprovedConclusions();

		// 날짜+브랜드별 그룹화
		const groupedData = groupByDateAndBrand(conclusions);

		// 전체 카운트
		const totalCount = conclusions.length;

		// HTML 렌더링
		renderBrandData(groupedData, totalCount);

	} catch (error) {
		console.error('데이터 로딩 실패:', error);
		document.getElementById('brand-data-list').innerHTML = '<div class="error">데이터 로딩에 실패했습니다.</div>';
	}
}

// 페이지 로드 시 실행
document.addEventListener('DOMContentLoaded', loadAndRenderBrandData);
