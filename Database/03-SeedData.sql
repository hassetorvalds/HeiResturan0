-- ============================================================
-- Script:    03-SeedData.sql
-- Project:   HeiResturant (黑 i 餐厅管理系统)
-- Purpose:   Inserts initial test/demo data
-- Usage:     Run against the HeiResturant database after creating tables
-- Requires:  02-CreateTables.sql must be run first
-- ============================================================

USE HeiResturant;
GO

-- ============================================================
-- Admin accounts
-- ============================================================
INSERT INTO dbo.AdminInfo (AdminID, Password)
VALUES (N'000001', N'123456');
PRINT 'Admin accounts seeded.';

-- ============================================================
-- Cashier accounts
-- ============================================================
INSERT INTO dbo.CashierInfo (CashierID, CashierName, Password)
VALUES
    (N'10001', N'收银员张三', N'114514'),
    (N'10002', N'收银员李四', N'114514');
PRINT 'Cashier accounts seeded.';

-- ============================================================
-- Student accounts
-- ============================================================
INSERT INTO dbo.StudentsInfo (StudentID, StudentName, Balance, Password)
VALUES
    (N'200001', N'学生王五',  200.00, N'114514'),
    (N'200002', N'学生赵六',  150.50, N'114514'),
    (N'200003', N'学生田七',  500.00, N'114514');
PRINT 'Student accounts seeded.';

-- ============================================================
-- Food catalog
-- ============================================================
INSERT INTO dbo.FoodsInfo (FoodName, Storage, BestBeforeDate, Price, Brand, Status)
VALUES
    (N'宫保鸡丁盖饭',   N'常温', '2026-07-01', 18.00, N'食堂自营',   N'Available'),
    (N'红烧牛肉面',     N'冷藏', '2026-06-30', 22.00, N'兰州拉面',   N'Available'),
    (N'珍珠奶茶',       N'常温', '2026-12-31', 12.00, N'一点点',     N'Available'),
    (N'炸鸡腿',         N'冷冻', '2026-08-15', 8.00,  N'肯德基风味', N'Available'),
    (N'炒饭',           N'常温', '2026-06-20', 15.00, N'食堂自营',   N'Available'),
    (N'可乐',           N'常温', '2027-01-01', 5.00,  N'可口可乐',   N'Available'),
    (N'三明治',         N'冷藏', '2026-06-25', 10.00, N'赛百味',     N'Available'),
    (N'冰淇淋',         N'冷冻', '2026-09-01', 6.00,  N'哈根达斯',   N'Available');
PRINT 'Food catalog seeded.';

-- ============================================================
-- Shops
-- ============================================================
INSERT INTO dbo.ShopInfo (ShopName)
VALUES
    (N'第一食堂'),
    (N'第二食堂'),
    (N'小吃街'),
    (N'便利店');
PRINT 'Shops seeded.';

-- ============================================================
-- Food-Shop mappings (many-to-many)
-- ============================================================
INSERT INTO dbo.FoodShop (FoodID, ShopID)
VALUES
    (1, 1),  -- 宫保鸡丁盖饭 → 第一食堂
    (1, 2),  -- 宫保鸡丁盖饭 → 第二食堂
    (2, 1),  -- 红烧牛肉面   → 第一食堂
    (2, 3),  -- 红烧牛肉面   → 小吃街
    (3, 3),  -- 珍珠奶茶     → 小吃街
    (3, 4),  -- 珍珠奶茶     → 便利店
    (4, 1),  -- 炸鸡腿       → 第一食堂
    (4, 3),  -- 炸鸡腿       → 小吃街
    (5, 1),  -- 炒饭         → 第一食堂
    (5, 2),  -- 炒饭         → 第二食堂
    (6, 3),  -- 可乐         → 小吃街
    (6, 4),  -- 可乐         → 便利店
    (7, 4),  -- 三明治       → 便利店
    (8, 3);  -- 冰淇淋       → 小吃街
PRINT 'Food-Shop mappings seeded.';

-- ============================================================
-- Sample transactions
-- ============================================================
INSERT INTO dbo.TradeList (StudentID, CashierID, TradeTime, FoodID, Num, Remark)
VALUES
    (N'200001', N'10001', '2026-06-10 12:05:00', 1, 1, N'堂食'),
    (N'200001', N'10001', '2026-06-10 12:05:30', 3, 2, N'外带'),
    (N'200002', N'10002', '2026-06-11 11:30:00', 2, 1, NULL),
    (N'200002', N'10002', '2026-06-12 17:45:00', 4, 3, N'打包'),
    (N'200003', N'10001', '2026-06-13 08:15:00', 5, 1, N'早餐'),
    (N'200003', N'10001', '2026-06-13 12:00:00', 1, 1, N'午餐');
PRINT 'Sample transactions seeded.';

GO
PRINT 'All seed data inserted successfully.';
