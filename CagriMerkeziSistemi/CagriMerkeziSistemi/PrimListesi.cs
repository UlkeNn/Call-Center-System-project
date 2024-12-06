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
    public partial class PrimListesi : Form
    {
        public PrimListesi()
        {
            InitializeComponent();
        }

        private void PrimListesi_Load(object sender, EventArgs e)
        {

            string query = $"SELECT * FROM vw_AsistanPrimleri WHERE AssistantID = {AppData.userID}";
            DataTable dt = SqlCon.Table(query);
            dataGridView1.DataSource = dt;
        }

        private void button1_Click(object sender, EventArgs e)
        {
            İtirazListesi itiraz = new İtirazListesi();
            itiraz.Show();
            this.Show();
        }
    }
}
