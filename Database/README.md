# HeiResturant 数据库部署指南

本目录包含 HeiResturant（黑 i 餐厅管理系统）数据库的完整部署脚本。

## 环境要求

- **SQL Server** 2016 或更高版本（Express/Standard/Enterprise 均可）
- **SQL Server Management Studio (SSMS)** 或 `sqlcmd` 命令行工具
- 具有 `sysadmin` 或 `dbcreator` 权限的登录账户（用于创建数据库）

## 数据库概览

| 表名           | 说明               | 关联                       |
|----------------|--------------------|----------------------------|
| `AdminInfo`    | 管理员账户         | 独立表                     |
| `CashierInfo`  | 收银员账户         | 1 ──< TradeList            |
| `StudentsInfo` | 学生/顾客账户      | 1 ──< TradeList            |
| `FoodsInfo`    | 食品/商品目录      | 1 ──< FoodShop, TradeList  |
| `ShopInfo`     | 商铺/食堂信息      | 1 ──< FoodShop             |
| `FoodShop`     | 食品-商铺关联表    | >── FoodsInfo, ShopInfo    |
| `TradeList`    | 交易记录           | >── StudentsInfo, CashierInfo, FoodsInfo |

## 快速部署

### 方法一：SSMS 图形界面

1. 打开 **SQL Server Management Studio (SSMS)**
2. 连接到 SQL Server 实例（Windows 身份验证或 sa 账户）
3. 按顺序打开并执行以下脚本（`F5` 或点击"执行"）：
   - `01-CreateDatabase.sql` — 创建数据库
   - `02-CreateTables.sql` — 创建所有表和约束
   - `03-SeedData.sql` — 插入测试数据

### 方法二：sqlcmd 命令行

```bash
# 1. 创建数据库
sqlcmd -S localhost -U sa -P "你的密码" -i "01-CreateDatabase.sql"

# 2. 创建表
sqlcmd -S localhost -U sa -P "你的密码" -i "02-CreateTables.sql"

# 3. 插入种子数据
sqlcmd -S localhost -U sa -P "你的密码" -i "03-SeedData.sql"
```

### 方法三：一键部署（合并脚本）

```bash
# 将三个脚本合并后一次性执行
cat 01-CreateDatabase.sql 02-CreateTables.sql 03-SeedData.sql | sqlcmd -S localhost -U sa -P "你的密码"
```

## 测试账户

部署完成后，可使用以下账户登录系统：

| 角色   | 账号   | 密码   | 说明         |
|--------|--------|--------|--------------|
| 管理员 | 000001 | 123456 | 系统管理员   |
| 收银员 | 10001  | 114514 | 收银员张三   |
| 收银员 | 10002  | 114514 | 收银员李四   |
| 学生   | 200001 | 114514 | 学生王五     |
| 学生   | 200002 | 114514 | 学生赵六     |
| 学生   | 200003 | 114514 | 学生田七     |

## 注意事项

1. **文件路径**：`01-CreateDatabase.sql` 中的数据库文件路径（`FILENAME`）默认为 SQL Server 2022 的默认数据目录。如果你的 SQL Server 版本或安装路径不同，请先修改脚本中的路径。

2. **登录账户**：应用程序连接字符串使用 `sa` 账户（配置在 `App.config` 中）。如果使用其他账户，请同步修改 `App.config` 中的连接字符串。

3. **密码安全**：种子数据中的密码为明文存储，仅用于开发/测试环境。生产环境应使用密码哈希。

4. **执行顺序**：脚本必须按编号顺序执行（01 → 02 → 03），否则会因外键依赖导致错误。

## 数据库关系图

```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│  AdminInfo  │     │  CashierInfo │     │ StudentsInfo│
│─────────────│     │──────────────│     │─────────────│
│ PK AdminID  │     │ PK CashierID │     │ PK StudentID│
│    Password │     │    CashierName│     │ StudentName │
└─────────────┘     │    Password  │     │ Balance     │
                    └──────┬───────┘     │ Password    │
                           │             └──────┬──────┘
                           │                    │
                           │    ┌───────────┐   │
                           │    │ TradeList │   │
                           │    │───────────│   │
                           │    │PK TradeID │   │
                           ├────┤FK CashierID   │
                           │    │FK StudentID───┘
                           │    │FK FoodID  │
                           │    │   TradeTime│
                           │    │   Num     │
                           │    │   Remark  │
                           │    └─────┬─────┘
                           │          │
┌──────────┐    ┌──────────┐         │
│ ShopInfo │    │FoodShop  │   ┌─────┴─────┐
│──────────│    │──────────│   │ FoodsInfo │
│PK ShopID │◄───┤FK ShopID │   │───────────│
│ ShopName │    │FK FoodID │──►│PK FoodID  │
└──────────┘    └──────────┘   │ FoodName  │
                               │ Storage   │
                               │ BestBefore│
                               │ Price     │
                               │ Brand     │
                               │ Status    │
                               └───────────┘
```
