<?php

namespace Retaguarda\Http\Controllers;

use Illuminate\Http\Request;
use Retaguarda\Http\Requests;
use Retaguarda\Http\Controllers\Controller;
use Auth;
use Session;
use Redirect;

class FrontController extends Controller
{
    public function __construct(){
        $this->middleware('auth',['only'=>'painel']);
    }
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {

        if(Auth::check()){

            return redirect('painel');
        }
        return view('index');
    }

    public function painel(){

        return view('painel');
        
    }

     public function cadastrovendedor(){

        return view('cadastrodevendedor');
    }

     public function admin(){

        return view('auth/login');
        
    }

     public function paineladmin(){

         return view('layouts/administrador');
        
    }

    
    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
 
}
