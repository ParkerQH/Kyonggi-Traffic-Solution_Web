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
<link rel="stylesheet" href="resource/css/conclusion.css">
</head>
<body>
	<%@include file="dbconn.jsp"%>
	<div class="app-container">
		<%@include file="header.jsp"%>
		<%--상단 헤더 부분--%>
		<div class="app-content">
			<div class="app-sidebar">
				<%--왼쪽 사이드바 부분 아이콘/홈페이지, 진행중, 완료, 미결, 전체--%>
				<a href="mainPage.jsp" class="app-sidebar-link active"> 
				<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor"
						stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-home"> 
						<path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" /> 
						<polyline points="9 22 9 12 15 12 15 22" />
				</svg>
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
						String brand = rs.getString("conclusion.brand");
						String result = rs.getString("conclusion.result");
						float accuracy = rs.getFloat("conclusion.accuracy");
						String reseon;
						if (rs.getString("conclusion.reseon") == null)
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
											<polyline points="22 4 12 14.01 9 11.01"></polyline>
										</svg>
									</button>
								</div>
							</div>
							<div class="project-box-content-header">
								<div class="box-content-left">
									<img src="resource/images/<%=conclusionPicture%>" alt="Project Icon" class="project-icon">
								</div>
								<div class="box-content-text">
									<section class="conclusion">
									<h2><%=date%>/<%=region%>/<%=brand%>></h2>
										<p>
											<strong>위반 사항 :&nbsp;</strong>
											<%=title%></p>
										<p>
											<strong>신고 내용 :&nbsp;</strong>
											<%=content%></p>
										<br>
										<form action="addTripAction.jsp" method="post"
											enctype="multipart/form-data">
											<div class="form-group">
												<label for="result">결과 :</label> <select id="result"
													name="result" onchange="updateRegions()">
													<option value=""
														<%=(result == null || result.equals("")) ? "selected" : ""%>>미확인</option>
													<option value="승인"
														<%="승인".equals(result) ? "selected" : ""%>>승인</option>
													<option value="반려"
														<%="반려".equals(result) ? "selected" : ""%>>반려</option>
												</select>
											</div>
											<div class="form-group">
												<label for="fine">벌금 :</label> <input type="text"
													name="fine" id="fine" value=<%=rs.getInt("fine")%>>
											</div>
											<div class="form-group">
												<label for="reseon">사유 :</label>
												<textarea name="reseon" id="reseon" rows="5"><%=reseon%></textarea>
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
								<p class="box-progress-percentage"><%=(int) (accuracy * 100)%>%
								</p>
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
