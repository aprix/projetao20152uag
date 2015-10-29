<?php

namespace Retaguarda;

use Illuminate\Database\Eloquent\Model;

class Institution extends Model
{
    protected $table = "institution";
    protected $primaryKey = "cnpj";
    
    protected $fillable = ['cnpj','name','razao_social','state_registration','adress','adress_num','adress_neighborhood','city','state','cep'];

    public $timestamps = false;

}
