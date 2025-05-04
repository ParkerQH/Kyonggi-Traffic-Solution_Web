document.addEventListener('DOMContentLoaded', function() {
  var modeSwitch = document.querySelector('.mode-switch');
  if (modeSwitch) {
    // 페이지 로드 시 로컬스토리지에서 다크모드 상태 확인
    if (localStorage.getItem('dark-mode') === 'true') {
      document.documentElement.classList.add('dark');
      modeSwitch.classList.add('active');
    }

    modeSwitch.addEventListener('click', function() {
      document.documentElement.classList.toggle('dark');
      modeSwitch.classList.toggle('active');
      if (document.documentElement.classList.contains('dark')) {
        localStorage.setItem('dark-mode', 'true');
      } else {
        localStorage.setItem('dark-mode', 'false');
      }
    });
  }

  var listView = document.querySelector('.list-view');
  var gridView = document.querySelector('.grid-view');
  var projectsList = document.querySelector('.project-boxes');
  if (listView && gridView && projectsList) {
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
  }

  var messagesBtn = document.querySelector('.messages-btn');
  var messagesSection = document.querySelector('.messages-section');
  var messagesClose = document.querySelector('.messages-close');
  if (messagesBtn && messagesSection && messagesClose) {
    messagesBtn.addEventListener('click', function() {
      messagesSection.classList.add('show');
    });
    messagesClose.addEventListener('click', function() {
      messagesSection.classList.remove('show');
    });
  }

  var sidebarLinks = document.querySelectorAll('.app-sidebar-link');
  if (sidebarLinks.length > 0) {
    sidebarLinks.forEach(function(link) {
      link.addEventListener('click', function() {
        sidebarLinks.forEach(function(l) {
          l.classList.remove('active');
        });
        link.classList.add('active');
      });
    });

    sidebarLinks.forEach((link) => {
      link.addEventListener("click", function(event) {
        event.preventDefault();
        let filter = this.getAttribute("data-filter");
        let currentUrl = new URL(window.location.href);
        currentUrl.searchParams.set("filter", filter);
        window.location.href = currentUrl.toString();
      });
    });
  }
});
