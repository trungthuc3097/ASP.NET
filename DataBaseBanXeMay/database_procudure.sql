create database DATABASE_XE_MAY

go
use DATABASE_XE_MAY

CREATE TABLE Categories(
	categories_id int IDENTITY(1,1) NOT NULL primary key,
	categories_name nvarchar(500)
)


CREATE TABLE Employer(
	employer_id int IDENTITY(1,1) NOT NULL primary key,
	employer_name nvarchar(500) ,
	employer_email varchar(500) ,
	employer_phone varchar(15) ,
	avatar nvarchar(100) 
)

CREATE TABLE Main_detail(
	main_detail_id int IDENTITY(1,1) NOT NULL primary key,
	model nvarchar(500) NULL,
	weight float NULL,
	size nvarchar(200) NULL,
	tank_capacity float NULL,
	warranty_period nvarchar(50) 
)

CREATE TABLE Moto_model(
	moto_model_id int IDENTITY(1,1) NOT NULL primary key,
	moto_model_name nvarchar(500)
)


CREATE TABLE Producer(
	producer_id int IDENTITY(1,1) NOT NULL primary key,
	producer_name nvarchar(500) NULL
)

create table Product (
	product_id int IDENTITY(1,1) NOT NULL primary key,
	categories_id int NULL,
	producer_id int NULL,
	main_detail_id int NULL,
	moto_model_id int NULL,
	product_name nvarchar(500) NULL,
	product_image nvarchar(500) NULL,
	product_price float NULL,
	product_quantity int NULL,
	product_description nvarchar(1000) NULL,
	product_review nvarchar(1000) NULL,
	FOREIGN KEY (categories_id) REFERENCES Categories(categories_id),
	FOREIGN KEY (producer_id) REFERENCES Producer(producer_id),
	FOREIGN KEY (main_detail_id) REFERENCES Main_detail(main_detail_id),
	FOREIGN KEY (moto_model_id) REFERENCES Moto_model(moto_model_id)

)

CREATE TABLE Users(
	user_id int IDENTITY(1,1) NOT NULL primary key,
	name nvarchar(50)not null,
	user_name nvarchar(100) not NULL,
	user_address nvarchar(500) NULL,
	user_phone varchar(15) NULL,
	user_email nvarchar(100) NULL,
	user_password varchar(32) not NULL,
	user_permission int NULL
)

CREATE TABLE Orders(
	orders_id int IDENTITY(1,1) NOT NULL primary key,
	user_id int NULL,
	total_money float NULL,
	quantity int NULL,
	orders_date datetime,
	customer_name nvarchar(50) ,
	customer_phone varchar(15) ,
	customer_email nvarchar(50) ,
	customer_address nvarchar(200),
	FOREIGN KEY (user_id) REFERENCES Users(user_id),
)

create table Orders_detail(
	orders_detail_id int IDENTITY(1,1) not null primary key,
	orders_id int,
	product_id int,
	quantity int,
	totalMoney float,	
	FOREIGN KEY (product_id) REFERENCES Product(product_id),
	FOREIGN KEY (orders_id) REFERENCES Orders(orders_id)	
)


CREATE TABLE Contact(
	id int IDENTITY(1,1) NOT NULL primary key,
	name nvarchar(500),
	email nvarchar(500),
	noidung nvarchar(1000)
)

--procedure
--Contact
go
create proc LoadContact
as
select * from Contact
--product
go
create proc LoadProducts
as
select * from Product
go
create proc LoadProductByMoto_ModelID
@motoId int
as
SELECT *FROM  Product where moto_model_id = @motoId
go
create proc LoadProductByProducerID
@producer_Id int
as
SELECT *FROM  Product where producer_id = @producer_Id
go
create proc LoadByCategories
@cateID int
as
SELECT * FROM Product where categories_id = @cateID
go
create proc LoadProductByID
@ProductID int
as
select * from Product where product_id =@ProductID 
go
create proc LoadDetailProductByID
@ProductID int
as
select * from Product p, Main_detail m where p.main_detail_id=m.main_detail_id and  product_id =@ProductID
go
create proc LoadProductByKeySearch
@key_search nvarchar(200)
as
select * from Product where product_name like '%' + @key_search + '%' 

go
CREATE PROCEDURE InsertProduct
	@categories_id int,
	@producer_id int,
	@main_detail_id int,
	@moto_model_id int,
	@product_name nvarchar(500),
	@product_image nvarchar(500), 
	@product_price float,
	@product_quantity int,
	@product_description nvarchar(1000),
	@product_review nvarchar(1000)
	  
AS 
BEGIN 
Insert into Product (categories_id, producer_id, main_detail_id, moto_model_id, product_name, product_image, product_price, product_quantity, product_description, product_review)
VALUES (@categories_id, @producer_id, @main_detail_id, @moto_model_id, @product_name, @product_image, @product_price,@product_quantity,@product_description,@product_review) 
END
go
CREATE PROCEDURE UpdateProduct
	@ProductId int,
	@CategoriesID int,
	@ProducerID int,
	@MainDetailID int,
	@MotoModelID int,
	@ProductName nvarchar(500),
	@ProductImage nvarchar(500), 
	@ProductPrice float,
	@ProductQuantity int,
	@ProductDescription nvarchar(1000),
	@ProductReview nvarchar(1000)
	  
AS 
BEGIN 
Update Product 
set  categories_id = @CategoriesID, producer_id = @ProducerID, main_detail_id = @MainDetailID, moto_model_id = @MotoModelID, product_name = @ProductName, product_image = @ProductImage, product_price = @ProductPrice, product_quantity = @ProductQuantity, product_description = @ProductDescription, product_review = @ProductReview 
where product_id = @ProductId
END
go
CREATE PROCEDURE DeleteProduct
	@ProductId int	  
AS 
BEGIN 
Delete from Product where product_id = @ProductId
END
--Categories
go
create proc LoadCategories
as
select * from Categories

go
create proc LoadCategoriesByID
@CategoriesID int
as
select * from Categories where categories_id =@CategoriesID 

go
CREATE PROCEDURE InsertCategories
	@categories_name nvarchar(500)
	  
AS 
BEGIN 
Insert into Categories 
values ( @categories_name)
END

go
CREATE PROCEDURE UpdateCategories
	@CategoriesId int,
	@CategoriesName nvarchar(500)
	  
AS 
BEGIN 
Update Categories 
set categories_name = @CategoriesName 
where categories_id = @CategoriesId
END

go
CREATE PROCEDURE DeleteCategories
	@CategoriesId int	  
AS 
BEGIN 
Delete from Categories where categories_id = @CategoriesId
END

--Producer
go
create proc LoadProducer
as
select * from Producer
go
create proc LoadProducerByID
@ProducerID int
as
select * from Producer where producer_id =@ProducerID

go
CREATE PROCEDURE InsertProducer
	@producer_name nvarchar(500)
	  
AS 
BEGIN 
Insert into Producer 
values (@producer_name)
END 

go
CREATE PROCEDURE UpdateProducer
	@ProducerId int,
	@ProducerName nvarchar(500)
	  
AS 
BEGIN 
Update Producer 
set producer_name = @ProducerName 
where producer_id = @ProducerId
END 

go
CREATE PROCEDURE DeleteProducer
	@ProducerId int
	  
AS 
BEGIN 
Delete from Producer where producer_id = @ProducerId
END 

--Moto_Model
go
create proc LoadMoto_Model
as
select * from Moto_model

go
create proc LoadMoto_ModelByID
@Moto_modelID int
as
select * from Moto_model where moto_model_id =@Moto_modelID

go
CREATE PROCEDURE InsertMoto_Model
	@Moto_model_name nvarchar(500)
	  
AS 
BEGIN 
Insert into Moto_model 
values (@Moto_model_name)
END 

go
CREATE PROCEDURE UpdateMoto_Model
	@Moto_modelId int,
	@Moto_modelName nvarchar(500)
	  
AS 
BEGIN 
Update Moto_model 
set moto_model_name = @Moto_modelName 
where moto_model_id = @Moto_modelId
END 

go
CREATE PROCEDURE DeleteMoto_Model
	@Moto_modelId int
AS 
BEGIN 
Delete from Moto_model where moto_model_id = @Moto_modelId
END 

--Order
go
create proc LoadIDOrder_detailByID
@orderID int
as 
select * from Orders_detail dt, Orders o where dt.orders_id = o.orders_id and o.orders_id = @orderID

go
create proc LoadOrder
as
select * from Orders

go
create proc LoadOrderByID
@ID int
as
select * from Orders where orders_id = @ID


go
CREATE PROCEDURE InsertOrder
	@user_id int,
	@total_money float,
	@quantity int,
	@orders_date Datetime,
	@customer_name nvarchar(50), 
	@customer_phone varchar(15),
	@customer_email nvarchar(50),
	@customer_address nvarchar(200)
	  
AS 
BEGIN 
insert into orders 
values (@user_id, @total_money, @quantity, @orders_date, @customer_name, @customer_phone, @customer_email, @customer_address)
END

go
CREATE PROCEDURE UpdateOrder
	@orders_id int,
	@user_id int,
	@total_money float,
	@quantity int,
	@orders_date Datetime,
	@customer_name nvarchar(50), 
	@customer_phone varchar(15),
	@customer_email nvarchar(50),
	@customer_address nvarchar(200)
	  
AS 
BEGIN 
Update Orders 
set user_id = @user_id, total_money = @total_money, quantity = @quantity, orders_date = @orders_date, customer_name = @customer_name, customer_phone = @customer_phone, customer_email = @customer_email, customer_address = @customer_address 
where orders_id = @orders_id
END

go
CREATE PROCEDURE DeleteOrder
	@OrderId int
AS 
BEGIN 
Delete from Orders where orders_id = @OrderId
END

--Order_Detail 

go
create proc LoadOrder_Detail
as
select * from Orders_detail

go
create proc LoadOrder_DetailByID
@ID int
as
select * from Orders_detail where orders_detail_id = @ID

go
CREATE PROCEDURE InsertOrder_Detail
	@orders_id int,
	@product_id int,
	@quantity int,
	@totalMoney float
	  
AS 
BEGIN 
insert into Orders_detail 
values (@orders_id,@product_id,@quantity,@totalMoney)
END

go
CREATE PROCEDURE UpdateOrder_Detail
	@orders_detail_id int,
	@orders_id int,
	@product_id int,
	@quantity int,
	@totalMoney float
AS 
BEGIN 
Update Orders_detail set orders_id = @orders_id,product_id = @product_id, quantity = @quantity, totalMoney = @totalMoney 
where orders_detail_id = @orders_detail_id
END

go
CREATE PROCEDURE DeleteOrder_Detail
	@Order_detailId int
AS 
BEGIN 
Delete from Orders_detail where orders_id = @Order_detailId
END

--User
go
create proc LoadUser
as
select * from Users

go
create proc LoadUserByID
	@UserID int
as
select * from Users where user_id =@UserID 

go
CREATE PROCEDURE InsertUser
	@name nvarchar(50),
	@user_name nvarchar(100),
	@user_address nvarchar(500),
	@user_phone varchar(15),
	@user_email nvarchar(100),
	@user_password nvarchar(32),
	@user_permission int
AS 
BEGIN 
Insert into Users 
values (@name,@user_name, @user_address, @user_phone, @user_email, @user_password, @user_permission)
END 

go
CREATE PROCEDURE UpdateUser
	@User_id int,
	@name nvarchar(50),
	@user_name nvarchar(100),
	@user_address nvarchar(500),
	@user_phone varchar(15),
	@user_email nvarchar(100),
	@User_pass nvarchar(32),
	@User_per int
	  
AS 
BEGIN 
Update Users 
set name = @Name, user_name = @User_name, user_address = @User_address, [user_phone] = @User_phone, user_email = @User_email, user_password = @User_pass, user_permission = @User_per 
where user_id = @User_id
END 

go
CREATE PROCEDURE DeleteUser
	@User_id int
	  
AS 
BEGIN 
Delete from Users where user_id = @User_id
END 

--Employer
go
create proc LoadEmployer
as
select * from Employer

go
create proc LoadEmployerByID
	@EmployerID int
as
select * from Employer where employer_id =@EmployerID 

go
CREATE PROCEDURE InsertEmployer
	@employer_name nvarchar(500),
	@employer_email nvarchar(500),
	@employer_phone varchar(15),
	@avatar nvarchar(100)
	  
AS 
BEGIN 
Insert into Employer 
values (@employer_name, @employer_email, @employer_phone, @avatar)
END 

go
CREATE PROCEDURE UpdateEmployer
	@Employer_id int,
	@employer_name nvarchar(500),
	@employer_email nvarchar(500),
	@employer_phone varchar(15),
	@avatar nvarchar(100)
	  
AS 
BEGIN 
Update Employer 
set employer_name = @Employer_name, employer_email = @Employer_email, employer_phone = @Employer_phone, avatar = @Avatar 
where employer_id = @Employer_id
END 

go
CREATE PROCEDURE DeleteEmployer
	@Employer_id int
	  
AS 
BEGIN 
Delete from Employer where employer_id = @Employer_id
END 


--Main_deitail...................
go
create proc LoadMain_Detail
as
select * from Main_detail

go
create proc LoadMain_DetailByID
	@Main_detailID int
as
select * from Main_detail where main_detail_id =@Main_detailID

go
CREATE PROCEDURE InsertMain_Detail
	@model nvarchar(500),
	@weight float,
	@size nvarchar(200),
	@tank_capacity float,
	@warranty_period nvarchar(50)
AS 
BEGIN 
Insert into Main_detail 
values (@model, @weight, @size, @tank_capacity, @warranty_period)
END 

go
CREATE PROCEDURE UpdateMain_Detail
	@mainDetailId int,
	@model nvarchar(500),
	@weight float,
	@size nvarchar(200),
	@tankCapacity float,
	@warrantyPeriod nvarchar(50)
	  
AS 
BEGIN 
Update Main_detail 
set model = @Model, weight = @weight, size = @size, tank_capacity = @tankCapacity, warranty_period = @warrantyPeriod 
where main_detail_id = @mainDetailId
END 

go
CREATE PROCEDURE DeleteMain_Detail
	@Main_detailId int
	  
AS 
BEGIN 
Delete from Main_detail where main_detail_id = @Main_detailId
END

-- INSERT CONTACT
go
CREATE PROCEDURE InsertContact
	@name nvarchar(500),
	@email nvarchar(500),
	@noidung nvarchar(1000)	 
AS 
BEGIN 
Insert into Contact 
VALUES (@name, @email, @noidung) 
END

--drop table Orders_detail
--drop table Orders 
--drop table Product
--drop table Users
--drop table Employer
--drop proc InsertCategories
--drop proc InsertEmployer
--drop proc InsertOrder
--drop proc InsertUser
--drop proc InsertProduct
--drop proc UpdateEmployer
--drop proc UpdateUser
--drop proc UpdateOrder
--drop proc UpdateProduct

-- Ph�n Trang
go
Alter PROCEDURE [dbo].[spPhanTrangSQL]
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
 -- X? l� tru?ng h?p @currPage=1
 IF @currPage=1
 BEGIN
  SET @SQL=@SQL+ N'Trang '
  SET @PageNumber=@PageSize
  IF @PageNumber>@TotalPage SET @PageNumber=@TotalPage
  SET @Start=1
 END
 ELSE
 BEGIN
  SET @SQL=@SQL+ N' <a href="?page=1">Trang ??u</a>'
  SET @SQL=@SQL+ ' <a href="?page='+ 
   Cast((@currPage-1) AS nvarchar(4))+N'"> << </a>'
  -- X? l� tru?ng h?p (@TotalPage-@currPage)<@PageSize/2
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
   AS nvarchar(4))+N'"> >> </a>'
   SET @SQL=@SQL+ N' 
    <a href="?page='+cast(@TotalPage AS nvarchar(6))+
     N'">Trang cu?i</a>'
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
    -- T�nh t?ng s? b?n ghi
    DECLARE @Tolal int
    SELECT @Tolal=Count(*) FROM Product
    
    EXEC spPhanTrangSQL
   @Tolal, 
   @currPage, 
   @Pagesize, 
   @recodperpage
END
exec PhanTrang 9,6,30