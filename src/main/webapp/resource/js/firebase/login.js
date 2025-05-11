import { db } from './firebase-init.js';
import { ref, get } from 'https://www.gstatic.com/firebasejs/11.7.1/firebase-database.js';

document.getElementById('loginForm').addEventListener('submit', async (e) => {
	e.preventDefault();

	const id = document.getElementById('login-id').value;
	const password = document.getElementById('login-pass').value;
	const errorMessage = document.getElementById('error-message');

	try {
		const managerRef = ref(db, `Manager/manager_ID/${id}`);
		const snapshot = await get(managerRef);

		if (snapshot.exists()) {
			const manager = snapshot.val();
			if (manager.pw === password) {
				// 로그인 성공 시 세션 스토리지에 저장
				sessionStorage.setItem('managerId', id);
				sessionStorage.setItem('managerName', manager.name);
				sessionStorage.setItem('managerRegion', manager.region);
				fetch('loginSuccess.jsp', {
				    method: 'POST',
				    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
				    body: `managerId=${encodeURIComponent(id)}&managerName=${encodeURIComponent(manager.name)}&managerRegion=${encodeURIComponent(manager.region)}`
				  })
				  .then(response => {
				    if (!response.ok) {
				      throw new Error(`HTTP error! Status: ${response.status}`);
				    }
				    return response.text();
				  })
				  .then(data => {
				    if (data.trim() === "OK") {
				      window.location.href = "mainPage.jsp";
				    } else {
				      showError("세션 저장 실패");
				    }
				  })
				  .catch(error => {
				    showError("서버 오류: " + error.message);
				  });
			} else {
				showError("잘못된 비밀번호입니다.");
			}
		} else {
			showError("존재하지 않는 아이디입니다.");
		}
	} catch (error) {
		console.error("로그인 오류:", error);
		showError("로그인 처리 중 오류가 발생했습니다.");
	}
});

function showError(message) {
	const errorDiv = document.getElementById('error-message');
	errorDiv.textContent = message;
	errorDiv.style.display = 'block';
}