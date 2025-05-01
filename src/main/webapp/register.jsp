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
<link rel="stylesheet" href="resource/css/register.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="resource/js/register.js"></script>
<title>Register Page</title>
</head>
<body>
	<%
	// 폼이 제출될 경우
	boolean showNotification = false; // 알림창 표시 여부
	String notificationMessage = ""; // 알림 메시지
	String welcomeMessage = ""; // 회원가입 후 환영 메시지

	if ("POST".equalsIgnoreCase(request.getMethod())) {
		String id = request.getParameter("register-id");
		String password = request.getParameter("register-pass");
		String name = request.getParameter("register-name");
		String phone = request.getParameter("register-phone");
		String email = request.getParameter("register-email");

		// DB 연결 후 회원 정보 저장
		PreparedStatement pstmt = null;
		try {
			String checkIdQuery = "SELECT COUNT(*) FROM User WHERE user_id = ?";
			pstmt = conn.prepareStatement(checkIdQuery);
			pstmt.setString(1, id);
			ResultSet rs = pstmt.executeQuery();
			if (rs.next() && rs.getInt(1) > 0) {
				showNotification = true; // 알림창 표시
				notificationMessage = "이미 존재하는 아이디입니다. 다른 아이디을 사용해주세요."; // 알림 메시지
			} else {
				String sql = "INSERT INTO User (user_id, name, pw, phone, email) VALUES (?, ?, ?, ?, ?)";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, id);
				pstmt.setString(2, name);
				pstmt.setString(3, password);
				pstmt.setString(4, phone);
				pstmt.setString(5, email);

				int result = pstmt.executeUpdate();
				if (result > 0) {
					showNotification = true;
					welcomeMessage = "환영합니다, " + name + "님!";
					response.setHeader("Refresh", "3; URL=login.jsp"); // 등록 성공 시 로그인 페이지로 리다이렉트
				} else {
					showNotification = true; // 알림창 표시
					notificationMessage = "회원 등록에 실패했습니다."; // 알림 메시지
				}
			}
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
			try {
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
		}
	}
	%>

	<!-- 알림창 -->
	<div class="notification" id="notification">
		<%=showNotification ? (welcomeMessage.isEmpty() ? notificationMessage : welcomeMessage) : ""%>
	</div>

	<div class="register">
		<img src="resource/images/background.png" alt="register image" class="register__img">
		<form action="register.jsp" class="container" method="post">
			<h1 class="register__title">회원가입</h1>

			<div class="register__content">
				<div class="register__box">
					<i class="ri-id-card-line register__icon"></i>
					<div class="register__box-input">
						<input type="text" required class="register__input" id="register-id" name="register-id" placeholder=" "> 
						<label for="register-email" class="register__label">아이디</label>
					</div>
				</div>

				<div class="register__box">
					<i class="ri-lock-2-line register__icon"></i>
					<div class="register__box-input">
						<input type="password" required class="register__input" 
						id="register-pass" name="register-pass" placeholder=" "
							pattern=".{8,}" title="비밀번호는 8자 이상으로 작성해주세요."> 
							<label for="register-pass" class="register__label">비밀번호</label> 
							<i class="ri-eye-off-line register__eye" id="register-eye" onclick="togglePasswordVisibility()"></i>
					</div>
				</div>

				<div class="register__box">
					<i class="ri-user-line register__icon"></i>
					<div class="register__box-input">
						<input type="text" required class="register__input" id="register-name" name="register-name" placeholder=" ">
						<label for="register-name" class="register__label">이름</label>
					</div>
				</div>

				<div class="register__box">
					<i class="ri-phone-line register__icon"></i>
					<div class="register__box-input">
						<input type="tel" required class="register__input" id="register-phone" name="register-phone" 
						placeholder=" " pattern="^(01[016789]|070)-?[0-9]{3,4}-?[0-9]{4}$" title="Ex. 010-1234-5678 or 01012345678"> 
						<label for="register-phone" class="register__label">전화번호</label>
					</div>
				</div>

				<div class="register__box">
					<i class="ri-mail-line register__icon"></i>
					<div class="register__box-input">
						<input type="text" required class="register__input" id="register-email" name="register-email" placeholder=" ">
						<label for="register-email" class="register__label">이메일</label>
					</div>
				</div>

			</div>

			<button type="submit" class="register__button">회원가입 하기</button>

			<p class="register__login">
				이미 계정이 있으신가요? <a href="login.jsp">로그인</a>
			</p>
		</form>
	</div>
</body>
</html>
