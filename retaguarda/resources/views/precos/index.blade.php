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

{!!Link_to_route('tabela.create', $title='Cadastrar nova tabela de preços',$parameters='', $attributes=['class'=>'btn btn-primary'])!!}
<br><br>

  <table class="table">
    <thead>
      <th>Tempo mínimo(min)</th>
      <th>Tempo unitário(min)</th>
      <th>Preço unitário(R$)</th>
      <th>Desconto p/ vendedor(%)</th>
      <th>Tempo máximo(min)</th>
    </thead>
    
    <tbody>
        <td>{!!$price->min_time!!}</td>
        <td>{!!$price->un_time!!}</td>
        <td>{!!$price->un_price!!}</td>
        <td>{!!$price->discount_sellers!!}</td>
        <td>{!!$price->max_price!!}</td>
        <td>{!!Link_to_route('tabela.edit', $title='Editar', $parameters=$price->id, $attributes= ['class'=>'btn btn-primary'])!!}</td>
    </tbody>
    @foreach($precos as $preco)
    <tbody>
        <td>{!!$preco->min_time!!}</td>
        <td>{!!$preco->un_time!!}</td>
        <td>{!!$preco->un_price!!}</td>
        <td>{!!$preco->discount_sellers!!}</td>
        <td>{!!$preco->max_price!!}</td>
        <td>{!!Link_to_route('tabela.edit', $title='Editar', $parameters=$preco->id, $attributes= ['class'=>'btn btn-primary'])!!}</td>
      <td>{!!Link_to("tabela/$preco->id/destroy", $title='Remover',['class'=>'btn btn-danger'])!!}</td>    
    </tbody>
    @endforeach

 </table>





@stop