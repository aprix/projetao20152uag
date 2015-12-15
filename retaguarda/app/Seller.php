<?php

namespace Retaguarda;

use Illuminate\Database\Eloquent\Model;

class Seller extends Model
{
    protected $table = "seller";
    protected $fillable = ['id_user','status'];
    protected $primaryKey = "id_user";
        public $timestamps = false;


 public function usuario(){
return $this->belongsTo('App\Usuario');
}
}
