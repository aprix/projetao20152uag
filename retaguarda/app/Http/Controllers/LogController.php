<?php

namespace Retaguarda\Http\Controllers;

use Illuminate\Http\Request;
use Auth;
use Session;
use Redirect;
use Retaguarda\Http\Requests;
use Retaguarda\Http\Requests\LoginRequest;
use Retaguarda\Http\Controllers\Controller;
use Retaguarda\Admin;
use DB;

    

class LogController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        //
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(LoginRequest $request)
    {
         if(Auth::attempt(['name'=>'admin', 'password'=>'admin'])){
            return Redirect::to('paineladmin');
         }else{

         return "Falha no login";
     }

    }


    public function login(LoginRequest $request){

     if($users = DB::table('admin')
            ->where('login','=',$request->login)
            ->select('admin.*')
            ->get()
             ){

foreach($users as $user){
           $senha = $user->senha;
           $id = $user->id;
}
            $senha2 = $request->password;
            $admin = Admin::find($id);

    if($senha2 == $senha){
       Auth::login($admin);
       
       if(Auth::check()){  

        

       return redirect('painel');
   

}
}

}
    return back()->with('message','loginfail');

    }
    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        //
    }
}
