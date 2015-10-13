<?php
	require_once("Rest.inc.php");
		
	class API extends REST {
	
		public $data = "";
		
		const DB_SERVER = "localhost";
		const DB_USER = "root";
		const DB_PASSWORD = "";
		const DB = "base";
		
		private $db = NULL;
	
		public function __construct(){
			parent::__construct();				// Init parent contructor
			$this->dbConnect();					// Initiate Database connection
		}
		
		/*
		 *  Database connection 
		*/
		private function dbConnect(){	
			$this->db = mysqli_connect(self::DB_SERVER,self::DB_USER,self::DB_PASSWORD, self::DB) or die(mysqli_error($this->db));
			
			if($this->db)
				mysqli_select_db($this->db,self::DB) or die(mysqli_error($this->db));
				
			mysqli_query($this->db, "SET CHARACTER set  'utf8'");
		}
		
		/*
		 * Public method for access api.
		 * This method dynmically call the method based on the query string
		 *
		 */
		public function processApi(){
			$func = strtolower(trim(str_replace("/","",$_REQUEST['rquest'])));
			
			if((int)method_exists($this,$func) > 0){
				$this->$func();
			}			
			else
				$this->response('',404);				// If the method not exist with in this class, response would be "Page not found".*/
		}
						
		
		private function insertAlgumRegistro(){
			if ($this->get_request_method() != 'POST'){
				$this->response('', 406);
			}
			
			//Recebe um Json como argumento para o parâmetro 'json'.
			$json = $this->_request['json'];			
			
			//Converte o Json em um array, os indices do array são iguais às chaves do Json. Ex.: {"id":1,"outroValor": "string"}.
			$vetor = json_decode($json, TRUE);
			
			//Valor do par cuja chave é 'id', pertencente ao Json passado como argumento para a requisição POST. 
			$id = $vetor['id'];
			
			//Array para ser convertido em um Json e ser retornado como resposta da requisição.
			$response_array = array();
			
			//String contendo algum comando de SELECT, UPDATE, DELETE, INSERT.
			$sql =   "SELECT EM ALGUMA TABELA";
			
			//Nesse caso, como se trata de uma consulta, os registros retornados na consulta serão percorridos através da variável $query.
			if ($query = mysqli_query($this->db, $sql)){
				
				//Averigua se a consulta retornou pelo menos um registro.
				if (mysqli_num_rows($query) > 0){
					
					//A função mysqli_fetch_array retorna um array, ele retorna o próximo registro selecionado no cursor da query.
					//Obs.: a função seleciona o próximo registro da consulta, sendo então usado para percorrer todos os registros da consulta.
					//Ex.: while ($row = mysqli_fetch_array($query, MYSQLI_ASSOC)){ faça alguma coisa para cada registro}
					$PegaProximoRegistroNaConsulta = mysqli_fetch_array($query, MYSQLI_ASSOC);
					
					//Pega os valores do primeira registro da consulta.
					$response_array['id'] = $PegaProximoRegistroNaConsulta['Algum Atributo'];
					$response_array['outroValor'] = $PegaProximoRegistroNaConsulta['Outro Atributo'];					
				}
				else{
					//Para mensagens de erro (500 == 'Erro interno').
					$this->response("Algum erro", 500);
				}
			}
			else{	
				//Para mensagens de erro.
				$this->response("Error: "+mysqli_error($this->db), 500);			
			}	
				
			//Retorna como resposta(200 == OK) uma estrutura de dados no formato Json. Ex.: {"id":1,"outroValor": "string"}
			$this->response($this->arrayToJson($response_array), 200);			
		}	
				
		/*
		 *	Encode array into JSON
		 * Decode JSON into array
		*/
		private function arrayToJson($data){
			if(is_array($data)){
				return json_encode($data);
			}
		}
	}
	
	// Initiiate Library
	
	$api = new API;
	$api->processApi();
?>