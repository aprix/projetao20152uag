<?php

/*
|--------------------------------------------------------------------------
| Application Routes
|--------------------------------------------------------------------------
|
| Here is where you can register all of the routes for an application.
| It's a breeze. Simply tell Laravel the URIs it should respond to
| and give it the controller to call when that URI is requested.
| post, get, put, delete
*/


//Route::get('/','FrontController@index');
Route::get('painel','FrontController@painel');
Route::resource('tabela','PriceController');
Route::post('tabela/create','PriceController@create');
//Route::get('admin','FrontController@admin');
Route::get('paineladmin','FrontController@paineladmin');

Route::resource('/','FrontController');
//Route::get('tabeladeprecos','FrontController@tabeladeprecos');
Route::resource('instituicao','InstitutionController');
Route::post('instituicao/store','InstitutionController@store');
Route::post('tabela/store','PriceController@store');
//Route::get('cadvendedor','FrontController@cadastrovendedor');
//Route::get('tabela/{id}/edit','PriceController@edit');
Route::put('tabela/{id}/update','PriceController@update');


