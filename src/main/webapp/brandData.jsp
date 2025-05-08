<%@page import="java.net.URLEncoder"%>
<%@page import="java.time.Period"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.util.Date, java.text.SimpleDateFormat, java.util.Locale, java.time.LocalDate, java.time.format.DateTimeFormatter"%>
<%@ page import="java.sql.*"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title></title>
<script>
	//화면 깜빡임 방지
	(function() {
		try {
			var isDark = localStorage.getItem('dark-mode') === 'true';
			if (isDark) {
				document.documentElement.classList.add('dark');
			}
		} catch (e) {
		}
	})();
</script>

<link rel="stylesheet" href="resource/css/main.css">
</head>
<%
if (session.getAttribute("managerId") == null) {
	response.sendRedirect("login.jsp");
	return;
}
%>
<body>
	<%@include file="dbconn.jsp"%>
	<div class="app-container">
		<%@include file="header.jsp"%>
		<%--상단 헤더 부분--%>
		<div class="app-content">
			<div class="app-sidebar">
				<%--왼쪽 사이드바 부분 아이콘/홈페이지, 진행중, 완료, 전체, 브랜드별--%>
				<a href="mainPage.jsp" class="app-sidebar-link"> <svg
						xmlns="http://www.w3.org/2000/svg" width="24" height="24"
						viewBox="0 0 24 24" fill="none" stroke="currentColor"
						stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
						class="feather feather-home"> <path
							d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" /> <polyline
							points="9 22 9 12 15 12 15 22" /></svg>
				</a> <a href="mainPage.jsp?filter=unconfirmed" class="app-sidebar-link">
					<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24"
						viewBox="0 0 24 24" fill="none" stroke="currentColor"
						stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
						class="feather feather-square">
						<rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect></svg>
				</a> <a href="mainPage.jsp?filter=confirmed" class="app-sidebar-link">
					<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24"
						viewBox="0 0 24 24" fill="none" stroke="currentColor"
						stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
						class="feather feather-check-square">
						<polyline points="9 11 12 14 22 4"></polyline>
						<path
							d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path></svg>
				</a> <a href="mainPage.jsp?filter=folder" class="app-sidebar-link">
					<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24"
						viewBox="0 0 24 24" fill="none" stroke="currentColor"
						stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
						class="feather feather-folder">
						<path
							d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"></path></svg>
				</a> <a href="brandData.jsp" class="app-sidebar-link" data-filter="send">
					<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24"
						viewBox="0 0 24 24" fill="none" stroke="currentColor"
						stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
						class="feather feather-send">
						<line x1="22" y1="2" x2="11" y2="13"></line>
						<polygon points="22 2 15 22 11 13 2 9 22 2"></polygon></svg>
				</a> <a href="brandData.jsp" class="app-sidebar-link" data-filter="list">
					<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24"
						viewBox="0 0 24 24" fill="none" stroke="currentColor"
						stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
						class="feather feather-archive">
						<polyline points="21 8 21 21 3 21 3 8"></polyline>
						<rect x="1" y="3" width="22" height="5"></rect>
						<line x1="10" y1="12" x2="14" y2="12"></line></svg>
				</a>
			</div>
			<div class="projects-section">
				<div class="projects-section-header">
					<a href="mainPage.jsp" style="text-decoration: none;"><p>브랜드별
							신고 내역</p></a>
					<%
					// 현재 날짜 가져오기
					LocalDate today = LocalDate.now();
					DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy. MM. dd");
					String todayDate = today.format(formatter);
					int month = LocalDate.now().getMonthValue();
					PreparedStatement pstmt = null;
					ResultSet rs = null;
					int count = 0;
					%>
					<p class="time"><%=todayDate%></p>
				</div>
				<div class="projects-section-line">
					<%--신고 접수 건수를 보여주는 부분--%>
					<div class="projects-status">
						<div class="item-status">
							<%
							String sql = "SELECT COUNT(*) FROM report INNER JOIN conclusion ON report.report_id = conclusion.report_id WHERE conclusion.result = ?"
									+ "AND report.date = '" + today + "' ;";
							pstmt = conn.prepareStatement(sql);
							pstmt.setString(1, "미확인");
							rs = pstmt.executeQuery();

							if (rs.next()) {
								count = rs.getInt(1);
							}
							%>
							<span class="status-number"><%=count%></span> <span
								class="status-type"><b>진행 중</b></span>
						</div>
						<div class="item-status">
							<%
							sql = "SELECT COUNT(*) FROM report INNER JOIN conclusion ON report.report_id = conclusion.report_id WHERE conclusion.result != ?"
									+ "AND report.date = '" + today + "' ;";
							pstmt = conn.prepareStatement(sql);
							pstmt.setString(1, "미확인");
							rs = pstmt.executeQuery();

							if (rs.next()) {
								count = rs.getInt(1);
							}
							%>
							<span class="status-number"><%=count%></span> <span
								class="status-type"><b>완료</b></span>
						</div>
						<div class="item-status">
							<%
							sql = "SELECT COUNT(*) FROM report WHERE report.date = '" + today + "';";
							pstmt = conn.prepareStatement(sql);
							rs = pstmt.executeQuery();

							if (rs.next()) {
								count = rs.getInt(1);
							}
							%>
							<span class="status-number"><%=count%></span> <span
								class="status-type"><b><%=month%>월 신고 건수</b></span>
						</div>
					</div>
					<div class="view-actions">
						<button class="view-btn list-view" title="List View">
							<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24"
								viewBox="0 0 24 24" fill="none" stroke="currentColor"
								stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
								class="feather feather-list">
        <line x1="8" y1="6" x2="21" y2="6" />
        <line x1="8" y1="12" x2="21" y2="12" />
        <line x1="8" y1="18" x2="21" y2="18" />
        <line x1="3" y1="6" x2="3.01" y2="6" />
        <line x1="3" y1="12" x2="3.01" y2="12" />
        <line x1="3" y1="18" x2="3.01" y2="18" /></svg>
						</button>
						<button class="view-btn grid-view active" title="Grid View">
							<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20"
								viewBox="0 0 24 24" fill="none" stroke="currentColor"
								stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
								class="feather feather-grid">
        <rect x="3" y="3" width="7" height="7" />
        <rect x="14" y="3" width="7" height="7" />
        <rect x="14" y="14" width="7" height="7" />
        <rect x="3" y="14" width="7" height="7" /></svg>
						</button>
					</div>
				</div>
				<div class="project-boxes jsGridView">
					<%
					int n = 0;
					String background;
					String bar;
					String filter = request.getParameter("filter");

					try {
						if ("send".equals(filter) || filter == null) {
							sql = "SELECT conclusion.brand, conclusion.date , COUNT(*) FROM report INNER JOIN conclusion ON report.report_id = conclusion.report_id WHERE conclusion.result != '미확인' AND conclusion.date = '"
							+ today + "' GROUP BY conclusion.date, conclusion.brand;";
						} else {
							sql = "SELECT conclusion.brand, conclusion.date , COUNT(*) FROM report INNER JOIN conclusion ON report.report_id = conclusion.report_id WHERE conclusion.result != '미확인' GROUP BY conclusion.date, conclusion.brand ORDER BY conclusion.date DESC;";
						}

						pstmt = conn.prepareStatement(sql);
						rs = pstmt.executeQuery();

						while (rs.next()) {
							int conclusionCount = rs.getInt(3);
							String brand = rs.getString("conclusion.brand");
							String date = rs.getString("conclusion.date");

							sql = "SELECT COUNT(*) FROM report INNER JOIN conclusion ON report.report_id = conclusion.report_id WHERE conclusion.result != '미확인' AND conclusion.date = ?;";
							pstmt = conn.prepareStatement(sql);
							pstmt.setString(1, date);
							ResultSet rst = pstmt.executeQuery();

							if (rst.next()) {
						count = rst.getInt(1);
							}
							rst.close();

							if (n % 6 == 0) {
						background = "#fee4cb";
						bar = "#ff942e";
						n++;
							} else if (n % 6 == 1) {
						background = "#e9e7fd";
						bar = "#4f3ff0";
						n++;
							} else if (n % 6 == 2) {
						background = "#dbf6fd";
						bar = "#096c86";
						n++;
							} else if (n % 6 == 3) {
						background = "#ffd3e2";
						bar = "#df3670";
						n++;
							} else if (n % 6 == 4) {
						background = "#c8f7dc";
						bar = "#34c471";
						n++;
							} else {
						background = "#d5deff";
						bar = "#4067f9";
						n = 0;
							}
					%>
					<%
					String backColor = (background != null) ? URLEncoder.encode(background, "UTF-8") : "";
					String barColor = (bar != null) ? URLEncoder.encode(bar, "UTF-8") : "";
					%>
					<div class="project-box-wrapper">
						<div class="project-box"
							style="background-color: <%=background%>;">
							<div class="project-box-header">
								<%
								LocalDate conclusionDate = LocalDate.parse(date, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
								String exDate = conclusionDate.format(formatter);
								%>
								<span><%=exDate%></span>
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
								<p class="box-content-header"><%=brand%></p>
								<p class="box-content-subheader"><%=exDate%>일자 접수 내역
								</p>
							</div>
							<div class="box-progress-wrapper">
								<p class="box-progress-header">신고 점유율</p>
								<div class="box-progress-bar">
									<span class="box-progress"
										style="width: <%=(int) (((float) conclusionCount / count) * 100)%>%; background-color: <%=bar%>"></span>
								</div>
								<p class="box-progress-percentage"><%=(int) (((float) conclusionCount / count) * 100)%>%
								</p>
							</div>

							<div class="project-box-footer">
								<div class="days-left" style="color: <%=bar%>;cursor:pointer;"
									onclick="window.location.href='excelDownload?brand=<%=brand%>&date=<%=date%>';">다운로드</div>
							</div>
						</div>
					</div>
					<%
					}
					%>
				</div>
			</div>
			<%@include file="notice.jsp"%>
			<%--우측 공지사항--%>
			<%
			} catch (SQLException e) {
			e.printStackTrace();
			} finally {
			if (rs != null)
				rs.close();
			if (pstmt != null)
				pstmt.close();
			}
			%>
		</div>
	</div>
	<script src="resource/js/brandData.js"></script>
</body>
</html>
