<?php

namespace Retaguarda;

use Illuminate\Database\Eloquent\Model;

class Usuario extends Model
{
    protected $table = "user";
    protected $primaryKey = "cpf";
    protected $fillable = ['cpf','saldo','senha','email','nickname'];

    public $timestamps = false;
}
