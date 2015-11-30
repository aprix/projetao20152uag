<?php

namespace Retaguarda\Http\Controllers;

use Illuminate\Http\Request;
use Retaguarda\Http\Requests;
use Retaguarda\Http\Controllers\Controller;
use Retaguarda\Http\Requests\PriceRequest;
use Retaguarda\Price;
use DB;

class PriceController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $id = "1";
        $price = Price::find($id);
       

        $precos =  DB::table('prices')
             ->where('id', '!=', 1)
             ->select('prices.*') 
             ->get();

             

              return view('precos.index', compact('price'), compact('precos'));

    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
         return view('precos.create');
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(PriceRequest $request)
    {
        $input = $request->all();
        Price::create($input);

        return  redirect('tabela');
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

        $price = Price::find($id);
        return view('precos.edit', compact('price'));

    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(PriceRequest $request, $id)
    {
      $price = Price::find($id);
       $price->fill($request->all());
       $price->save();

      return redirect('tabela')->with('message','editprecos');
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        Price::find($id)->delete();

        return redirect('tabela');

    }
}
