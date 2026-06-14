using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace HeiResturan0
{
    public partial class FormLogin : Form
    {
        public FormLogin()
        {
            InitializeComponent();
        }

        private void label1_Click(object sender, EventArgs e)
        {

        }
        private void label2_Click(object sender, EventArgs e)
        {

        }

        // 登录按钮
        private void button1_Click(object sender, EventArgs e)
        {
            string account = textBox1.Text;
            string password = textBox2.Text;

            var loginResult = DatabaseHelper.ValidateLogin(account, password);

            if (loginResult.Success)
            {
                Form targetForm = null;

                // 根据角色创建对应窗体
                switch (loginResult.Role)
                {
                    case "Admin":
                        targetForm = new FormAdminMain();
                        break;
                    case "Cashier":
                        targetForm = new FormCashier();
                        break;
                    case "Student":
                        targetForm = new FormStudent();
                        break;
                }

                if (targetForm != null)
                {
                    // 子窗体关闭时重新显示登录窗体
                    targetForm.FormClosed += (s, args) =>
                    {
                        // 清除密码框
                        textBox2.Clear();
                        this.Show();
                    };

                    this.Hide();
                    targetForm.Show();
                }
            }
            else
            {
                MessageBox.Show(loginResult.ErrorMessage, "登录失败",
                    MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
        }

        // 退出按钮
        private void button2_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        // 登录窗体关闭时退出程序
        private void FormLogin_FormClosing(object sender, FormClosingEventArgs e)
        {
            Application.Exit();
        }
    }
}
