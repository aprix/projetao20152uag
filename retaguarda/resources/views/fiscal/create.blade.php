@extends('layouts.principal')

@section('content')

@if ($errors->any())
<ul class="alert alert-warning">
@foreach($errors->all() as $error)
<li>{{ $error }}</li>
@endforeach
</ul>
@endif


  {!!Form::open(['url'=>'fiscal/store'])!!}

<fieldset>

<!-- Form Name -->
<legend>Cadastrar fiscal</legend>

<!-- Text input-->
<div class="form-group col-md-2">
    {!!Form::label('ID de usuário')!!}  
  
   {!!Form::text('id_user', $user->id, ['class'=>'form-control', 'placeholder'=>'', 'required'=>'','readonly'])!!}   
 
</div>

<!-- Text input-->
<div class="form-group col-md-5">
  {!!Form::label('Nome')!!}
 
    {!!Form::text('name',null, ['class'=>'form-control', 'placeholder'=>'', 'required'=>''])!!}
  
</div>

<div class="form-group col-md-3">
  {!!Form::label('RG')!!}  
  
  {!!Form::text('rg',  null, ['class'=>'form-control', 'placeholder'=>'', 'required'=>''])!!}    
  
</div>


<!-- Button (Double) -->
<div class="form-group col-md-10">
   {!!Form::submit('&nbsp;&nbsp;&nbsp;&nbsp;Salvar&nbsp;&nbsp;&nbsp;&nbsp;', ['class'=>'btn btn-primary'])!!}
   {!!Link_to('fiscal', $title='Cancelar',['class'=>'btn btn-danger'])!!}
</div>

</fieldset>

{!!Form::close()!!}


@stop