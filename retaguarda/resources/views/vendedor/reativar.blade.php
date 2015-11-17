@extends('layouts.principal')

@section('content')

@if ($errors->any())
<ul class="alert alert-warning">
@foreach($errors->all() as $error)
<li>{{ $error }}</li>
@endforeach
</ul>
@endif


  

<fieldset>

<!-- Form Name -->
<legend>Cadastro de vendedor</legend>

<div>
	<h1>Esse usuário possui cadastro de vendedor desativado.<br>Deseja reativá-lo?</h1>
</div>
<!-- Button (Double) -->
<div class="col-md-10">
   {!!Link_to("vendedor/$sellers->id/reativar", $title='&nbsp;&nbsp;&nbsp;&nbsp;Sim&nbsp;&nbsp;&nbsp;&nbsp;',['class'=>'btn btn-primary'])!!}
   {!!Link_to('vendedor', $title='&nbsp;&nbsp;&nbsp;&nbsp;Não&nbsp;&nbsp;&nbsp;&nbsp;',['class'=>'btn btn-danger'])!!}
</div>

</fieldset>




@stop