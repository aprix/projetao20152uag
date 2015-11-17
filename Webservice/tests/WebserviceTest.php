<?php

class WebserviceTest extends PHPUnit_Framework_TestCase {
	
	public function testGetVacancyLocationNotFound(){
		
		//testando locacao de vaga com veiculo nao estacionado
		$url = "http://localhost/Webservice/get_vacancy_location?json=\"{\"Plate\":\"kga9998\"}\"";		
		$response = file_get_contents($url);		
		$json = json_decode($response, true);
		
		$this->assertArrayHasKey('Error', $json);
		
	}
	
	public function testPostVacancyLocationInvalidNumber(){
		
		//testando locacao de vaga com veiculo com numero invalido		
		$postdata = http_build_query(
		    array(
		        'json' => "{\"Plate\":\"kga9998\", \"Time\":\"1\", \"NameCreditCard\":\"Teste\", \"FlagCreditCard\":\"Visa\", \"NumberCreditCard\":\"9999999999999999\",\"MonthCreditCard\":\"10\",\"YearCreditCard\":\"2017\",\"CSCCredCard\":\"123\"}"
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
		
		$response = file_get_contents('http://localhost/Webservice/post_vacancy_location', false, $context);		
		$json = json_decode($response, true);
		
		$this->assertArrayHasKey('Error', $json);
		
	}
	
	public function testPostVacancyLocationValidNumber(){
		
		//testando locacao de vaga com veiculo com numero valido		
		$postdata = http_build_query(
		    array(
		        'json' => "{\"Plate\":\"kga9998\", \"Time\":\"1000\", \"NameCreditCard\":\"Teste\", \"FlagCreditCard\":\"Visa\", \"NumberCreditCard\":\"################\",\"MonthCreditCard\":\"10\",\"YearCreditCard\":\"2017\",\"CSCCredCard\":\"123\"}"
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
		
		$response = file_get_contents('http://localhost/Webservice/post_vacancy_location', false, $context);		
		$json = json_decode($response, true);
		
		$this->assertArrayHasKey('Sucess', $json);
		
	}
	
//	public function testGetVacancyLocationFounded(){
//		
//		//insert no vacancy_location o veiculo com esta placa
//		
//		//testando locacao de vaga com veiculo estacionado
//		$url = "http://localhost/Webservice/get_vacancy_location?json=\"{\"Plate\":\"kga9998\"}\"";		
//		$response = file_get_contents($url, false, null, 1);		
//		$json_array = json_decode($response, true);
//		
//		echo $json_array;
//		
//		$json_object = $json_array[1];
//		
//		$this->assertArrayHasKey('DateBegin', $json_oject);
//		
//	}

	public function testPostUserSuccessful(){
		//testando locacao de vaga com veiculo com numero valido		
		$postdata = http_build_query(
		    array(
		        'json' => "{\"Id\":\"0\", \"Email\":\"leandrorenanf@gmail.com\", \"Nickname\":\"Renan\", \"CPF\":\"99999992221\", \"Password\":\"123456\"}"
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
		
		$response = file_get_contents('http://localhost/Webservice/post_user', false, $context);		
		$json = json_decode($response, true);
		
		$this->assertArrayHasKey('Id', $json);
	}
	
	public function testPostUserCPFRepeat(){
		//testando locacao de vaga com veiculo com numero valido		
		$postdata = http_build_query(
		    array(
		        'json' => "{\"Id\":\"0\", \"Email\":\"leandrorenanf@gmail.com\", \"Nickname\":\"Renan\", \"CPF\":\"99999999221\", \"Password\":\"123456\"}"
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
		
		$response = file_get_contents('http://localhost/Webservice/post_user', false, $context);		
		$json = json_decode($response, true);
		
		$this->assertArrayHasKey('Error', $json);
	}
	
	public function testUpdateUser(){
		//testando locacao de vaga com veiculo com numero valido		
		$postdata = http_build_query(
		    array(
		        'json' => "{\"Id\":\"1\", \"Email\":\"leandrorenanf@gmail.com\", \"Nickname\":\"Renan\", \"CPF\":\"99999999999\", \"Password\":\"123456\"}"
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
		
		$response = file_get_contents('http://localhost/Webservice/post_user', false, $context);		
		$json = json_decode($response, true);
		
		$this->assertArrayHasKey('Id', $json);
	}
}

?>