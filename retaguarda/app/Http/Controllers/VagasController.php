<?php

namespace Retaguarda\Http\Controllers;

use Illuminate\Http\Request;

use Retaguarda\Http\Requests;
use Retaguarda\Http\Controllers\Controller;
use DB;

class VagasController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return view('vagas.index');
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



        $users = DB::table('vehicle')
                ->join('vacancy_location', 'vehicle.id', '=','vacancy_location.id_vehicle')
                ->where('vacancy_location.date_location', 'like', "%".$id."%")
                ->select('vacancy_location.*', 'vehicle.plate')
                ->orderBy('id','desc')
                ->get();
        
        
       /* $users = DB::table('vacancy_location')
             ->where('date_location', 'like', "%".$id."%")
             ->select('vacancy_location.*') 
             ->get();*/

         $total = DB::table('vacancy_location')
             ->where('date_location', 'like', "%".$id."%")
             ->select('vacancy_location.*') 
             ->count();

             //return $users;
              return view('vagas.resultado', compact('users', 'total'),  compact('request'));
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
