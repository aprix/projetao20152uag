@extends('layouts.principal')

@section('content')

@if ($errors->any())
<ul class="alert alert-warning">
@foreach($errors->all() as $error)
<li>{{ $error }}</li>
@endforeach
</ul>
@endif

@foreach($users as $user)

 {!!Form::open(['url'=>"fiscal/$user->id_user/update", 'method'=>'put'])!!}

<fieldset>

<!-- Form Name -->
<legend>Editar Fiscal</legend>

<!-- Text input-->
<div class="form-group col-md-2">
    {!!Form::label('ID de usuário')!!}  
  
   {!!Form::text('id_user', $user->id_user, ['class'=>'form-control', 'placeholder'=>'', 'required'=>'','readonly'])!!}   
 
</div>

<!-- Text input-->
<div class="form-group col-md-5">
  {!!Form::label('Nome')!!}
 
    {!!Form::text('name',$user->name, ['class'=>'form-control', 'placeholder'=>'', 'required'=>''])!!}
  
</div>

<div class="form-group col-md-3">
  {!!Form::label('RG')!!}  
  
  {!!Form::text('rg',  $user->rg, ['class'=>'form-control', 'placeholder'=>'', 'required'=>''])!!}    
  
</div>

@endforeach

<!-- Button (Double) -->
<div class="form-group col-md-10">
   {!!Form::submit('&nbsp;&nbsp;&nbsp;Salvar&nbsp;&nbsp;&nbsp;', ['class'=>'btn btn-primary'])!!}
   {!!Link_to('fiscal', $title='Cancelar',['class'=>'btn btn-danger'])!!}
</div>

</fieldset>

{!!Form::close()!!}


@stop