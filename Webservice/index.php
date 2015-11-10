<?php

require_once("Rest.inc.php");
require_once("database_operations.php");



class API extends REST {

    public $data = "";

    const DB_SERVER = "localhost:3306";
    const DB_USER = "azul";
    const DB_PASSWORD = "123456";
    const DB = "zona_azul";

    private $db = NULL;

    public function __construct() {
        parent::__construct();    // Init parent contructor
        $this->dbConnect();     // Initiate Database connection
    }

    /*
     *  Database connection 
     */

    private function dbConnect() {
        $this->db = mysqli_connect(self::DB_SERVER, self::DB_USER, self::DB_PASSWORD, self::DB) or die(mysqli_error($this->db));

        if ($this->db)
            mysqli_select_db($this->db, self::DB) or die(mysqli_error($this->db));

        mysqli_query($this->db, "SET CHARACTER set  'utf8'");
    }
    /*
     * Public method for access api.
     * This method dynmically call the method based on the query string
     *
     */

    public function processApi() {

        $func = strtolower(trim(str_replace("/", "", $_REQUEST['rquest'])));

        if ((int) method_exists($this, $func) > 0) {
            $this->$func();
        } else {
            $this->response('Method not Found', 404);    // If the method not exist with in this class, response would be "Page not found".*/
	}

    }

	private function post_vacancy_location() {
        if ($this->get_request_method() != 'POST') {
            $this->response($this->get_request_method(), 406);
        }

        //Recebe um Json como argumento para o parâmetro 'json'.
        $json = $this->_request['json'];

        //Converte o Json em um array, os indices do array são iguais às chaves do Json. Ex.: {"id":1,"outroValor": "string"}.
        $vetor = json_decode($json, TRUE);

        //variaveis
        $placaVeiculo = $vetor['Plate'];
        $hora = $vetor['Time'];
        $nomeImpresso = $vetor['NameCreditCard'];
        $bandeiraCartao = $vetor['FlagCreditCard'];
        $numeroCartao = $vetor['NumberCreditCard'];
		$mesValidadeCartao = $vetor['MonthCreditCard'];
		$anoValidadeCartao = $vetor['YearCreditCard'];
        $cscCartao = $vetor['CSCCredCard'];
		
		// sql que verifica se para esta placa já existe algum veiculo estacionado utilizando a data atual como referência.
        $sql = select_vacancy_location($placaVeiculo);
		
		$response = array();

        if ($query = mysqli_query($this->db, $sql)) {

			// se a quantidade de linhas retornadas da query for > 0 indica que o veiculo desta placa já está estacionado
            if (mysqli_num_rows($query) > 0) {

				//lançada mensagem para a aplicação...
                $response['Error'] = "Veiculo ja estacionado";
				$this->response(json_encode($response), 200);

            } else {
				
				$this->validate_credit_card($numeroCartao, $response);

				// TODO verificar este método....
		 		$pay = payment($nomeImpresso, $bandeiraCartao, $numeroCartao, $mesValidadeCartao, $anoValidadeCartao, $cscCartao);
		
				// realiza uma consulta verificando se já existe algum registro do veiculo desta placa com o usuario padrão(id = 1)				
				$sql_select_vehicle = select_vehicle($placaVeiculo, 1);
				$select_vehicle = mysqli_query($this->db, $sql_select_vehicle);
						
				// se não existe registro( == 0) então...
				if(mysqli_num_rows($select_vehicle) == 0){
							
					// é inserido um novo registro...
					$sql_insert_vehicle = insert_vehicle($placaVeiculo);
				    $insert_vehicle = mysqli_query($this->db, $sql_insert_vehicle );
		
					// em caso de erro será enviado para a aplicação...
					if(! $insert_vehicle){
						$response['Error'] = mysqli_error($this->db);
						$this->response(json_encode($response), 200);
					}
		
				}
						
				// como já foi verificado na consulta $query que não existe locação de vaga
				// neste momento para o veiculo é realizada a locação de vaga...
				$sql_insert_vacancy_location = insert_vacancy_location($placaVeiculo, $hora);
		        $insert_vacancy_location = mysqli_query($this->db,  $sql_insert_vacancy_location);
		
				// em caso de erro será enviado para a aplicação...
				if(! $insert_vacancy_location){
					$response['Error'] = mysqli_error($this->db);					
					$this->response(json_encode($response), 200);
				}
		
				// feito novamente a consulta para pegar a data salva
				$query = mysqli_query($this->db, $sql);
				if(mysqli_num_rows($query) > 0){
					$row = mysqli_fetch_array($query, MYSQLI_ASSOC);
						
					// caso ocorra tudo certo será retornada a aplicação uma mensagem de sucesso...
					$response['Sucess'] = $row['initialDate'];					
					$this->response(json_encode($response), 200);
				} else {
					//Para mensagens de erro.
		            $response['Error'] = mysqli_error($this->db);
					$this->response(json_encode($response), 200);
				}
 
			}
        } else {
            //Para mensagens de erro.
            $response['Error'] = mysqli_error($this->db);
			$this->response(json_encode($response), 200);
        }
    }

	private function get_vacancy_location(){
		if ($this->get_request_method() != 'GET') {
            $this->response($this->get_request_method(), 406);
        }

        //Recebe um Json como argumento para o parâmetro 'json'.
        $json = $this->_request['json'];

        //Converte o Json em um array, os indices do array são iguais às chaves do Json. Ex.: {"id":1,"outroValor": "string"}.
        $vector = json_decode($json, TRUE);
		
		// pega a variavel Plate(placa do carro)
		$plate = $vector['Plate'];
		
		// este sql é uma consulta que retorna a data de inicio da locação
		// e a data de fim da locação...
		$sql = select_vacancy_location($plate);

		$response = array();

		if ($query = mysqli_query($this->db, $sql)) {

			// se a quantidade de linhas retornadas da query for igual a zero...
            if (mysqli_num_rows($query) == 0) {

				// então o veiculo não está estacionado...
				$response['Error'] = "Veiculo nao estacionado";
			} else {
				// pega o proximo registro, que neste caso DEVE ser o unico
				$row = mysqli_fetch_array($query, MYSQLI_ASSOC);
				
				// salva no formato solicitado por Diogo na issue do dia 16/10/2015.
				$response['DateBegin'] = $row['initialDate'];
				$response['DeadlineTime'] = $row[ 'finalDate' ];
			}
		} else {
			$response['Error'] = mysqli_error($this->db);
		}

		// por fim response é convertido para o formato json...
		$response_json = json_encode($response);
		
		// e enviado para aplicação...
		$this->response($response_json, 200);
	}

	private function post_user(){
		if ($this->get_request_method() != 'POST') {
            $this->response($this->get_request_method(), 406);
        }
        //Recebe um Json como argumento para o parâmetro 'json'.
        $json = $this->_request['json'];

        //Converte o Json em um array, os indices do array são iguais às chaves do Json. Ex.: {"id":1,"outroValor": "string"}.
        $vector = json_decode($json, TRUE);
	
		// variaveis
		$id = $vector['Id'];
		$email = $vector['Email'];
		$nick = $vector['Nickname'];
		$cpf = $vector['CPF'];		
		$password = $vector['Password'];

		$response = array();
		
		if($id == 0){
			// insert
			$sql = insert_user($cpf, $password, $email, $nick);

			if($query = mysqli_query($this->db, $sql)){

				// pega o id do insert
				$response['Id'] = (string) mysqli_insert_id($this->db);
				$this->response(json_encode($response), 200);

			} else {

				$response['Error'] = mysqli_error($this->db);
				$this->response(json_encode($response), 200);

			}
		} else {

			//update
			$sql = update_user($id, $cpf, $password, $email, $nick);

			if($query = mysqli_query($this->db, $sql)){
				
				// retorna o id que ja foi passado
				$response['Id'] = $id;
				$this->response(json_encode($response), 200);

			} else {

				$response['Error'] = mysqli_error($this->db);
				$this->response(json_encode($response), 200);

			}
		}
			
	}

	private function post_credit_card(){
		if ($this->get_request_method() != 'POST') {
            $this->response($this->get_request_method(), 406);
        }
        //Recebe um Json como argumento para o parâmetro 'json'.
        $json = $this->_request['json'];

        //Converte o Json em um array, os indices do array são iguais às chaves do Json. Ex.: {"id":1,"outroValor": "string"}.
        $vector = json_decode($json, TRUE);
	
		// variaveis
		$id = $vector['Id'];
		$id_user = $vector['IdUser'];
		$name = $vector['Name'];
		$number = $vector['Number'];
		$flag = $vector['Flag'];		
		$month = $vector['MonthValidate'];
		$year = $vector['YearValidate'];
		$status = $vector['Status'];

		if($status == "True"){
			$status = 1;
		} else {
			$status = 0;
		}

		$response = array();
		
		if($status == 1){
			$this->validate_credit_card($number, $response);
		}
		
		if($id == 0){
			// insert
			$sql = insert_credit_card($id_user, $name, $number, $flag, $month, $year, $status);

			if($query = mysqli_query($this->db, $sql)){

				// pega o id do insert
				$response['Id'] = (string) mysqli_insert_id($this->db);
				$this->response(json_encode($response), 200);

			} else {

				$response['Error'] = mysqli_error($this->db);
				$this->response(json_encode($response), 200);

			}
		} else {

			//update
			$sql = update_credit_card($id, $id_user, $name, $number, $flag, $month, $year, $status);

			if($query = mysqli_query($this->db, $sql)){
				
				// retorna o id que ja foi passado
				$response['Id'] = $id;
				$this->response(json_encode($response), 200);

			} else {

				$response['Error'] = mysqli_error($this->db);
				$this->response(json_encode($response), 200);

			}
		}
			
	}

	private function get_credit_card(){		
		if ($this->get_request_method() != 'GET') {
            $this->response($this->get_request_method(), 406);
        }

		//Recebe um Json como argumento para o parâmetro 'json'.
        $json = $this->_request['json'];

        //Converte o Json em um array, os indices do array são iguais às chaves do Json. Ex.: {"id":1,"outroValor": "string"}.
        $vector = json_decode($json, TRUE);
		
		// pega a variavel Plate(placa do carro)
		$id_user = $vector['IdUser'];
		
		// este sql é uma consulta que retorna a data de inicio da locação
		// e a data de fim da locação...
		$sql = select_credit_card_for_user($id_user);

		$response = array();

		if ($query = mysqli_query($this->db, $sql)){
			if (mysqli_num_rows($query) > 0){
				$response_row = array();
				$i = 0;
				// este laço varre as linhas da consulta e vai as armazenando em $response...
				while ($row = mysqli_fetch_array($query, MYSQLI_ASSOC)){
					$response_row['Id'] = $row['id'];
					$response_row['Name'] = $row['name'];
					$response_row['Number'] = $row['num'];
					$response_row['Flag'] = $row['flag'];
					$response_row['MonthValidate'] = $row['validate_month'];
					$response_row['YearValidate'] = $row['validate_year'];					

					$response[$i] = $response_row;
					$i++;
				}
			}

		}  else {

			$response['Error'] = mysqli_error($this->db);
			$this->response(json_encode($response), 200);

		}
		// por fim response é convertido para o formato json...
		$response_json = json_encode($response);
		
		// e enviado para aplicação...
		$this->response($response_json, 200);
	}
	
	private function login(){
		if ($this->get_request_method() != 'GET') {
            $this->response($this->get_request_method(), 406);
        }

        //Recebe um Json como argumento para o parâmetro 'json'.
        $json = $this->_request['json'];

        //Converte o Json em um array, os indices do array são iguais às chaves do Json. Ex.: {"id":1,"outroValor": "string"}.
        $vector = json_decode($json, TRUE);
		
		// pega as variaveis
		$cpf = $vector['CPF'];
		$password = $vector['Password'];
		// este sql é uma consulta que retorna a data de inicio da locação
		// e a data de fim da locação...
		$sql = select_user($cpf, $password);
		
		$response = array();

		if ($query = mysqli_query($this->db, $sql)){
			if (mysqli_num_rows($query) > 0){
				$row = mysqli_fetch_array($query, MYSQLI_ASSOC);
				
				$response['Id']       = $row['id'];
				$response['Nickname'] = $row['nickname'];
				$response['Email']    = $row['email'];
			} else {
				$response['Error'] = 'CPF ou senha inválidos';
			}
		} else {
			$response['Error'] = mysqli_error($this->db);
		}
		
		$this->response(json_encode($response), 200);
	}
	
	private function post_credits(){
		if ($this->get_request_method() != 'POST') {
            $this->response($this->get_request_method(), 406);
        }

        //Recebe um Json como argumento para o parâmetro 'json'.
        $json = $this->_request['json'];

        //Converte o Json em um array, os indices do array são iguais às chaves do Json. Ex.: {"id":1,"outroValor": "string"}.
        $vector = json_decode($json, TRUE);
		
		// variaveis
		$id_user = $vector['IdUser'];
		$id_credit_card = $vector['IdCreditCard'];
		$csc = $vector['CSC'];
		$value = $vector['Value'];
		
		$sql = select_credit_card($id_user, $id_credit_card);
		
		$response = array();

		if ($query = mysqli_query($this->db, $sql)){
			if (mysqli_num_rows($query) > 0){
				// pega o unico registro da consulta e armazena em $row
				$row = mysqli_fetch_array($query, MYSQLI_ASSOC);
				
				$pay = payment($row['name'], $row['flag'], $row['num'], $row['validate_month'], $row['validate_year'], $csc);
				
				if($pay){
					
					$sql_insert_payment = insert_payment($id_user, $id_credit_card, $value, 1);
					
					//inserindo na tabela payment
					if($query_insert_payment = mysqli_query($this->db, $sql_insert_payment)){
					
						// atualizando o saldo do user
						$sql_update_saldo = update_user_saldo($id_user, $value);						
						if($query_update_saldo = mysqli_query($this->db, $sql_update_saldo)){
							
							$response['Sucess'] = 'Sucesso';
							
						} else {
							
							$response['Error'] = mysqli_error($this->db);
							
						}
						
					} else {
						
						$response['Error'] = mysqli_error($this->db);
						
					}
				}
				
			} else {
				$response['Error'] = 'Cartão de crédito não cadastrado';
			}
		} else {
			$response['Error'] = mysqli_error($this->db);
		}
		
		$this->response(json_encode($response), 200);
	}

	private function get_vacancy_location_user(){
		if ($this->get_request_method() != 'GET') {
            $this->response($this->get_request_method(), 406);
        }

        //Recebe um Json como argumento para o parâmetro 'json'.
        $json = $this->_request['json'];

        //Converte o Json em um array, os indices do array são iguais às chaves do Json. Ex.: {"id":1,"outroValor": "string"}.
        $vector = json_decode($json, TRUE);
		
		// pega a variavel id do user
		$id_user = $vector['IdUser'];
		
		// este sql é uma consulta que retorna a data de inicio da locação
		// e a data de fim da locação...
		$sql = select_vacancy_location_user($id_user);

		$response = array();

		if ($query = mysqli_query($this->db, $sql)){
			if (mysqli_num_rows($query) > 0){
				$response_row = array();
				$i = 0;
				// este laço varre as linhas da consulta e vai as armazenando em $response...
				while ($row = mysqli_fetch_array($query, MYSQLI_ASSOC)){
					$response_row[ 'Plate' ] = $row[ 'plate' ];
					$response_row['StartTime'] = $row['date_location'];
					$response_row[ 'Time' ] = $row[ 'time_location' ];
					$response[$i] = $response_row;
					$i++;
				}
			}
		} else {
			$response['Error'] = mysqli_error($this->db);
		}
		// por fim response é convertido para o formato json...
		$response_json = json_encode($response);
		
		// e enviado para aplicação...
		$this->response($response_json, 200);

	}
	
	// funcao especifica da validacao do numero do cartao
	private function validate_credit_card($numeroCartao, $response){
		// faz as validações de pagamento...

        if(strlen($numeroCartao) != 16){

			$response['Error'] = "Número do cartão deve ter 16 dígitos";
			$this->response(json_encode($response), 200);


		} else if(substr($numeroCartao, 0, 1) != 4 && substr($numeroCartao, 0, 1) != 5 && substr($numeroCartao, 0, 1) != 3)  {

			$response['Error'] = "Cartão com numeração inválida";
			$this->response(json_encode($response), 200);

		} else{
			
			$soma = 0;

			for($i = strlen($numeroCartao) - 1; $i >= 0; $i--){

     			$lenght = $i+1;

				if(($i % 2) == 0){	

					$impares = substr($numeroCartao, $i, 1)*2;
					if ($impares > 9) {
						$impares = $impares - 9;
					}
					$soma= $soma + $impares;
   							
				}
	
				if (($i%2)!= 0) {
		
					$soma = $soma+ substr($numeroCartao, $i, 1);

				}
			}


			if ($soma%10 != 0){

				$response['Error'] = "Cartão com numeração inválida";
				$this->response(json_encode($response), 200);

			}
		}
	}

    /*
     * 	Encode array into JSON
     * Decode JSON into array
     */

    private function arrayToJson($data) {
        if (is_array($data)) {
            return json_encode($data);
        }
    }

}

// Initiiate Library

$api = new API;
$api->processApi();
?>

