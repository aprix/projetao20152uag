<?php

namespace Retaguarda\Http\Controllers;

use Illuminate\Http\Request;
use Retaguarda\Http\Requests;
use Retaguarda\Http\Controllers\Controller;
use Retaguarda\Http\Requests\SearchRequest;
use Retaguarda\Usuario;
use Retaguarda\Seller;
use DB;


class SellerController extends Controller
{

     public function __construct(){
        $this->middleware('auth');
    }
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
       $users = DB::table('user')
            ->join('seller', 'user.id', '=', 'seller.id_user')
            ->select('user.*', 'seller.id')
             ->where('seller.status', '=','1')
            ->get();

        return view('vendedor.index', compact('users'));
        
         }


    public function search(SearchRequest $request){
        $input = $request->cpf;
        //$users = DB::table('user')->where('cpf','LIKE', '%'. $input .'%');
        if($users = Usuario::find($input)){
        return view('vendedor/resultado', compact('users'));
    }
        return redirect('vendedor')->with('message','fail');

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
        $input = $request->id;
        
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

    public function reativar($id)
    {
         DB::table('seller')
        ->where('id', $id)
        ->update(['status'=> 1]);

        return redirect('vendedor')->with('message','sellerreativar');
    }
    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        if($encontrei = DB::table('seller')
                        ->select('id_user')
                        ->where('id_user','=',$id)
                        ->where('status','=', 1)
                        ->get()

            ){
            
            return redirect('vendedor')->with('message','primaryseller');
        }

        if($encontrei = DB::table('seller')
                        ->select('id_user')
                        ->where('id_user','=',$id)
                        ->where('status','=', 0)
                        ->get()

            ){
            $sellers = Seller::find($id);
           // return $sellers->id_user;
            return view('vendedor.reativar',compact('sellers'));
        }


        DB::table('seller')->insert(
        ['id_user' => $id, 'status' => 1]
    );
        return redirect('vendedor')->with('message','store');
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
         DB::table('seller')
        ->where('id', $id)
        ->update(['status'=> 0]);

        return redirect('vendedor')->with('message','destroy');
    
    }
}
