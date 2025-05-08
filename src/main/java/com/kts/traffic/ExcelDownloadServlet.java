package com.kts.traffic;
import java.io.IOException;
import java.io.InputStream;
import java.sql.*;
import java.util.Properties;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import jakarta.servlet.http.HttpServlet;

@WebServlet("/excelDownload")
public class ExcelDownloadServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    	
    	Properties props = new Properties();
    	InputStream in = getClass().getClassLoader().getResourceAsStream("db.properties");
    	props.load(in);
    	
        // DB 접속 정보
        String jdbcURL = props.getProperty("db.url");
        String dbUser = props.getProperty("db.user");
        String dbPass = props.getProperty("db.password");
        String brand = request.getParameter("brand");
        String date = request.getParameter("date");

        // 엑셀 워크북 생성
        try (
            Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPass);
        	PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM Conclusion WHERE brand = ? AND date = ?");
        ) {
        	pstmt.setString(1, brand);
        	pstmt.setString(2, date);
            ResultSet rs = pstmt.executeQuery();
            Workbook workbook = new XSSFWorkbook();
            
            Sheet sheet = workbook.createSheet("Conclusion");

            // 헤더 행 생성
            Row headerRow = sheet.createRow(0);
            String[] columns = {
                "conclusion_id", "result", "accuracy", "brand", "reseon",
                "fine", "date", "analytical_picture", "manager_id", "report_id"
            };
            for (int i = 0; i < columns.length; i++) {
                headerRow.createCell(i).setCellValue(columns[i]);
            }

            // 데이터 행 생성
            int rowIdx = 1;
            while (rs.next()) {
                Row row = sheet.createRow(rowIdx++);
                row.createCell(0).setCellValue(rs.getInt("conclusion_id"));
                row.createCell(1).setCellValue(rs.getString("result"));
                row.createCell(2).setCellValue(rs.getDouble("accuracy"));
                row.createCell(3).setCellValue(rs.getString("brand"));
                row.createCell(4).setCellValue(rs.getString("reseon"));
                row.createCell(5).setCellValue(rs.getObject("fine") != null ? rs.getInt("fine") : 0);
                row.createCell(6).setCellValue(rs.getString("date"));
                row.createCell(7).setCellValue(rs.getString("analytical_picture"));
                row.createCell(8).setCellValue(rs.getString("manager_id"));
                row.createCell(9).setCellValue(rs.getObject("report_id") != null ? rs.getInt("report_id") : 0);
            }

            // 응답 헤더 설정
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=conclusion_" + System.currentTimeMillis() + ".xlsx");

            // 엑셀 파일을 응답 스트림에 작성
            workbook.write(response.getOutputStream());
            workbook.close();
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
