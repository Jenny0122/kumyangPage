<?php
  //UTF-8인 경우 아래의 header의 주석을 해제한다.
  //header("Content-type: application/xml; charset=UTF-8");
  $host = "211.39.140.93"; //접속하고자하는 도메인
//  $host = "61.82.137.182"; //접속하고자하는 도메인
  $port = "8080"; //일반적인 웹서버포트
  $convert = $_GET["convert"];
  $query = $_GET["query"];
  $target = $_GET["target"];
  $charset = $_GET["charset"];
  $fullpath = "/neo-2.0.0/WNRun.do?convert=".$convert."&query=".$query."&target=".$target."&charset=".$charset;
  $fp = fsockopen($host, $port, &$errno, &$errstr, 30);
  if(!$fp) {
	return fasle;
	exit; 
  }else{
	fputs($fp, "POST ".$fullpath." HTTP/1.0\r\n");
	fputs($fp, "Host: ".$host."\r\n");
	fputs($fp, "Accept: application/xml\r\n");
	fputs($fp, "Connection: close\r\n\r\n"); 
	$content = "";
	while(!feof($fp)){
		$temp = fgets($fp, 1024);
		$content .= $contents.$temp;
		
	}
	$xmls = trim(substr($content,strpos($content, "\r\n\r\n")));//헤더 삭제 
	echo $xmls;//제어이전 내용 확인
	fclose($fp);
  }
?>