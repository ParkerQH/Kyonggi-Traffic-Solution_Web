<%@ page language="java" contentType="text/plain; charset=UTF-8" pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("UTF-8");
session.setMaxInactiveInterval(30 * 60);
String managerId = request.getParameter("managerId");
String managerName = request.getParameter("managerName");
String managerRegion = request.getParameter("managerRegion");
session.setAttribute("managerId", managerId);
session.setAttribute("managerName", managerName);
session.setAttribute("managerRegion", managerRegion);
out.print("OK");
%>
