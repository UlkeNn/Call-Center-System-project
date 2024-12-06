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
    public partial class TakimLideriFormu : Form
    {
        public TakimLideriFormu()
        {
            InitializeComponent();
        }

        private void GridDoldur()
        {
            DataTable dt1 = new DataTable();
            string listFunctionTeamQuery = $"select * from fn_TakimUyeleri({AppData.userID})";
        //    string listTeamQuery = $"select zz.Name, zz.Surname, zz.SicilNo, t.TeamName from (Select fu.Name,fu.Surname,fu.SicilNo,tu.TeamID from TeamUser tu inner join fUser fu  on fu.UserID = tu.UserID  where tu.TeamID = (Select TeamID from UserRole Where UserID = {AppData.userID} ) ) zz inner join Team t on t.TeamID = zz.TeamID";
            dt1 = SqlCon.Table(listFunctionTeamQuery);

            dataGridView1.DataSource = dt1;
            DataTable dt2 = new DataTable();
            string listFunctionObjectionQuery = $"SELECT * FROM fn_TakimItirazlari({AppData.userID})";        
          //  string listObjectionQuery = $"Select * from (Select fUser.UserID, SicilNo,fUser.Name,fUser.Surname,ObjectionID,ObjectionDescription,ObjectionMonthYear,ObjectionStatus from Objection inner join fUser on fUser.UserID = Objection.AssistantID)zz where zz.UserID in(Select UserID from TeamUser where TeamID = (Select TeamID from TeamUser where UserID = {AppData.userID}) )";
            dt2 = SqlCon.Table(listFunctionObjectionQuery);
            dataGridView2.DataSource = dt2;
        }

        private void TakimLideriFormu_Load(object sender, EventArgs e)
        {
            GridDoldur();

            string comboboxListObjectionIdQuery = $"Select ObjectionID from (Select fUser.UserID, SicilNo,fUser.Name,fUser.Surname,ObjectionID,ObjectionDescription,ObjectionMonthYear,ObjectionStatus from Objection inner join fUser on fUser.UserID = Objection.AssistantID)zz where zz.UserID in(Select UserID from TeamUser where TeamID = (Select TeamID from TeamUser where UserID = {AppData.userID}) )";
            SqlCommand komut = new SqlCommand();
            komut.CommandText = comboboxListObjectionIdQuery;
            komut.Connection = SqlCon.con;
            komut.CommandType = CommandType.Text;
            SqlDataReader dr;
            dr = komut.ExecuteReader();
            while (dr.Read())
            {
                comboBox1.Items.Add(dr["ObjectionID"]);
            }
                        dr.Close();


        }

        private void button1_Click(object sender, EventArgs e)
        {
            /*string addResponseQuery = $"insert into Response (ObjectionID, ResponseMessage) values ({comboBox1.Text},'{textBox2.Text}')";
            SqlCon.Command(addResponseQuery);
            string UpdateObjectionQuery = $"Update Objection SET ObjectionStatus = '{comboBox2.Text}' where ObjectionID = {comboBox1.Text}";
            SqlCon.Command(UpdateObjectionQuery);*/


            try
            {
                // 1. Kullanıcıdan veri al
             
                // 2. Veritabanı bağlantısı aç
                using (SqlConnection connection = new SqlConnection(SqlCon.SQLConnectionString)) // connectionString'i kendi veritabanı bağlantı bilgilerinizle değiştirin
                {
                    connection.Open();

                    // 3. SqlCommand oluştur
                    using (SqlCommand command = new SqlCommand("sp_ItirazCevapla", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;

                        // 4. Parametreleri ekle
                        command.Parameters.AddWithValue("@ObjectionID", comboBox1.Text);
                        command.Parameters.AddWithValue("@TakimLideriID", AppData.userID);
                        command.Parameters.AddWithValue("@ResponseMessage", textBox2.Text);

                        // 5. Stored procedure'ü çalıştır
                        command.ExecuteNonQuery();
                    }
                }

                MessageBox.Show("İtiraz cevabı başarıyla kaydedildi.");
            }
            catch (Exception ex)
            {
                MessageBox.Show("Hata: " + ex.Message);
            }
            GridDoldur();
        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void label1_Click(object sender, EventArgs e)
        {

        }
    }
}
