using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CagriMerkeziSistemi
{
    public static class SqlCon
    {//@"Data Source=FAHRIGEDIK;Initial Catalog=cagriTakipSistemi;User ID=sa;Password=123;Connect Timeout=30;Encrypt=True;TrustServerCertificate=True"
        public static string SQLConnectionString = @"Data Source=ULGEN;Initial Catalog=cagriTakipSistemi;Integrated Security=True;";
        public static SqlConnection con = new SqlConnection(SQLConnectionString);
        private static SqlDataAdapter da = new SqlDataAdapter();
        private static SqlCommand com = new SqlCommand();

        public static void Baglanti()
        {
            if (con.State == System.Data.ConnectionState.Closed)
            {
                con.Open();
            }
        }
        public static object Command(string query)
        {
            object obj;
            using (SqlConnection con = new SqlConnection(SQLConnectionString))
            {
                con.Open();
                using (SqlCommand com = new SqlCommand(query, con))
                {
                    obj = com.ExecuteScalar();
                }
            }
            return obj;   
        }
        public static DataTable Table(string query)
        {
            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(SQLConnectionString))
            {
                using (SqlCommand com = new SqlCommand(query, con))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(com))
                    {
                        da.Fill(dt);
                    }
                }
            }
            return dt;
        }
    }
}
