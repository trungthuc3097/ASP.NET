CREATE PROCEDURE [dbo].[spPhanTrangSQL]
@Total int,
@currPage int ,
@PageSize int,
@rowperpage int  
AS
BEGIN
DECLARE  @PageNumber int SET @PageNumber=1
DECLARE @i int
SET @i=1
DECLARE @TotalPage int
IF @Total%@rowperpage>0
SET @TotalPage=(@Total/@rowperpage)+1
ELSE
SET @TotalPage=@Total/@rowperpage 
DECLARE @Start int SET @Start=0
DECLARE @SQL nvarchar(4000)
SET @SQL=''
IF @currPage<=@TotalPage
BEGIN
 -- Xử lý trường hợp @currPage=1
 IF @currPage=1
 BEGIN
  SET @SQL=@SQL+ N'Trang '
  SET @PageNumber=@PageSize
  IF @PageNumber>@TotalPage SET @PageNumber=@TotalPage
  SET @Start=1
 END
 ELSE
 BEGIN
  SET @SQL=@SQL+ N' <a href="?page=1">Trang đầu</a>'
  SET @SQL=@SQL+ ' <a href="?page='+ 
   Cast((@currPage-1) AS nvarchar(4))+N'">Trang trước</a>'
  -- Xử lý trường hợp (@TotalPage-@currPage)<@PageSize/2
  IF(@TotalPage-@currPage)<@PageSize/2
     BEGIN
     SET @Start=(@TotalPage-@PageSize)+1
     IF @Start<=0 SET @Start=1 
     SET @PageNumber = @TotalPage
     END
  ELSE
  BEGIN
   IF (@currPage-(@PageSize/2))=0
   BEGIN
    SET @Start=1
    SET @PageNumber=@currPage+(@PageSize/2)+1
    IF @TotalPage<@PageNumber
     SET @PageNumber=@TotalPage
   END
   ELSE
      BEGIN
      SET @Start=@currPage-(@PageSize/2)
      IF @Start<=0 SET @Start=1 
      SET @PageNumber=@currPage+(@PageSize/2)
      IF @TotalPage<@PageNumber
          SET @PageNumber=@TotalPage
      ELSE
      IF @PageNumber <@PageSize 
          SET @PageNumber=@PageSize
      END
  END
  END 
  
 SET @i=@Start
 WHILE @i<=@PageNumber
 BEGIN
  IF @i=@currPage
   SET @SQL=@SQL+'
    ['+Cast(Cast(@i AS int) AS nvarchar(4))+'] '
  ELSE
   SET @SQL=@SQL+'
    <a href="?page='+Cast(@i AS nvarchar(4))+'">'
    +Cast(@i AS nvarchar(4))+'</a> '
  SET @i=@i+1 
 END
 IF @currPage<@TotalPage
 BEGIN
  SET @SQL=@SQL+ N'
   <a href="?page='+Cast((@currPage+1) 
   AS nvarchar(4))+N'">Trang sau</a>'
   SET @SQL=@SQL+ N' 
    <a href="?page='+cast(@TotalPage AS nvarchar(6))+
     N'">Trang cuối</a>'
 END
 SELECT @SQL AS PhanTrang 
 -- PRINT @SQL
END
END

CREATE proc PhanTrang
@currPage int,
@recodperpage int,
@Pagesize int
AS
Begin
    Begin
    WITH s AS
    (
        SELECT ROW_NUMBER() 
   OVER(ORDER BY product_id ,
   product_name) AS RowNum, 
   product_id, 
   product_name,
   product_price,
   product_image  
        FROM Product  
    )
    Select * From s 
    Where RowNum Between 
  (@currPage - 1)*@recodperpage+1 
   AND @currPage*@recodperpage
    END
    -- Tính tổng số bản ghi
    DECLARE @Tolal int
    SELECT @Tolal=Count(*) FROM Product
    
    EXEC spPhanTrangSQL
   @Tolal, 
   @currPage, 
   @Pagesize, 
   @recodperpage
END
exec PhanTrang 9,6,30