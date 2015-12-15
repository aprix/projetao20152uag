@extends('layouts.principal')

@section('content')

<?php $message=Session::get('message')?>


{!!Form::open(['url'=>'pagamentos/show', 'class'=>'searchform'])!!}
<legend>Relatório de pagamentos</legend>
<fieldset>
<div class="form-group col-md-2">
  {!!Form::label('Ano')!!}
  
  {!!Form::selectRange('ano',2015, 2011)!!}
  
</div>

<div class="form-group col-md-2">
  {!!Form::label('Mês')!!}
  
  {!!Form::select('mes', array(
    '-%-' => 'Todos',
    '-01-' => 'Janeiro',
    '-02-' => 'Fevereiro',
    '-03-' => 'Março',
    '-04-' => 'Abril',
    '-05-' => 'Maio',
    '-06-' => 'Junho',
    '-07-' => 'Julho',
    '-08-' => 'Agosto',
    '-09-' => 'Setembro',
    '-10-' => 'Outubro',
    '-11-' => 'Novembro',
    '-12-' => 'Dezembro',
))!!}

  <!--{!!Form::selectRange('mes', 1,12)!!}-->
  
</div>

<div class="form-group col-md-2">
  {!!Form::label('Dia')!!}
  
  {!!Form::select('dia', array(
    '% ' => 'Todos',
    '01 ' => '01',
    '02 ' => '02',
    '03 ' => '03',
    '04 ' => '04',
    '05 ' => '05',
    '06 ' => '06',
    '07 ' => '07',
    '08 ' => '08',
    '09 ' => '09',
    '10 ' => '10',
    '11 '  => '11',
    '12 ' => '12',
    '13 '  => '13',
    '14 ' => '14' ,
    '15 '  => '15',
    '16 '  => '16',
    '17 '  => '17',
    '18 '  => '18',
    '19 '  => '19',
    '20 '  => '20',
    '21 '  => '21',
    '22 '  => '22',
    '23 ' => '23' ,
    '24 '  => '24',
    '25 '  => '25',
    '26 '  => '26',
    '27 '  => '27',
    '28 ' => '28',
    '29 '  => '29',
    '30 '  => '30',
    '31 '  => '31',

))!!}
  
  
</div>
<!--<div class="form-group col-md-3">
  {!!Form::label('Resultados por página')!!}
  {!!Form::selectRange('paginas',4, 15)!!}
</div>-->
<div class="form-group col-md-2">


{!!Form::submit('Buscar', ['class'=>'btn btn-primary'])!!}
</div>
</fieldset>
 {!!Form::close()!!} 




@stop