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
      <h2>Login</h2>
      <div class="input-field">
        <input type="text" required>
        <label>아이디</label>
      </div>
      <div class="input-field">
        <input type="password" required>
        <label>비밀번호</label>
      </div>
      <div class="forget">
        <label for="remember">
          <input type="checkbox" id="remember">
          <p>Remember me</p>
        </label>
        <a href="#">Forgot password?</a>
      </div>
      <button type="submit">Log In</button>
      <div class="register">
        <p>계정이 아직 없으신가요? <a href="register.jsp">회원가입</a></p>
      </div>
    </form>
  </div>
</body>

</html>                        