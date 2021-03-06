@extends('layouts.principal')

@section('content')

<?php $message=Session::get('message')?>


{!!Form::open(['url'=>'vagas/show', 'class'=>'searchform'])!!}
<legend>Relatório de consumo de vagas</legend>
<fieldset>
<div class="form-group col-md-2">
  {!!Form::label('Ano')!!}
  
  {!!Form::selectRange('ano',2015, 2011)!!}
  
</div>

<div class="form-group col-md-2">
  {!!Form::label('Mês')!!}
  
  {!!Form::select('mes', array(
    '-%-' => 'Todos',
    '-1-' => 'Janeiro',
    '-2-' => 'Fevereiro',
    '-3-' => 'Março',
    '-4-' => 'Abril',
    '-5-' => 'Maio',
    '-6-' => 'Junho',
    '-7-' => 'Julho',
    '-8-' => 'Agosto',
    '-9-' => 'Setembro',
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
    '1 ' => '01',
    '2 ' => '02',
    '3 ' => '03',
    '4 ' => '04',
    '5 ' => '05',
    '6 ' => '06',
    '7 ' => '07',
    '8 ' => '08',
    '9 ' => '09',
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