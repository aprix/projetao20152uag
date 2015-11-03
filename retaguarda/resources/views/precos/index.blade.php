@extends('layouts.principal')

@section('content')

<?php $message=Session::get('message')?>

@if($message=='update')
<div class="alert alert-success alert-dismissible" role="alert">
  <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
  Tabela de preços editada com sucesso
</div>

@endif

<legend>Tabela de Preços</legend>

  <table class="table">
    <thead>
      <th>Tempo mínimo</th>
      <th>Tempo unitário</th>
      <th>Preço unitário</th>
      <th>Desconto p/ vendedores</th>
      <th>Max Price</th>
    </thead>
    @foreach($prices as $price)
    <tbody>
        <td>{!!$price->min_time!!}</td>
        <td>{!!$price->un_time!!}</td>
        <td>{!!$price->un_price!!}</td>
        <td>{!!$price->discount_sellers!!}</td>
        <td>{!!$price->max_price!!}</td>
        <td>{!!Link_to_route('tabela.edit', $title='Editar', $parameters=$price->id, $attributes= ['class'=>'btn btn-primary'])!!}</td>
    </tbody>
    @endforeach

 </table>



@stop