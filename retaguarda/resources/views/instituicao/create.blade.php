@extends('layouts.administrador')

@section('content')

@if ($errors->any())
<ul class="alert alert-warning">
@foreach($errors->all() as $error)
<li>{{ $error }}</li>
@endforeach
</ul>
@endif


  {!!Form::open(['url'=>'instituicao/store'])!!}

<fieldset>

<!-- Form Name -->
<legend>Cadastrar Instituição</legend>

<!-- Text input-->
<div class="form-group col-md-2">
    {!!Form::label('CNPJ')!!}  
  
   {!!Form::text('cnpj', null, ['class'=>'form-control', 'placeholder'=>'', 'required'=>''])!!}   
 
</div>

<!-- Text input-->
<div class="form-group col-md-5">
  {!!Form::label('Nome')!!}
  
    {!!Form::text('name', null, ['class'=>'form-control', 'placeholder'=>'', 'required'=>''])!!}

</div>

<!-- Text input-->
<div class="form-group col-md-5">
  {!!Form::label('Razão Social')!!}
 
    {!!Form::text('razao_social', null, ['class'=>'form-control', 'placeholder'=>'', 'required'=>''])!!}
  
</div>

<!-- Text input-->
<div class="form-group col-md-2">
  {!!Form::label('Inscrição Estadual')!!}
  
  {!!Form::text('state_registration', null, ['class'=>'form-control', 'placeholder'=>''])!!}

</div>

<!-- Text input-->
<div class="form-group col-md-6">
  {!!Form::label('Endereço')!!}  
 
  {!!Form::text('adress', null, ['class'=>'form-control', 'placeholder'=>'', 'required'=>''])!!}    
  
</div>

<!-- Text input-->
<div class="form-group col-md-1">
  {!!Form::label('Número')!!}  
  
  {!!Form::text('adress_num', null, ['class'=>'form-control', 'placeholder'=>'', 'required'=>''])!!}        
 
</div>

<!-- Text input-->
<div class="form-group col-md-2">
  {!!Form::label('Bairro')!!}   
  
  {!!Form::text('adress_neighborhood', null, ['class'=>'form-control', 'placeholder'=>'', 'required'=>''])!!}        
    
  
</div>

<!-- Text input-->
<div class="form-group col-md-2">
  {!!Form::label('Cidade')!!} 
  
  {!!Form::text('city', null, ['class'=>'form-control', 'placeholder'=>'', 'required'=>''])!!}        
    
  
</div>

<!-- Text input-->
<div class="form-group col-md-2">
  {!!Form::label('Estado')!!} 
  
  {!!Form::text('state', null, ['class'=>'form-control', 'placeholder'=>'', 'required'=>''])!!}        
    
  
</div>

<!-- Text input-->
<div class="form-group col-md-2">
  {!!Form::label('CEP')!!} 
 
  {!!Form::text('cep', null, ['class'=>'form-control', 'placeholder'=>'', 'required'=>''])!!}        
    
 
</div>

<!-- Button (Double) -->
<div class="form-group col-md-10">
   {!!Form::submit('cadastrar', ['class'=>'btn btn-primary'])!!}
</div>

</fieldset>

{!!Form::close()!!}


@stop