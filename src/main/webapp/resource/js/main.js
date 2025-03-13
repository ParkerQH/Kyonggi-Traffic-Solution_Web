document.addEventListener('DOMContentLoaded', function() {
	var modeSwitch = document.querySelector('.mode-switch');
	modeSwitch.addEventListener('click', function() {
		document.documentElement.classList.toggle('dark');
		modeSwitch.classList.toggle('active');
	});
	var listView = document.querySelector('.list-view');
	var gridView = document.querySelector('.grid-view');
	var projectsList = document.querySelector('.project-boxes');
	listView.addEventListener('click', function() {
		gridView.classList.remove('active');
		listView.classList.add('active');
		projectsList.classList.remove('jsGridView');
		projectsList.classList.add('jsListView');
	});
	gridView.addEventListener('click', function() {
		gridView.classList.add('active');
		listView.classList.remove('active');
		projectsList.classList.remove('jsListView');
		projectsList.classList.add('jsGridView');
	});
	document.querySelector('.messages-btn').addEventListener('click', function() {
		document.querySelector('.messages-section').classList.add('show');
	});
	document.querySelector('.messages-close').addEventListener('click', function() {
		document.querySelector('.messages-section').classList.remove('show');
	});

	var sidebarLinks = document.querySelectorAll('.app-sidebar-link');
	sidebarLinks.forEach(function(link) {
		link.addEventListener('click', function() {
			// 모든 링크에서 active 클래스 제거
			sidebarLinks.forEach(function(l) {
				l.classList.remove('active');
			});
			// 클릭한 링크에 active 클래스 추가
			link.classList.add('active');
		});
	});
	
	document.querySelectorAll(".app-sidebar-link").forEach((link) => {
	        link.addEventListener("click", function (event) {
	            event.preventDefault(); // 기본 동작 막기

	            let filter = this.getAttribute("data-filter"); // 클릭한 버튼의 data-filter 값 가져오기
	            console.log("선택한 필터:", filter); // 콘솔 확인

	            // 현재 URL을 변경하여 필터 값 전달
	            let currentUrl = new URL(window.location.href);
	            currentUrl.searchParams.set("filter", filter);
	            window.location.href = currentUrl.toString();
	        });
	    });

});            