-- ============================================================
-- Script:    01-CreateDatabase.sql
-- Project:   HeiResturant (黑 i 餐厅管理系统)
-- Purpose:   Creates the HeiResturant database on SQL Server
-- Usage:     Run as a SQL Server administrator (sa or equivalent)
-- ============================================================

-- Drop the database if it already exists (for clean re-deployment)
IF DB_ID('HeiResturant') IS NOT NULL
BEGIN
    ALTER DATABASE HeiResturant SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE HeiResturant;
    PRINT 'Existing database HeiResturant dropped.';
END
GO

-- Create the database
CREATE DATABASE HeiResturant
ON PRIMARY
(
    NAME = HeiResturant_Data,
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\HeiResturant.mdf',
    SIZE = 50MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 10MB
)
LOG ON
(
    NAME = HeiResturant_Log,
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\HeiResturant_log.ldf',
    SIZE = 10MB,
    MAXSIZE = 2GB,
    FILEGROWTH = 5MB
);
GO

PRINT 'Database HeiResturant created successfully.';
GO
