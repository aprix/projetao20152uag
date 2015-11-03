@extends('layouts.principal')

@section('content')

@if ($errors->any())
<ul class="alert alert-warning">
@foreach($errors->all() as $error)
<li>{{ $error }}</li>
@endforeach
</ul>
@endif


  {!!Form::open(['url'=>'tabela/store'])!!}

<fieldset>

<!-- Form Name -->
<legend>Tabela de preços</legend>

<!-- Text input-->
<div class="form-group col-md-2">
    {!!Form::label('Tempo mínimo')!!}  
  
   {!!Form::text('min_time', null, ['class'=>'form-control', 'placeholder'=>'', 'required'=>''])!!}   
 
</div>

<!-- Text input-->
<div class="form-group col-md-5">
  {!!Form::label('Preço unitário')!!}
 
    {!!Form::text('un_price', null, ['class'=>'form-control', 'placeholder'=>'', 'required'=>''])!!}
  
</div>

<div class="form-group col-md-3">
  {!!Form::label('Tempo unitário')!!}  
  
  {!!Form::text('un_time', null, ['class'=>'form-control', 'placeholder'=>'', 'required'=>''])!!}    
  
</div>


<!-- Text input-->
<div class="form-group col-md-2">
  {!!Form::label('Desconto p/ vendedores')!!}
  
  {!!Form::selectRange('discount_sellers', 0, 100)!!}
  
</div>

<!-- Text input-->
<div class="form-group col-md-3">
  {!!Form::label('max_price')!!}  
  
  {!!Form::text('max_price', null, ['class'=>'form-control', 'placeholder'=>'', 'required'=>''])!!}    
  
</div>



<!-- Button (Double) -->
<div class="form-group col-md-10">
   {!!Form::submit('cadastrar', ['class'=>'btn btn-primary'])!!}
</div>

</fieldset>

{!!Form::close()!!}


@stop