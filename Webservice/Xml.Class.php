<?php

Class Xml{

	//atributos

	private $xml;
	private $tab = 1;



	//métodos

	public function _construct ($version = '1.0', $encode = 'UTF-8'){ //construtor
 	
 		$this -> xml .= "<?xml version ='$version' enconde = '$encode'?>\n";

	} 

	public function openTag($name){    //inicio da tag xml

		$this -> addTab();
		$this -> xml .= "<$name>\n";
		$this -> tab++;

	}

	public function closeTag($name){  //final da tag xml

		$this -> tab--;
		$this -> addTab();
		$this -> xml .= "</$name>\n";

	}

	public function setValue($value){  

		$this -> xml .= "$value\n";
	}

	public function addTab(){  //metodo para fazer identação do xml

		for ($i = 1; $i < $this -> tab; i++){

			$this -> xml .= "\t";

		}

	}

	public function addTag($name, $value){ //cria tag apenas com valor

		$this -> xml .= "<$name>$value</$name>\n";

	}

	public function _toString(){ 

		return $this -> xml;
	}
}

?>
 