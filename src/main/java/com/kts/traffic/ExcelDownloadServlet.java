package com.kts.traffic;
import java.io.IOException;
import java.io.InputStream;
import java.sql.*;
import java.util.Properties;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

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
        	PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM Report INNER JOIN Conclusion ON report.report_id = conclusion.report_id WHERE conclusion.brand = ? AND conclusion.date = ?");
        ) {
        	pstmt.setString(1, brand);
        	pstmt.setString(2, date);
            ResultSet rs = pstmt.executeQuery();
            Workbook workbook = new XSSFWorkbook();
            Sheet sheet = workbook.createSheet("요청명단");

            // 1. 굵고 가운데, 폰트 크게(16pt) 스타일
            CellStyle bigBoldCenterStyle = workbook.createCellStyle();
            Font bigBoldFont = workbook.createFont();
            bigBoldFont.setBold(true);
            bigBoldFont.setFontHeightInPoints((short)18); // 글씨 크기
            bigBoldCenterStyle.setFont(bigBoldFont);
            bigBoldCenterStyle.setAlignment(HorizontalAlignment.CENTER);
            bigBoldCenterStyle.setVerticalAlignment(VerticalAlignment.CENTER);
            setAllBorders(bigBoldCenterStyle);
            
            // 2. 굵고 가운데(기본) 스타일
            CellStyle boldCenterStyle = workbook.createCellStyle();
            Font boldFont = workbook.createFont();
            boldFont.setBold(true);
            boldFont.setFontHeightInPoints((short)11);
            boldCenterStyle.setFont(boldFont);
            boldCenterStyle.setAlignment(HorizontalAlignment.CENTER);
            boldCenterStyle.setVerticalAlignment(VerticalAlignment.CENTER);
            setAllBorders(boldCenterStyle);

            // 3. 기본 테두리 스타일
            CellStyle borderStyle = workbook.createCellStyle();
            borderStyle.setAlignment(HorizontalAlignment.CENTER);
            borderStyle.setVerticalAlignment(VerticalAlignment.CENTER);
            setAllBorders(borderStyle);
            
            // "요청명단" 0~1행, 0~5열 병합
            sheet.addMergedRegion(new CellRangeAddress(0, 1, 0, 2));
            Row titleRow = sheet.createRow(0);
            Cell titleCell = titleRow.createCell(0);
            titleCell.setCellValue("요청명단");
            titleCell.setCellStyle(bigBoldCenterStyle);

            // 0행: "관리자", "소속", "날짜"
            Row subHeaderRow = sheet.getRow(0);
            if (subHeaderRow == null) subHeaderRow = sheet.createRow(1);
            Cell adminCell = subHeaderRow.createCell(3);
            adminCell.setCellValue("관리자");
            adminCell.setCellStyle(boldCenterStyle);

            Cell regionCell = subHeaderRow.createCell(4);
            regionCell.setCellValue("소속");
            regionCell.setCellStyle(boldCenterStyle);

            Cell dateCell = subHeaderRow.createCell(5);
            dateCell.setCellValue("날짜");
            dateCell.setCellStyle(boldCenterStyle);

            // 1행: name, region, 2025-04-05 (데이터 미수집 상태이므로 그대로 출력)
            Row infoValueRow = sheet.createRow(1);
            infoValueRow.createCell(3).setCellValue("name");
            infoValueRow.createCell(4).setCellValue("region");
            infoValueRow.createCell(5).setCellValue("2025-04-05");
            // 테두리 적용
            for (int i = 3; i <= 5; i++) {
                infoValueRow.getCell(i).setCellStyle(borderStyle);
            }

            // 2행: 컬럼명
            String[] columns = {
                "관리번호","브랜드", "지역", "날짜", "시간", "사유"
            };
            Row headerRow = sheet.createRow(2);
            for (int i = 0; i < columns.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(columns[i]);
                cell.setCellStyle(boldCenterStyle);
            }

            // 3행~: 데이터
            int rowIdx = 3;
            while (rs.next()) {
                Row row = sheet.createRow(rowIdx++);
                for (int i = 0; i < columns.length; i++) {
                    Cell cell = row.createCell(i);
                    Object value = null;
                    switch (i) {
                        case 0: value = rs.getInt("conclusion.conclusion_id"); break;
                        case 1: value = rs.getString("conclusion.brand"); break;
                        case 2: value = rs.getString("report.region"); break;
                        case 3: value = rs.getString("report.date"); break;
                        case 4: value = rs.getString("report.date"); break;
                        case 5: value = rs.getString("report.title"); break;
                    }
                    if (value != null) {
                        if (value instanceof Number)
                            cell.setCellValue(((Number) value).doubleValue());
                        else
                            cell.setCellValue(value.toString());
                    }
                    cell.setCellStyle(borderStyle);
                }
            }

            // 전체 컬럼 너비 자동조정 (옵션)
            for (int i = 0; i < columns.length; i++) {
                sheet.autoSizeColumn(i);
                
                if (i == 0) sheet.setColumnWidth(i, 2500); // 관리번호
                if (i == 1) sheet.setColumnWidth(i, 2500); // 브랜드
                if (i == 2) sheet.setColumnWidth(i, 10000); // 지역
            }

            // 응답 헤더
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename="+ brand + "_" + date + ".xlsx");

            workbook.write(response.getOutputStream());
            workbook.close();
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
    
    // 셀 전체 테두리 적용 함수
    private void setAllBorders(CellStyle style) {
        style.setBorderTop(BorderStyle.THIN);
        style.setBorderBottom(BorderStyle.THIN);
        style.setBorderLeft(BorderStyle.THIN);
        style.setBorderRight(BorderStyle.THIN);
    }
}
