-- cho thang, nam. In ra so ngay cua thang thuoc nam do

DECLARE @thang INT = 12
DECLARE @nam INT = 2000

DECLARE @nnT2 INT = 28 

IF((@nam % 4 = 0 AND @nam % 100 <> 0) OR (@nam % 400 = 0)) SET @nnT2 = 29

SELECT CASE
			WHEN @thang IN (1,3,5,7,8,10,12) THEN 31
			WHEN @thang IN (4,6,9,11) THEN 30
			WHEN @thang = 2 THEN @nnT2
			ELSE -1
			END
GO