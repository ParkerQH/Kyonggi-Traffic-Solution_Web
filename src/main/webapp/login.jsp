<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ page import="java.sql.*"%>
<%@ include file="dbconn.jsp"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://cdn.jsdelivr.net/npm/remixicon@4.6.0/fonts/remixicon.css" rel="stylesheet">
<link rel="stylesheet" href="resource/css/login.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="resource/js/login.js"></script>
<title>Login Page</title>
</head>
<body>
	<div class="login">
		<img src="resource/images/background.png" alt="login image"
			class="login__img">
		<form action="login.jsp" class="container" method="post">
			<h1 class="login__title">로그인</h1>

			<div class="login__content">
				<div class="login__box">
					<i class="ri-user-3-line login__icon"></i>
					<div class="login__box-input">
						<input type="text" name="id" required class="login__input"
							id="login-id" placeholder=" " /> <label for="login-id"
							class="login__label">아이디</label>
					</div>
				</div>

				<div class="login__box">
					<i class="ri-lock-2-line login__icon"></i>
					<div class="login__box-input">
						<input type="password" name="password" required
							class="login__input" id="login-pass" placeholder=" " /> <label
							for="login-pass" class="login__label">비밀번호</label> <i
							class="ri-eye-off-line login__eye" id="login-eye"
							onclick="togglePasswordVisibility()"></i>
					</div>
				</div>

				<!-- 오류 메시지 출력 위치 -->
				<div class="error-message" id="error-message"></div>
			</div>

			<button type="submit" class="login__button">로그인</button>

			<p class="login__register">
				<a href="register.jsp">회원가입</a>
			</p>

			<%
			// 세션 유효 시간
			session.setMaxInactiveInterval(30 * 60);
			// 폼 제출 후 로그인 검증 수행
			String id = request.getParameter("id");
			String password = request.getParameter("password");
			boolean isValid = false; // 기본값을 false로 설정
			String userName = null;
			if (id != null && password != null) {
				// SQL 쿼리로 로그인 검증
				String query = "SELECT pw, name FROM User WHERE user_id = ?";
				PreparedStatement pstmt = null;
				ResultSet rs = null;

				try {
					pstmt = conn.prepareStatement(query);
					pstmt.setString(1, id);
					rs = pstmt.executeQuery();

					if (rs.next()) {
						String dbPassword = rs.getString("pw");
						// 비밀번호가 일치하면 로그인 성공
						if (password.equals(dbPassword)) {
							isValid = true;
							userName = rs.getString("name");
						}
					}

					if (isValid) {
						session.setAttribute("loggedInUser", userName);
			%>
			<script>
				window.location.href = "mainPage.jsp"; // 로그인 성공 후 리다이렉션
			</script>
			<%
					} else {
			%>
			<script>
				document.getElementById('error-message').innerText = "잘못된 아이디 또는 비밀번호입니다.";
				document.getElementById('error-message').style.display = "block"; // 오류 메시지 표시
			</script>
			<%
					}
				} catch (SQLException e) {
					e.printStackTrace();
				} finally {
					try {
						if (rs != null)
							rs.close();
						if (pstmt != null)
							pstmt.close();
					} catch (SQLException e) {
						e.printStackTrace();
					}
				}
			}
			%>
		</form>
	</div>
</body>
</html>
