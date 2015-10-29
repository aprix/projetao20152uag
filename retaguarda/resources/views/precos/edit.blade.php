@extends('layouts.principal')

@section('content')

@if ($errors->any())
<ul class="alert alert-warning">
@foreach($errors->all() as $error)
<li>{{ $error }}</li>
@endforeach
</ul>
@endif


  {!!Form::open(['url'=>"tabela/$price->id/update", 'method'=>'put'])!!}

<fieldset>

<!-- Form Name -->
<legend>Tabela de preços</legend>

<!-- Text input-->
<div class="form-group col-md-2">
    {!!Form::label('Tempo mínimo')!!}  
  
   {!!Form::text('min_time', $price->min_time, ['class'=>'form-control', 'placeholder'=>'', 'required'=>''])!!}   
 
</div>

<!-- Text input-->
<div class="form-group col-md-5">
  {!!Form::label('Preço unitário')!!}
 
    {!!Form::text('un_price', $price->un_price, ['class'=>'form-control', 'placeholder'=>'', 'required'=>''])!!}
  
</div>

<div class="form-group col-md-3">
  {!!Form::label('Tempo unitário')!!}  
  
  {!!Form::text('un_time',  $price->un_time, ['class'=>'form-control', 'placeholder'=>'', 'required'=>''])!!}    
  
</div>


<!-- Text input-->
<div class="form-group col-md-2">
  {!!Form::label('Desconto p/ vendedores')!!}
  
  {!!Form::selectRange('discount_sellers', 0, 100, $price->discount_sellers)!!}
  
</div>

<!-- Text input-->
<div class="form-group col-md-3">
  {!!Form::label('max_price')!!}  
  
  {!!Form::text('max_price',  $price->max_price, ['class'=>'form-control', 'placeholder'=>'', 'required'=>''])!!}    
  
</div>



<!-- Button (Double) -->
<div class="form-group col-md-10">
   {!!Form::submit('Salvar', ['class'=>'btn btn-primary'])!!}
</div>

</fieldset>

{!!Form::close()!!}


@stop