@extends('layouts.principal')

@section('content')

<?php $message=Session::get('message')?>

@if($message=='update')
<div class="alert alert-success alert-dismissible" role="alert">
  <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
  Vendedor cadastrado com sucesso
</div>

@endif

<legend>Usuário</legend>

  <table class="table">
    <thead>
      <th>ID</th>
      <th>CPF</th>
      <th>Apelido</th>
      <th>Email</th>
      <th>Saldo(R$)</th>
    </thead>
   
    <tbody>
        <td>{!!$users->id!!}</td>
        <td>{!!$users->cpf!!}</td>
        <td>{!!$users->nickname!!}</td>
        <td>{!!$users->email!!}</td>
        <td>{!!$users->saldo!!}</td>
        <td>{!!Link_to("fiscal/$users->cpf/create", $title='Cadastrar',['class'=>'btn btn-primary'])!!}</td>

        
        
    </tbody>
   

 </table>



@stop