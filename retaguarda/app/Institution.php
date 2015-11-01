<?php

namespace Retaguarda;

use Illuminate\Database\Eloquent\Model;

class Institution extends Model
{
    protected $table = "institution";
    protected $primaryKey = "cnpj";
    
    protected $fillable = ['cnpj','name','razao_social','state_registration','address','address_num','address_neighborhood','city','state','cep'];

    public $timestamps = false;

}
