-- cho 1 so nguyen n bat ky. (1) in ra so tu 1 -> n. (2) in ra tong so chan tu 1 -> n

DECLARE @n INT = 10
DECLARE @i INT = 1
DECLARE @s INT = 0

WHILE(@i <= @n)
BEGIN
	PRINT @i
	IF(@i % 2 = 0) SET @s = @s + @i
	SET @i = @i + 1
END

PRINT N'Tổng các số chẵn: ' + CAST(@s AS CHAR)
GO