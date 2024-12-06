using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Net.Mail;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace CagriMerkeziSistemi
{
    public partial class İtirazListesi : Form
    {
        public İtirazListesi()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
           
            try
            {
                // 1. Kullanıcıdan veri al
                

                // 2. Veritabanı bağlantısı aç
                using (SqlConnection connection = new SqlConnection(SqlCon.SQLConnectionString)) // connectionString'i kendi veritabanı bağlantı bilgilerinizle değiştirin
                {
                    connection.Open();

                    // 3. SqlCommand oluştur
                    using (SqlCommand command = new SqlCommand("sp_ItirazEkle", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;

                        // 4. Parametreleri ekle
                        command.Parameters.AddWithValue("@AssistantID", AppData.userID);
                        command.Parameters.AddWithValue("@ObjectionDescription", textBox1.Text);
                        command.Parameters.AddWithValue("@ObjectionMonthYear", textBox2.Text);

                        // 5. Stored procedure'ü çalıştır
                        command.ExecuteNonQuery();

                      /*  if (command.ExecuteNonQuery() > 0)
                        {
                            // Takım lideri ve grup yöneticisinin e-posta adreslerini veritabanından alın
                            string takimLideriEmail = "..."; // Takım liderinin e-posta adresini veritabanından çekin
                            string grupYoneticisiEmail = "..."; // Grup yöneticisinin e-posta adresini veritabanından çekin

                            // E-posta içeriğini oluşturun
                            string subject = "Yeni Prim İtirazı";
                            string body = $"Sayın Takım Lideri ve Grup Yöneticisi,Asistan {asistanAdSoyad} tarafından {objectionMonthYear:yyyy-MM} dönemi primi için yeni bir itiraz kaydı oluşturulmuştur.\n\nİtiraz açıklaması: {objectionDescription}";

                            // E-posta gönderme işlemi
                            using (MailMessage mail = new MailMessage())
                            {
                                mail.From = new MailAddress("gonderen_email_adresi@gmail.com"); // Gönderen e-posta adresi
                                mail.To.Add(takimLideriEmail);
                                mail.To.Add(grupYoneticisiEmail);
                                mail.Subject = subject;
                                mail.Body = body;

                                using (SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587)) // Gmail SMTP ayarları
                                {
                                    smtp.Credentials = new NetworkCredential("gonderen_email_adresi@gmail.com", "email_sifresi"); // Gönderen e-posta adresi ve şifresi
                                    smtp.EnableSsl = true;
                                    smtp.Send(mail);
                                }
                            }
                        }*/


                    }
                }





                MessageBox.Show("İtirazınız başarıyla kaydedildi.");
            }
            catch (Exception ex)
            {
                MessageBox.Show("Hata: " + ex.Message);
            }

            GridDoldur();

        }

        private void GridDoldur()
        {
            DataTable dt1 = new DataTable();
            using (SqlCommand command = new SqlCommand("sp_AsistanItirazlariGetir", SqlCon.con))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@AssistantID", AppData.userID);
                SqlDataAdapter adapter = new SqlDataAdapter(command);
                DataTable dataTable = new DataTable();
                adapter.Fill(dataTable);
                dataGridView1.DataSource = dataTable;
            }
            
            string listResponseQuery = $"select * from Response where ObjectionID in(Select ObjectionID from Objection where AssistantID = {AppData.userID})";
            DataTable dt2 = new DataTable();    
            dt2 = SqlCon.Table(listResponseQuery);
            dataGridView2.DataSource = dt2;
        }

        private void İtirazListesi_Load(object sender, EventArgs e)
        {
            GridDoldur();
        }

        private void dataGridView2_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }
    }
}
