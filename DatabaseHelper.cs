using System;
using Microsoft.Data.SqlClient;
using System.Configuration;   // 读取 App.config
using System.Data;            // 用到 CommandType 时可选

namespace HeiResturan0
{
    /// <summary>
    /// 登录验证结果
    /// </summary>
    public class LoginResult
    {
        public bool Success { get; set; }
        public string Role { get; set; }          // "Admin" / "Cashier" / "Student"
        public string UserID { get; set; }
        public string DisplayName { get; set; }   // CashierName / StudentName
        public string ErrorMessage { get; set; }
    }

    public static class DatabaseHelper
    {
        public static string GetConnectionString()
        {
            var connStr = ConfigurationManager.ConnectionStrings["MyDB"]?.ConnectionString;
            if (string.IsNullOrEmpty(connStr))
            {
                throw new Exception("在 App.config 中未找到名为 'MyDB' 的连接字符串。");
            }
            return connStr;
        }

        /// <summary>
        /// 验证用户登录 - 依次查询 AdminInfo, CashierInfo, StudentsInfo
        /// </summary>
        public static LoginResult ValidateLogin(string account, string password)
        {
            var result = new LoginResult();

            // 输入校验
            if (string.IsNullOrWhiteSpace(account) || string.IsNullOrWhiteSpace(password))
            {
                result.Success = false;
                result.ErrorMessage = "账号和密码不能为空。";
                return result;
            }

            try
            {
                using (var conn = new SqlConnection(GetConnectionString()))
                {
                    conn.Open();

                    // 1) 检查 AdminInfo
                    using (var cmd = new SqlCommand(
                        "SELECT AdminID FROM AdminInfo WHERE AdminID = @id AND Password = @pwd", conn))
                    {
                        cmd.Parameters.AddWithValue("@id", account.Trim());
                        cmd.Parameters.AddWithValue("@pwd", password.Trim());
                        var obj = cmd.ExecuteScalar();
                        if (obj != null)
                        {
                            result.Success = true;
                            result.Role = "Admin";
                            result.UserID = obj.ToString().Trim();
                            result.DisplayName = result.UserID;
                            return result;
                        }
                    }

                    // 2) 检查 CashierInfo
                    using (var cmd = new SqlCommand(
                        "SELECT CashierID, CashierName FROM CashierInfo WHERE CashierID = @id AND Password = @pwd", conn))
                    {
                        cmd.Parameters.AddWithValue("@id", account.Trim());
                        cmd.Parameters.AddWithValue("@pwd", password.Trim());
                        using (var reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                result.Success = true;
                                result.Role = "Cashier";
                                result.UserID = reader["CashierID"].ToString().Trim();
                                result.DisplayName = reader["CashierName"].ToString().Trim();
                                return result;
                            }
                        }
                    }

                    // 3) 检查 StudentsInfo
                    using (var cmd = new SqlCommand(
                        "SELECT StudentID, StudentName FROM StudentsInfo WHERE StudentID = @id AND Password = @pwd", conn))
                    {
                        cmd.Parameters.AddWithValue("@id", account.Trim());
                        cmd.Parameters.AddWithValue("@pwd", password.Trim());
                        using (var reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                result.Success = true;
                                result.Role = "Student";
                                result.UserID = reader["StudentID"].ToString().Trim();
                                result.DisplayName = reader["StudentName"].ToString().Trim();
                                return result;
                            }
                        }
                    }

                    // 未匹配任何用户
                    result.Success = false;
                    result.ErrorMessage = "账号或密码错误。";
                }
            }
            catch (Exception ex)
            {
                result.Success = false;
                result.ErrorMessage = $"数据库错误: {ex.Message}";
            }

            return result;
        }
    }
}
