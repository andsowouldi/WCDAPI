Add-Type -Assembly System.ServiceModel.Web,System.Runtime.Serialization

$url = "https://what.cd/login.php"

$CookieContainer = New-Object System.Net.CookieContainer

$postData = "username=andsowouldi&password=[Your Password]"

$buffer = [text.encoding]::ascii.getbytes($postData)

[net.httpWebRequest] $req = [net.webRequest]::create($url)
$req.method = "POST"
$req.Accept = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
$req.Headers.Add("Accept-Language: en-US")
$req.Headers.Add("Accept-Encoding: gzip,deflate")
$req.Headers.Add("Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7")
$req.AllowAutoRedirect = $false
$req.ContentType = "application/x-www-form-urlencoded"
$req.ContentLength = $buffer.length
$req.TimeOut = 50000
$req.KeepAlive = $true
$req.Headers.Add("Keep-Alive: 300");
$req.CookieContainer = $CookieContainer
$reqst = $req.getRequestStream()
$reqst.write($buffer, 0, $buffer.length)
$reqst.flush()
$reqst.close()
[net.httpWebResponse] $res = $req.getResponse()
$resst = $res.getResponseStream()
$sr = new-object IO.StreamReader($resst)
$result = $sr.ReadToEnd()

$web = new-object net.webclient
$web.Headers.add("Cookie", $res.Headers["Set-Cookie"])
$forum = $web.DownloadString("https://what.cd/ajax.php?action=forum&type=viewforum&forumid=26") | ConvertFrom-JSON
$forum.response.threads | ForEach-Object {
   $_.title
}
$res.close()