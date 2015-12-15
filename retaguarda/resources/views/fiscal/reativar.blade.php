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
<legend>Cadastro de Fiscal</legend>

<div>
	<h1>Esse usuário possui cadastro de fiscal desativado.<br>Deseja reativá-lo?</h1>
</div>


 
     
  
   @foreach($supervisors as $supervisor)

   @endforeach
        
      
        
   
   </fieldset>
<!-- Button (Double) -->
<div class="col-md-10">
   {!!Link_to("fiscal/$supervisor->id/reativar", $title='&nbsp;&nbsp;&nbsp;&nbsp;Sim&nbsp;&nbsp;&nbsp;&nbsp;',['class'=>'btn btn-primary'])!!}
   {!!Link_to('fiscal', $title='&nbsp;&nbsp;&nbsp;&nbsp;Não&nbsp;&nbsp;&nbsp;&nbsp;',['class'=>'btn btn-danger'])!!}
</div>

</fieldset>




@stop