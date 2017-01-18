<?php
	$isGzip = $_REQUEST['gzipFlag'];  //0 表示数据进行了压缩    1表示未压缩
 	$str = $_REQUEST['str'];    //进行Gzip或未进行压缩的请求参数

	if($isGzip=='0'){
        //如果进行了压缩,自定义一个压缩的响应数据（客户端进行Gzip解压）
        $res = 'responseData:cuihaohaoTest54786';
        $res = gzencode($res); 
        echo $res;
   	}else{  
		//如果请求没有进行压缩,拿到请求的明文直接返回
        echo $str;
   	}


?>