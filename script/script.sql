USE [master]
GO
/****** Object:  Database [carrentaldb]    Script Date: 3/11/2022 5:56:36 PM ******/
CREATE DATABASE [carrentaldb]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'carrentaldb', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\carrentaldb.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'carrentaldb_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\carrentaldb_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [carrentaldb] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [carrentaldb].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [carrentaldb] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [carrentaldb] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [carrentaldb] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [carrentaldb] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [carrentaldb] SET ARITHABORT OFF 
GO
ALTER DATABASE [carrentaldb] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [carrentaldb] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [carrentaldb] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [carrentaldb] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [carrentaldb] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [carrentaldb] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [carrentaldb] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [carrentaldb] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [carrentaldb] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [carrentaldb] SET  DISABLE_BROKER 
GO
ALTER DATABASE [carrentaldb] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [carrentaldb] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [carrentaldb] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [carrentaldb] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [carrentaldb] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [carrentaldb] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [carrentaldb] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [carrentaldb] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [carrentaldb] SET  MULTI_USER 
GO
ALTER DATABASE [carrentaldb] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [carrentaldb] SET DB_CHAINING OFF 
GO
ALTER DATABASE [carrentaldb] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [carrentaldb] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [carrentaldb] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [carrentaldb] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [carrentaldb] SET QUERY_STORE = OFF
GO
USE [carrentaldb]
GO
/****** Object:  User [Rida]    Script Date: 3/11/2022 5:56:36 PM ******/
CREATE USER [Rida] FOR LOGIN [rida] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  DatabaseRole [worker]    Script Date: 3/11/2022 5:56:36 PM ******/
CREATE ROLE [worker]
GO
/****** Object:  DatabaseRole [secretary]    Script Date: 3/11/2022 5:56:36 PM ******/
CREATE ROLE [secretary]
GO
/****** Object:  DatabaseRole [manager]    Script Date: 3/11/2022 5:56:36 PM ******/
CREATE ROLE [manager]
GO
ALTER ROLE [secretary] ADD MEMBER [Rida]
GO
/****** Object:  Schema [secretary]    Script Date: 3/11/2022 5:56:36 PM ******/
CREATE SCHEMA [secretary]
GO
/****** Object:  Table [dbo].[TBLCAR]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBLCAR](
	[CAR_ID] [int] IDENTITY(100,1) NOT NULL,
	[CAR_LOC_ID] [int] NOT NULL,
	[CAR_COLOR] [varchar](256) NULL,
	[CAR_YEAR] [int] NULL,
	[CAR_MODEL] [varchar](256) NULL,
	[CAR_TYPE] [varchar](256) NULL,
	[CAR_RENTED_STATUS] [bit] NULL,
	[CAR_PRICE_PER_DAY] [float] NULL,
	[CAR_PENALTY_PER_DAY] [float] NULL,
 CONSTRAINT [PK_TBLCAR] PRIMARY KEY CLUSTERED 
(
	[CAR_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vwCarStatus]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[vwCarStatus]
as
	select c.CAR_ID as [Car Id], CAR_RENTED_STATUS as status
	from TBLCAR as c
GO
/****** Object:  Table [dbo].[TBLBRANCH]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBLBRANCH](
	[LOC_ID] [int] IDENTITY(200,1) NOT NULL,
	[LOC_NAME] [varchar](128) NULL,
	[LOC_EMAIL] [varchar](128) NULL,
	[LOC_STREET] [varchar](128) NULL,
	[LOC_PHONE] [varchar](128) NULL,
 CONSTRAINT [PK_TBLBRANCH] PRIMARY KEY CLUSTERED 
(
	[LOC_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vwCarsAndBranch]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vwCarsAndBranch]
as
		SELECT CAR_ID AS Car_Id, s.status as [Status], LOC_NAME as Branch, CAR_COLOR AS Color, CAR_YEAR as Year, CAR_MODEL as Model, CAR_TYPE as Type,
CAR_PRICE_PER_DAY as Price, CAR_PENALTY_PER_DAY as Penalty
		FROM TBLCAR as c, TBLBRANCH as b, vwCarStatus as s
		where c.CAR_LOC_ID = b.LOC_ID and s.[Car Id] = c.CAR_ID
GO
/****** Object:  Table [dbo].[TBLRENTINFO]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBLRENTINFO](
	[RI_RENT_ID] [int] IDENTITY(1,1) NOT NULL,
	[RI_CT_ID] [int] NOT NULL,
	[RI_CAR_ID] [int] NOT NULL,
	[RI_NB_OF_DAYS] [int] NULL,
	[RI_RENTED_DAY] [datetime] NULL,
	[RI_ARR_DATE] [datetime] NULL,
	[RI_ARR_DUE] [datetime] NULL,
	[RI_PENALTY] [float] NULL,
	[RI_AMOUNT] [float] NULL,
 CONSTRAINT [PK_TBLRENTINFO] PRIMARY KEY CLUSTERED 
(
	[RI_RENT_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vwGreaterThan]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vwGreaterThan]
AS
select ri_car_id, sum(ri_amount) as total, sum(RI_PENALTY) as penalty
from TBLRENTINFO
group by RI_CAR_ID
GO
/****** Object:  UserDefinedFunction [dbo].[fnGetLessThan]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
FN INPUT: Amount
FN OUTPUT: All cars that have generated more than amount
*/

CREATE FUNCTION [dbo].[fnGetLessThan](@amount float)
RETURNS TABLE
RETURN
	SELECT * 
	FROM vwGreaterThan 
	WHERE (total + penalty) > @amount
GO
/****** Object:  UserDefinedFunction [dbo].[fnViewCarById]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
FN INPUT: Car id
FN OUTPUT: Car and it's branch attributes
*/
CREATE FUNCTION [dbo].[fnViewCarById](@cid int)
RETURNS TABLE
RETURN (select *
		from vwCarsAndBranch 
		where CAR_ID = @cid)
GO
/****** Object:  UserDefinedFunction [dbo].[fnViewArrivalInThisDate]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
FN INPUT: some date
FN OUTPUT: view all cars that arrived in this date
*/

CREATE FUNCTION [dbo].[fnViewArrivalInThisDate] (@dd Date)
RETURNS TABLE
RETURN (select RI_RENT_ID as rid, RI_CT_ID as cid, RI_NB_OF_DAYS as nbDays,
		RI_ARR_DATE as [arrival], RI_ARR_DUE as [due], RI_PENALTY as penalty,
		RI_AMOUNT as [total payed]
		from TBLRENTINFO
		where RI_ARR_DATE = @dd)

GO
/****** Object:  Table [dbo].[TBLACCOUNT]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBLACCOUNT](
	[AC_CARD_NUMBER] [int] IDENTITY(1,1) NOT NULL,
	[AC_CT_ID] [int] NOT NULL,
	[AC_BALANCE] [float] NULL,
 CONSTRAINT [PK_TBLACCOUNT] PRIMARY KEY CLUSTERED 
(
	[AC_CARD_NUMBER] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[fnViewCardById]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
FN INPUT: card id
FN OUTPUT: account attr
*/

CREATE FUNCTION [dbo].[fnViewCardById](@card_id int)
RETURNS TABLE
RETURN (
		select AC_CARD_NUMBER as [card number], AC_CT_ID as [customer id],
		AC_BALANCE as balance
		from TBLACCOUNT 
		where AC_CARD_NUMBER = @card_id
	)
GO
/****** Object:  Table [dbo].[TBLCUSTOMER]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBLCUSTOMER](
	[CT_ID] [int] IDENTITY(1,1) NOT NULL,
	[CT_FIRSTNAME] [varchar](256) NULL,
	[CT_LASTNAME] [varchar](256) NULL,
	[CT_ADDRESS] [varchar](256) NULL,
	[CT_AGE] [int] NULL,
	[CT_EMAIL] [varchar](256) NULL,
	[CT_PASSWORD] [varchar](256) NULL,
	[CT_PREMUIM] [bit] NULL,
 CONSTRAINT [PK_TBLCUSTOMER] PRIMARY KEY CLUSTERED 
(
	[CT_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[fnSelectCustomerFromId]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
FN INPUT: Cust id
FN OUTPUT: Return Cust attributes
*/

CREATE function [dbo].[fnSelectCustomerFromId] (@cid int)
returns table
as
return
(
    select CT_ID as cid, CT_FIRSTNAME as firstname, CT_LASTNAME as lastname,
	CT_ADDRESS as [address], CT_EMAIL as email, CT_PASSWORD as [password],
	CT_PREMUIM as premium
	from TBLCUSTOMER
	where ct_id = @cid
)
GO
/****** Object:  Table [dbo].[TBLINSURANCE]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBLINSURANCE](
	[INS_ID] [int] IDENTITY(200,1) NOT NULL,
	[INS_CAR_ID] [int] NOT NULL,
	[INS_STARTING_DATE] [datetime] NULL,
	[INS_EXPIRY_DATE] [datetime] NULL,
	[INS_COST] [float] NULL,
 CONSTRAINT [PK_TBLINSURANCE] PRIMARY KEY CLUSTERED 
(
	[INS_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vwInsuranceHistory]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vwInsuranceHistory]
as
	Select INS_ID as insId, INS_CAR_ID as carId,
		Convert(date,INS_STARTING_DATE) as [starting date],
		Convert(date, ins_expiry_date) as [expiry date]
		from TBLiNSURANCE
GO
/****** Object:  Table [dbo].[TBLREQUEST]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBLREQUEST](
	[REQ_ID] [int] IDENTITY(1,1) NOT NULL,
	[REQ_RI_RENT_ID] [int] NOT NULL,
	[REQ_CT_ID] [int] NOT NULL,
	[REQ_AC_CARD_NUMBER] [int] NOT NULL,
	[REQ_STATUS] [int] NULL,
	[REQ_DATE] [datetime] NULL,
	[REQ_CONFIRMDATE] [datetime] NULL,
 CONSTRAINT [PK_TBLREQUEST] PRIMARY KEY CLUSTERED 
(
	[REQ_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vwPendingRequests]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vwPendingRequests]
as
	select REQ_ID as reqId,REQ_RI_RENT_ID as rentId
		,REQ_STATUS as [status],REQ_DATE as initDate
		FROM TBLREQUEST 
		WHERE REQ_STATUS = 0
GO
/****** Object:  View [dbo].[vwRentedCars]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vwRentedCars]
as
	select *
	from vwCarsAndBranch
	where [status] = 1
GO
/****** Object:  View [dbo].[vwAllCustomers]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[vwAllCustomers]
as
	Select CT_ID as cid, CT_FIRSTNAME as firstname, CT_LASTNAME as lastname,
	CT_ADDRESS as [address], CT_EMAIL as email, CT_PASSWORD as [password],
	CT_PREMUIM as premium
	From TBLCUSTOMER 
GO
/****** Object:  View [dbo].[vwExpiredInsurance]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[vwExpiredInsurance]
as
		Select INS_ID as insId, INS_CAR_ID as carId,
		Convert(date,INS_STARTING_DATE) as [starting date],
		Convert(date, ins_expiry_date) as [expiry date]
		from TBLiNSURANCE 
        where INS_EXPIRY_DATE < GETDATE()
GO
/****** Object:  View [dbo].[vwCustRentInfo]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vwCustRentInfo]
as
	select cid, email, ri_car_id as carid, ri_amount as amount
	from vwAllCustomers as v, tblRentInfo as r
	where v.cid = r.RI_CT_ID
GO
/****** Object:  UserDefinedFunction [dbo].[fnLoadTables]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
FN INPUT: DB name
FN OUTPUT: Tables in DB
*/

CREATE function [dbo].[fnLoadTables] ( @dbname varchar(30) )
returns table
return
	select [name]
	from sysobjects 
	where type = 'U'
GO
/****** Object:  View [dbo].[vwDbNames]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vwDbNames]
as
	select [name]
	from sys.databases
GO
/****** Object:  Table [dbo].[TBLADMINST]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBLADMINST](
	[ADMIN_ID] [int] NOT NULL,
	[ADMIN_EMAIL] [varchar](256) NULL,
	[ADMIN_PASSWORD] [varchar](256) NULL,
	[ADM_CARD_NB] [int] NULL,
 CONSTRAINT [PK_TBLADMINST] PRIMARY KEY CLUSTERED 
(
	[ADMIN_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TBLLOGGED]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBLLOGGED](
	[LID] [int] NULL,
	[CST] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TBLRENT]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBLRENT](
	[RT_CT_ID] [int] NOT NULL,
	[RT_CAR_ID] [int] NOT NULL,
 CONSTRAINT [PK_TBLRENT] PRIMARY KEY CLUSTERED 
(
	[RT_CT_ID] ASC,
	[RT_CAR_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [HAVEACCOUNT_FK]    Script Date: 3/11/2022 5:56:36 PM ******/
CREATE NONCLUSTERED INDEX [HAVEACCOUNT_FK] ON [dbo].[TBLACCOUNT]
(
	[AC_CT_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [LOCATED_FK]    Script Date: 3/11/2022 5:56:36 PM ******/
CREATE NONCLUSTERED INDEX [LOCATED_FK] ON [dbo].[TBLCAR]
(
	[CAR_LOC_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [COVERS_FK]    Script Date: 3/11/2022 5:56:36 PM ******/
CREATE NONCLUSTERED INDEX [COVERS_FK] ON [dbo].[TBLINSURANCE]
(
	[INS_CAR_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [RENT_FK]    Script Date: 3/11/2022 5:56:36 PM ******/
CREATE NONCLUSTERED INDEX [RENT_FK] ON [dbo].[TBLRENT]
(
	[RT_CT_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [RENT2_FK]    Script Date: 3/11/2022 5:56:36 PM ******/
CREATE NONCLUSTERED INDEX [RENT2_FK] ON [dbo].[TBLRENT]
(
	[RT_CAR_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [GETRENTINFO_FK]    Script Date: 3/11/2022 5:56:36 PM ******/
CREATE NONCLUSTERED INDEX [GETRENTINFO_FK] ON [dbo].[TBLRENTINFO]
(
	[RI_CT_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [HASRENTINFO_FK]    Script Date: 3/11/2022 5:56:36 PM ******/
CREATE NONCLUSTERED INDEX [HASRENTINFO_FK] ON [dbo].[TBLRENTINFO]
(
	[RI_CAR_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [ASSOCIATION_22_FK]    Script Date: 3/11/2022 5:56:36 PM ******/
CREATE NONCLUSTERED INDEX [ASSOCIATION_22_FK] ON [dbo].[TBLREQUEST]
(
	[REQ_CT_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [BELONGS_FK]    Script Date: 3/11/2022 5:56:36 PM ******/
CREATE NONCLUSTERED INDEX [BELONGS_FK] ON [dbo].[TBLREQUEST]
(
	[REQ_RI_RENT_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [REFUNDED_FK]    Script Date: 3/11/2022 5:56:36 PM ******/
CREATE NONCLUSTERED INDEX [REFUNDED_FK] ON [dbo].[TBLREQUEST]
(
	[REQ_AC_CARD_NUMBER] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TBLCAR]  WITH CHECK ADD  CONSTRAINT [FK_TBLCAR_LOCATED_TBLBRANC] FOREIGN KEY([CAR_LOC_ID])
REFERENCES [dbo].[TBLBRANCH] ([LOC_ID])
GO
ALTER TABLE [dbo].[TBLCAR] CHECK CONSTRAINT [FK_TBLCAR_LOCATED_TBLBRANC]
GO
ALTER TABLE [dbo].[TBLINSURANCE]  WITH CHECK ADD  CONSTRAINT [FK_TBLINSUR_COVERS_TBLCAR] FOREIGN KEY([INS_CAR_ID])
REFERENCES [dbo].[TBLCAR] ([CAR_ID])
GO
ALTER TABLE [dbo].[TBLINSURANCE] CHECK CONSTRAINT [FK_TBLINSUR_COVERS_TBLCAR]
GO
ALTER TABLE [dbo].[TBLRENT]  WITH CHECK ADD  CONSTRAINT [FK_TBLRENT_RENT2_TBLCAR] FOREIGN KEY([RT_CAR_ID])
REFERENCES [dbo].[TBLCAR] ([CAR_ID])
GO
ALTER TABLE [dbo].[TBLRENT] CHECK CONSTRAINT [FK_TBLRENT_RENT2_TBLCAR]
GO
ALTER TABLE [dbo].[TBLRENTINFO]  WITH CHECK ADD  CONSTRAINT [FK_TBLRENTI_GETRENTIN_TBLCUSTO] FOREIGN KEY([RI_CT_ID])
REFERENCES [dbo].[TBLCUSTOMER] ([CT_ID])
GO
ALTER TABLE [dbo].[TBLRENTINFO] CHECK CONSTRAINT [FK_TBLRENTI_GETRENTIN_TBLCUSTO]
GO
ALTER TABLE [dbo].[TBLRENTINFO]  WITH CHECK ADD  CONSTRAINT [FK_TBLRENTI_HASRENTIN_TBLCAR] FOREIGN KEY([RI_CAR_ID])
REFERENCES [dbo].[TBLCAR] ([CAR_ID])
GO
ALTER TABLE [dbo].[TBLRENTINFO] CHECK CONSTRAINT [FK_TBLRENTI_HASRENTIN_TBLCAR]
GO
ALTER TABLE [dbo].[TBLREQUEST]  WITH CHECK ADD  CONSTRAINT [FK_TBLREQUE_ASSOCIATI_TBLCUSTO] FOREIGN KEY([REQ_CT_ID])
REFERENCES [dbo].[TBLCUSTOMER] ([CT_ID])
GO
ALTER TABLE [dbo].[TBLREQUEST] CHECK CONSTRAINT [FK_TBLREQUE_ASSOCIATI_TBLCUSTO]
GO
ALTER TABLE [dbo].[TBLREQUEST]  WITH CHECK ADD  CONSTRAINT [FK_TBLREQUE_BELONGS_TBLRENTI] FOREIGN KEY([REQ_RI_RENT_ID])
REFERENCES [dbo].[TBLRENTINFO] ([RI_RENT_ID])
GO
ALTER TABLE [dbo].[TBLREQUEST] CHECK CONSTRAINT [FK_TBLREQUE_BELONGS_TBLRENTI]
GO
ALTER TABLE [dbo].[TBLREQUEST]  WITH CHECK ADD  CONSTRAINT [FK_TBLREQUE_REFUNDED_TBLACCOU] FOREIGN KEY([REQ_AC_CARD_NUMBER])
REFERENCES [dbo].[TBLACCOUNT] ([AC_CARD_NUMBER])
GO
ALTER TABLE [dbo].[TBLREQUEST] CHECK CONSTRAINT [FK_TBLREQUE_REFUNDED_TBLACCOU]
GO
/****** Object:  StoredProcedure [dbo].[spAddCar]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
SP INPUT: CAR ATTRIBUTES
SP OUTPUT: NONE
SP WORK: ADDING NEW CAR
*/



CREATE PROCEDURE [dbo].[spAddCar]
    @color varchar(256),
    @year varchar(256),
    @model varchar(256),
    @type varchar(256),
    @pricepday float,
    @penaltypday float,
    @location int,
    @insuranceCost float,
	@errorcode	int	output
AS

BEGIN

    DECLARE @cid int
	set @errorcode = 1
	if(exists(select * from TBLBRANCH where LOC_ID = @location))
	begin
		/*suppose we added cars from 100...120 , we deleted 120 and 119 and 118
		the id count wil still at 120, so new car id is 121 but selected id=117+1*/
		/*should do: move set @cid = ... to after insert*/
		/*the new id count will be max and unique*/
		insert into tblcar (CAR_COLOR,CAR_YEAR,CAR_MODEL,CAR_TYPE,CAR_PRICE_PER_DAY,CAR_PENALTY_PER_DAY,CAR_LOC_ID,CAR_RENTED_STATUS)
		values (lower(@color), @year,lower(@model), lower(@type),
		@pricepday,@penaltypday,lower(@location),0);
		set @cid = (select MAX(CAR_ID) from TBLCAR ) + 1;
		insert into TBLINSURANCE (INS_CAR_ID,INS_STARTING_DATE,INS_EXPIRY_DATE,INS_COST)
		values (@cid,getdate(),(select Convert(date, dateadd(month, 6, (getdate())))),@insuranceCost)
	end
	else
	begin
		set @errorcode = -1
	end
END
GO
/****** Object:  StoredProcedure [dbo].[spAddCustomer]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*
SP INPUT: Customer Attr
SP JOB: Add Customer
SP Handles: Proc called after Checking if email is not duplicated
*/

CREATE PROC [dbo].[spAddCustomer]
    @fname		varchar(256),
    @lname		varchar(256),
    @age		int,
    @address	varchar(256),
    @email		varchar(256),
    @password	varchar(256)

AS 
	Begin
		INSERT INTO TBLCUSTOMER (
		CT_FIRSTNAME, CT_LASTNAME, 
		CT_AGE, CT_ADDRESS, CT_EMAIL, CT_PASSWORD)
		VALUES
		--Password is case sensitive
		(Lower(@fname), Lower(@lname), 
		@age, @address, Lower(@email), @password);
	End
GO
/****** Object:  StoredProcedure [dbo].[spAddRole]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
sp in: role name
sp do: create role
*/

CREATE proc [dbo].[spAddRole]
	@rolename	varchar(30),
	@ownername	varchar(30) = NULL
as
	Declare
		@exec_stmt	varchar(1000)

	if @ownername is null
		select @ownername = user_name()

	set @exec_stmt = 'create role '
	set @exec_stmt += quotename(@rolename, ']')
	set @exec_stmt +=' authorization '
	set @exec_stmt += quotename(@ownername, ']')

	print @exec_stmt
	exec(@exec_stmt)
GO
/****** Object:  StoredProcedure [dbo].[spAllCustStat]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*View all customer rental details
using cursors*/

CREATE Proc [dbo].[spAllCustStat]
As
	Declare crAllStat Cursor
	For (
		Select cid
		From vwCustRentInfo
	)
	Declare 
		@cid	int,
		@currid	int
	
	set @currid = -1	--dummy id
	Open crAllStat
	Fetch Next From crAllStat Into @cid
	While @@FETCH_STATUS = 0
		Begin
			if @currid != @cid --don't execute duplicated id's (Hint: we could use select distict in query)
				exec spCustStat @cid
			set @currid = @cid
			Fetch Next From crAllStat Into @cid
			
		End
	Close crAllStat
	Deallocate crAllStat
GO
/****** Object:  StoredProcedure [dbo].[spCheckCardIdAvailability]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
SP INPUT: card id
SP JOB: Check if Card is valid
*/

CREATE PROC [dbo].[spCheckCardIdAvailability]
	@card_id int,
	@errorcode int OUTPUT
AS
	IF exists (SELECT 1
			   FROM TBLACCOUNT
			   WHERE AC_CARD_NUMBER = @card_id)
		BEGIN	
			set @errorcode = 1;
			PRINT 'Card number found'
		END
	ELSE
		BEGIN
			SET @errorcode = -1;
			PRINT 'Enter valid card id'
		END
GO
/****** Object:  StoredProcedure [dbo].[spCheckCarIdAvailability]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
SP INPUT: Car id
SP JOB: Check if id exists
*/

CREATE PROC [dbo].[spCheckCarIdAvailability]
	@car_id int,
	@errorcode int OUTPUT
AS
	IF exists (select 1
			   from TBLCAR 
			   where CAR_ID = @car_id)
		BEGIN
			SET @errorcode = 1;
			PRINT 'Car id found';
		END
	ELSE
		BEGIN
			SET @errorcode = -1;
			PRINT 'Enter valid car ID'
		END
GO
/****** Object:  StoredProcedure [dbo].[spCheckPendingRequestsAvailability]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
SP JOB: Check if there's Pending Requests
*/

CREATE PROC [dbo].[spCheckPendingRequestsAvailability]
	@errorcode int OUTPUT
AS
	IF ((select COUNT(*)
		 FROM TBLREQUEST 
		 WHERE REQ_STATUS = 0) >0 )
	BEGIN
		SET @errorcode = 1;
		PRINT 'There is requests not checked yet'
	END
	ELSE
	BEGIN
		SET @errorcode = -1;
		PRINT 'No results found'
	END
GO
/****** Object:  StoredProcedure [dbo].[spCheckPremium]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
SP INPUT: Cust id
SP JOB: Check if Cust is premium
*/

CREATE proc [dbo].[spCheckPremium]
	@cid	int,
	@prem	bit	output
as
	set @prem = (
		select CT_PREMUIM
		from TBLCUSTOMER
		where CT_ID = @cid
	)
	print 'prem : ' + cast(@prem as varchar(1))
GO
/****** Object:  StoredProcedure [dbo].[spCheckRentInfoIdAvailability]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
SP INPUT: Request ID
SP JOB: Validate ID and Check if Request is approved
*/

CREATE PROC [dbo].[spCheckRentInfoIdAvailability]
	@request_id	int,
	@errorcode	int OUTPUT
AS
	IF exists (SELECT * 
			   FROM TBLREQUEST 
			   WHERE REQ_ID = @request_id)
		BEGIN
			DECLARE @isChecked int
			SET @isChecked = (select REQ_STATUS
							  FROM TBLREQUEST 
							  WHERE REQ_ID = @request_id);
			IF ( @isChecked = 1)
				BEGIN
					set @errorcode =0;
					PRINT 'This request is already checked'
				END
			ELSE
				BEGIN
					SET @errorcode = 1;--request not checked yet
					PRINT 'Processing...'
				END
		END
	ELSE
		BEGIN
			SET @errorcode = -1;
			PRINT 'Enter valid id'
		END
GO
/****** Object:  StoredProcedure [dbo].[spConfirmArrival]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*
SP INPUT: Rent ID
SP JOB:	Confirm Car Arrival
SP Do: Verifies Id, Verifies rented status, and confirm arrival
*/

CREATE PROC [dbo].[spConfirmArrival]
    @rentid		int,
    @penalty	float OUTPUT,
    @errorcode	int OUTPUT
AS
    DECLARE 
		@nbdays			int,
		@carid			int,
		@rentedStatus	bit,
		@startingdate	datetime,
		@duedate		datetime
    
    set @penalty = 0
    
	IF exists (SELECT RI_RENT_ID FROM TBLRENTINFO WHERE RI_RENT_ID = @rentid )
	    BEGIN
			set @carid = (SELECT RI_CAR_ID 
						  FROM TBLRENTINFO 
						  WHERE RI_RENT_ID = @rentid)

			set @rentedStatus = (SELECT CAR_RENTED_STATUS 
								 FROM TBLCAR 
								 WHERE CAR_ID = @carid)

			IF (@rentedStatus = 0)
				BEGIN
					PRINT 'Car not rented'
					set @errorcode = 0
				END
			ELSE
				BEGIN
					set @errorcode = 1
					PRINT 'Done'
					set @startingdate = (SELECT RI_RENTED_DAY
										 FROM TBLRENTINFO 
										WHERE RI_RENT_ID = @rentid)

					set @duedate = (SELECT RI_ARR_DUE 
									FROM TBLRENTINFO 
									WHERE RI_RENT_ID = @rentid)

					UPDATE TBLCAR
					SET CAR_RENTED_STATUS = 0 
					WHERE CAR_ID = @carid
				-- COMMIT
					UPDATE TBLRENTINFO
					SET RI_PENALTY = (SELECT CAR_PENALTY_PER_DAY 
									  FROM TBLCAR 
									  WHERE CAR_ID = @carid) * 
									  DATEDIFF(DAY, @startingdate, @duedate)
					
					UPDATE TBLRENTINFO
					SET RI_ARR_DATE = GETDATE()
					
				-- COMMIT
					set @penalty = (
					SELECT RI_PENALTY 
					FROM TBLRENTINFO
					WHERE RI_RENT_ID = @rentid
					)
				END
		END
	
	ELSE
		BEGIN
			set @errorcode = -1
			PRINT 'Rent ID does not exist'
		END
GO
/****** Object:  StoredProcedure [dbo].[spCreateLogin]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
sp INPUT: login name, pass, default db schema
sp JOB: Create a new login
*/

CREATE proc [dbo].[spCreateLogin]
	@logname	varchar(30),
	@logpass	varchar(20) = NULL,		-- default is no password
	@defdb		varchar(30) = 'master'	-- default db is master if not provided
as
	declare @exec_stmt	varchar(1000)

	set @exec_stmt = '' --good practice
	set @exec_stmt += 'create login ' + quotename(@logname)

	if @logpass is null
		select @logpass = ''

	set @exec_stmt = @exec_stmt + ' with password = ' + quotename(@logpass, '''')
	set @exec_stmt = @exec_stmt + ' must_change '

	if @defdb is null
		set @defdb = 'master'
	else
		set @exec_stmt = @exec_stmt + ', default_database = ' + quotename(@defdb)
	
	set @exec_stmt = @exec_stmt + ' , check_expiration=on, check_policy=on'
	--for debugging
	print @exec_stmt
	exec(@exec_stmt)

	if @@error <> 0
	begin
		print 'some error occured'
		return (1)
	end
GO
/****** Object:  StoredProcedure [dbo].[spCreateUser]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spCreateUser]
	@logname	sysname,	--login name
	@uname		sysname		--user to add for login
as
	Declare @exec_stmt	varchar(1000)

	set @exec_stmt = 'create user ' + quotename(@uname)
	set @exec_stmt += ' for login ' + quotename(@logname)

	print @exec_stmt
	exec(@exec_stmt)		--execute before testing @@error macro
	if @@error <> 0
		begin
			print 'Some error occur'
			return (-1)
		end
	else
		print 'user ' + @uname + ' added to login ' + @logname
GO
/****** Object:  StoredProcedure [dbo].[spCustStat]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*Cursors*/

/*Display Customer with his Total Rents Per Day
And Total Amount Payed*/

CREATE Proc [dbo].[spCustStat]
	@cid	int
As
	Declare crCustStat Cursor
	for (
		Select carid, amount
		From vwCustRentInfo
		where cid = @cid
	)

	Declare
		@currcar		int,
		@crid			int,
		@total_rents	int,
		@total_payed	int,
		@d_rented		int,
		@curramt		float

	Select @total_payed = 0,
		   @total_rents = 0,
		   @d_rented = 0
	
	Open crCustStat
	Fetch Next From crCustStat into @currcar, @curramt
	While @@FETCH_STATUS = 0
		Begin
			set @d_rented = @d_rented + 1
			Print 'car: ' + cast(@currcar as varchar(5))
			set @crid = @currcar
			While @@FETCH_STATUS = 0
				Begin
					set @total_rents = @total_rents + 1
					set @total_payed = @total_payed + @curramt
					Print 'amount ' + cast(ceiling(@curramt) as varchar(10))
					Fetch Next From crCustStat into @crid, @curramt
					if(@currcar != @crid) break
				End
			Fetch Next From crCustStat into @currcar, @curramt
		End
	Print 'Total Rents : ' + cast(@total_rents as varchar(5))
	Print 'Total Payed : ' + cast(@total_payed as varchar(5))
	Print 'Distinct Cars rented : ' + cast(@d_rented as varchar(5))
	Close crCustStat
	Deallocate CrCustStat
GO
/****** Object:  StoredProcedure [dbo].[spDeleteLogin]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
sp in: login name
sp do: delete login
*/

CREATE proc [dbo].[spDeleteLogin]
	@logname	varchar(30)
as
	declare @exec_stmt	varchar(100)

	set @exec_stmt = ''
	set @exec_stmt = 'drop login '
	
	if @logname is not null
		set @exec_stmt = @exec_stmt + quotename(@logname)
	
	print(@exec_stmt)
	exec(@exec_stmt)
	if @@error <> 0
		begin
			print 'Failed Deleting Login'
			return (-1)
		end
	else
		begin
			print 'Login deleted'
		end
GO
/****** Object:  StoredProcedure [dbo].[spDeleteUser]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spDeleteUser]
	@uname	sysname
as
	Declare @exec_stmt	varchar(1000)

	set @exec_stmt = 'Drop User if exists ' + @uname
	print @exec_stmt
	exec(@exec_stmt)
	
	if @@error <> 0
		begin
			print 'Some error occur'
			return (-2)
		end
	else	
		print 'user ' + @uname + ' dropped'
GO
/****** Object:  StoredProcedure [dbo].[spGetCustomer]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
SP: View all Customers
*/
CREATE proc [dbo].[spGetCustomer]
as
return
    select * from TBLCUSTOMER
GO
/****** Object:  StoredProcedure [dbo].[spGetTableNames]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spGetTableNames]
	@dbname		varchar(30)
as
	declare @exec_stmt varchar(1000)
	
	set @exec_stmt = ''
	set @exec_stmt = @exec_stmt + 'select name from ' + quotename(@dbname) +
	'.sys.objects where type = ' + quotename('U','''')
	print @exec_stmt
	exec (@exec_stmt)
	if @@error <> 0
		print 'some error occur'
GO
/****** Object:  StoredProcedure [dbo].[spGiveRole]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*
SP INPUT: login name, server role
SP JOB: add server role to login name
*/
CREATE proc [dbo].[spGiveRole]
	@logname	sysname,
	@role		varchar(30),
	@type		char = 'U',
	@out		varchar(100)	output --for debugging
as
	declare
		@exec_stmt	varchar(1000)
	set @exec_stmt = 'alter '
	
	if(@type='S')
		set @exec_stmt += 'server '
	set @exec_stmt += 'role ' + quotename(@role) + ' add member ' + quotename(@logname)

	print @exec_stmt	--for debugging
	exec(@exec_stmt)
	if @@error <> 0
	begin
		print 'Failed---'
		return (-1)
	end
	else
	begin
		print 'Success+++'
		set @out = @exec_stmt
	end
GO
/****** Object:  StoredProcedure [dbo].[spGrantTables]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
sp in:  logname (could be user or role name)
		tablename
		insert bit, update bit, delete bit, {grand | revoke} bit
sp do: control role / user permission on tablename
*/
CREATE proc [dbo].[spGrantTables]
	@logname	varchar(30),
	@tablename	varchar(30),
	@i			bit,
	@u			bit,
	@d			bit,
	@q			varchar(100) output,
	@g			bit = 1
as
	Declare	
		@exec_stmt	varchar(1000),
		@prev		bit
	
	if @g = 1
		set @exec_stmt = 'grant '
	else
		set @exec_stmt = 'revoke '

	if @i = 1
		begin
			set @exec_stmt += 'insert '
			set @prev = 1
		end
	if @u = 1
		begin
			if @prev = 1
				set @exec_stmt += ', '
			set @exec_stmt += 'update '
			set @prev = 1
		end
	if @d = 1
		begin
			if @prev = 1
				set @exec_stmt += ', '
			set @exec_stmt += 'delete '
		end
	set @exec_stmt += 'on ' + quotename(@tablename)
	set @exec_stmt += ' to ' + quotename(@logname)
	print @exec_stmt
	if @@error <> 0
		begin
			print 'some error occur'
			return (-1)
		end
	else
		print 'Success+++'
	set @q=@exec_stmt
GO
/****** Object:  StoredProcedure [dbo].[spInitRequest]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
SP INPUT: email , rent id
SP JOB: init a refund request for customer with @email on rent id
*/


CREATE proc [dbo].[spInitRequest]
	@email				varchar(30),
	@rentId				int,
	@cardnumber			varchar(30),
	@emailError			int	output,
	@rentIdError		int output,
	@cardNumberError	int output,
	@result				int output
AS
	declare @cid	int
	set @cid = (
		select ct_id 
		from TBLCUSTOMER
		where CT_EMAIL = (select CT_EMAIL 
						  from TBLCUSTOMER as c, TBLLOGGED as l 
						  where cst = 1 and c.CT_ID = l.LID )
	)
	print 'customer id is ' + cast( @cid as varchar(5) )
	set @emailError = 0
	set @cardNumberError = 0
	set @rentIdError = 0
	if (@email not in (
		select CT_EMAIL 
		from TBLCUSTOMER 
		where CT_ID = @cid))
		begin
			set @emailError = 1
			print 'invalid email'
		end
	if (@cardnumber not in (
		select AC_CARD_NUMBER
		from TBLACCOUNT as T 
		where AC_CARD_NUMBER = @cardnumber and AC_CT_ID = @cid))
		begin
			set @cardNumberError = 1
			print 'invalid card'
		end
	if (@rentId not in(
		select RI_RENT_ID
		from TBLRENTINFO
		where RI_RENT_ID = @rentId and RI_CT_ID = @cid ) )
		begin
			set @rentIdError = 1
			print 'invalid rent id'
		end
	if (@emailError = 0 and @rentIdError = 0 and @cardNumberError = 0)
		begin
			set @result = 1
			INSERT INTO TBLREQUEST (
			REQ_RI_RENT_ID, REQ_CT_ID, 
			REQ_AC_CARD_NUMBER, REQ_STATUS, REQ_DATE)
			VALUES
			(@rentId, @cid, @cardnumber, 0, GETDATE())
		end
	else
	begin
		set @result = 0
		print 'some error occur'
		print 'request aborted'
	end
GO
/****** Object:  StoredProcedure [dbo].[spIsValidLogin]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
SP INPUT: Cust email and pass
SP JOB: Validates Them
*/

CREATE proc [dbo].[spIsValidLogin]
	@email	varchar(30),
	@pass	varchar(30),
	@valid	bit	output
as
	if(exists(
	select 1 
	from TBLCUSTOMER 
	where CT_EMAIL = @email and CT_PASSWORD = @pass))
	begin
		set @valid = 1
		print 'valid login'
	end
	else
	begin
		set @valid = 0
		print 'invalid login'
	end
GO
/****** Object:  StoredProcedure [dbo].[spLoadDBNames]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[spLoadDBNames]
as
	select [name] from sys.databases
GO
/****** Object:  StoredProcedure [dbo].[spLoadRoles]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spLoadRoles]
as 
	select name
	from sys.database_principals 
	where type = 'R' and is_fixed_role = 0 and principal_id != 0
GO
/****** Object:  StoredProcedure [dbo].[spLogIn]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
SP INPUT: Cust email
SP JOB: Add record to logged users
*/

CREATE PROC [dbo].[spLogIn]
	@email	varchar(256),
	@cid	int		OUTPUT
AS
	set @cid = (SELECT CT_ID FROM TBLCUSTOMER WHERE CT_EMAIL = @email)
	if (exists(
		select 1
		from tbllogged
		where lid = @cid))
		begin
			update tbllogged
			set cst = 1
			where lid = @cid
		end
	else
		begin
			insert into tbllogged values (@cid, 1)
		end
GO
/****** Object:  StoredProcedure [dbo].[spLogOut]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
SP INPUT: Cust id
SP JOB: Remove record for cid from logged in users
*/

CREATE PROC [dbo].[spLogOut]
	@cid	int
as
	/*
	no need to check if he is already logged out
	because we're not using some troubleshooting system
	example: if cust already logged out, and this proc
	gets executed, we can create log, troubleshooting incuding table name and error
	*/
	update TBLLOGGED
	set cst = 0
	where lid = @cid
GO
/****** Object:  StoredProcedure [dbo].[spRefund]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
SP INPUT: Request id
SP JOB: Refund
SP DO: get customer related to this request, and carry on transcation with specific percentage
*/

CREATE proc [dbo].[spRefund]
		@request_id			int,
		@refund_percentage float,
		@errorcode			int OUTPUT
AS
	BEGIN
		/*begin refund percentage constraint*/
		if (@refund_percentage <= 1 or @refund_percentage >= 90)
		begin
			print 'invalid refund amount'
			set @errorcode = -5
			rollback
		end
		/*end constraint*/
		DECLARE 
				@rent_info_id	INT,
				@amount			FLOAT,
				@card_number	INT,
				@admin_card_number INT

		SET @rent_info_id = (
			select REQ_RI_RENT_ID 
			FROM TBLREQUEST 
			WHERE REQ_ID = @request_id );
		
		set @amount = (
			SELECT RI_AMOUNT +RI_PENALTY
			FROM TBLRENTINFO
			WHERE RI_RENT_ID = @rent_info_id);
		
		set @amount = @amount - ((@refund_percentage /100)*@amount);
		
		SET @card_number = (
			SELECT REQ_AC_CARD_NUMBER 
			FROM TBLREQUEST 
			WHERE REQ_ID = @request_id);

		SET @admin_card_number = (
			select ADM_CARD_NB 
			from TBLADMINST);

		BEGIN TRANSACTION
			UPDATE TBLACCOUNT
			SET AC_BALANCE = AC_BALANCE + @amount
			WHERE AC_CARD_NUMBER = @card_number

			UPDATE TBLACCOUNT
			SET AC_BALANCE = AC_BALANCE - @amount
			WHERE AC_CARD_NUMBER = @admin_card_number
		
		IF ((
			select AC_BALANCE 
			FROM TBLACCOUNT 
			WHERE AC_CARD_NUMBER = @admin_card_number ) < 0 )
			BEGIN
				SET @errorcode = -1;
				PRINT 'No enough balance to make this transaction'
				ROLLBACK
			END

		Else
			BEGIN
				SET @errorcode = 1;
				PRINT 'Transaction done'
			END

		COMMIT TRANSACTION

		--what does that mean ?
		--why not in transaction?
		UPDATE TBLREQUEST
		SET REQ_STATUS = 1
		WHERE REQ_ID = @request_id

	END
GO
/****** Object:  StoredProcedure [dbo].[spRemoveCarById]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
SP INPUT: Car id
SP JOB: Remove car
SP DO: check id, remove
*/

CREATE Proc [dbo].[spRemoveCarById]
	@cid int,
	@errorcode int OUTPUT
AS
	if Exists (
		SELECT CAR_ID
		FROM TBLCAR 
		WHERE CAR_ID = @cid)
		BEGIN
			DELETE from tblCar where car_id = @cid
			SET @errorcode = 1
			PRINT 'The car is deleted'
		END

	ELSE
		BEGIN
			SEt @errorcode = -1
			PRINT 'Invalid car ID'
		END
GO
/****** Object:  StoredProcedure [dbo].[spRentCar]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE proc [dbo].[spRentCar]
	@cid		int,
    @amount		float,
    @cardnumber int,
	@carid		int,
	@nbDays		int,
	@errorcode	int	output
AS
	declare @T2				varchar(20),
			@ResultValue	int,
			@balance		float,
			@carStatus		bit
	
	set @errorcode = 1
	set @carStatus = (
		select [Status]
		from vwCarsAndBranch
		where Car_Id = @carid
	)
	print ' the status is : ' + cast ( @carStatus as char(1)) 
	select @T2 = 'RentTransaction';
	print 'card is ' + cast(@cardnumber as varchar(5))
	print 'cid is '+ cast(@cid as varchar(5))

	if(@carStatus = 1)
	begin
		print 'car is already rented'
		set @errorcode = 3
		return
		--rollback
	end
	if(@cardnumber not in (
	select AC_CARD_NUMBER 
	from tblaccount 
	where ac_card_number = @cardnumber and ac_ct_id = @cid))
	begin
		print 'card does not exists '
		set @errorcode = 2
		return 
	end
	begin tran @T2;

		-- add amount to admin account
		update TBLACCOUNT
		SET AC_BALANCE = AC_BALANCE + @Amount
		where AC_CARD_NUMBER = 1;
		
		-- remove amount from customer account ( if possible )
		set @balance = (
			select AC_BALANCE 
			FROM TBLACCOUNT 
			WHERE AC_CARD_NUMBER = @cardnumber
		)

		if (@balance - @amount >= 0)
			begin
				update TBLACCOUNT
				SET AC_BALANCE = AC_BALANCE - @Amount
				where AC_CARD_NUMBER = @CardNumber;

				-- adding record to TBLRENT
				INSERT INTO TBLRENT
				VALUES
				(@cid, @carid)

				-- adding record to TBLRENTINFO
				INSERT INTO TBLRENTINFO (
					RI_CAR_ID, RI_CT_ID, RI_NB_OF_DAYS,
					RI_RENTED_DAY, RI_ARR_DUE, RI_AMOUNT
				)
				VALUES
				(@carid, @cid, @nbDays, (select GETDATE())
				, (DATEADD(DAY,@nbDays,(select GETDATE()))), @amount);
			
				-- change car status to rented
				update TBLCAR
				set CAR_RENTED_STATUS = 1
				where CAR_ID = @carid

				commit tran T2
			end
		else
			begin
				set @errorcode = 5
				print 'not sufficient amount in balance'
				rollback tran
				return 
			end
GO
/****** Object:  StoredProcedure [dbo].[spUpdateInsurance]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
SP INPUT: Car id
SP JOB: Renew Car insurance if expired
*/

CREATE PROC [dbo].[spUpdateInsurance]
    @carid  int,
	@errorcode int OUTPUT
AS
    IF exists (select CAR_ID FROM TBLCAR WHERE CAR_ID = @carid)
		BEGIN
				DECLARE @expireDate date
			
				set @expireDate = (
					select INS_EXPIRY_DATE 
					FROM TBLINSURANCE 
					WHERE INS_CAR_ID = @carid
					)
					
					--if expired
					if(@expireDate <= GETDATE())
						BEGIN
							set @errorcode = 1;
							PRINT 'The insurance is updated'--only update if expired
							--adding new insurance record
							insert into TBLINSURANCE (
								ins_car_id, ins_starting_date, ins_expiry_date
							)
							VALUES
							(@carid,GETDATE(), (SELECT DATEADD(MONTH, 6, (GETDATE()))));
						END
					ELSE
						BEGIN
							set @errorcode =0;
							PRINT 'The insurance is not expired'
						END
	    END

	ELSE
		BEGIN
			set @errorcode = -1;
			PRINT 'Invalid car ID'
		END
GO
/****** Object:  StoredProcedure [dbo].[spValidSignUp]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
SP INPUT: Cust email
SP JOB: Validates (check if no duplication)
*/


CREATE proc [dbo].[spValidSignUp] 
	@email varchar(30),
	@valid	bit	OUTPUT
as
	if 
	(exists(
		select 1
		from TBLCUSTOMER
		where CT_EMAIL=@email))
	begin
		set @valid = 0
	end
GO
/****** Object:  StoredProcedure [dbo].[spViewCards]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
SP INPUT: Cust id
SP JOB: View All Cards for Customer
*/

CREATE PROC [dbo].[spViewCards]
	@CID	int
as
	SELECT AC_CARD_NUMBER as [Card Number], convert(decimal(10,2),AC_BALANCE) as Balance
	FROM TBLACCOUNT
	WHERE AC_CT_ID = @CID
GO
/****** Object:  StoredProcedure [dbo].[spViewDaysLeft]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
SP INPUT: Rent id
SP JOB: View days left / Calculate penalty
*/

CREATE PROC [dbo].[spViewDaysLeft]
	@RentId			int,
	@DaysLeft		int OUTPUT,
	@errorcode		int OUTPUT,
	@Penalty		float OUTPUT,
	@overduedDays	int OUTPUT
AS
	DECLARE 
			@carid			int, 
			@carPenalty		float, 
			@exist			bit, 
			@duedate		datetime, 
			@startingdate	datetime

	set @errorcode = 1
	set @Penalty = 0

	if(not exists (
		select 1 
		from TBLRENTINFO 
		where RI_RENT_ID = @RentId
	))

	BEGIN
		set @errorcode = 2
		PRINT 'RENT DOES NOT EXIST FOR SELECTED CUSTOMER'
	END
	ELSE
		BEGIN
			set @carid = (
				select ri_car_id
				from TBLRENTINFO 
				where RI_RENT_ID = @RentId
			)

			set @startingdate = (
				SELECT RI_RENTED_DAY 
				FROM TBLRENTINFO 
				WHERE RI_RENT_ID = @RentId
			)

			set @duedate = (
				SELECT RI_ARR_DUE 
				FROM TBLRENTINFO 
				WHERE RI_RENT_ID = @RentId
			)

		--if not overdued yet
		IF ((GETDATE()) <= @duedate )
			BEGIN
				set @DaysLeft = DATEDIFF(DAY, (SELECT GETDATE()), @duedate)
				PRINT 'days left'+ CAST(@DaysLeft as Varchar(5))
				print ' car exist , days left : '+ cast(@DaysLeft as varchar(5))
			END
		--if overdued
		ELSE
			BEGIN
				set @errorcode = 3
				set @carPenalty = (SELECT CAR_PENALTY_PER_DAY FROM TBLCAR WHERE CAR_ID = @carid )
				set @overduedDays = DATEDIFF(DAY, @duedate, getdate())
				set @Penalty = (@carPenalty * @overduedDays)
				print 'overdue by ' + cast (@overduedDays as varchar(5)) + ' days'
				print 'due date overdued '
				print 'penalty : ' + cast (@Penalty as varchar(5))
				print 'car penalty is : ' + cast(@carPenalty as varchar(5))
			END
		END
GO
/****** Object:  StoredProcedure [dbo].[spViewMatchingCars]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
SP INPUT: car model and location
SP JOB: View matching cars
*/

CREATE proc [dbo].[spViewMatchingCars]
	@model		varchar(256),
	@location	varchar(256)
as
	select * 
	from vwCarsAndBranch as v 
	where v.Branch = @location
	and v.Model = @model
GO
/****** Object:  StoredProcedure [dbo].[spViewMyRequest]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
SP INPUT : Cust id
SP JOB: View his requests
*/

CREATE   proc [dbo].[spViewMyRequest]
	@cid	int
as
	select req_ri_rent_id as [Request ID], req_ac_card_number as [To Account],
		   req_status as [Status], req_date as [Init Date]
	from TBLREQUEST
	where REQ_CT_ID = @cid
GO
/****** Object:  StoredProcedure [dbo].[spViewReceipt]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
SP INPUT: car id and nb days
SP JOB: How much to pay
*/

CREATE PROC [dbo].[spViewReceipt]
	@carid			int,
	@nbDays			int,
	@errorcode		int output,
	@total			float output
AS
	set @errorcode = 1
	if(@carid not in (
		select Car_Id 
		from TBLCAR 
		where CAR_ID = @carid
	))
	begin
		print ' no car with such id'
		set @errorcode = 2
	end
	else
		SET @total = (
			SELECT CAR_PRICE_PER_DAY 
			FROM TBLCAR 
			WHERE CAR_ID = @carid
		) * @nbDays
GO
/****** Object:  StoredProcedure [dbo].[spViewRents]    Script Date: 3/11/2022 5:56:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
SP INPUT: Customer id
SP JOB: View his rents
*/

CREATE PROC [dbo].[spViewRents]
	@CID	int
AS
	SELECT RI_RENT_ID as [Rent ID], RI_CAR_ID as [Car Id] , RI_NB_OF_DAYS as [Nb Days],
	Convert(date, RI_RENTED_DAY) as [Rented Day], Convert(date, RI_ARR_DUE) as [Arrival Due],
	Convert(decimal(10, 2), RI_AMOUNT) as [Payed Amount]
	FROM TBLRENTINFO
	WHERE RI_CT_ID = @CID
GO
USE [master]
GO
ALTER DATABASE [carrentaldb] SET  READ_WRITE 
GO
