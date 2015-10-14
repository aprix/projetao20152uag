<?php

require_once('Xml.Class.php');
require_once('config.php');

$xml = new Xml();

$erro = 0;
$sucesso = 0;


//variaveis

$operacaoDoSistema = $_GET('IdOperation')
$placaVeiculo = $_GET['Plate'];
$hora = $_GET['Time'];
$nomeImpresso = $_GET['NameCreditCard'];
$bandeiraCartao = $_GET['FlagCreditCard'];
$numeroCartao = $_GET['NumberCreditCard'];
$mesValidade = $_GET['MonthCreditCard'];
$anoValidade = $_GET['YearCreditCard'];
$cscCartao	= $_GET['CSCCredCard'];

$xml -> openTag("response");

if($operacaoDoSistema == 1){ //operação 1 é corresponde ao pagamento de cliente não registrado

	if($placaVeiculo == ''){

		$erro = 1;
		$mensagemDeErro = 'Insira o numero da placa';


	}else if($nomeImpresso == '' || $bandeiraCartao == '' || $numeroCartao == '' || $mesValidade == '' || $anoValidade = '' || $cscCartao = ''){

		$erro = 2;
		$mensagemDeErro = 'Dados do cartão insuficientes';

	}else{

		$resposta = mysql_query("SELECT  "); //buscar pela placa do veiculo se o mesmo já está estacionado IMPLEMENTAR CONSULTA

		if(mysql_num_rows($resposta) > 0 ){

			$erro = 3;
			$mensagemDeErro = 'Veículo já está estacionado';

		}else{

			mysql_query("INSERT"); //Insere os dados da compra nas tabelas correspondentes IMPLEMENTAR INSERÇÃO


		}

	}

	if($erro > 0){

		$xml -> addTag('erro', $erro);
		$xml -> addTag('mensagem', $mensagemDeErro);
	
	}
}

if ($operacaoDoSistema == 2) { //operação de consulta pela placa do veiculo

if($placaVeiculo == ''){

		$erro = 1;
		$mensagemDeErro = 'Insira o numero da placa';

}else{

	$resposta = mysql_query("SELECT  "); //buscar pela placa do veiculo se o mesmo já está estacionado IMPLEMENTAR CONSULT

	if (mysql_num_rows($resposta) == 0) {

		$erro = 4;
		$mensagemDeErro = 'Veiculo sem vaga reservada';

	}else if(mysql_num_rows($resposta) == 1){

		$sucesso = 1;
		$mensagemFeedback = 'Veiculo com vaga reservada' 
	}

	}

	if ($erro > 0){

		$xml -> addTag('erro', $erro);
		$xml -> addTag('mensagem', $mensagemDeErro);

	}else{
	
		$xml -> addTag('Sucesso!', $mensagemFeedback;

	}
}

$xml -> closeTag("response");

$echo $xml;


?>