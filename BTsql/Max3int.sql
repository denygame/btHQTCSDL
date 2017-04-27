-- 3 so nguyen tuy y. In ra so lon nhat

DECLARE @a INT = 5
DECLARE @b INT = 8
DECLARE @c INT = 6

DECLARE @max INT = 0
IF(@max < @a) SET @max = @a
IF(@max < @b) SET @max = @b
IF(@max < @c) SET @max = @c

PRINT N'Số lớn nhất là: ' + CAST(@max AS CHAR)
GO
