USE KTSDB;

CREATE TABLE IF NOT EXISTS Report (
	report_id INT AUTO_INCREMENT NOT NULL,
	region VARCHAR(50) NOT NULL,
	date VARCHAR(50) NOT NULL,
	content VARCHAR(100),
	picture VARCHAR(255) NOT NULL,
	analytical_picture VARCHAR(255),
	user_id VARCHAR(50),
	PRIMARY KEY (report_id),
    FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE
) DEFAULT CHARSET=utf8;

INSERT INTO Report (region, date, content, picture, analytical_picture, user_id) VALUES
('수원', '2025-02-25', '2인 주행', 'pic1.jpg', 'analysis1.jpg', 'hong123'),
('수원', '2025-03-01', '헬멧 미착용', 'pic2.jpg', 'analysis2.jpg', 'kim123'),
('화성', '2025-03-01', '헬멧 미착용', 'pic3.jpg', 'analysis3.jpg', 'park123');


DESC Report;
SELECT * FROM Report;
drop table Report;