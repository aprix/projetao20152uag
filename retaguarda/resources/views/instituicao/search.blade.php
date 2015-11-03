@extends('layouts.administrador')

@section('content')

@if ($errors->any())
<ul class="alert alert-warning">
@foreach($errors->all() as $error)
<li>{{ $error }}</li>
@endforeach
</ul>
@endif


  {!!Form::open()!!}

<fieldset>

<!-- Form Name -->
<legend>Procurar Instituição</legend>

<div class="form-group col-md-2">

    {!!Form::label('CNPJ')!!}  
  
   {!!Form::text('cnpj', null,['class'=>'form-control', 'placeholder'=>'', 'required'=>''])!!}   
 
</div class="form-group col-md-4">

{!!Link_to_route('tabela.edit', $title='Editar', $parameters='12345678901234', $attributes= ['class'=>'btn btn-primary'])!!}
 
</div>


</fieldset>

{!!Form::close()!!}


@stop