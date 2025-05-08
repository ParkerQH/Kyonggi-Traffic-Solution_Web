<?php
// excel_down.php 파일 생성
header("Content-Type: application/vnd.ms-excel; charset=UTF-8");
header("Content-Disposition: attachment; filename=export_".date('Ymd').".xls");
header("Cache-Control: max-age=0");

// DB 연결 설정
$db_host = 'localhost';
$db_user = 'root';
$db_pass = '';
$db_name = 'your_database';
$conn = new mysqli($db_host, $db_user, $db_pass, $db_name);

// 쿼리 실행
$result = $conn->query("SELECT * FROM your_table");
?>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
    <table border="1">
        <tr>
            <th>번호</th>
            <th>이름</th>
            <th>이메일</th>
            <th>가입일</th>
        </tr>
        <?php while($row = $result->fetch_assoc()): ?>
        <tr>
            <td style="mso-number-format:'\@'"><?= $row['id'] ?></td>
            <td><?= $row['name'] ?></td>
            <td><?= $row['email'] ?></td>
            <td><?= $row['reg_date'] ?></td>
        </tr>
        <?php endwhile; ?>
    </table>
</body>
</html>
