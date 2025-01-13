using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Net;
using System.IO;
using System.Text;
using common;

namespace Search.ark
{
    public partial class ark_trans : System.Web.UI.Page
    {
        protected string xmlResult = "";
        //private static string Url = string.Format("http://{0}:8080/WNRun.do", ConfigurationManager.AppSettings["SEARCH_IP"]);
//        private static string Url = "http://" + WNCollection.SEARCH_IP+ ":8080/morpheus/WNRun.do";
		private static string Url = "http://211.39.140.93:8080/neo-2.0.0/WNRun.do";
        private HttpWebRequest request = (HttpWebRequest)WebRequest.Create(Url);
        private HttpWebResponse response = null;
        private Stream postDataStream = null;
        private Stream respPostStream = null;
        private StreamReader readerPost = null;

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                string query = Request["query"] != null ? Request["query"] : "";
                string convert = Request["convert"] != null ? Request["convert"] : "fw";
                string charset = Request["charset"] != null ? Request["charset"] : "";
                string target = Request["target"] != null ? Request["target"] : "";

                string postParams = string.Format("query={0}&convert={1}&target={2}&charset={3}", query, convert, target, charset);
                byte[] result = Encoding.UTF8.GetBytes(postParams);
                //byte[] result = Encoding.ASCII.GetBytes(postParams);

                // HttpWebRequest 오브젝트 설정
                request.Method = "POST";
                request.ContentType = "application/x-www-form-urlencoded";
                request.Accept = "application/json";
                request.ContentLength = result.Length;

                // POST할 데이터를 입력합니다.
                postDataStream = request.GetRequestStream();
                postDataStream.Write(result, 0, result.Length);
                postDataStream.Close();

                response = (HttpWebResponse)request.GetResponse();

                // Response의 결과를 스트림을 생성합니다.
                respPostStream = response.GetResponseStream();
                readerPost = new StreamReader(respPostStream, Encoding.UTF8);

                // 생성한 스트림으로부터 string으로 변환합니다.
                string resultPost = readerPost.ReadToEnd();
                xmlResult = resultPost;
            }
            catch
            {
                xmlResult = "{\"responsestatus\":-1,\"result\":[{\"totalcount\":0},{\"totalcount\":0}]}";
            }
        }
    }
}
