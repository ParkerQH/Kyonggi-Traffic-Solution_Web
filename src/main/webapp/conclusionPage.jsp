<%@page import="java.time.Period"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.util.Date, java.text.SimpleDateFormat, java.util.Locale, java.time.LocalDate, java.time.format.DateTimeFormatter"%>
<%@ page import="java.sql.*"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title></title>
<link rel="stylesheet" href="resource/css/conclusion.css">
</head>
<body>
	<%@include file="dbconn.jsp"%>
	<div class="app-container">
		<div class="app-header">
			<div class="app-header-left">
				<span class="app-icon"></span> <a href="mainPage.jsp"
					style="text-decoration: none;"><p class="app-name">TRAFFIC
						SOLUTION</p></a>
				<div class="search-wrapper">
					<input class="search-input" type="text" placeholder="Search">
					<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20"
						fill="none" stroke="currentColor" stroke-linecap="round"
						stroke-linejoin="round" stroke-width="2"
						class="feather feather-search" viewBox="0 0 24 24">
        <defs></defs>
        <circle cx="11" cy="11" r="8"></circle>
        <path d="M21 21l-4.35-4.35"></path>
        </svg>
				</div>
			</div>
			<div class="app-header-right">
				<button class="mode-switch" title="Switch Theme">
					<svg class="moon" fill="none" stroke="currentColor"
						stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
						width="24" height="24" viewBox="0 0 24 24">
        <defs></defs>
        <path d="M21 12.79A9 9 0 1111.21 3 7 7 0 0021 12.79z"></path>
        </svg>
				</button>
				<button class="profile-btn">
					<svg xmlns="http://www.w3.org/2000/svg" width="19" height="19"
						fill="currentColor" class="bi bi-person-circle"
						viewBox="0 0 19 19">
                <path d="M11 6a3 3 0 1 1-6 0 3 3 0 0 1 6 0z" />
                <path fill-rule="evenodd"
							d="M0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8zm8-7a7 7 0 0 0-5.468 11.37C3.242 11.226 4.805 10 8 10s4.757 1.225 5.468 2.37A7 7 0 0 0 8 1z" />
              </svg>
					<span>ADMIN</span>
				</button>
			</div>
			<button class="messages-btn">
				<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20"
					viewBox="0 0 24 24" fill="none" stroke="currentColor"
					stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
					class="feather feather-message-circle">
        <path
						d="M21 11.5a8.38 8.38 0 0 1-.9 3.8 8.5 8.5 0 0 1-7.6 4.7 8.38 8.38 0 0 1-3.8-.9L3 21l1.9-5.7a8.38 8.38 0 0 1-.9-3.8 8.5 8.5 0 0 1 4.7-7.6 8.38 8.38 0 0 1 3.8-.9h.5a8.48 8.48 0 0 1 8 8v.5z" /></svg>
			</button>
		</div>
		<div class="app-content">
			<div class="app-sidebar">
				<%--왼쪽 사이드바 부분 아이콘/홈페이지, 진행중, 완료, 미결, 전체--%>
				<a href="#" class="app-sidebar-link active"> <svg
						xmlns="http://www.w3.org/2000/svg" width="24" height="24"
						viewBox="0 0 24 24" fill="none" stroke="currentColor"
						stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
						class="feather feather-home"> <path
							d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" /> <polyline
							points="9 22 9 12 15 12 15 22" /></svg>
				</a> <a href="#" class="app-sidebar-link"> <svg
						xmlns="http://www.w3.org/2000/svg" width="24" height="24"
						viewBox="0 0 24 24" fill="none" stroke="currentColor"
						stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
						class="feather feather-square">
						<rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect></svg>
				</a> <a href="#" class="app-sidebar-link"> <svg
						xmlns="http://www.w3.org/2000/svg" width="24" height="24"
						viewBox="0 0 24 24" fill="none" stroke="currentColor"
						stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
						class="feather feather-check-square">
						<polyline points="9 11 12 14 22 4"></polyline>
						<path
							d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path></svg>
				</a> <a href="#" class="app-sidebar-link"> <svg
						xmlns="http://www.w3.org/2000/svg" width="24" height="24"
						viewBox="0 0 24 24" fill="none" stroke="currentColor"
						stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
						class="feather feather-x-square">
						<rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect>
						<line x1="9" y1="9" x2="15" y2="15"></line>
						<line x1="15" y1="9" x2="9" y2="15"></line></svg>
				</a> <a href="#" class="app-sidebar-link"> <svg
						xmlns="http://www.w3.org/2000/svg" width="24" height="24"
						viewBox="0 0 24 24" fill="none" stroke="currentColor"
						stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
						class="feather feather-folder">
						<path
							d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"></path></svg>
				</a>
			</div>
			<div class="projects-section">
				<div class="projects-section-header">
					<p>CONCLUSION</p>
					<%
					// report 데이터 및 색상 데이터 가져오기
					String reportId = request.getParameter("id");
					String background = request.getParameter("backcolar");
					String bar = request.getParameter("barcolar");

					// 현재 날짜 가져오기
					LocalDate today = LocalDate.now();
					DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMMM dd, yyyy", Locale.ENGLISH); // "March 08, 2025" 형식
					DateTimeFormatter format = DateTimeFormatter.ofPattern("MMM dd, yyyy", Locale.ENGLISH); // "March 08, 2025" 형식
					String todayDate = today.format(formatter);
					PreparedStatement pstmt = null;
					ResultSet rs = null;
					int count = 0;
					%>
					<p class="time"><%=todayDate%></p>
				</div>
				<%
				try {
					String sql = "SELECT * FROM report INNER JOIN conclusion ON report.report_id = conclusion.report_id WHERE report.report_id = ?;";
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, reportId);
					rs = pstmt.executeQuery();

					if (rs.next()) {
						String date = rs.getString("report.date");
						String region = rs.getString("report.region");
						String title = rs.getString("report.title");
						String content = rs.getString("report.content");
						String conclusionPicture = rs.getString("conclusion.analytical_picture");
						String result = rs.getString("conclusion.result");
						float accuracy = rs.getFloat("conclusion.accuracy");	
						String reseon;
						if(rs.getString("conclusion.reseon")==null)
							reseon = "";
						else
							reseon = rs.getString("conclusion.resion");
				%>

				<div class="project-boxes jsGridView">
					<div class="project-box-wrapper">
						<div class="project-box"
							style="background-color: <%=background%>;">
							<div class="project-box-header">
								<%
								LocalDate reportDate = LocalDate.parse(date, DateTimeFormatter.ofPattern("yyyy-MM-dd")); //<변경>예시 데이터(2일 전 날짜)
								String exDate = reportDate.format(formatter);
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
								<div class="box-content-left">
									<img src="resource/images/<%=conclusionPicture%>"
										alt="Project Icon" class="project-icon">
								</div>
								<div class="box-content-text">
									<section class="about">
										<h2><%=date %>/<%=region %></h2>
										
										<p><strong>위반 사항 :&nbsp;</strong> <%=title %></p>
										<p><strong>신고 내용 :&nbsp;</strong> <%=content%></p>
										<br>
									</section>
									<section class="conclusion">
										<form action="addTripAction.jsp" method="post"
											enctype="multipart/form-data">
											<div class="form-group">
												<label for="result">결과 :</label> <select id="result"
													name="result" onchange="updateRegions()">
													<option value="" selected>미확인</option>
													<option value="승인">승인</option>
													<option value="반려">반려</option>
												</select>
											</div>
											<div class="form-group">
												<label for="fine">벌금 :</label>
												<input type="text" name="fine" id="fine" value=<%= rs.getInt("fine") %>>
											</div>
											<div class="form-group">
												<label for="reseon">사유 :</label>
												<textarea name="reseon" id="reseon" rows="5" ><%= reseon %></textarea>
											</div>
											<div class="form-group">
												<input type="submit" value="제출">
											</div>
										</form>
									</section>
								</div>
							</div>
							<div class="box-progress-wrapper">
								<p class="box-progress-header">Progress</p>
								<div class="box-progress-bar">
									<span class="box-progress"
										style="width: <%=(int) (accuracy * 100)%>%; background-color: <%=bar%>"></span>
								</div>
								<p class="box-progress-percentage"><%=(int) (accuracy * 100)%>%</p>
							</div>
							<div class="project-box-footer">
								<div class="days-left" style="color: <%=bar%>;">2 일전</div>
							</div>
						</div>
					</div>
				</div>
				<%
				}
				%>
			</div>
			<div class="messages-section">
				<button class="messages-close">
					<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24"
						viewBox="0 0 24 24" fill="none" stroke="currentColor"
						stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
						class="feather feather-x-circle">
        <circle cx="12" cy="12" r="10" />
        <line x1="15" y1="9" x2="9" y2="15" />
        <line x1="9" y1="9" x2="15" y2="15" /></svg>
				</button>
				<div class="projects-section-header">
					<p>공지사항</p>
				</div>
				<div class="messages">
					<%
					sql = "SELECT * FROM notice ORDER BY notice_id DESC;";
					pstmt = conn.prepareStatement(sql);
					rs = pstmt.executeQuery();

					while (rs.next()) {
						String title = rs.getString("title");
						String content = rs.getString("content");
						String date = rs.getString("date");

						LocalDate noticeDate = LocalDate.parse(date, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
						String noDate = noticeDate.format(format);
					%>
					<div class="message-box">
						<div class="message-content">
							<div class="message-header">
								<div class="title"><%=title%></div>
								<div class="star-checkbox">
									<input type="checkbox" id="star-1"> <label for="star-1">
										<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20"
											viewBox="0 0 24 24" fill="none" stroke="currentColor"
											stroke-width="2" stroke-linecap="round"
											stroke-linejoin="round" class="feather feather-star">
        <polygon
												points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" /></svg>
									</label>
								</div>
							</div>
							<p class="message-line"><%=content%></p>
							<p class="message-line time"><%=noDate%></p>
						</div>
					</div>
					<%
					}
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
		</div>
	</div>

	<script src="resource/js/main.js"></script>
</body>
</html>
