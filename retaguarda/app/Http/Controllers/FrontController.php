<?php

namespace Retaguarda\Http\Controllers;

use Illuminate\Http\Request;
use Retaguarda\Http\Requests;
use Retaguarda\Http\Controllers\Controller;

class FrontController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return view('index');
    }

    public function painel(){

        return view('painel');
        
    }

     public function cadastrovendedor(){

        return view('cadastrodevendedor');
    }

     public function admin(){

        return view('adminlogin');
        
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
