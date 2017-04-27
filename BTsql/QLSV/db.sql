﻿USE master 
CREATE DATABASE QLSV
GO
USE QLSV
GO

CREATE TABLE KHOA
(
	MAKHOA VARCHAR(10),
	TENKHOA NVARCHAR(100),
	NAMTHANHLAP INT,
	PRIMARY KEY (MAKHOA)
)

CREATE TABLE KHOAHOC
(
	MAKHOAHOC VARCHAR(10),
	NAMBATDAU INT ,
	NAMKETTHUC INT,
	PRIMARY KEY (MAKHOAHOC)
)

CREATE TABLE SINHVIEN
(
	MASV VARCHAR(10),
	HOTEN NVARCHAR(100),
	NAMSINH INT,
	DANTOC NVARCHAR(20),
	MALOP VARCHAR(10),
	PRIMARY KEY (MASV)

)

CREATE TABLE CHUONGTRINH
(
	MACT VARCHAR (10),
	TENCHUONGTRINH NVARCHAR(100),
	PRIMARY KEY (MACT)

)

CREATE TABLE MONHOC
(
	MAMH VARCHAR (10),
	TENMONHOC NVARCHAR(100),
	MAKHOA VARCHAR(10),
	PRIMARY KEY (MAMH)
)

CREATE TABLE KETQUA
(
	MASV VARCHAR(10),
	MAMH VARCHAR (10),
	LANTHI INT ,
	DIEM FLOAT,
	PRIMARY KEY (MASV, MAMH,LANTHI)

)

CREATE TABLE GIANGKHOA
(
	MACT VARCHAR(10),
	MAKHOA VARCHAR(10),
	MAMH VARCHAR(10),
	NAMHOC INT,
	HOCKY INT,
	SOTIETLYTHUYET INT,
	SOTIETTHUCHANH INT,
	SOTINCHI INT,
	PRIMARY KEY (MACT,MAKHOA,MAMH)
)

CREATE TABLE LOP
(
	MALOP VARCHAR(10),
	MAKHOAHOC VARCHAR(10),
	MAKHOA VARCHAR(10),
	MACT VARCHAR(10),
	SOTHUTU INT ,
	PRIMARY KEY(MALOP)
)	
GO


INSERT KHOA
VALUES ('CNTT',N'CÔNG NGHỆ THÔNG TIN',1995)
INSERT KHOA
VALUES('VL',N'VẬT LÝ',1970)
INSERT KHOAHOC
VALUES ('K2002',2002,2006)
INSERT KHOAHOC
VALUES ('K2003',2003,2007)
INSERT KHOAHOC
VALUES ('K2004',2004,2008)
INSERT SINHVIEN
VALUES (0212001,N'NGUYỄN VĨNH AN',1984,'KINH','TH2002/01')
INSERT SINHVIEN
VALUES (0212002,N'NGUYỄN THANH BÌNH',1985,'KINH','TH2002/01')
INSERT SINHVIEN
VALUES (0212003,N'NGUYỄN THANH CƯỜNG',1984,'KINH','TH2002/02')
INSERT SINHVIEN
VALUES (0212004,N'NGUYỄN QUỐC DUY',1983,'KINH','TH2002/02')
INSERT SINHVIEN
VALUES (0311001,N'PHAN TUẤN ANH',1985,'KINH','VL2003/01')
INSERT SINHVIEN
VALUES (0311002,N'HUỲNH THANH SANG',1984,'KINH','VL2003/01')

INSERT CHUONGTRINH
VALUES ('CQ',N'CHÍNH QUI')
INSERT MONHOC
VALUES ('THT01',N'TOÁN CAO CẤP AI','CNTT')
INSERT MONHOC
VALUES ('VLT01',N'TOÁN CAO CẤP AI','VL')
INSERT MONHOC
VALUES ('THT02',N'TOÁN RỜI RẠC','CNTT')
INSERT MONHOC
VALUES ('THCSO1',N'CẤU TRÚC DỮ LIỆU 1','CNTT')
INSERT MONHOC
VALUES ('THCS02',N'HỆ ĐIỀU HÀNH','CNTT')

INSERT KETQUA
VALUES(0212001,'THT01',1,4)
INSERT KETQUA
VALUES(0212001,'THT01',2,7)
INSERT KETQUA
VALUES(0212002,'THT01',1,8)
INSERT KETQUA
VALUES(0212003,'THT01',1,6)
INSERT KETQUA
VALUES(0212004,'THT01',1,9)
INSERT KETQUA
VALUES(0212001,'THT02',1,8)
INSERT KETQUA
VALUES(0212002,'THT02',1,5.5)
INSERT KETQUA
VALUES(0212003,'THT02',1,4)
INSERT KETQUA
VALUES(0212003,'THT02',2,6)
INSERT KETQUA
VALUES(0212001,'THCS01',1,6.5)
INSERT KETQUA
VALUES(0212002,'THCS01',1,4)
INSERT KETQUA
VALUES(0212003,'THCS01',1,7)

INSERT GIANGKHOA
VALUES('CQ','CNTT','THT01',2003,1,60,30,5)
INSERT GIANGKHOA
VALUES('CQ','CNTT','THT01',2003,2,45,30,4)
INSERT GIANGKHOA
VALUES('CQ','CNTT','THT01',2004,1,45,30,4)

INSERT LOP
VALUES('TH2002/01','K2002','CNTT','CQ',1)
INSERT LOP
VALUES('TH2002/02','K2002','CNTT','CQ',2)
INSERT LOP
VALUES('VL2003/01','K2003','VL','CQ',1)
GO










-- 4.1
DECLARE @maKhoaHoc VARCHAR(10)
SELECT @maKhoaHoc = MAKHOAHOC FROM KHOAHOC WHERE NAMBATDAU = 2002 AND NAMKETTHUC = 2006

SELECT MALOP INTO tableTestLopEcntt FROM LOP WHERE MAKHOA = 'CNTT' AND MAKHOAHOC = @maKhoaHoc

SELECT * FROM SINHVIEN WHERE MALOP IN (SELECT * FROM tableTestLopEcntt)

--DROP TABLE tableTestLopEcntt
GO

-- 4.2
SELECT MASV, HOTEN, NAMSINH FROM SINHVIEN WHERE YEAR(GETDATE()) - NAMSINH < 18
GO

-- 4.3
SELECT MASV INTO tableTestSVchuaHoc FROM KETQUA WHERE MAMH = 'THCS01'
SELECT MASV FROM SINHVIEN WHERE MASV NOT IN (SELECT * FROM tableTestSVchuaHoc) AND MALOP IN (SELECT * FROM tableTestLopEcntt)
GO

-- 4.4
SELECT MASV INTO tableTest FROM KETQUA WHERE DIEM < 5 AND LANTHI < 2 AND MAMH = 'THCS01'
SELECT * FROM SINHVIEN WHERE MASV IN (SELECT * FROM tableTest)
DROP TABLE tableTest
GO

-- 4.5

SELECT MALOP, COUNT(*) AS [SISO] INTO tableTestDEMsv FROM SINHVIEN WHERE MALOP IN (SELECT * FROM tableTestLopEcntt) GROUP BY MALOP

SELECT L.MALOP, L.MAKHOAHOC, TENCHUONGTRINH, dem.SISO
FROM LOP AS L, CHUONGTRINH AS CT, tableTestDEMsv as dem WHERE L.MAKHOA = 'CNTT' AND L.MACT = CT.MACT AND L.MALOP = dem.MALOP

DROP TABLE tableTestDEMsv
GO

-- 4.6
--SELECT MAMH, MAX(LANTHI) AS [LANTHI] INTO tableTestDiemTB FROM KETQUA WHERE MASV = 0212003 GROUP BY MAMH

--DECLARE @i INT = 0

--WHILE(@i<(SELECT COUNT(*) FROM tableTestDiemTB))
--BEGIN
--	SELECT DIEM INTO tableDiem0212003 FROM KETQUA WHERE MAMH = (SELECT MAMH FROM tableTestDiemTB) AND LANTHI = (SELECT LANTHI FROM tableTestDiemTB) AND MASV = 0212003
--END

--SELECT DIEM FROM KETQUA WHERE 

--SELECT AVG() FROM KETQUA WHERE MASV = 0212003 AND 

--SELECT * FROM KETQUA WHERE MASV = 0212003 

--SELECT * FROM tableTestDiemTB

