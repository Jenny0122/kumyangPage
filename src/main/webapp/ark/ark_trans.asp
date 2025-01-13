<% session.codepage =65001%><% Response.ContentType = "application/json;charset=UTf-8" %><%
if Request("query") <> "" then
	query = Request("query")
end if
if Request("convert") <> "" then
	convert = Request("convert")
end If
if Request("target") <> "" then
	target = Request("target")
end If
if Request("charset") <> "" then
	charset = Request("charset")
end if
Set xh = CreateObject("MSXML2.serverXMLHTTP")

query = Server.URLEncode(query)

'url = "http://61.82.137.182:8080/neo/WNRun.do?query="+query+"&convert="+convert+"&target="+target+"&charset="+charset
url = "http://211.39.140.93:8080/neo-2.0.0/WNRun.do?query="+query+"&convert="+convert+"&target="+target+"&charset="+charset

xh.Open "POST", url, false
xh.Send
response.binaryWrite xh.responseBody
Set xh = Nothing
%>