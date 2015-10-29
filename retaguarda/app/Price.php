<?php

namespace Retaguarda;

use Illuminate\Database\Eloquent\Model;

class Price extends Model
{
    protected $table = "prices";
    protected $fillable = ['min_time','un_time','un_price','discount_sellers','max_price'];

    public $timestamps = false;
}
