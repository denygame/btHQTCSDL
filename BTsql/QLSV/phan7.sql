USE QLSV
GO

-- 7.1, 7.9
create trigger UTG_insert_update_CT on dbo.CHUONGTRINH for insert,update
as
begin
	declare @checkFalse int = 0
	declare  @tab table(name  varchar(100))
	insert into @tab   values('TC'),('CQ'),('CD')
	declare @count int=0
	SELECT @count=COUNT(MACT) from inserted where MACT in (select * from @tab)
	if(@count=0)
	begin
		print 'khong the insert chuong trinh co ma khac TC, CQ, CD'
		set @checkFalse = @checkFalse + 1
	end


	-- ten chuong trinh phai phan biet
	declare @ten nvarchar(100)
	select @ten = TENCHUONGTRINH from CHUONGTRINH
	if((select COUNT(*) from inserted where TENCHUONGTRINH not in (select TENCHUONGTRINH from CHUONGTRINH))=0)
	begin
		print 'ten chuong trinh phai phan biet'
		set @checkFalse = @checkFalse + 1
	end

	if(@checkFalse != 0) rollback tran
end
go







-- 7.2, 7.3, 7.4, 7.5, 7.8
create trigger UTG_insert_update_GIANGKHOA ON dbo.GIANGKHOA for insert, update
as
begin
	declare @checkFalse int = 0
	declare  @tab table(hocky  int)
	insert into @tab  values(1),(2)
	declare @count int=0
	SELECT @count=COUNT(HOCKY) from inserted where HOCKY in (select * from @tab)
	if(@count=0)
	begin
		print 'chi co hoc ky 1,2'
		set @checkFalse = @checkFalse + 1
	end

	if((select SOTIETLYTHUYET from inserted) > 120)
	begin
		print 'so tiet ly thuyet toi da la 120'
		set @checkFalse = @checkFalse + 1
	end

	if((select SOTIETTHUCHANH from inserted) > 60)
	begin
		print 'so tiet thuc hanh toi da la 60'
		set @checkFalse = @checkFalse + 1
	end

	if((select SOTINCHI from inserted) > 6)
	begin
		print 'so tin chi toi da la 6'
		set @checkFalse = @checkFalse + 1
	end

	if((select SOTIETLYTHUYET from inserted) < (select SOTIETTHUCHANH from inserted))
	begin
		print 'so tiet ly thuyet >= so tiet thuc hanh'
		set @checkFalse = @checkFalse + 1
	end

	if(@checkFalse != 0) rollback tran
end
go


-- 7.6 , 7.12, 7.15
create trigger UTG_insert_update_KQ on dbo.KETQUA for insert, update
as
begin
	declare @checkFalse int = 0

	declare @d float
	select @d = DIEM from inserted

	if(@d > 10 or @d < 0)
	begin
		print 'chi diem he so 10'
		set @checkFalse = @checkFalse + 1
	end

	IF FLOOR(@d/0.5) <> CEILING(@d/0.5)
	begin --float. Chia 0.5 thanh float thi change
		UPDATE dbo.KETQUA
		SET DIEM = ROUND(@d * 2, 0) / 2 
		FROM dbo.KETQUA
		INNER JOIN inserted i on i.MAMH = KETQUA.MAMH and i.MASV = KETQUA.MASV and i.LANTHI = KETQUA.LANTHI
	end


	-- SV CHỈ DC THI 2 LAN CHO 1 MON HOC
	if((select LANTHI FROM inserted) > 2)
	begin
		print 'moi sinh vien chi dc thi 2 lan'
		set @checkFalse = @checkFalse + 1
	end


	-- 7.15 chi dc thi mon co trong chuong trinh va trong khoa   -------------- xem lai
	declare @masv varchar(10)
	select @masv = MASV from inserted
	
	declare @malop varchar(10)
	select @malop = MALOP from SINHVIEN where MASV = @masv

	declare @mact varchar(10)
	select @mact = MACT from LOP where MALOP = @malop

	declare @makhoa varchar(10)
	select @makhoa = MAKHOA from LOP where MALOP = @malop

	declare @mamhInsert varchar(10)
	select @mamhInsert = MAMH from inserted

	if(@mamhInsert not in (select MAMH from GIANGKHOA where MAKHOA = @makhoa and MACT = @mact))
	begin
		print 'sv chi co the tham gia thi mon hoc trong chuong trinh hay trong khoa'
		set @checkFalse = @checkFalse + 1
	end







	if(@checkFalse != 0) rollback tran
end
go



-- 7.7
create trigger UTG_insert_update_KHOAHOC on dbo.KHOAHOC for insert, update
as
begin
	if((select NAMKETTHUC from inserted) < (select NAMBATDAU from inserted))
	begin
		print 'nam ket thuc >= nam bat dau'
		rollback transaction
	end
end
go

-- 7.10
create trigger UTG_insert_update_KHOA ON dbo.KHOA for insert,update
as
begin
	declare @ten nvarchar(100)
	select @ten = TENKHOA from KHOA
	if((select COUNT(*) from inserted where TENKHOA not in (select TENKHOA from KHOA))=0)
	begin
		print 'ten KHOA phai phan biet'
		rollback transaction
	end
end
go

-- 7.11
create trigger UTG_insert_update_MONHOC on dbo.MONHOC for insert, update
as
begin
	declare @ten nvarchar(100)
	select @ten = TENMONHOC from MONHOC
	if((select COUNT(*) from inserted where TENMONHOC not in (select TENMONHOC from MONHOC))=0)
	begin
		print 'ten mon hoc phai la duy nhat'
		rollback transaction
	end
end
go

-- 7.14 xem lai
create trigger UTG_insert_update_LOP on dbo.LOP for insert,update
as
begin
	declare @makhoahoc varchar(10)
	declare @makhoa varchar(10)
	select @makhoa = MAKHOA, @makhoahoc = MAKHOAHOC from inserted

	if((select NAMBATDAU from KHOAHOC where MAKHOAHOC = @makhoahoc) < (select NAMTHANHLAP from KHOA where MAKHOA = @makhoa))
	BEGIN
		print 'nam bat dau khoa hoc >= nam thanh lap khoa'
		rollback tran
	END
end
go




-- 7.16

















--SELECT ROUND(15 * 2, 0) / 2 


--declare @value float = 1.56/0.5

--IF FLOOR(@value) <> CEILING(@value)
--BEGIN
--    PRINT 'this is float number'
--END
--ELSE
--BEGIN
--    PRINT 'this is integer number'
--END