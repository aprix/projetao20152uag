<?php

namespace Retaguarda\Http\Controllers;

use Illuminate\Http\Request;
use Retaguarda\Http\Requests;
use Retaguarda\Http\Controllers\Controller;
use Retaguarda\Http\Requests\SearchRequest;
use Retaguarda\Http\Requests\FiscalRequest;
use Retaguarda\Usuario;
use Retaguarda\Supervisor;
use DB;

class FiscalController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
         $users = DB::table('user')
            ->join('supervisor', 'user.id', '=', 'supervisor.id_user')
            ->select('supervisor.*')
            ->where('supervisor.status', '=','1')
            ->get();

        return view('fiscal.index', compact('users'));
    }



    public function reativar($id)
    {
         DB::table('supervisor')
        ->where('id', $id)
        ->update(['status'=> 1]);

        return redirect('fiscal')->with('message','fiscalreativar');
    }


     public function search(SearchRequest $request){
        $input = $request->cpf;
        //$users = DB::table('user')->where('cpf','LIKE', '%'. $input .'%');
        if($users = Usuario::find($input)){
        return view('fiscal.resultado', compact('users'));
    }
        return redirect('fiscal')->with('message','fail');

    }
    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create($id)
    {
        if($existe = DB::table('user')
                        ->join('supervisor', 'user.id', '=', 'supervisor.id_user')
                        ->select('user.*')
                        ->where('user.cpf','=',$id)
                        ->where('supervisor.status','=', 1)
                        ->get()

            ){
            
            return redirect('fiscal')->with('message','primarysupervisor');
        }

        if($existence = DB::table('user')
                        ->join('supervisor', 'user.id', '=', 'supervisor.id_user')
                        ->select('user.*')
                        ->where('user.cpf','=', $id)
                        ->where('supervisor.status','=', 0)
                        ->get()

            ){
            $supervisors = DB::table('user')
                        ->join('supervisor', 'user.id', '=', 'supervisor.id_user')
                        ->select('supervisor.*')
                        ->where('user.cpf','=',$id)
                        ->get();

                        //return $supervisors;
            return view('fiscal.reativar',compact('supervisors'));
            //return redirect('fiscal')->with('message','primaryseller');
        }

        $user = Usuario::find($id);
       // return $user->cpf;
        return view('fiscal.create', compact('user'));

    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(FiscalRequest $request)
    {
        $input = $request->all();
         DB::table('supervisor')->insert(
        ['id_user' => $request->id_user,'name' => $request->name, 'rg' => $request->rg, 'status' => 1]
    );

        return  redirect('fiscal');
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
         $users = DB::table('supervisor')
                ->where('id','=',$id)
                ->select('supervisor.*')
                ->get();
         //return $user;

        return view('fiscal.edit', compact('users'));

    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(FiscalRequest $request, $id)
    {
        $user = Supervisor::find($id);
       $user->fill($request->all());
       $user->save();

      return redirect('fiscal')->with('message','fiscaledited');
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
       

        DB::table('supervisor')
        ->where('id', $id)
        ->update(['status'=> 0]);

        return redirect('fiscal')->with('message','destroy');
    }
}
