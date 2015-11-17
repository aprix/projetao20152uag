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
Route::get('admin','FrontController@admin');
Route::get('paineladmin','FrontController@paineladmin');
//Route::resource('log','LogController');
Route::resource('front','FrontController');
Route::resource('vendedor','SellerController');
Route::resource('fiscal','FiscalController');
Route::post('vendedor/search','SellerController@search');
Route::get('vendedor/{id}/destroy','SellerController@destroy');
Route::get('vendedor/{id}/reativar','SellerController@reativar');
Route::get('fiscal/{id}/reativar','FiscalController@reativar');
Route::get('fiscal/{id}/create','FiscalController@create');
Route::post('fiscal/search','FiscalController@search');
Route::get('fiscal/{id}/destroy','FiscalController@destroy');
Route::get('instituicao/search','InstitutionController@search');
Route::resource('instituicao','InstitutionController');
Route::post('instituicao/store','InstitutionController@store');
Route::post('tabela/store','PriceController@store');
Route::post('fiscal/store','FiscalController@store');
//Route::get('cadvendedor','FrontController@cadastrovendedor');
//Route::get('tabela/{id}/edit','PriceController@edit');
Route::put('tabela/{id}/update','PriceController@update');
Route::put('fiscal/{id_user}/update','FiscalController@update');

//Route::get('auth/login', 'Auth\AuthController@getLogin');
//Route::post('auth/login', 'Auth\AuthController@postLogin');
Route::controllers([
'auth' => 'Auth\AuthController',
'password' => 'Auth\PasswordController',
 ]);
