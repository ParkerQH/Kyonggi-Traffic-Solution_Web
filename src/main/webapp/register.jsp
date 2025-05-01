<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Andev Web</title>
  <link rel="stylesheet" href="resource/css/login.css">
</head>

<body>
  <div class="wrapper">
    <form action="#">
      <h2>회원가입</h2>
      <div class="input-field">
        <input type="text" required>
        <label>아이디</label>
      </div>
      <div class="input-field">
        <input type="password" required>
        <label>비밀번호</label>
      </div>
      <div class="input-field">
        <input type="text" required>
        <label>이름</label>
      </div>
      <div class="input-field">
        <input type="text" required>
        <label>근무지</label>
      </div>
      <div class="input-field">
        <input type="text" required>
        <label>전화번호</label>
      </div>
      <button type="submit">회원가입</button>
      <div class="register">
        <p>계정이 이미 있으신가요? <a href="login.jsp">로그인</a></p>
      </div>
    </form>
  </div>
</body>

</html>                        