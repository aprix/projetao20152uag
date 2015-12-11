<?php

namespace Retaguarda;

use Illuminate\Database\Eloquent\Model;

class Supervisor extends Model
{
     protected $table = "supervisor";
    protected $fillable = ['id_user','name','rg','status'];
     protected $primaryKey = "id_user";
        public $timestamps = false;


 public function usuario(){
return $this->belongsTo('App\Usuario');
}
}
