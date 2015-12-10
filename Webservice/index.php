<?php

require_once("Rest.inc.php");
require_once("database_operations.php");
require_once("lib/Mail/Mail.php");



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
		
		$sql_max_time = select_un_price();		
				
		$response = array();
				
		if($query_max_time = mysqli_query($this->db, $sql_max_time)) {
				$row_max_time = mysqli_fetch_array($query_max_time, MYSQLI_ASSOC);
				$un_price = $row_max_time['un_price'];
				$max_time = $row_max_time['max_time'];
				
				// sql que verifica se para esta placa já existe algum veiculo estacionado utilizando a data atual como referência.
		        $sql = select_vacancy_location_time($placaVeiculo);
		
		        if ($query = mysqli_query($this->db, $sql)) {
		
					// se a quantidade de linhas retornadas da query for > 0 indica que o veiculo desta placa já está estacionado
		            if (mysqli_num_rows($query) > 0) {
						
						$row_vl = mysqli_fetch_array($query, MYSQLI_ASSOC);
						$previous_time = $row_vl['time_location'];
						$id_vl = $row_vl['id'];
						
						if($previous_time + $hora <= $max_time){
							$this->validate_credit_card($numeroCartao, $response);
			
							// TODO verificar este método....
					 		$pay = payment($nomeImpresso, $bandeiraCartao, $numeroCartao, $mesValidadeCartao, $anoValidadeCartao, $cscCartao);
					
							// realiza uma consulta verificando se já existe algum registro do veiculo desta placa com o usuario padrão(id = 1)				
							$sql_select_vehicle = select_vehicle($placaVeiculo, 1);
							$select_vehicle = mysqli_query($this->db, $sql_select_vehicle);
									
							// se não existe registro( == 0) então...
							if(mysqli_num_rows($select_vehicle) == 0){
										
								// é inserido um novo registro...
								$sql_insert_vehicle = insert_vehicle(1, $placaVeiculo);
							    $insert_vehicle = mysqli_query($this->db, $sql_insert_vehicle );
					
								// em caso de erro será enviado para a aplicação...
								if(! $insert_vehicle){
									$response['Error'] = mysqli_error($this->db);
									$this->response(json_encode($response), 200);
								}
					
							}
									
							// como já foi verificado na consulta $query que não existe locação de vaga
							// neste momento para o veiculo é realizada a locação de vaga...
							$sql_update_vacancy_location = update_vacancy_location_time($id_vl, $hora, $hora * $un_price);
							echo $sql_update_vacancy_location;
							// em caso de erro será enviado para a aplicação...
							if(mysqli_query($this->db,  $sql_update_vacancy_location)){
								
								$sql = select_vacancy_location($placaVeiculo);
								// feito novamente a consulta para pegar a data salva
								if($query = mysqli_query($this->db, $sql)){
									$row = mysqli_fetch_array($query, MYSQLI_ASSOC);
										
									// caso ocorra tudo certo será retornada a aplicação uma mensagem de sucesso...
									$response['Sucess'] = $row['initialDate'];					
									$this->response(json_encode($response), 200);
								} else {
									//Para mensagens de erro.
						            $response['Error'] = mysqli_error($this->db);
									$this->response(json_encode($response), 200);
								}
								
							} else {								
								$response['Error'] = mysqli_error($this->db);					
								$this->response(json_encode($response), 200);
								
							}
					
							
						} else {
							$to_max = $max_time - $previous_time;
							//lançada mensagem para a aplicação...
		                	$response['Error'] = "Tempo máximo ultrapassado, só é possível colocar até $to_max minutos";
							$this->response(json_encode($response), 200);
							
						}
					// caso o veiculo ainda nao esteja estacionado
		            } else {
						
						if($hora <= $max_time){
						
							$this->validate_credit_card($numeroCartao, $response);
			
							// TODO verificar este método....
					 		$pay = payment($nomeImpresso, $bandeiraCartao, $numeroCartao, $mesValidadeCartao, $anoValidadeCartao, $cscCartao);
					
							// realiza uma consulta verificando se já existe algum registro do veiculo desta placa com o usuario padrão(id = 1)				
							$sql_select_vehicle = select_vehicle($placaVeiculo, 1);
							$select_vehicle = mysqli_query($this->db, $sql_select_vehicle);
									
							// se não existe registro( == 0) então...
							if(mysqli_num_rows($select_vehicle) == 0){
										
								// é inserido um novo registro...
								$sql_insert_vehicle = insert_vehicle(1, $placaVeiculo);
							    $insert_vehicle = mysqli_query($this->db, $sql_insert_vehicle );
					
								// em caso de erro será enviado para a aplicação...
								if(! $insert_vehicle){
									$response['Error'] = mysqli_error($this->db);
									$this->response(json_encode($response), 200);
								}
					
							}
									
							// como já foi verificado na consulta $query que não existe locação de vaga
							// neste momento para o veiculo é realizada a locação de vaga...
							$sql_insert_vacancy_location = insert_vacancy_location(1, $placaVeiculo, $hora, $hora * $un_price);
					        $insert_vacancy_location = mysqli_query($this->db,  $sql_insert_vacancy_location);
					
							// em caso de erro será enviado para a aplicação...
							if(! $insert_vacancy_location){
								$response['Error'] = mysqli_error($this->db);					
								$this->response(json_encode($response), 200);
							}
					
							// feito novamente a consulta para pegar a data salva
							$sql = select_vacancy_location($placaVeiculo);							
							if($query = mysqli_query($this->db, $sql)){
									$row = mysqli_fetch_array($query, MYSQLI_ASSOC);
									
									// caso ocorra tudo certo será retornada a aplicação uma mensagem de sucesso...
									$response['Sucess'] = $row['initialDate'];			
									$this->response(json_encode($response), 200);
							} else {
								//Para mensagens de erro.
					            $response['Error'] = mysqli_error($this->db);
								$this->response(json_encode($response), 200);
							}
						// caso o valor solicitado for maior que o tempo maximo permitido
						} else {
							//lançada mensagem para a aplicação...
		                	$response['Error'] = "Tempo máximo ultrapassado, só é possível colocar até $max_time minutos";
							$this->response(json_encode($response), 200);
							
						}
		 
					}
		        } else {
		            //Para mensagens de erro.
		            $response['Error'] = mysqli_error($this->db);
					$this->response(json_encode($response), 200);
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
	
	private function post_vacancy_location_user(){
		if ($this->get_request_method() != 'POST') {
            $this->response($this->get_request_method(), 406);
        }

        //Recebe um Json como argumento para o parâmetro 'json'.
        $json = $this->_request['json'];

        //Converte o Json em um array, os indices do array são iguais às chaves do Json. Ex.: {"id":1,"outroValor": "string"}.
        $vector = json_decode($json, TRUE);
		
		//Variaveis
		$id_user = $vector['IdUser'];
		$plate = $vector['Plate'];
		$time = $vector['Time'];
		
		$sql_select_vehicle = select_vehicle($plate, $id_user);
		
		$response = array();

		if ($query = mysqli_query($this->db, $sql_select_vehicle)){
			// se nao existe veiculo vinculado ao user
			if (mysqli_num_rows($query) == 0){
				
				// é inserido um novo registro...
				$sql_insert_vehicle = insert_vehicle($id_user, $plate);
				
				// caso dê algum erro...
				if(! mysqli_query($this->db, $sql_insert_vehicle )){
					// é enviado para aplicação...
					$response['Error'] = mysqli_error($this->db);
					$this->response(json_encode($response), 200);
				}
			}
			
			$sql_select_saldo = select_user_saldo($id_user);
			
			if($query_select_saldo = mysqli_query($this->db, $sql_select_saldo)){
				$row_saldo = mysqli_fetch_array($query_select_saldo, MYSQLI_ASSOC);
				
				// armazena o saldo do user
				$saldo = $row_saldo['saldo'];
				
				$sql_select_un_price = select_un_price();
				
				if($query_select_un_price = mysqli_query($this->db, $sql_select_un_price)){
					$row_un_price = mysqli_fetch_array($query_select_un_price, MYSQLI_ASSOC);
					
					// armazena o un_price e o tempo maximo
					$un_price = $row_un_price['un_price'];				
					$max_time = $row_un_price['max_time'];
					
					$sql_select_discount = select_table_prices($id_user);
					
					if($query_discount = mysqli_query($this->db, $sql_select_discount)){
						$row_discount = mysqli_fetch_array($query_discount, MYSQLI_ASSOC);
						
						$discount = $row_discount['discount'];
						
						// armazena quanto será o total gasto
						$value = $time * $un_price * (1 - $discount/100.0);
						
						// se existe saldo suficiente
						if($value <= $saldo){
							$sql_select_vl = select_vacancy_location_time($plate);						
							
							if($query_vl = mysqli_query($this->db, $sql_select_vl)){
								
								// dependendo da existencia da locacao de vaga será escolhido um update ou um insert
								$sql_ = '';
								
								if (mysqli_num_rows($query_vl) == 0){
									// se o tempo solicitado for menor que o tempo maximo permitido
									if($time <= $max_time){
										$sql_ = insert_vacancy_location($id_user, $plate, $time, $value);
										
									} else {
										$response['Error'] = "Tempo máximo ultrapassado, só é possível colocar até $max_time minutos";
										// por fim response é convertido para o formato json...
										$response_json = json_encode($response);
			
										// e enviado para aplicação...
										$this->response($response_json, 200);
									}
								// caso ja exista locacao de vaga...
								} else {									
									$row_vl = mysqli_fetch_array($query_vl, MYSQLI_ASSOC);
									$id_vl = $row_vl['id'];
									$previous_time = $row_vl['time_location'];
									
									// se acrescentando o tempo não ultrapassar o tempo maximo permitido
									if($previous_time + $time <= $max_time){
										$sql_ = update_vacancy_location_time($id_vl, $time, $value);	
																		
									}  else {
										$to_max = $max_time - $previous_time;
										$response['Error'] = "Tempo máximo ultrapassado, só é possível colocar até $to_max minutos";
										// por fim response é convertido para o formato json...
										$response_json = json_encode($response);
			
										// e enviado para aplicação...
										$this->response($response_json, 200);
									}
								}
								// realizando a atualizacao do saldo e preparando o retorno do json
								if(mysqli_query($this->db, $sql_)){			
									$sql_update_saldo = update_user_saldo($id_user, - $value);
								
									if(mysqli_query($this->db, $sql_update_saldo)){									
										$sql_select_vacancy_location = select_vacancy_location($plate);
										
										if($query_vacancy_location = mysqli_query($this->db, $sql_select_vacancy_location)){
											$row_query = mysqli_fetch_array($query_vacancy_location, MYSQLI_ASSOC);
											// coloca no vetor de saida a data final										
											$response['Sucess'] = $row_query['finalDate'];
									
										// caso dê erro no select_vacancy_location
										} else {
											$response['Error'] = mysqli_error($this->db);
										}
									// caso dê erro no update_saldo
									} else {
										$response['Error'] = mysqli_error($this->db);
									}
								// caso dê erro no insert_vacancy_location
								} else {
									$response['Error'] = mysqli_error($this->db);
								}
							// caso dê erro no 	select_vl					
							} else {
								$response['Error'] = mysqli_error($this->db);
							}			
						// caso o value seja maior que o saldo
						} else {
							$response['Error'] = 'Saldo insuficiente!';
						}
					// caso dê erro no select_discount
					} else {
						$response['Error'] = mysqli_error($this->db);
					}					
				// caso dê erro no select_un_price
				}  else {
					$response['Error'] = mysqli_error($this->db);
				}
			// caso dê erro no select_saldo
			} else {
				$response['Error'] = mysqli_error($this->db);
			}
			// caso não exista veiculo de placa plate associado ao user			
		// caso dê erro no select_vehicle
		} else {
			$response['Error'] = mysqli_error($this->db);
		}
		// por fim response é convertido para o formato json...
		$response_json = json_encode($response);
		
		// e enviado para aplicação...
		$this->response($response_json, 200);
		
	}
	
	private function get_credits_user(){
		if ($this->get_request_method() != 'GET') {
            $this->response($this->get_request_method(), 406);
        }
		
		//Recebe um Json como argumento para o parâmetro 'json'.
        $json = $this->_request['json'];

        //Converte o Json em um array, os indices do array são iguais às chaves do Json. Ex.: {"id":1,"outroValor": "string"}.
        $vector = json_decode($json, TRUE);
		
		//Variaveis
		$id_user = $vector['IdUser'];
		
		$sql = select_user_saldo($id_user);
		
		$response = array();
		
		if ($query = mysqli_query($this->db, $sql)){
			if (mysqli_num_rows($query) > 0){
				$row = mysqli_fetch_array($query, MYSQLI_ASSOC);
				
				$response['Value'] = $row['saldo'];
			}
		} else {
			$response['Error'] = mysqli_error($this->db);
		}
		
		// por fim response é convertido para o formato json...
		$response_json = json_encode($response);
		
		// e enviado para aplicação...
		$this->response($response_json, 200);
	}
	
	private function get_price(){
		if ($this->get_request_method() != 'GET') {
            $this->response($this->get_request_method(), 406);
        }
		
		//Recebe um Json como argumento para o parâmetro 'json'.
        $json = $this->_request['json'];

        //Converte o Json em um array, os indices do array são iguais às chaves do Json. Ex.: {"id":1,"outroValor": "string"}.
        $vector = json_decode($json, TRUE);
		
		//Variaveis
		$id_user = $vector['IdUser'];
		
		$sql = select_table_prices($id_user);
		
		$response = array();
		
		if ($query = mysqli_query($this->db, $sql)){
			if (mysqli_num_rows($query) > 0){
				$row = mysqli_fetch_array($query, MYSQLI_ASSOC);
				
				$response['PriceTime']     = $row['un_price'];
				$response['MinTime']       = $row['min_time'];
				$response['MaxTime']       = $row['max_price'];
				$response['UnitTime']      = $row['un_time'];
				$response['DiscountPrice'] = $row['discount'];
			}
		} else {
			$response['Error'] = mysqli_error($this->db);
		}
		
		// por fim response é convertido para o formato json...
		$response_json = json_encode($response);
		
		// e enviado para aplicação...
		$this->response($response_json, 200);
	}
	
	private function redefine_password(){
		if ($this->get_request_method() != 'GET') {
            $this->response($this->get_request_method(), 406);
        }
		
		//Recebe um Json como argumento para o parâmetro 'json'.
        $json = $this->_request['json'];

        //Converte o Json em um array, os indices do array são iguais às chaves do Json. Ex.: {"id":1,"outroValor": "string"}.
        $vector = json_decode($json, TRUE);
		
		//Variaveis
		$cpf = $vector['CPF'];
		
		$sql = select_email($cpf);
		
		$response = array();
		
		if ($query = mysqli_query($this->db, $sql)){
			if (mysqli_num_rows($query) > 0){
				$row = mysqli_fetch_array($query, MYSQLI_ASSOC);
				
				$email = $row['email'];
				$nick  = $row['nickname'];
				
				$senha = rand(0,10000);
				
				$sql_senha = update_senha($cpf, $senha);
				
				if (mysqli_query($this->db, $sql_senha)){
					$from = "AzulFacil";
					$title = "Redefinição de Senha";
					$body = "Olá, aqui está sua nova senha: $senha
					
Esta é uma senha temporária e por isso redefina esta para a senha que desejar o mais breve possível

Suporte AzulFácil";
					 
					$host = "smtp.gmail.com";
					// tem que colocar um gmail valido
					$username = "";
					// e sua senha
					$password = "";
					$port     = '587';
					 
					$header = array ('From'    => $from,
									 'To'      => $email,
									 'Subject' => $title);
					$smtp = Mail::factory('smtp',
					  array ('host'     => $host,
					    	 'auth'     => true,
					    	 'username' => $username,
					  		 'password' => $password,
							 'port'     => $port));
					 
					$mail = $smtp->send($email, $header, $body);
					 
					if (PEAR::isError($mail)) {
					  $response['Error'] = $mail->getMessage();
					} else {
					  $response['Sucess'] = "E-mail com nova senha enviado com sucesso!";
					}
				
				} else {
					$response['Error'] = mysqli_error($this->db);
					
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
