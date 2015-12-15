<?php

use Illuminate\Foundation\Testing\WithoutMiddleware;
use Illuminate\Foundation\Testing\DatabaseMigrations;
use Illuminate\Foundation\Testing\DatabaseTransactions;

class FormTest extends TestCase
{
    /**
     * A basic test example.
     *
     * @return void
     */
    public function testEditPrice()
    {
        $this->visit('tabela')
             ->click('Editar')
             ->seePageIs('tabela/1/edit')
             ->click('Cancelar')
             ->seePageIs('tabela')
             ->click('Editar')
             ->type('10', 'un_time')
             ->type('20','max_price')
             ->press('Salvar')
             ->seePageIs('tabela');
            
    }

     public function testCreateInstitution()
    {
        $this->visit('instituicao/create')
        	->click('Cancelar')
        	->seePageIs('paineladmin')
        	->click('Instituições')
        	->click('Cadastrar Instituição')
        	->seePageIs('instituicao/create')
        	->type('12345678901235', 'cnpj')
        	->type('Vinicius', 'name')
        	->type('ViniciusLTDA', 'razao_social')
        	->type('1234562', 'state_registration')
        	->type('Avenida', 'address')
        	->type('100', 'address_num')
        	->type('Centro', 'address_neighborhood')
        	->type('Garanhuns', 'city')
        	->type('Pernambuco', 'state')
        	->type('Garanhuns', 'cep')
        	->press('Cadastrar')
        	->seePageIs('instituicao/create')
        	->type('55295160','cep')
        	->press('Cadastrar')
        	->seePageIs('paineladmin');

             ;
            
    }
}
