
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
<link rel="stylesheet" href="resource/css/conclusion.css">
</head>
<%
if (session.getAttribute("managerUid") == null) {
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
				<div class="projects-section-header">
					<p>세부정보</p>
					<%
					// report 데이터 및 색상 데이터 가져오기
					String reportId = request.getParameter("id");
					String background = request.getParameter("backcolar");
					String bar = request.getParameter("barcolar");

					// 현재 날짜 가져오기
					LocalDate today = LocalDate.now();
					DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy. MM. dd"); // "2025 .05 .07" 형식
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
						String brand = rs.getString("conclusion.brand");
						String conclusionPicture = rs.getString("conclusion.analytical_picture");
						String result = rs.getString("conclusion.result");
						float accuracy = rs.getFloat("conclusion.accuracy");
						String reseon = rs.getString("conclusion.reseon");
						if (reseon == null)
					reseon = "";
						if (brand == null)
					brand = "확인 안됨";
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
								<div class="box-content-left">
									<img src="resource/images/<%=conclusionPicture%>"
										alt="Project Icon" class="project-icon">
								</div>
								<div class="box-content-text">
									<section class="conclusion">
										<h2><%=date%>/<%=region%></h2>
										<p>
											<strong>킥보드사 &nbsp;:&nbsp;</strong>
											<%=brand%></p>
										<p>
											<strong>위반 사항 :&nbsp;</strong>
											<%=title%></p>
										<p>
											<strong>신고 내용 :&nbsp;</strong>
											<%=content%></p>
										<br>
										<form action="updateResult.jsp" method="post">
											<input type="hidden" name="backcolar" value="<%=background%>">
											<input type="hidden" name="barcolar" value="<%=bar%>">
											<input type="hidden" name="reportId" value="<%=reportId%>">
											<input type="hidden" name="date" value="<%=today%>">
											<input type="hidden" name="managerId"
												value="<%=(String) session.getAttribute("managerId")%>">
											<div class="form-group">
												<label for="result">결과 :</label> <select id="result"
													name="result" onchange="updateRegions()">
													<option value="미확인"
														<%=(result == null || "미확인".equals(result)) ? "selected" : ""%>>미확인</option>
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
