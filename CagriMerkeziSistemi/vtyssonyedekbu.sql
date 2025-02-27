USE [master]
GO
/****** Object:  Database [cagriTakipSistemi]    Script Date: 24.05.2024 21:36:48 ******/
CREATE DATABASE [cagriTakipSistemi]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'cagriTakipSistemi', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\cagriTakipSistemi.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'cagriTakipSistemi_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\cagriTakipSistemi_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [cagriTakipSistemi] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [cagriTakipSistemi].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [cagriTakipSistemi] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [cagriTakipSistemi] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [cagriTakipSistemi] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [cagriTakipSistemi] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [cagriTakipSistemi] SET ARITHABORT OFF 
GO
ALTER DATABASE [cagriTakipSistemi] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [cagriTakipSistemi] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [cagriTakipSistemi] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [cagriTakipSistemi] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [cagriTakipSistemi] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [cagriTakipSistemi] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [cagriTakipSistemi] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [cagriTakipSistemi] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [cagriTakipSistemi] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [cagriTakipSistemi] SET  DISABLE_BROKER 
GO
ALTER DATABASE [cagriTakipSistemi] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [cagriTakipSistemi] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [cagriTakipSistemi] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [cagriTakipSistemi] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [cagriTakipSistemi] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [cagriTakipSistemi] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [cagriTakipSistemi] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [cagriTakipSistemi] SET RECOVERY FULL 
GO
ALTER DATABASE [cagriTakipSistemi] SET  MULTI_USER 
GO
ALTER DATABASE [cagriTakipSistemi] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [cagriTakipSistemi] SET DB_CHAINING OFF 
GO
ALTER DATABASE [cagriTakipSistemi] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [cagriTakipSistemi] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [cagriTakipSistemi] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [cagriTakipSistemi] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'cagriTakipSistemi', N'ON'
GO
ALTER DATABASE [cagriTakipSistemi] SET QUERY_STORE = ON
GO
ALTER DATABASE [cagriTakipSistemi] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [cagriTakipSistemi]
GO
/****** Object:  UserDefinedFunction [dbo].[calculate_time_difference]    Script Date: 24.05.2024 21:36:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[calculate_time_difference]
(
    @start_time TIME,
    @end_time TIME
)
RETURNS NVARCHAR(50)
AS
BEGIN
    DECLARE @diff_in_minutes INT;
    DECLARE @result NVARCHAR(50);

    -- Calculate difference in minutes
    SET @diff_in_minutes = DATEDIFF(MINUTE, @start_time, @end_time);

    -- Check if difference is less than or equal to 5 minutes
    IF @diff_in_minutes <= 5
        SET @result = '5 dakikadan az';
    ELSE
        SET @result = '5 dakikadan fazla';

    RETURN @result;
END;
GO
/****** Object:  UserDefinedFunction [dbo].[GetCallCount]    Script Date: 24.05.2024 21:36:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[GetCallCount] (
    @Tarih DATE,
    @AsistanID INT
)
RETURNS INT
AS
BEGIN
    DECLARE @AramaSayisi INT;

    SELECT @AramaSayisi = COUNT(*)
    FROM Call
    WHERE YEAR(InterviewDate) = YEAR(@Tarih)
        AND MONTH(InterviewDate) = MONTH(@Tarih)
        AND DATEDIFF(MINUTE, InterviewStartTime, InterviewFinishTime) <= 5
        AND AssistantID = @AsistanID;

    RETURN @AramaSayisi;
END;
GO
/****** Object:  Table [dbo].[Premium]    Script Date: 24.05.2024 21:36:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Premium](
	[PremiumID] [int] IDENTITY(1,1) NOT NULL,
	[AssistantID] [int] NULL,
	[Amount] [money] NULL,
	[Status] [varchar](50) NULL,
	[MonthYear] [varchar](50) NULL,
 CONSTRAINT [PK_Premium] PRIMARY KEY CLUSTERED 
(
	[PremiumID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_AsistanPrimleri]    Script Date: 24.05.2024 21:36:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_AsistanPrimleri] AS
SELECT *
FROM Premium;
GO
/****** Object:  Table [dbo].[fUser]    Script Date: 24.05.2024 21:36:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[fUser](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[Surname] [varchar](50) NULL,
	[UserName] [varchar](50) NULL,
	[SicilNo] [varchar](50) NULL,
	[TCNo] [varchar](50) NULL,
	[Password] [varchar](50) NULL,
	[Email] [varchar](50) NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserRole]    Script Date: 24.05.2024 21:36:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRole](
	[RoleID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
 CONSTRAINT [PK_UserRole] PRIMARY KEY CLUSTERED 
(
	[RoleID] ASC,
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TeamUser]    Script Date: 24.05.2024 21:36:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TeamUser](
	[TeamID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
 CONSTRAINT [PK_TeamUser] PRIMARY KEY CLUSTERED 
(
	[TeamID] ASC,
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_TakimUyeleri]    Script Date: 24.05.2024 21:36:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_TakimUyeleri] (@UserID INT)
RETURNS TABLE
AS
RETURN
    SELECT 
        fu.Name, 
        fu.Surname, 
        fu.SicilNo
    FROM TeamUser tu 
    INNER JOIN fUser fu ON fu.UserID = tu.UserID
    WHERE tu.TeamID = (SELECT TeamID FROM UserRole WHERE UserID = @UserID);
GO
/****** Object:  Table [dbo].[Objection]    Script Date: 24.05.2024 21:36:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Objection](
	[ObjectionID] [int] IDENTITY(1,1) NOT NULL,
	[AssistantID] [int] NULL,
	[ObjectionDescription] [varchar](50) NULL,
	[ObjectionMonthYear] [varchar](50) NULL,
	[ObjectionStatus] [varchar](50) NULL,
 CONSTRAINT [PK_Objection] PRIMARY KEY CLUSTERED 
(
	[ObjectionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_TakimItirazlari]    Script Date: 24.05.2024 21:36:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_TakimItirazlari] (@UserID INT)
RETURNS TABLE
AS
RETURN
    SELECT 
        fUser.UserID,
        SicilNo,
        fUser.Name,
        fUser.Surname,
        ObjectionID,
        ObjectionDescription,
        ObjectionMonthYear,
        ObjectionStatus 
    FROM Objection 
    INNER JOIN fUser ON fUser.UserID = Objection.AssistantID
    WHERE fUser.UserID IN (
        SELECT UserID 
        FROM TeamUser 
        WHERE TeamID = (
            SELECT TeamID 
            FROM TeamUser 
            WHERE UserID = @UserID
        )
    );
GO
/****** Object:  View [dbo].[vw_AsistanItirazlari]    Script Date: 24.05.2024 21:36:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_AsistanItirazlari] AS
SELECT *
FROM Objection;
GO
/****** Object:  Table [dbo].[Call]    Script Date: 24.05.2024 21:36:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Call](
	[CallID] [int] IDENTITY(1,1) NOT NULL,
	[AssistantID] [int] NULL,
	[CustomerID] [int] NULL,
	[InterviewTopic] [varchar](50) NULL,
	[InterviewDate] [date] NULL,
	[InterviewStartTime] [time](7) NULL,
	[InterviewFinishTime] [time](7) NULL,
	[InterviewStateInfo] [varchar](50) NULL,
 CONSTRAINT [PK_Call] PRIMARY KEY CLUSTERED 
(
	[CallID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Group]    Script Date: 24.05.2024 21:36:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Group](
	[GroupID] [int] IDENTITY(1,1) NOT NULL,
	[GroupName] [varchar](50) NULL,
 CONSTRAINT [PK_Group] PRIMARY KEY CLUSTERED 
(
	[GroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Response]    Script Date: 24.05.2024 21:36:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Response](
	[ResponseID] [int] IDENTITY(1,1) NOT NULL,
	[ObjectionID] [int] NULL,
	[ResponseMessage] [varchar](100) NULL,
 CONSTRAINT [PK_Response] PRIMARY KEY CLUSTERED 
(
	[ResponseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Role]    Script Date: 24.05.2024 21:36:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Role](
	[RoleID] [int] IDENTITY(1,1) NOT NULL,
	[RoleName] [varchar](50) NULL,
 CONSTRAINT [PK_Role] PRIMARY KEY CLUSTERED 
(
	[RoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Team]    Script Date: 24.05.2024 21:36:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Team](
	[TeamID] [int] IDENTITY(1,1) NOT NULL,
	[TeamName] [varchar](50) NULL,
	[GroupID] [int] NULL,
 CONSTRAINT [PK_Team] PRIMARY KEY CLUSTERED 
(
	[TeamID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Call] ON 

INSERT [dbo].[Call] ([CallID], [AssistantID], [CustomerID], [InterviewTopic], [InterviewDate], [InterviewStartTime], [InterviewFinishTime], [InterviewStateInfo]) VALUES (1, 1, 2, N'Fahri', CAST(N'2024-05-23' AS Date), CAST(N'12:23:00' AS Time), CAST(N'12:43:00' AS Time), N'Sorun Çözülüoo')
INSERT [dbo].[Call] ([CallID], [AssistantID], [CustomerID], [InterviewTopic], [InterviewDate], [InterviewStartTime], [InterviewFinishTime], [InterviewStateInfo]) VALUES (2, 1, 9, N'Konu', CAST(N'2023-12-12' AS Date), CAST(N'12:54:00' AS Time), CAST(N'13:45:00' AS Time), N'Sorun Çözülüooo')
INSERT [dbo].[Call] ([CallID], [AssistantID], [CustomerID], [InterviewTopic], [InterviewDate], [InterviewStartTime], [InterviewFinishTime], [InterviewStateInfo]) VALUES (3, 1, 10, N'Konu', CAST(N'1999-12-12' AS Date), CAST(N'10:00:00' AS Time), CAST(N'11:11:00' AS Time), N'Sorun çözüldü')
INSERT [dbo].[Call] ([CallID], [AssistantID], [CustomerID], [InterviewTopic], [InterviewDate], [InterviewStartTime], [InterviewFinishTime], [InterviewStateInfo]) VALUES (4, 1, 1, N'TestTrigger1', CAST(N'1999-12-12' AS Date), CAST(N'10:00:00' AS Time), CAST(N'10:03:00' AS Time), N'Sorun Çözülüo')
INSERT [dbo].[Call] ([CallID], [AssistantID], [CustomerID], [InterviewTopic], [InterviewDate], [InterviewStartTime], [InterviewFinishTime], [InterviewStateInfo]) VALUES (5, 1, 4, N'TestTrigger2', CAST(N'1999-09-08' AS Date), CAST(N'10:00:11' AS Time), CAST(N'11:11:11' AS Time), N'Sorun Çözülüo')
INSERT [dbo].[Call] ([CallID], [AssistantID], [CustomerID], [InterviewTopic], [InterviewDate], [InterviewStartTime], [InterviewFinishTime], [InterviewStateInfo]) VALUES (6, 1, 4, N'TestTrigger2', CAST(N'1999-04-08' AS Date), CAST(N'10:00:11' AS Time), CAST(N'11:11:11' AS Time), N'Sorun Çözülüo')
INSERT [dbo].[Call] ([CallID], [AssistantID], [CustomerID], [InterviewTopic], [InterviewDate], [InterviewStartTime], [InterviewFinishTime], [InterviewStateInfo]) VALUES (7, 1, 4, N'TestTrigger2', CAST(N'1999-06-08' AS Date), CAST(N'10:00:11' AS Time), CAST(N'11:11:11' AS Time), N'Sorun Çözülüo')
INSERT [dbo].[Call] ([CallID], [AssistantID], [CustomerID], [InterviewTopic], [InterviewDate], [InterviewStartTime], [InterviewFinishTime], [InterviewStateInfo]) VALUES (8, 1, 4, N'TestTrigger2', CAST(N'1999-06-08' AS Date), CAST(N'10:00:11' AS Time), CAST(N'11:11:11' AS Time), N'Sorun Çözülüo')
INSERT [dbo].[Call] ([CallID], [AssistantID], [CustomerID], [InterviewTopic], [InterviewDate], [InterviewStartTime], [InterviewFinishTime], [InterviewStateInfo]) VALUES (9, 1, 2, N'TestTrigger2', CAST(N'1999-06-08' AS Date), CAST(N'10:00:11' AS Time), CAST(N'11:11:11' AS Time), N'Sorun Çözülüo')
INSERT [dbo].[Call] ([CallID], [AssistantID], [CustomerID], [InterviewTopic], [InterviewDate], [InterviewStartTime], [InterviewFinishTime], [InterviewStateInfo]) VALUES (10, 1, 13, N'Test', CAST(N'1999-12-11' AS Date), CAST(N'12:22:00' AS Time), CAST(N'12:24:00' AS Time), N'')
INSERT [dbo].[Call] ([CallID], [AssistantID], [CustomerID], [InterviewTopic], [InterviewDate], [InterviewStartTime], [InterviewFinishTime], [InterviewStateInfo]) VALUES (11, 1, 14, N'Arıza', CAST(N'2024-05-30' AS Date), CAST(N'18:20:00' AS Time), CAST(N'18:14:00' AS Time), N'Tamamlandı ')
INSERT [dbo].[Call] ([CallID], [AssistantID], [CustomerID], [InterviewTopic], [InterviewDate], [InterviewStartTime], [InterviewFinishTime], [InterviewStateInfo]) VALUES (12, 1, 16, N'Talep', CAST(N'2024-05-18' AS Date), CAST(N'20:00:00' AS Time), CAST(N'21:00:00' AS Time), N'Sorun çözülemedi')
INSERT [dbo].[Call] ([CallID], [AssistantID], [CustomerID], [InterviewTopic], [InterviewDate], [InterviewStartTime], [InterviewFinishTime], [InterviewStateInfo]) VALUES (13, 15, 1, N'Arıza', CAST(N'2024-05-20' AS Date), CAST(N'20:00:00' AS Time), CAST(N'21:00:00' AS Time), N'Tamamlandı')
SET IDENTITY_INSERT [dbo].[Call] OFF
GO
SET IDENTITY_INSERT [dbo].[fUser] ON 

INSERT [dbo].[fUser] ([UserID], [Name], [Surname], [UserName], [SicilNo], [TCNo], [Password], [Email]) VALUES (1, N'Mehmet', N'Keklik', N'mehmet', N'147258369', N'14725836914', N'1234', N'mehmet@gmail.com')
INSERT [dbo].[fUser] ([UserID], [Name], [Surname], [UserName], [SicilNo], [TCNo], [Password], [Email]) VALUES (2, N'Samet', N'Yılmaz', N'samet', N'321321', N'321321312', N'samet123', N'samet@gmail.com')
INSERT [dbo].[fUser] ([UserID], [Name], [Surname], [UserName], [SicilNo], [TCNo], [Password], [Email]) VALUES (3, N'Müşteriisim', N'MüşteriSoyisim', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[fUser] ([UserID], [Name], [Surname], [UserName], [SicilNo], [TCNo], [Password], [Email]) VALUES (4, N'Müşteriisim', N'MüşteriSoyisim', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[fUser] ([UserID], [Name], [Surname], [UserName], [SicilNo], [TCNo], [Password], [Email]) VALUES (5, N'Müşteriisim', N'MüşteriSoyisim', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[fUser] ([UserID], [Name], [Surname], [UserName], [SicilNo], [TCNo], [Password], [Email]) VALUES (6, N'Zeynep', N'Demirel', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[fUser] ([UserID], [Name], [Surname], [UserName], [SicilNo], [TCNo], [Password], [Email]) VALUES (7, N'Zeynep', N'Demirel', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[fUser] ([UserID], [Name], [Surname], [UserName], [SicilNo], [TCNo], [Password], [Email]) VALUES (8, N'Zeynep', N'Demirel', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[fUser] ([UserID], [Name], [Surname], [UserName], [SicilNo], [TCNo], [Password], [Email]) VALUES (9, N'Zeyn', N'Dem', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[fUser] ([UserID], [Name], [Surname], [UserName], [SicilNo], [TCNo], [Password], [Email]) VALUES (10, N'Umit', N'Can', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[fUser] ([UserID], [Name], [Surname], [UserName], [SicilNo], [TCNo], [Password], [Email]) VALUES (11, N'Fahri', N'Can', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[fUser] ([UserID], [Name], [Surname], [UserName], [SicilNo], [TCNo], [Password], [Email]) VALUES (12, N'Fahri', N'Can', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[fUser] ([UserID], [Name], [Surname], [UserName], [SicilNo], [TCNo], [Password], [Email]) VALUES (13, N'Fahri', N'Can', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[fUser] ([UserID], [Name], [Surname], [UserName], [SicilNo], [TCNo], [Password], [Email]) VALUES (14, N'a', N'b', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[fUser] ([UserID], [Name], [Surname], [UserName], [SicilNo], [TCNo], [Password], [Email]) VALUES (15, N'Sefacan', N'Demir', N'sefa', N'123456789', N'98765432101', N'sefa123', N'sefacan@gmail.com')
INSERT [dbo].[fUser] ([UserID], [Name], [Surname], [UserName], [SicilNo], [TCNo], [Password], [Email]) VALUES (16, N'Ceren', N'yılmaz', NULL, NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[fUser] OFF
GO
SET IDENTITY_INSERT [dbo].[Group] ON 

INSERT [dbo].[Group] ([GroupID], [GroupName]) VALUES (1, N'Grup1')
SET IDENTITY_INSERT [dbo].[Group] OFF
GO
SET IDENTITY_INSERT [dbo].[Objection] ON 

INSERT [dbo].[Objection] ([ObjectionID], [AssistantID], [ObjectionDescription], [ObjectionMonthYear], [ObjectionStatus]) VALUES (1, 1, N'Test', N'Test', N'Bekliyor')
INSERT [dbo].[Objection] ([ObjectionID], [AssistantID], [ObjectionDescription], [ObjectionMonthYear], [ObjectionStatus]) VALUES (2, 1, N'Test', N'Test', N'Bekliyor')
INSERT [dbo].[Objection] ([ObjectionID], [AssistantID], [ObjectionDescription], [ObjectionMonthYear], [ObjectionStatus]) VALUES (3, 1, N'Test', N'1999-12', N'Bekliyor')
INSERT [dbo].[Objection] ([ObjectionID], [AssistantID], [ObjectionDescription], [ObjectionMonthYear], [ObjectionStatus]) VALUES (4, 1, N'Test', N'Test', N'Bekliyor')
INSERT [dbo].[Objection] ([ObjectionID], [AssistantID], [ObjectionDescription], [ObjectionMonthYear], [ObjectionStatus]) VALUES (5, 1, N'1', N'Test', N'Cevaplandı')
INSERT [dbo].[Objection] ([ObjectionID], [AssistantID], [ObjectionDescription], [ObjectionMonthYear], [ObjectionStatus]) VALUES (6, 1, N'1', N'Test', N'Bekliyor')
INSERT [dbo].[Objection] ([ObjectionID], [AssistantID], [ObjectionDescription], [ObjectionMonthYear], [ObjectionStatus]) VALUES (7, 1, N'Açıklama', N'1999-12', N'Bekliyor')
INSERT [dbo].[Objection] ([ObjectionID], [AssistantID], [ObjectionDescription], [ObjectionMonthYear], [ObjectionStatus]) VALUES (8, 1, N'Açıklama', N'1999-12', N'Bekliyor')
INSERT [dbo].[Objection] ([ObjectionID], [AssistantID], [ObjectionDescription], [ObjectionMonthYear], [ObjectionStatus]) VALUES (9, 1, N'Açıklama', N'1999-12', N'Bekliyor')
INSERT [dbo].[Objection] ([ObjectionID], [AssistantID], [ObjectionDescription], [ObjectionMonthYear], [ObjectionStatus]) VALUES (10, 1, N'Açıklama', N'1999-12', N'Cevaplandı')
INSERT [dbo].[Objection] ([ObjectionID], [AssistantID], [ObjectionDescription], [ObjectionMonthYear], [ObjectionStatus]) VALUES (11, 1, N'Açıklama', N'1999-12', N'Bekliyor')
INSERT [dbo].[Objection] ([ObjectionID], [AssistantID], [ObjectionDescription], [ObjectionMonthYear], [ObjectionStatus]) VALUES (12, 1, N'Açıklama', N'1999-12', N'Bekliyor')
INSERT [dbo].[Objection] ([ObjectionID], [AssistantID], [ObjectionDescription], [ObjectionMonthYear], [ObjectionStatus]) VALUES (13, 1, N'Açıklama', N'1999-12', N'Bekliyor')
INSERT [dbo].[Objection] ([ObjectionID], [AssistantID], [ObjectionDescription], [ObjectionMonthYear], [ObjectionStatus]) VALUES (14, 1, N'Açıklama', N'1999-12', N'Bekliyor')
INSERT [dbo].[Objection] ([ObjectionID], [AssistantID], [ObjectionDescription], [ObjectionMonthYear], [ObjectionStatus]) VALUES (15, 1, N'Açıklama', N'1999-12', N'Onaylandı')
INSERT [dbo].[Objection] ([ObjectionID], [AssistantID], [ObjectionDescription], [ObjectionMonthYear], [ObjectionStatus]) VALUES (16, 1, N'Açıklama', N'1999-12', N'Bekliyor')
INSERT [dbo].[Objection] ([ObjectionID], [AssistantID], [ObjectionDescription], [ObjectionMonthYear], [ObjectionStatus]) VALUES (17, 1, N'', N'', N'Bekliyor')
INSERT [dbo].[Objection] ([ObjectionID], [AssistantID], [ObjectionDescription], [ObjectionMonthYear], [ObjectionStatus]) VALUES (18, 1, N'', N'', N'Bekliyor')
INSERT [dbo].[Objection] ([ObjectionID], [AssistantID], [ObjectionDescription], [ObjectionMonthYear], [ObjectionStatus]) VALUES (19, 1, N'İtiraz Ediyorum', N'2024-05', N'Bekliyor')
INSERT [dbo].[Objection] ([ObjectionID], [AssistantID], [ObjectionDescription], [ObjectionMonthYear], [ObjectionStatus]) VALUES (20, 1, N'asdas', N'2024-05', N'Bekliyor')
INSERT [dbo].[Objection] ([ObjectionID], [AssistantID], [ObjectionDescription], [ObjectionMonthYear], [ObjectionStatus]) VALUES (21, 1, N'a', N'2024-05', N'Bekliyor')
INSERT [dbo].[Objection] ([ObjectionID], [AssistantID], [ObjectionDescription], [ObjectionMonthYear], [ObjectionStatus]) VALUES (22, 15, N'b', N'2024-05', N'Onaylandı')
SET IDENTITY_INSERT [dbo].[Objection] OFF
GO
SET IDENTITY_INSERT [dbo].[Premium] ON 

INSERT [dbo].[Premium] ([PremiumID], [AssistantID], [Amount], [Status], [MonthYear]) VALUES (45, 1, 0.0000, N'Prim hak ediş yok', N'1999-04')
INSERT [dbo].[Premium] ([PremiumID], [AssistantID], [Amount], [Status], [MonthYear]) VALUES (46, 1, 0.0000, N'Prim hak ediş yok', N'1999-06')
INSERT [dbo].[Premium] ([PremiumID], [AssistantID], [Amount], [Status], [MonthYear]) VALUES (47, 1, 0.0000, N'Prim hak ediş yok', N'1999-09')
INSERT [dbo].[Premium] ([PremiumID], [AssistantID], [Amount], [Status], [MonthYear]) VALUES (48, 1, 0.0000, N'Prim hak ediş yok', N'1999-12')
INSERT [dbo].[Premium] ([PremiumID], [AssistantID], [Amount], [Status], [MonthYear]) VALUES (49, 1, 0.0000, N'Prim hak ediş yok', N'2023-12')
INSERT [dbo].[Premium] ([PremiumID], [AssistantID], [Amount], [Status], [MonthYear]) VALUES (50, 1, 0.0000, N'Prim hak ediş yok', N'2024-05')
INSERT [dbo].[Premium] ([PremiumID], [AssistantID], [Amount], [Status], [MonthYear]) VALUES (51, 15, 0.0000, N'Prim hak ediş yok', N'2024-05')
SET IDENTITY_INSERT [dbo].[Premium] OFF
GO
SET IDENTITY_INSERT [dbo].[Response] ON 

INSERT [dbo].[Response] ([ResponseID], [ObjectionID], [ResponseMessage]) VALUES (1, 1, N'dklcd')
INSERT [dbo].[Response] ([ResponseID], [ObjectionID], [ResponseMessage]) VALUES (2, 5, N'2')
INSERT [dbo].[Response] ([ResponseID], [ObjectionID], [ResponseMessage]) VALUES (3, 6, N'3')
INSERT [dbo].[Response] ([ResponseID], [ObjectionID], [ResponseMessage]) VALUES (4, 15, N'ndjskflkk itiraz Cevabı')
INSERT [dbo].[Response] ([ResponseID], [ObjectionID], [ResponseMessage]) VALUES (5, 5, N'Testttttt')
INSERT [dbo].[Response] ([ResponseID], [ObjectionID], [ResponseMessage]) VALUES (6, 10, N'djwskalfş')
SET IDENTITY_INSERT [dbo].[Response] OFF
GO
SET IDENTITY_INSERT [dbo].[Role] ON 

INSERT [dbo].[Role] ([RoleID], [RoleName]) VALUES (1, N'Müşteri Temsilcisi')
INSERT [dbo].[Role] ([RoleID], [RoleName]) VALUES (2, N'Grup Yöneticisi')
INSERT [dbo].[Role] ([RoleID], [RoleName]) VALUES (3, N'Takım Lideri')
INSERT [dbo].[Role] ([RoleID], [RoleName]) VALUES (4, N'Müşteri')
SET IDENTITY_INSERT [dbo].[Role] OFF
GO
SET IDENTITY_INSERT [dbo].[Team] ON 

INSERT [dbo].[Team] ([TeamID], [TeamName], [GroupID]) VALUES (3, N'Takım1', 1)
SET IDENTITY_INSERT [dbo].[Team] OFF
GO
INSERT [dbo].[TeamUser] ([TeamID], [UserID]) VALUES (3, 1)
INSERT [dbo].[TeamUser] ([TeamID], [UserID]) VALUES (3, 2)
GO
INSERT [dbo].[UserRole] ([RoleID], [UserID]) VALUES (1, 1)
INSERT [dbo].[UserRole] ([RoleID], [UserID]) VALUES (1, 15)
INSERT [dbo].[UserRole] ([RoleID], [UserID]) VALUES (3, 2)
INSERT [dbo].[UserRole] ([RoleID], [UserID]) VALUES (4, 3)
INSERT [dbo].[UserRole] ([RoleID], [UserID]) VALUES (4, 6)
INSERT [dbo].[UserRole] ([RoleID], [UserID]) VALUES (4, 7)
INSERT [dbo].[UserRole] ([RoleID], [UserID]) VALUES (4, 8)
INSERT [dbo].[UserRole] ([RoleID], [UserID]) VALUES (4, 9)
INSERT [dbo].[UserRole] ([RoleID], [UserID]) VALUES (4, 10)
INSERT [dbo].[UserRole] ([RoleID], [UserID]) VALUES (4, 11)
INSERT [dbo].[UserRole] ([RoleID], [UserID]) VALUES (4, 12)
INSERT [dbo].[UserRole] ([RoleID], [UserID]) VALUES (4, 13)
INSERT [dbo].[UserRole] ([RoleID], [UserID]) VALUES (4, 14)
INSERT [dbo].[UserRole] ([RoleID], [UserID]) VALUES (4, 16)
GO
ALTER TABLE [dbo].[Call]  WITH CHECK ADD  CONSTRAINT [FK_Call_User] FOREIGN KEY([AssistantID])
REFERENCES [dbo].[fUser] ([UserID])
GO
ALTER TABLE [dbo].[Call] CHECK CONSTRAINT [FK_Call_User]
GO
ALTER TABLE [dbo].[Call]  WITH CHECK ADD  CONSTRAINT [FK_Call_User1] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[fUser] ([UserID])
GO
ALTER TABLE [dbo].[Call] CHECK CONSTRAINT [FK_Call_User1]
GO
ALTER TABLE [dbo].[Objection]  WITH CHECK ADD  CONSTRAINT [FK_Objection_User] FOREIGN KEY([AssistantID])
REFERENCES [dbo].[fUser] ([UserID])
GO
ALTER TABLE [dbo].[Objection] CHECK CONSTRAINT [FK_Objection_User]
GO
ALTER TABLE [dbo].[Premium]  WITH CHECK ADD  CONSTRAINT [FK_Premium_User] FOREIGN KEY([AssistantID])
REFERENCES [dbo].[fUser] ([UserID])
GO
ALTER TABLE [dbo].[Premium] CHECK CONSTRAINT [FK_Premium_User]
GO
ALTER TABLE [dbo].[Response]  WITH CHECK ADD  CONSTRAINT [FK_Response_Objection] FOREIGN KEY([ResponseID])
REFERENCES [dbo].[Objection] ([ObjectionID])
GO
ALTER TABLE [dbo].[Response] CHECK CONSTRAINT [FK_Response_Objection]
GO
ALTER TABLE [dbo].[Team]  WITH CHECK ADD  CONSTRAINT [FK_Team_Group] FOREIGN KEY([GroupID])
REFERENCES [dbo].[Group] ([GroupID])
GO
ALTER TABLE [dbo].[Team] CHECK CONSTRAINT [FK_Team_Group]
GO
ALTER TABLE [dbo].[TeamUser]  WITH CHECK ADD  CONSTRAINT [FK_TeamUser_Team] FOREIGN KEY([TeamID])
REFERENCES [dbo].[Team] ([TeamID])
GO
ALTER TABLE [dbo].[TeamUser] CHECK CONSTRAINT [FK_TeamUser_Team]
GO
ALTER TABLE [dbo].[TeamUser]  WITH CHECK ADD  CONSTRAINT [FK_TeamUser_User] FOREIGN KEY([UserID])
REFERENCES [dbo].[fUser] ([UserID])
GO
ALTER TABLE [dbo].[TeamUser] CHECK CONSTRAINT [FK_TeamUser_User]
GO
ALTER TABLE [dbo].[UserRole]  WITH CHECK ADD  CONSTRAINT [FK_UserRole_Role] FOREIGN KEY([RoleID])
REFERENCES [dbo].[Role] ([RoleID])
GO
ALTER TABLE [dbo].[UserRole] CHECK CONSTRAINT [FK_UserRole_Role]
GO
ALTER TABLE [dbo].[UserRole]  WITH CHECK ADD  CONSTRAINT [FK_UserRole_User] FOREIGN KEY([UserID])
REFERENCES [dbo].[fUser] ([UserID])
GO
ALTER TABLE [dbo].[UserRole] CHECK CONSTRAINT [FK_UserRole_User]
GO
/****** Object:  StoredProcedure [dbo].[sp_AsistanItirazlariGetir]    Script Date: 24.05.2024 21:36:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_AsistanItirazlariGetir]
    @AssistantID INT
AS
BEGIN
    SELECT * FROM Objection WHERE AssistantID = @AssistantID;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_CagriEkle]    Script Date: 24.05.2024 21:36:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CagriEkle]
    @AssistantUserID INT,
    @CustomerUserID INT,
    @InterviewTopic NVARCHAR(50),
    @InterviewDate DATE,
    @InterviewStartTime TIME,
    @InterviewFinishTime TIME,
    @InterviewStateInfo NVARCHAR(50)
AS
BEGIN
    -- Hata kontrolü (Gerekirse)
    IF NOT EXISTS (SELECT 1 FROM fUser U 
                   INNER JOIN UserRole UR ON U.UserID = UR.UserID
                   INNER JOIN Role R ON UR.RoleID = R.RoleID
                   WHERE U.UserID = @AssistantUserID AND R.RoleName = 'Müşteri Temsilcisi')
    BEGIN
        RAISERROR('Geçersiz asistan ID', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM fUser U 
                   INNER JOIN UserRole UR ON U.UserID = UR.UserID
                   INNER JOIN Role R ON UR.RoleID = R.RoleID
                   WHERE U.UserID = @CustomerUserID AND R.RoleName = 'Müşteri')
    BEGIN
        RAISERROR('Geçersiz müşteri ID', 16, 1);
        RETURN;
    END

    -- Çağrı kaydını ekle (CallID otomatik artacağı için eklenmedi)
    INSERT INTO Call (AssistantID, CustomerID, InterviewTopic, InterviewDate, InterviewStartTime, InterviewFinishTime, InterviewStateInfo)
    VALUES (@AssistantUserID, @CustomerUserID, @InterviewTopic, @InterviewDate, @InterviewStartTime, @InterviewFinishTime, @InterviewStateInfo);
END
GO
/****** Object:  StoredProcedure [dbo].[sp_ItirazCevapla]    Script Date: 24.05.2024 21:36:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ItirazCevapla]
    @ObjectionID INT,
    @TakimLideriID INT,
    @ResponseMessage NVARCHAR(MAX)
AS
BEGIN
    -- Hata kontrolü (Gerekirse)
    IF NOT EXISTS (SELECT 1 FROM [fUser] U 
                   INNER JOIN UserRole UR ON U.UserID = UR.UserID
                   INNER JOIN Role R ON UR.RoleID = R.RoleID
                   WHERE U.UserID = @TakimLideriID AND R.RoleName = 'Takım Lideri')
    BEGIN
        RAISERROR('Geçersiz takım lideri ID', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Objection WHERE ObjectionID = @ObjectionID)
    BEGIN
        RAISERROR('Geçersiz itiraz ID', 16, 1);
        RETURN;
    END

    -- İtiraz cevabını ekle (ResponseID otomatik artacağı için eklenmedi)
    INSERT INTO Response (ObjectionID, ResponseMessage)
    VALUES (@ObjectionID, @ResponseMessage);

    -- İtiraz durumunu güncelle
    UPDATE Objection
    SET ObjectionStatus = 'Cevaplandı'
    WHERE ObjectionID = @ObjectionID;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_ItirazEkle]    Script Date: 24.05.2024 21:36:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ItirazEkle]
    @AssistantID INT,
    @ObjectionDescription NVARCHAR(MAX),
    @ObjectionMonthYear NVARCHAR(MAX) -- İtirazın yapıldığı ay ve yılı bir DATE olarak alıyoruz
AS
BEGIN
    -- Hata kontrolü (Gerekirse)
    IF NOT EXISTS (SELECT 1 FROM [fUser] U 
                   INNER JOIN UserRole UR ON U.UserID = UR.UserID
                   INNER JOIN Role R ON UR.RoleID = R.RoleID
                   WHERE U.UserID = @AssistantID AND R.RoleName = 'Müşteri Temsilcisi')
    BEGIN
        RAISERROR('Geçersiz asistan ID', 16, 1);
        RETURN;
    END


    IF NOT EXISTS (SELECT 1 FROM Premium WHERE AssistantID = @AssistantID AND MonthYear=	@ObjectionMonthYear)
    BEGIN
        RAISERROR('Belirtilen ay ve yıl için prim kaydı bulunamadı', 16, 1);
        RETURN;
    END

    -- İtiraz kaydını ekle (ObjectionID otomatik artacağı için eklenmedi)
    INSERT INTO Objection (AssistantID, ObjectionDescription, ObjectionMonthYear, ObjectionStatus)
    VALUES (@AssistantID, @ObjectionDescription, @ObjectionMonthYear, 'Bekliyor');
END
GO
USE [master]
GO
ALTER DATABASE [cagriTakipSistemi] SET  READ_WRITE 
GO
