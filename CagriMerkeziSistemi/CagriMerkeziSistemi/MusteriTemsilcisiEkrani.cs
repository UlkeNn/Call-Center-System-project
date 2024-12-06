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
    public partial class MusteriTemsilcisiEkrani : Form
    {
        public MusteriTemsilcisiEkrani()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
           CagriListesiMenu cagriListesiMenu = new CagriListesiMenu();
           cagriListesiMenu.Show();
          
        }

        private void button2_Click(object sender, EventArgs e)
        {
            PrimListesi primListesi = new PrimListesi();
            primListesi.Show();
     
        }

        private void button3_Click(object sender, EventArgs e)
        {
            İtirazlarım itiraz = new İtirazlarım();
            itiraz.Show();
       
        }
    }
}
