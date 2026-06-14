-- ============================================================
-- Script:    02-CreateTables.sql
-- Project:   HeiResturant (黑 i 餐厅管理系统)
-- Purpose:   Creates all tables, constraints, and relationships
-- Usage:     Run against the HeiResturant database after creating it
-- Requires:  01-CreateDatabase.sql must be run first
-- ============================================================

USE HeiResturant;
GO

-- ============================================================
-- Table 1: AdminInfo — Administrator accounts
-- ============================================================
IF OBJECT_ID('dbo.AdminInfo', 'U') IS NOT NULL
    DROP TABLE dbo.AdminInfo;
GO

CREATE TABLE dbo.AdminInfo
(
    AdminID     NVARCHAR(20)    NOT NULL,
    Password    NVARCHAR(50)    NOT NULL,
    CONSTRAINT PK_AdminInfo
        PRIMARY KEY CLUSTERED (AdminID)
);
GO

-- ============================================================
-- Table 2: CashierInfo — Cashier/employee accounts
-- ============================================================
IF OBJECT_ID('dbo.CashierInfo', 'U') IS NOT NULL
    DROP TABLE dbo.CashierInfo;
GO

CREATE TABLE dbo.CashierInfo
(
    CashierID   NVARCHAR(20)    NOT NULL,
    CashierName NVARCHAR(50)    NOT NULL,
    Password    NVARCHAR(50)    NOT NULL,
    CONSTRAINT PK_CashierInfo
        PRIMARY KEY CLUSTERED (CashierID)
);
GO

-- ============================================================
-- Table 3: StudentsInfo — Student/customer accounts
-- ============================================================
IF OBJECT_ID('dbo.StudentsInfo', 'U') IS NOT NULL
    DROP TABLE dbo.StudentsInfo;
GO

CREATE TABLE dbo.StudentsInfo
(
    StudentID   NVARCHAR(20)    NOT NULL,
    StudentName NVARCHAR(50)    NOT NULL,
    Balance     DECIMAL(10, 2)  NOT NULL    DEFAULT 0,
    Password    NVARCHAR(50)    NOT NULL,
    CONSTRAINT PK_StudentsInfo
        PRIMARY KEY CLUSTERED (StudentID)
);
GO

-- ============================================================
-- Table 4: FoodsInfo — Food/product catalog
-- ============================================================
IF OBJECT_ID('dbo.FoodsInfo', 'U') IS NOT NULL
    DROP TABLE dbo.FoodsInfo;
GO

CREATE TABLE dbo.FoodsInfo
(
    FoodID          INT             NOT NULL    IDENTITY(1, 1),
    FoodName        NVARCHAR(100)   NOT NULL,
    Storage         NVARCHAR(100)   NULL,
    BestBeforeDate  DATE            NULL,
    Price           DECIMAL(10, 2)  NOT NULL,
    Brand           NVARCHAR(100)   NULL,
    Status          NVARCHAR(20)    NULL        DEFAULT N'Available',
    CONSTRAINT PK_FoodsInfo
        PRIMARY KEY CLUSTERED (FoodID)
);
GO

-- ============================================================
-- Table 5: ShopInfo — Shop locations
-- ============================================================
IF OBJECT_ID('dbo.ShopInfo', 'U') IS NOT NULL
    DROP TABLE dbo.ShopInfo;
GO

CREATE TABLE dbo.ShopInfo
(
    ShopID      INT             NOT NULL    IDENTITY(1, 1),
    ShopName    NVARCHAR(100)   NOT NULL,
    CONSTRAINT PK_ShopInfo
        PRIMARY KEY CLUSTERED (ShopID)
);
GO

-- ============================================================
-- Table 6: FoodShop — Many-to-many junction (Food ↔ Shop)
-- ============================================================
IF OBJECT_ID('dbo.FoodShop', 'U') IS NOT NULL
    DROP TABLE dbo.FoodShop;
GO

CREATE TABLE dbo.FoodShop
(
    FoodID  INT NOT NULL,
    ShopID  INT NOT NULL,
    CONSTRAINT PK_FoodShop
        PRIMARY KEY CLUSTERED (FoodID, ShopID),
    CONSTRAINT FK_FoodShop_FoodsInfo
        FOREIGN KEY (FoodID) REFERENCES dbo.FoodsInfo(FoodID)
        ON DELETE CASCADE,
    CONSTRAINT FK_FoodShop_ShopInfo
        FOREIGN KEY (ShopID) REFERENCES dbo.ShopInfo(ShopID)
        ON DELETE CASCADE
);
GO

-- ============================================================
-- Table 7: TradeList — Transaction records
-- ============================================================
IF OBJECT_ID('dbo.TradeList', 'U') IS NOT NULL
    DROP TABLE dbo.TradeList;
GO

CREATE TABLE dbo.TradeList
(
    TradeID     INT             NOT NULL    IDENTITY(1, 1),
    StudentID   NVARCHAR(20)    NOT NULL,
    CashierID   NVARCHAR(20)    NOT NULL,
    TradeTime   DATETIME        NOT NULL    DEFAULT GETDATE(),
    FoodID      INT             NOT NULL,
    Num         INT             NOT NULL    DEFAULT 1,
    Remark      NVARCHAR(200)   NULL,
    CONSTRAINT PK_TradeList
        PRIMARY KEY CLUSTERED (TradeID),
    CONSTRAINT FK_TradeList_StudentsInfo
        FOREIGN KEY (StudentID) REFERENCES dbo.StudentsInfo(StudentID),
    CONSTRAINT FK_TradeList_CashierInfo
        FOREIGN KEY (CashierID) REFERENCES dbo.CashierInfo(CashierID),
    CONSTRAINT FK_TradeList_FoodsInfo
        FOREIGN KEY (FoodID) REFERENCES dbo.FoodsInfo(FoodID)
);
GO

-- ============================================================
-- Indexes for common query patterns
-- ============================================================
CREATE NONCLUSTERED INDEX IX_TradeList_StudentID
    ON dbo.TradeList(StudentID);
GO

CREATE NONCLUSTERED INDEX IX_TradeList_TradeTime
    ON dbo.TradeList(TradeTime DESC);
GO

CREATE NONCLUSTERED INDEX IX_TradeList_CashierID
    ON dbo.TradeList(CashierID);
GO

PRINT 'All tables created successfully.';
GO
