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
	
});            