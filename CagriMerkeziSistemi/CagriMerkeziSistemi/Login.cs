using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace CagriMerkeziSistemi
{
    public partial class Login : Form
    {
        public Login()
        {
            InitializeComponent();
        }

        private void Login_Load(object sender, EventArgs e)
        {

        }

        private void müsteriGirisi_Click(object sender, EventArgs e)
        {
            SqlCon.con.Open();

            string userİsNullQuery = $"select Count(*) as 'isNull' from fUser where UserName = '{textBox1.Text}' and Password = '{textBox2.Text}'";

            var obj = SqlCon.Command(userİsNullQuery);
            int isNullValue = int.Parse(obj.ToString());

            if (isNullValue==1)
            {
                string userIDquery = $"select UserID  from fUser where UserName = '{textBox1.Text}' and Password = '{textBox2.Text}'";
                var userID = SqlCon.Command(userIDquery);
                AppData.userID = Convert.ToInt32(userID.ToString());


                string userRoleIDCmd = $"select RoleID from UserRole where UserID = (Select UserID from fUser where UserName = '{textBox1.Text}' and Password = '{textBox2.Text}')";
                var userRoleID = SqlCon.Command(userRoleIDCmd);


                //Müşteri Temsilcisi Giriş Formu
                if (int.Parse(userRoleID.ToString())==1)
                {
                    MusteriTemsilcisiEkrani musteriTemsilcisiEkrani = new MusteriTemsilcisiEkrani();
                    musteriTemsilcisiEkrani.Show();
                    this.Hide();
                }

                //Grup Yöneticisi Giriş Formu
                if (int.Parse(userRoleID.ToString()) == 2)
                {

                }
                //Takım Lideri Giriş Formu
                if (int.Parse(userRoleID.ToString()) == 3)
                {
                    TakimLideriFormu tlf = new TakimLideriFormu();
                    tlf.Show();
                    this.Hide();
                }
                MessageBox.Show("Giriş Yapıldı");
                SqlCon.con.Close();

            }
            else
            {
                MessageBox.Show("Hatalı Giriş");
            }
        }
    }
}
