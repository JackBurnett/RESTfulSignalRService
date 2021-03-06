USE [master]
GO
/****** Object:  Database [SignalRBroadCasterDB]    Script Date: 4/21/2015 2:28:43 PM ******/
CREATE DATABASE [SignalRBroadCasterDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'SignalRBroadCasterDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.WONDE_LAPTOP\MSSQL\DATA\SignalRBroadCasterDB.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'SignalRBroadCasterDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.WONDE_LAPTOP\MSSQL\DATA\SignalRBroadCasterDB_log.ldf' , SIZE = 5696KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [SignalRBroadCasterDB] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [SignalRBroadCasterDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [SignalRBroadCasterDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [SignalRBroadCasterDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [SignalRBroadCasterDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [SignalRBroadCasterDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [SignalRBroadCasterDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [SignalRBroadCasterDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [SignalRBroadCasterDB] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [SignalRBroadCasterDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [SignalRBroadCasterDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [SignalRBroadCasterDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [SignalRBroadCasterDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [SignalRBroadCasterDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [SignalRBroadCasterDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [SignalRBroadCasterDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [SignalRBroadCasterDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [SignalRBroadCasterDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [SignalRBroadCasterDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [SignalRBroadCasterDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [SignalRBroadCasterDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [SignalRBroadCasterDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [SignalRBroadCasterDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [SignalRBroadCasterDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [SignalRBroadCasterDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [SignalRBroadCasterDB] SET RECOVERY FULL 
GO
ALTER DATABASE [SignalRBroadCasterDB] SET  MULTI_USER 
GO
ALTER DATABASE [SignalRBroadCasterDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [SignalRBroadCasterDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [SignalRBroadCasterDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [SignalRBroadCasterDB] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'SignalRBroadCasterDB', N'ON'
GO
USE [SignalRBroadCasterDB]
GO
/****** Object:  User [TestUser]    Script Date: 4/21/2015 2:28:43 PM ******/
CREATE USER [TestUser] FOR LOGIN [TestUser] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [TestUser]
GO

sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
sp_configure 'Ole Automation Procedures', 1;
GO
RECONFIGURE;
GO

/****** Object:  StoredProcedure [dbo].[USP_INVOKE_REST_SERVICE]    Script Date: 4/21/2015 2:28:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<WONDE,TADESSE>
-- Create date: <03,20,2015>
-- Description:	<Uses to invoke REST service >
-- =============================================
CREATE PROCEDURE [dbo].[USP_INVOKE_REST_SERVICE]
	@message NVARCHAR(MAX),
	@eventName NVARCHAR(20),
	@response NVARCHAR(1000) OUTPUT
AS
BEGIN
    DECLARE @object AS INT;
	DECLARE @obj INT
	DECLARE @url NVARCHAR(MAX)
	
	-- Make sure the URL pointed to the right SignalR enabled service
	SET @url = CONCAT('http://localhost:35387/messagebroadcast/broadcast?message=', @message,'&eventName=', @eventName)

	-- Make sure Ole Automation Procedures are configured. See the link for detail
	-- https://msdn.microsoft.com/en-us/library/ms191188.aspx

    EXEC sp_OACreate 'MSXML2.XMLHTTP', @object OUT;
    EXEC sp_OAMethod @object, 'open', NULL, 'post', @url,'false'
    EXEC sp_OAMethod @object, 'send'
    EXEC sp_OAMethod @object, 'responseText', @response OUTPUT
 
    EXEC sp_OADestroy @object
END  

GO
/****** Object:  Table [dbo].[ConfigurationLookUp]    Script Date: 4/21/2015 2:28:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConfigurationLookUp](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](20) NULL,
	[Value] [nvarchar](20) NULL,
 CONSTRAINT [PK_ConfigurationLookUp] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
USE [master]
GO
ALTER DATABASE [SignalRBroadCasterDB] SET  READ_WRITE 
GO
USE [SignalRBroadCasterDB]
GO
INSERT INTO [dbo].[ConfigurationLookUp]
           ([Name]
           ,[Value])
     VALUES
           ('ServiceRefeshTime'
           ,'10')
GO

INSERT INTO [dbo].[ConfigurationLookUp]
           ([Name]
           ,[Value])
     VALUES
           ('ServiceReAttempt'
           ,'30')
GO

INSERT INTO [dbo].[ConfigurationLookUp]
           ([Name]
           ,[Value])
     VALUES
           ('ServiceTimeOut'
           ,'20')
GO
USE [SignalRBroadCasterDB]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<WONDE,TADESSE>
-- Create date: <03,20,2015>
-- Description:	<Delete ConfigurationLookUp Trigger >
-- =============================================
CREATE TRIGGER [dbo].[TRG_DELETE_CONFIGURATION_LOOKUP] ON [dbo].[ConfigurationLookUp] 
FOR DELETE
AS
	DECLARE @id INT;
	DECLARE @name NVARCHAR(20);
	DECLARE @value NVARCHAR(20);
	DECLARE @message AS NVARCHAR(MAX);
	DECLARE @eventName AS NVARCHAR(20);
	DECLARE @response NVARCHAR(10)

	-- Complex query can be applied based on requirement
	SELECT
      @id = d.ID,
	  @name = d.Name,
	  @value = d.Value
    FROM
      deleted d

    -- JSONify the message
	SET @message = CONCAT('{"ID":',CAST(@id AS NVARCHAR(20)),',"Name":"',@name,'","Value":"',@value,'"}')
	SET @eventName = 'onDeleted'

	EXEC [dbo].[USP_INVOKE_REST_SERVICE]  @message, @eventName,@response OUTPUT
GO
USE [SignalRBroadCasterDB]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<WONDE,TADESSE>
-- Create date: <03,20,2015>
-- Description:	<Delete ConfigurationLookUp Trigger >
-- =============================================
CREATE TRIGGER [dbo].[TRG_INSERTED_CONFIGURATION_LOOKUP] ON [dbo].[ConfigurationLookUp] 
FOR INSERT
AS
	DECLARE @id INT;
	DECLARE @name NVARCHAR(20);
	DECLARE @value NVARCHAR(20);
	DECLARE @message AS NVARCHAR(MAX);
	DECLARE @eventName AS NVARCHAR(20);
	DECLARE @response NVARCHAR(10)

	-- Complex query can be applied based on requirement
	SELECT
      @id = i.ID,
	  @name = i.Name,
	  @value = i.Value
    FROM
      inserted i

    -- JSONify the message
	SET @message = CONCAT('{"ID":',CAST(@id AS NVARCHAR(20)),',"Name":"',@name,'","Value":"',@value,'"}')
	SET @eventName = 'onInserted'

	EXEC [dbo].[USP_INVOKE_REST_SERVICE]  @message, @eventName,@response OUTPUT
GO
USE [SignalRBroadCasterDB]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<WONDE,TADESSE>
-- Create date: <03,20,2015>
-- Description:	<Update ConfigurationLookUp Trigger >
-- =============================================
CREATE TRIGGER [dbo].[TRG_UPDATE_CONFIGURATION_LOOKUP] ON [dbo].[ConfigurationLookUp] 
FOR UPDATE
AS
	DECLARE @id INT;
	DECLARE @name NVARCHAR(20);
	DECLARE @value NVARCHAR(20);
	DECLARE @message AS NVARCHAR(MAX);
	DECLARE @eventName AS NVARCHAR(20);
	DECLARE @response NVARCHAR(10)

	-- Complex query can be applied based on requirement
	SELECT
      @id = i.ID,
	  @name = i.Name,
	  @value = i.Value
    FROM
      inserted i
    INNER JOIN
      deleted d
    ON i.ID = d.ID

    -- JSONify the message
	SET @message = CONCAT('{"ID":',CAST(@id AS NVARCHAR(20)),',"Name":"',@name,'","Value":"',@value,'"}')
	SET @eventName = 'onUpdated'

	EXEC [dbo].[USP_INVOKE_REST_SERVICE]  @message, @eventName,@response OUTPUT
