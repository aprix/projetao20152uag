<?php

class PostTicketTest extends PHPUnit_Framework_TestCase {	
	
	public function testPostTicketInvalidCreditCard(){
		
		/**
		 * no banco localmente existe um user com id 1 e um credit card com id 1
		 */
		 	
		$postdata = http_build_query(
		    array(
		        'json' => "{\"IdUser\":\"1\",
				 \"IdCreditCard\":\"2\",
				  \"Value\":\"100\",
				   \"CSC\":\"123\"}"
		    )
		);
		
		$opts = array('http' =>
		    array(
		        'method'  => 'POST',
		        'header'  => 'Content-type: application/x-www-form-urlencoded',
		        'content' => $postdata
		    )
		);
		
		$context  = stream_context_create($opts);		
		$response = file_get_contents('http://localhost/Webservice/post_ticket', false, $context);		
		$json = json_decode($response, true);
		
		$this->assertArrayHasKey('Error', $json);		
		$this->assertEquals('Cartão de crédito não cadastrado', $json['Error']);
		
	}
	
	public function testPostTicketSucess(){
		
		/**
		 * no banco localmente existe um user com id 1 e um credit card com id 1
		 * incrementando o saldo do usuário
		 */
		 
//		$DB_SERVER = "localhost:3306";
//    	$DB_USER = "azul";
//    	$DB_PASSWORD = "123456";
//    	$DB = "zona_azul";
//		
//		$connect = new \mysqli($DB_SERVER, $DB_USER, $DB_PASSWORD, $DB);
//		
//		$connection = \mysqli_connect($DB_SERVER, $DB_USER, $DB_PASSWORD, $DB) or die(mysqli_error($connection));
//		
//		if ($connection)
//            mysqli_select_db($connection, $DB) or die(mysqli_error($connection));
//
//        mysqli_query($connection, "SET CHARACTER set  'utf8'");

		 
		$inc = 10;
		$id_user = 1;
		
//		$sql_saldo = "SELECT user.saldo FROM user WHERE user.status = 1 AND user_id = $id_user";
		
//		$saldo = 0;
//		
//		if($query_saldo = mysqi_query($connection, $sql_saldo)){
//			$row = mysqli_fetch_array($query_saldo, MYSQLI_ASSOC);
//			$saldo = $row['saldo'];
//		}
		 	
		$postdata = http_build_query(
		    array(
		        'json' => "{\"IdUser\":\"$id_user\",
				 \"IdCreditCard\":\"1\",
				  \"Value\":\"$inc\",
				   \"CSC\":\"123\"}"
		    )
		);
		
		$opts = array('http' =>
		    array(
		        'method'  => 'POST',
		        'header'  => 'Content-type: application/x-www-form-urlencoded',
		        'content' => $postdata
		    )
		);
		
		$context  = stream_context_create($opts);		
		$response = file_get_contents('http://localhost/Webservice/post_ticket', false, $context);		
		$json = json_decode($response, true);
		
		$this->assertArrayHasKey('Sucess', $json);
		
//		$saldo_incr = 0;
//		
//		if($query_saldo = mysqi_query($connection, $sql_saldo)){
//			$row = mysqli_fetch_array($query_saldo, MYSQLI_ASSOC);
//			$saldo_incr = $row['saldo'];
//		}		
//		
//		$this->assertEquals($saldo + $inc, $saldo_incr);
	}
}

?>