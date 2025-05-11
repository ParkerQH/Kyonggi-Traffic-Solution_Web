import { db } from './firebase-init.js';
import { ref, get, set } from 'https://www.gstatic.com/firebasejs/11.7.1/firebase-database.js';

document.getElementById('registerForm').addEventListener('submit', async (e) => {
	e.preventDefault();

	const id = document.getElementById('register-id').value;
	const password = document.getElementById('register-pass').value;
	const name = document.getElementById('register-name').value;
	const managerClass = document.getElementById('register-class').value;
	const region = document.getElementById('register-region').value;

	const notification = document.getElementById('notification');

	try {
		// 아이디 중복 확인
		const managerRef = ref(db, `Manager/manager_ID/${id}`);
		const snapshot = await get(managerRef);

		if (snapshot.exists()) {
			showNotification("이미 존재하는 아이디입니다.", "error");
		} else {
			// 관리자 정보 저장
			await set(managerRef, {
				name: name,
				pw: password,
				class: managerClass,
				region: region
			});
			showNotification(`${name}님, 환영합니다! 3초 후 로그인 페이지로 이동합니다.`, "success");
			setTimeout(() => {
				window.location.href = "login.jsp";
			}, 3000);
		}
	} catch (error) {
		console.error("회원가입 오류:", error);
		showNotification("회원가입 중 오류가 발생했습니다.", "error");
	}
});

function showNotification(message, type) {
	const notification = document.getElementById('notification');
	notification.textContent = message;
	notification.className = `notification ${type}`;
	notification.style.display = 'block';
	setTimeout(() => {
		notification.style.display = 'none';
	}, 3000);
}