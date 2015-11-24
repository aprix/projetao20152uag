<?php

class PostVacancyLocation extends PHPUnit_Framework_TestCase {	
	
	public function testPostVacancyLocationInvalidSaldo(){
		
		/**
		 * no banco localmente existe um user com id 1 e um vehicle com id 1
		 * o saldo é menor que 120
		 * un_price = 1
		 */
		 	
		$postdata = http_build_query(
		    array(
		        'json' => "{\"IdUser\":\"1\",
				 \"Plate\":\"kga9998\",
				  \"Time\":\"120\"}"
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
		$response = file_get_contents('http://localhost/Webservice/post_vacancy_location_user', false, $context);		
		$json = json_decode($response, true);
		
		$this->assertArrayHasKey('Error', $json);		
		$this->assertEquals('Saldo insuficiente!', $json['Error']);
		
	}
	
	public function testPostVacancyLocationSucess(){
		
		/**
		 * no banco localmente existe um user com id 1 e um vehicle com id 1
		 * o saldo é menor que 120
		 * un_price = 1
		 */
		 	
		$postdata = http_build_query(
		    array(
		        'json' => "{\"IdUser\":\"1\",
				 \"Plate\":\"kga1118\",
				  \"Time\":\"10\"}"
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
		$response = file_get_contents('http://localhost/Webservice/post_vacancy_location_user', false, $context);		
		$json = json_decode($response, true);
		
		$this->assertArrayHasKey('Sucess', $json);
		echo $json['Sucess'];
	}
}

?>