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
                
				// faz as validações de pagamento...
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



	private function get_vacancy_location_date(){
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
		$sql = select_vacancy_location_date($plate);

		$response = array();

		if ($query = mysqli_query($this->db, $sql)){
			if (mysqli_num_rows($query) > 0){
				$response_row = array();
				$i = 0;
				// este laço varre as linhas da consulta e vai as armazenando em $response...
				while ($row = mysqli_fetch_array($query, MYSQLI_ASSOC)){
					$response_row['InitialDate'] = $row['initialDate'];
					$response_row[ 'FinalDate' ] = $row[ 'finalDate' ];
					$response[$i] = $response_row;
					$i++;
				}
			}
		}
		// por fim response é convertido para o formato json...
		$response_json = json_encode($response);
		
		// e enviado para aplicação...
		$this->response($response_json, 200);

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
