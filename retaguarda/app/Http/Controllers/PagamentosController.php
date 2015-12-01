<?php

namespace Retaguarda\Http\Controllers;

use Illuminate\Http\Request;

use Retaguarda\Http\Requests;
use Retaguarda\Http\Controllers\Controller;
use DB;

class PagamentosController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return view('pagamentos.index');
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
    public function store(Request $request)
    {
        //
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show(Request $request)
    {
       
        $id = $request ->ano;
        $id .=$request->mes;
        $id .=$request->dia;

        $users = DB::table('user')
                ->join('payment', 'user.id', '=','payment.id_user')
                ->where('payment.date_payment', 'like', "%".$id."%")
                ->select('payment.*', 'user.nickname')
                ->orderBy('id','desc')
                ->get();
        /*$users = DB::table('payment')
             ->where('date_payment', 'like', "%".$id."%")
             ->select('payment.*') 
             ->get();*/

         $total = DB::table('payment')
             ->where('date_payment', 'like', "%".$id."%")
             ->select('payment.val') 
             ->sum('val');

             //return $result;
               return view('pagamentos.resultado', compact('users', 'request'),  compact('total'));
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
