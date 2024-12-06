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
    public partial class İtirazlarım : Form
    {
        public İtirazlarım()
        {
            InitializeComponent();
        }

        private void İtirazlarım_Load(object sender, EventArgs e)
        {
            DataTable dt1 = new DataTable();
            string listObjectionViewQuery = $"SELECT * FROM vw_AsistanItirazlari WHERE AssistantID = {AppData.userID}";
            dt1 = SqlCon.Table(listObjectionViewQuery);
            dataGridView1.DataSource = dt1;
            string listResponseQuery = $"select * from Response where ObjectionID in(Select ObjectionID from Objection where AssistantID = {AppData.userID})";
            DataTable dt2 = new DataTable();
            dt2 = SqlCon.Table(listResponseQuery);
            dataGridView2.DataSource = dt2;
        }

        private void dataGridView2_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

    
    }
}
