<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, java.io.*"%>
<%@ include file="dbconn.jsp"%>

<%
// 요청 인코딩 설정
request.setCharacterEncoding("UTF-8");

// 폼 데이터 수집
String reportId = request.getParameter("reportId");
String background = request.getParameter("backcolar");
String bar = request.getParameter("barcolar");
String managerId = request.getParameter("managerId");
String date = request.getParameter("date");
String result = request.getParameter("result");
String fine = request.getParameter("fine");
String reseon = request.getParameter("reseon");

// conclusion 데이터 업데이트
String sql = "UPDATE Conclusion SET result = ?, fine = ?, reseon = ? WHERE report_id = ?";
PreparedStatement pstmt = conn.prepareStatement(sql);
pstmt.setString(1, result);
pstmt.setString(2, fine);
pstmt.setString(3, reseon);
pstmt.setString(4, reportId);
int affectedRows = pstmt.executeUpdate();

// 업데이트 성공 여부 확인 후 리다이렉트
if (affectedRows > 0) {
	response.sendRedirect("conclusionPage.jsp?id=" + reportId);
} else {
	// 업데이트 실패 시 예외 처리
	throw new SQLException("데이터 업데이트 실패. Report ID: " + reportId);
}
%>
