USE KTSDB;

CREATE TABLE IF NOT EXISTS report (
	report_id VARCHAR(50) NOT NULL UNIQUE,
	report_date VARCHAR(50) NOT NULL,
	content VARCHAR(100),
	picture VARCHAR(255) NOT NULL,
	analytical_picture VARCHAR(255),
	user_id VARCHAR(50),
	PRIMARY KEY (report_id),
    FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE
) DEFAULT CHARSET=utf8;