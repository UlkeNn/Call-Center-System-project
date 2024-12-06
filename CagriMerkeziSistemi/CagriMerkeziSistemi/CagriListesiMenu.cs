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
    public partial class CagriListesiMenu : Form
    {
        public CagriListesiMenu()
        {
            InitializeComponent();
        }

        private void CagriListesiMenu_Load(object sender, EventArgs e)
        {
            string AllCallQuery = $"select u.Name, u.Surname, c.InterviewTopic, c.InterviewDate, c.InterviewStartTime, c.InterviewFinishTime, c.InterviewStateInfo from Call c inner join fUser u on c.CustomerID = u.UserID where AssistantID  =  {AppData.userID} order by c.CallID desc";
           DataTable dt = SqlCon.Table(AllCallQuery);
            dataGridView1.DataSource = dt;
        }


        //Yeni Çağrı Ekle
        private void button1_Click(object sender, EventArgs e)
        {
            CagriEklemeForm cagriEklemeForm = new CagriEklemeForm();
            cagriEklemeForm.Show();
            this.Hide();
        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }
    }
}
