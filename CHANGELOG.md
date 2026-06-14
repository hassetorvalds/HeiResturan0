# HeiResturan0 修改日志

> 餐厅管理系统 · C# WinForms · .NET Framework 4.7.2 · SQL Server (SSMS22)

---

## 2026-06-14 — 项目初始化 & 登录功能

### 项目概览

| 属性 | 值 |
|------|-----|
| 解决方案 | `HeiResturan0.sln` |
| 项目文件 | `HeiResturan0.csproj` |
| 目标框架 | .NET Framework 4.7.2 |
| 数据库 | `HeiResturant` @ `localhost` (SQL Server, sa 认证) |
| ORM/数据驱动 | `Microsoft.Data.SqlClient` 7.0.1 (NuGet) |

### 数据库架构 (7 张表)

| 表名 | 字段 | 用途 |
|------|------|------|
| `AdminInfo` | `AdminID` (PK), `Password` | 管理员账号 |
| `CashierInfo` | `CashierID` (PK), `CashierName`, `Password` | 收银员账号 |
| `StudentsInfo` | `StudentID` (PK), `StudentName`, `Balance`, `Password` | 学生账号及余额 |
| `FoodsInfo` | `FoodID` (PK), `FoodName`, `Storage`, `BestBeforeDate`, `Price`, `Brand`, `Status` | 食品信息 |
| `ShopInfo` | `ShopID` (PK), `ShopName` | 商铺信息 |
| `FoodShop` | `FoodID` (FK), `ShopID` (FK) | 食品-商铺关联 (多对多) |
| `TradeList` | `TradeID` (PK), `StudentID` (FK), `CashierID` (FK), `TradeTime`, `FoodID` (FK), `Num`, `Remark` | 交易记录 |

### 预设测试数据

| 角色 | 账号 | 密码 | 说明 |
|------|------|------|------|
| 管理员 (Admin) | `000001` | `123456` | AdminInfo 表 |
| 收银员 (Cashier) | `10001` | `114514` | CashierInfo 表, 含 CashierName |
| 学生 (Student) | `200001` | `114514` | StudentsInfo 表, 含 StudentName + Balance |

---

### 文件修改记录

#### `DatabaseHelper.cs` — 数据库帮助类

- 保留 `GetConnectionString()` — 从 `App.config` 读取连接字符串
- 新增 `LoginResult` 类:
  - `Success` (bool), `Role` (string), `UserID` (string), `DisplayName` (string), `ErrorMessage` (string)
- 新增 `ValidateLogin(account, password)`:
  - 使用参数化查询防止 SQL 注入
  - 按顺序查询 `AdminInfo` → `CashierInfo` → `StudentsInfo`
  - 匹配则返回角色 + 显示名，否则返回错误消息

#### `FormLogin.cs` — 登录窗体逻辑

- `button1_Click` (登录):
  1. 获取 `textBox1`(账号) 和 `textBox2`(密码)
  2. 调用 `DatabaseHelper.ValidateLogin()`
  3. 成功 → `this.Hide()` + 打开对应角色窗体
  4. 失败 → MessageBox 显示错误
- `button2_Click` (退出): `Application.Exit()`
- 子窗体关闭时自动 `this.Show()` 返回登录界面
- `FormLogin_FormClosing`: 确保关闭登录窗时退出程序

#### `FormLogin.Designer.cs` — 登录窗体设计

- `textBox2.PasswordChar = '*'` + `UseSystemPasswordChar = true`
- 窗口标题改为 `"餐厅管理系统 - 登录"`
- 绑定 `FormClosing` 事件

#### `HeiResturan0.csproj` — 项目文件修复

- **移除**: `System.Data.Common` NuGet 包引用 (v4.1.1.0 与 Microsoft.Data.SqlClient 需要的 v4.2.0.0 冲突)
- **新增**: Framework 内置 `System.Data.Common` 引用 (无版本冲突)

#### `App.config` — 配置文件

- 连接字符串:
  ```
  Server=localhost;Database=HeiResturant;User Id=sa;Password=060319;TrustServerCertificate=True;
  ```

---

### 窗体清单

| 窗体 | 文件 | 状态 |
|------|------|------|
| `FormLogin` | `FormLogin.cs` + `.Designer.cs` + `.resx` | ✅ 登录功能完成 |
| `FormAdminMain` | `FormAdmin.cs` + `.Designer.cs` | 🔲 空壳, 待开发 |
| `FormStudent` | `FormStudent.cs` + `.Designer.cs` | 🔲 空壳, 待开发 |
| `FormCashier` | `FormCashier.cs` + `.Designer.cs` | 🔲 空壳, 待开发 |

### 待开发功能

- [ ] 管理员界面 (FormAdminMain) — 管理食品、商铺、用户等
- [ ] 收银员界面 (FormCashier) — 创建交易、扣款
- [ ] 学生界面 (FormStudent) — 查看余额、交易记录
- [ ] 密码修改功能
- [ ] 各窗体 UI 设计
