# HeiResturan0 — 餐厅管理系统

基于 C# WinForms (.NET Framework 4.7.2) 的餐厅管理桌面应用，连接 SQL Server 数据库，支持三种角色登录。

## 环境要求

| 依赖 | 版本/说明 |
|------|-----------|
| Visual Studio | 2022 (v18 Community 实测可用) |
| .NET Framework | 4.7.2 |
| SQL Server | SSMS 22 (localhost) |
| NuGet | Microsoft.Data.SqlClient 7.0.1 |

## 快速启动

1. 在 SQL Server 中创建 `HeiResturant` 数据库并导入数据表
2. 用 Visual Studio 打开 `HeiResturan0.sln`
3. 确认 `App.config` 中连接字符串正确:
   ```xml
   <add name="MyDB"
        connectionString="Server=localhost;Database=HeiResturant;User Id=sa;Password=你的密码;TrustServerCertificate=True;"
        providerName="Microsoft.Data.SqlClient" />
   ```
4. 按 `F5` 运行

## 测试账号

| 角色 | 账号 | 密码 |
|------|------|------|
| 管理员 | `000001` | `123456` |
| 收银员 | `100001` | `114514` |
| 学生 | `200001` | `114514` |

## 项目结构

```
HeiResturan0/
├── Program.cs              # 程序入口
├── DatabaseHelper.cs       # 数据库连接 + 查询方法
├── FormLogin.cs/.Designer  # 登录窗体（三种角色统一登录）
├── FormAdmin.cs/.Designer  # 管理员主界面（待开发）
├── FormCashier.cs/.Designer # 收银员主界面（待开发）
├── FormStudent.cs/.Designer # 学生主界面（待开发）
├── App.config              # 数据库连接字符串
├── CHANGELOG.md            # 修改日志
└── README.md               # 本文件
```

## 数据库表结构

```
AdminInfo    — 管理员账号 (AdminID, Password)
CashierInfo  — 收银员账号 (CashierID, CashierName, Password)
StudentsInfo — 学生账号 (StudentID, StudentName, Balance, Password)
FoodsInfo    — 食品信息 (FoodID, FoodName, Storage, BestBeforeDate, Price, Brand, Status)
ShopInfo     — 商铺信息 (ShopID, ShopName)
FoodShop     — 商铺-食品关联 (FoodID, ShopID)
TradeList    — 交易记录 (TradeID, StudentID, CashierID, TradeTime, FoodID, Num, Remark)
```

## 登录流程

```
┌─────────────────────────────┐
│       FormLogin 登录        │
│  输入账号 (textBox1)        │
│  输入密码 (textBox2)        │
│  [登录]  /  [退出]         │
└──────────┬──────────────────┘
           │ ValidateLogin()
           ▼
    ┌──────┴──────┐
    │  AdminInfo? │──是──▶ FormAdminMain
    └──────┬──────┘
           │否
    ┌──────┴──────┐
    │ CashierInfo?│──是──▶ FormCashier
    └──────┬──────┘
           │否
    ┌──────┴──────┐
    │StudentsInfo?│──是──▶ FormStudent
    └──────┬──────┘
           │否
           ▼
    MessageBox("账号或密码错误")
```

## 开发状态

- [x] 数据库连接测试
- [x] 三种角色统一登录
- [ ] 管理员功能（食品管理、商铺管理、用户管理）
- [ ] 收银员功能（交易录入、扣款）
- [ ] 学生功能（余额查询、消费记录）
