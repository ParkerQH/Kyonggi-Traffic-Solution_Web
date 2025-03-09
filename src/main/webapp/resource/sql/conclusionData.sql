USE KTSDB;

CREATE TABLE IF NOT EXISTS Conclusion (
	conclusion_id INT AUTO_INCREMENT NOT NULL,
	result VARCHAR(50),
	accuracy FLOAT,
	fine INT,
	date VARCHAR(50),
	analytical_picture VARCHAR(255),
	manager_id VARCHAR(50),
	report_id INT,
	PRIMARY KEY (conclusion_id),
    FOREIGN KEY (manager_id) REFERENCES manager(manager_id) ON DELETE CASCADE,
    FOREIGN KEY (report_id) REFERENCES report(report_id) ON DELETE CASCADE
) DEFAULT CHARSET=utf8;

INSERT INTO Conclusion (result, accuracy, fine, date, analytical_picture, manager_ID, report_ID) VALUES
('승인', 0.86, 40000, '2025-02-26', 'analysis1.jpg', 'admin1', 1),
('반려', 0.89, 0, '2025-03-01', 'analysis2.jpg','admin2', 2),
('승인', 0.68, 20000, '2025-03-01', 'analysis3.jpg','admin3', 3);

DESC Conclusion;
SELECT * FROM Conclusion;
drop table Conclusion;