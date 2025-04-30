<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.util.Date, java.text.SimpleDateFormat, java.util.Locale, java.time.LocalDate, java.time.format.DateTimeFormatter"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>우측 공지 페이지</title>
<!--link rel="stylesheet" href="resource/css/main.css"  -->
</head>
<body>
	<%--@include file="dbconn.jsp"--%>
	<div class="messages-section">
		<button class="messages-close">
			<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24"
				viewBox="0 0 24 24" fill="none" stroke="currentColor"
				stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
				class="feather feather-x-circle">
        		<circle cx="12" cy="12" r="10" />
        		<line x1="15" y1="9" x2="9" y2="15" />
        		<line x1="9" y1="9" x2="15" y2="15" />
        	</svg>
		</button>
		<div class="projects-section-header">
			<p>공지사항</p>
		</div>
		<div class="messages">
			<%
			DateTimeFormatter format_nt = DateTimeFormatter.ofPattern("MMM dd, yyyy", Locale.ENGLISH);		
			String sql_nt = "SELECT * FROM notice ORDER BY notice_id DESC;";
			PreparedStatement pstmt_nt = conn.prepareStatement(sql_nt);
			ResultSet rs_nt = pstmt_nt.executeQuery();
			
			try{
				while (rs_nt.next()) {
					String title = rs_nt.getString("title");
					String content = rs_nt.getString("content");
					String date = rs_nt.getString("date");

					LocalDate noticeDate = LocalDate.parse(date, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
					String noDate = noticeDate.format(format_nt);
			%>
			<div class="message-box">
				<div class="message-content">
					<div class="message-header">
						<div class="title"><%=title%></div>
						<div class="star-checkbox">
							<input type="checkbox" id="star-1"> <label for="star-1">
								<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20"
									viewBox="0 0 24 24" fill="none" stroke="currentColor"
									stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
									class="feather feather-star">
        							<polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" />
        						</svg>
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
				if (rs_nt != null)
				rs_nt.close();
				if (pstmt_nt != null)
				pstmt_nt.close();
			}
			%>
		</div>
	</div>
</body>
</html>