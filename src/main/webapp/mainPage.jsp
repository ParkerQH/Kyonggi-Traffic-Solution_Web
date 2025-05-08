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
				<a href="mainPage.jsp" class="app-sidebar-link" data-filter="all">
					<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24"
						viewBox="0 0 24 24" fill="none" stroke="currentColor"
						stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
						class="feather feather-home"> <path
							d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" /> <polyline
							points="9 22 9 12 15 12 15 22" /></svg>
				</a> <a href="mainPage.jsp" class="app-sidebar-link"
					data-filter="unconfirmed"> <svg
						xmlns="http://www.w3.org/2000/svg" width="24" height="24"
						viewBox="0 0 24 24" fill="none" stroke="currentColor"
						stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
						class="feather feather-square">
						<rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect></svg>
				</a> <a href="mainPage.jsp" class="app-sidebar-link"
					data-filter="confirmed"> <svg
						xmlns="http://www.w3.org/2000/svg" width="24" height="24"
						viewBox="0 0 24 24" fill="none" stroke="currentColor"
						stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
						class="feather feather-check-square">
						<polyline points="9 11 12 14 22 4"></polyline>
						<path
							d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path></svg>
				</a> <a href="mainPage.jsp" class="app-sidebar-link"
					data-filter="folder"> <svg xmlns="http://www.w3.org/2000/svg"
						width="24" height="24" viewBox="0 0 24 24" fill="none"
						stroke="currentColor" stroke-width="2" stroke-linecap="round"
						stroke-linejoin="round" class="feather feather-folder">
						<path
							d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"></path></svg>
				</a> <a href="brandData.jsp" class="app-sidebar-link"> <svg
						xmlns="http://www.w3.org/2000/svg" width="24" height="24"
						viewBox="0 0 24 24" fill="none" stroke="currentColor"
						stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
						class="feather feather-send">
						<line x1="22" y1="2" x2="11" y2="13"></line>
						<polygon points="22 2 15 22 11 13 2 9 22 2"></polygon></svg>
				</a> <a href="brandData.jsp?filter=list" class="app-sidebar-link"> <svg
						xmlns="http://www.w3.org/2000/svg" width="24" height="24"
						viewBox="0 0 24 24" fill="none" stroke="currentColor"
						stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
						class="feather feather-archive">
						<polyline points="21 8 21 21 3 21 3 8"></polyline>
						<rect x="1" y="3" width="22" height="5"></rect>
						<line x1="10" y1="12" x2="14" y2="12"></line></svg>
				</a>
			</div>
			<div class="projects-section">
				<%
				String filter = request.getParameter("filter");
				String pageTitle;
				if ("all".equals(filter) || filter == null)
					pageTitle = "HOME";
				else if ("folder".equals(filter))
					pageTitle = "신고 내역 전체보기";
				else
					pageTitle = "오늘 신고 접수내역";
				%>
				<div class="projects-section-header">
					<a href="mainPage.jsp" style="text-decoration: none;"><p><%=pageTitle%></p></a>
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
					try {
						if ("unconfirmed".equals(filter)) {
							sql = "SELECT * FROM report INNER JOIN conclusion ON report.report_id = conclusion.report_id WHERE conclusion.result = '미확인' "
							+ "AND report.date = '" + today + "' " + "ORDER BY report.date DESC;";
						} else if ("confirmed".equals(filter)) {
							sql = "SELECT * FROM report INNER JOIN conclusion ON report.report_id = conclusion.report_id WHERE conclusion.result in ('승인','반려') "
							+ "AND report.date = '" + today + "' " + "ORDER BY report.date DESC;";
						} else if ("folder".equals(filter)) {
							sql = "SELECT * FROM report INNER JOIN conclusion ON report.report_id = conclusion.report_id ORDER BY report.date DESC;";
						} else {
							sql = "SELECT * FROM report INNER JOIN conclusion ON report.report_id = conclusion.report_id "
							+ "AND MONTH(report.date) = '" + month + "' " + "ORDER BY report.date DESC;";
						}

						pstmt = conn.prepareStatement(sql);
						rs = pstmt.executeQuery();

						while (rs.next()) {
							int reportId = rs.getInt("report.report_id");
							String region = rs.getString("report.region");
							String date = rs.getString("report.date");
							String title = rs.getString("report.title");
							String content = rs.getString("report.content");
							String result = rs.getString("conclusion.result");
							float accuracy = rs.getFloat("conclusion.accuracy");

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
					<div class="project-box-wrapper"
						onclick="window.location='conclusionPage.jsp?id=<%=rs.getString("report_id")%>&backcolar=<%=backColor%>&barcolar=<%=barColor%>';"
						style="cursor: pointer;">
						<div class="project-box"
							style="background-color: <%=background%>;">
							<div class="project-box-header">
								<%
								LocalDate reportDate = LocalDate.parse(date, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
								String exDate = reportDate.format(formatter);
								%>
								<span><%=exDate%></span>
								<div class="more-wrapper">
									<button class="project-btn-more">
										<%
										if (result.equals("승인")) {
										%>

										<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24"
											viewBox="0 0 24 24" fill="none" stroke="currentColor"
											stroke-width="2" stroke-linecap="round"
											stroke-linejoin="round" class="feather feather-check-circle">
											<path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
											<polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
										<%
										} else if (result.equals("반려")) {
										%>

										<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24"
											viewBox="0 0 24 24" fill="none" stroke="currentColor"
											stroke-width="2" stroke-linecap="round"
											stroke-linejoin="round" class="feather feather-x-circle">
											<circle cx="12" cy="12" r="10"></circle>
											<line x1="15" y1="9" x2="9" y2="15"></line>
											<line x1="9" y1="9" x2="15" y2="15"></line></svg>
										<%
										} else if (result.equals("미결")) {
										%>

										<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24"
											viewBox="0 0 24 24" fill="none" stroke="currentColor"
											stroke-width="2" stroke-linecap="round"
											stroke-linejoin="round" class="feather feather-help-circle">
											<circle cx="12" cy="12" r="10"></circle>
											<path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"></path>
											<line x1="12" y1="17" x2="12.01" y2="17"></line></svg>
										<%
										} else if (result.equals("미확인")) {
										%>
										<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24"
											viewBox="0 0 24 24" fill="none" stroke="currentColor"
											stroke-width="2" stroke-linecap="round"
											stroke-linejoin="round" class="feather feather-circle">
											<circle cx="12" cy="12" r="10"></circle></svg>
										<%
										}
										%>
									</button>
								</div>
							</div>
							<div class="project-box-content-header">
								<p class="box-content-header"><%=title%></p>
								<p class="box-content-subheader"><%=content%></p>
							</div>
							<div class="box-progress-wrapper">
								<p class="box-progress-header">AI 신뢰도</p>
								<div class="box-progress-bar">
									<span class="box-progress"
										style="width: <%=(int) (accuracy * 100)%>%; background-color: <%=bar%>"></span>
								</div>
								<p class="box-progress-percentage"><%=(int) (accuracy * 100)%>%
								</p>
							</div>

							<div class="project-box-footer">
								<%
								Period period = Period.between(reportDate, today);
								int daysBetween = period.getDays();
								%>
								<div class="days-left" style="color: <%=bar%>;"><%=daysBetween%>
									일전
								</div>
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
	<script src="resource/js/main.js"></script>
</body>
</html>
