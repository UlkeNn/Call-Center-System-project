using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace CagriMerkeziSistemi
{
    public partial class CagriEklemeForm : Form
    {
        public CagriEklemeForm()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            
            string addCustomerQuery = $"insert into fUser ( Name, Surname) values  ('{textBox1.Text}','{textBox2.Text}');  SELECT SCOPE_IDENTITY();";
            var customerID =  SqlCon.Command(addCustomerQuery);
            customerID = Convert.ToInt32(customerID.ToString());

            string addCustomerRoleQuery = $"insert into UserRole (RoleID,UserID) values (4,{customerID})";
            SqlCon.Command(addCustomerRoleQuery);


            // 2. Veritabanı bağlantısı aç
            using (SqlConnection connection = new SqlConnection(SqlCon.SQLConnectionString))
            {

                connection.Open();
                // 3. SqlCommand oluştur
                SqlCommand command = new SqlCommand("sp_CagriEkle", connection);
                command.CommandType = CommandType.StoredProcedure;

                // 4. Parametreleri ekle
                command.Parameters.AddWithValue("@AssistantUserID",AppData.userID);
                command.Parameters.AddWithValue("@CustomerUserID", customerID);
                command.Parameters.AddWithValue("@InterviewTopic", comboBox1.Text);
                command.Parameters.AddWithValue("@InterviewDate", textBox4.Text);
                command.Parameters.AddWithValue("@InterviewStartTime", textBox5.Text);
                command.Parameters.AddWithValue("@InterviewFinishTime", textBox6.Text);
                command.Parameters.AddWithValue("@InterviewStateInfo", comboBox2.Text);

                // 5. Stored procedure'ü çalıştır
                try
                {
                    command.ExecuteNonQuery();
                    MessageBox.Show("Çağrı başarıyla kaydedildi.");
                }
                catch (SqlException ex)
                {
                    MessageBox.Show("Hata: " + ex.Message);
                }
            }




            CagriListesiMenu  cgr = new CagriListesiMenu();
            cgr.Show();
            this.Hide();
        }

        private void CagriEklemeForm_Load(object sender, EventArgs e)
        {

        }
    }
}
