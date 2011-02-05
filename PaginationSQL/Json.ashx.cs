using System;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web;
using System.Web.Configuration;
using System.Web.Script.Serialization;

namespace PaginationSQL
{
    /// <summary>
    /// Summary description for Json
    /// </summary>
    public class Json : IHttpHandler
    {
        private string ChinookConnection = WebConfigurationManager.ConnectionStrings["ChinookConnection"].ConnectionString;
        private string data = "";
        private int page_number = 1;
        private int page_size = 25;
        private int total_count = 0;

        public void ProcessRequest(HttpContext context)
        {
            page_size = Convert.ToInt32(context.Request.QueryString["page_size"]);
            page_number = Convert.ToInt32(context.Request.QueryString["page_number"]);
            
            StringBuilder json = new StringBuilder();

            string artistId = "";
            string name = "";

            DataSet artist = GetArtistsByPage(page_size, page_number);
            foreach (DataRow dr in artist.Tables[0].Rows)
            {
                artistId = dr["ArtistId"].ToString();
                name = JavaScriptStringEncode(dr["Name"].ToString());

                json.Append("{");
                json.Append("\"artistId\":\"" + artistId + "\",");
                json.Append("\"artistName\":\"" + name + "\"");
                json.Append("},");

                total_count = Convert.ToInt32(dr["TotalCount"]);
            }
            data = "{\"items\":[";
            if (json.Length != 0)
            {
                //remove trailing comma since we can't determine if last record during the append
                //data += "[" + json.ToString(0, json.Length - 1) + "]";
                data += json.ToString(0, json.Length - 1);
            }
            data += "],\"page_number\":" + page_number + ",\"page_size\":" + page_size + ",\"total_count\":" + total_count + "}";

            context.Response.Clear();
            context.Response.Cache.SetCacheability(HttpCacheability.NoCache);
            context.Response.ContentType = "application/json;charset=utf-8";
            context.Response.Flush();
            context.Response.Write(data);
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }

        //if your app has more data access methods, move this into a
        //data access layer class, such as Dal.cs
        public DataSet GetArtistsByPage(int pageSize, int pageNumber)
        {
            SqlConnection con = new SqlConnection(ChinookConnection);
            SqlCommand cmd = new SqlCommand("sp_ArtistsByPage", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@pageSize", pageSize);
            cmd.Parameters.AddWithValue("@pageNumber", pageNumber);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataSet ds = new DataSet();
            da.Fill(ds, "Artists");
            return ds;
        }

        //if your app works with json elsewhere, move this into
        //another class - perhaps Utils.cs
        public string JavaScriptStringEncode(string message)
        {
            if (String.IsNullOrEmpty(message))
            {
                return message;
            }
            StringBuilder builder = new StringBuilder();
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.Serialize(message, builder);
            return builder.ToString(1, builder.Length - 2); // remove first + last quote
        }

    }
}