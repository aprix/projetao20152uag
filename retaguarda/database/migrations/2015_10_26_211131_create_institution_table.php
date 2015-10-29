<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateInstitutionTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('institution', function (Blueprint $table) {
             $table -> string('cnpj',15);
             $table -> string('name', 100);
             $table -> string('razao_social', 200);
            $table -> integer('state_registration');
            $table -> string('adress', 100);
            $table -> integer('adress_num');
            $table -> string('adress_neighborhood', 50);
            $table -> string('city', 50);
            $table -> string('state', 50);
            $table -> integer('cep');
        
            $table -> primary('cnpj');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::drop('institution');
    }
}
