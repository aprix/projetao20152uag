@extends('layouts.principal')

@section('content')

@if ($errors->any())
<ul class="alert alert-warning">
@foreach($errors->all() as $error)
<li>{{ $error }}</li>
@endforeach
</ul>
@endif


  {!!Form::open(['url'=>'fiscal/search', 'class'=>'searchform'])!!}

<fieldset>

<!-- Form Name -->
<legend>Procurar Usuário</legend>

<div class="form-group col-md-2">  
  
   {!!Form::text('cpf', null,['class'=>'form-control', 'placeholder'=>'Digite o CPF', 'required'=>''])!!}
 </div>   
 
<div class="form-group col-md-2">

{!!Form::submit('Buscar', ['class'=>'btn btn-primary'])!!}
 
</div>

<div>
</fieldset>

{!!Form::close()!!}

<fieldset>
<legend>Fiscais Cadastrados</legend>

  <table class="table">
    <thead>
      <th>ID de fiscal</th>
      <th>Nome</th>
      <th>RG</th>
     
    </thead>
   @foreach($users as $user)
    <tbody>
        <td>{!!$user->id!!}</td>
        <td>{!!$user->name!!}</td>
        <td>{!!$user->rg!!}</td>
        <td>{!!Link_to("fiscal/$user->id/destroy", $title='Remover',['class'=>'btn btn-danger'])!!}</td>

   @endforeach
        
      
        
    </tbody>
   </fieldset>
</div>
@stop