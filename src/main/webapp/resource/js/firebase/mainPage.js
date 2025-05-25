import { collection, query, where, getCountFromServer, onSnapshot, orderBy, Timestamp } from 'https://www.gstatic.com/firebasejs/11.8.1/firebase-firestore.js';
import { db } from './firebase-init.js';

// 현재 날짜 및 이번 달 범위 계산
const now = new Date();
const currentYear = now.getFullYear();
const currentMonth = now.getMonth(); // 0-based (0=1월, 4=5월)

// 이번 달 시작일과 다음 달 시작일 (Firestore Timestamp)
const startOfMonth = Timestamp.fromDate(new Date(currentYear, currentMonth, 1));
const startOfNextMonth = Timestamp.fromDate(new Date(currentYear, currentMonth + 1, 1));

// 오늘 날짜 표시
document.getElementById('today-date').textContent = now.toLocaleDateString('ko-KR', {
	year: 'numeric', month: '2-digit', day: '2-digit'
});
document.getElementById('current-month').textContent = currentMonth + 1; // 1-based로 표시

// 이번 달 기준 상태별 카운트 집계
async function updateMonthlyStats() {
	try {
		// 1. 진행 중 (미확인): result가 null이면서 이번 달
		const qUnconfirmed = query(
			collection(db, "Conclusion"),
			where("date", ">=", startOfMonth),
			where("date", "<", startOfNextMonth),
			where("result", "==", '미확인')
		);
		const snapUnconfirmed = await getCountFromServer(qUnconfirmed);
		document.getElementById('count-unconfirmed').textContent = snapUnconfirmed.data().count;

		// 2. 완료 (승인): result가 "승인"이면서 이번 달
		const qApproved = query(
			collection(db, "Conclusion"),
			where("date", ">=", startOfMonth),
			where("date", "<", startOfNextMonth),
			where("result", "==", "승인")
		);
		const snapApproved = await getCountFromServer(qApproved);

		// 3. 완료 (반려): result가 "반려"이면서 이번 달
		const qRejected = query(
			collection(db, "Conclusion"),
			where("date", ">=", startOfMonth),
			where("date", "<", startOfNextMonth),
			where("result", "==", "반려")
		);
		const snapRejected = await getCountFromServer(qRejected);

		// 완료 = 승인 + 반려
		const completedCount = snapApproved.data().count + snapRejected.data().count;
		document.getElementById('count-completed').textContent = completedCount;

		// 4. 이번 달 전체 신고 건수
		const qTotal = query(
			collection(db, "Conclusion"),
			where("date", ">=", startOfMonth),
			where("date", "<", startOfNextMonth)
		);
		const snapTotal = await getCountFromServer(qTotal);
		document.getElementById('count-total').textContent = snapTotal.data().count;

	} catch (error) {
		console.error("월별 통계 집계 오류:", error);
		showError("통계를 불러오는 중 오류가 발생했습니다.");
	}
}

// 이번 달 신고 목록 실시간 표시
function subscribeMonthlyReports() {
	const listDiv = document.getElementById('conclusion-list');
	const q = query(
		collection(db, "Conclusion"),
		where("date", ">=", startOfMonth),
		where("date", "<", startOfNextMonth),
		orderBy("date", "desc")
	);

	onSnapshot(q, (snapshot) => {
		listDiv.innerHTML = '';
		let colorIndex = 0;
		const colors = [
			{ bg: "#fee4cb", bar: "#ff942e" },
			{ bg: "#e9e7fd", bar: "#4f3ff0" },
			{ bg: "#dbf6fd", bar: "#096c86" },
			{ bg: "#ffd3e2", bar: "#df3670" },
			{ bg: "#c8f7dc", bar: "#34c471" },
			{ bg: "#d5deff", bar: "#4067f9" }
		];

		snapshot.forEach(doc => {
			const data = doc.data();
			const color = colors[colorIndex % 6];
			colorIndex++;

			let statusIcon = '';
			if (data.result === "승인") {
				statusIcon = `<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-check-circle"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>`;
			} else if (data.result === "반려") {
				statusIcon = `<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-x-circle"><circle cx="12" cy="12" r="10"></circle><line x1="15" y1="9" x2="9" y2="15"></line><line x1="9" y1="9" x2="15" y2="15"></line></svg>`;
			} else {
				statusIcon = `<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-circle"><circle cx="12" cy="12" r="10"></circle></svg>`;
			}

			const dateStr = data.date ? data.date.toDate().toLocaleDateString('ko-KR', { year: 'numeric', month: '2-digit', day: '2-digit' }) : '';
			const confidence = (1-(data.confidence || 0)) * 100;
			const region = data.region || '';
			const regionShort = region.length > 25 ? region.slice(0, 25) + '…' : region;
			
			listDiv.innerHTML += `
                <div class="project-box-wrapper" onclick="window.location='conclusionPage.jsp?id=${doc.id}';" style="cursor: pointer;">
                    <div class="project-box" style="background-color: ${color.bg};">
                        <div class="project-box-header">
                            <span>${dateStr}</span>
                            <div class="more-wrapper">${statusIcon}</div>
                        </div>
                        <div class="project-box-content-header">
                            <p class="box-content-header">${data.violation || ''}</p>
                            <p class="box-content-subheader">${regionShort}</p>
                        </div>
                        <div class="box-progress-wrapper">
                            <p class="box-progress-header">AI 신뢰도</p>
                            <div class="box-progress-bar">
                                <span class="box-progress" style="width: ${confidence}%; background-color: ${color.bar}"></span>
                            </div>
                            <p class="box-progress-percentage">${Math.round(confidence)}%</p>
                        </div>
                    </div>
                </div>
            `;
		});

		if (snapshot.empty) {
			listDiv.innerHTML = `<div class="project-box"><div class="project-box-content">이번 달 신고 내역이 없습니다.</div></div>`;
		}
	});
}

function showError(message) {
	console.error(message);
	// 에러 표시 로직 추가
}

// 실행
updateMonthlyStats();
subscribeMonthlyReports();
