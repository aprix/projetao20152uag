@extends('layouts.principal')

@section('content')



	<div class= "cadastro-vendedor">
		<div class"formularios">
			<form class="form-horizontal">
		<fieldset>

		<!-- Form Name -->
		<legend>Cadastro de Vendedor</legend>

		<!-- Text input-->
		<div class="form-group">
 			 <label class="col-md-4 control-label" for="cpf">CPF/CNPJ</label>  
  			 <div class="col-md-4">
  			 <input id="cpf" name="cpf" type="text" placeholder="Digite o CPF ou CNPJ" class="form-control input-md" required="">
    
 		 	</div>
		</div>

<!-- Text input-->
<div class="form-group">
  <label class="col-md-4 control-label" for="nome">Nome</label>  
  <div class="col-md-4">
  <input id="nome" name="nome" type="text" placeholder="Digite o nome" class="form-control input-md" required="">
    
  </div>
</div>

<!-- Button -->
<div class="form-group">
  <label class="col-md-4 control-label" for="cadastrar"></label>
  <div class="col-md-4">
    <button id="cadastrar" name="cadastrar" class="btn btn-primary">Cadastrar</button>
  </div>
</div>

</fieldset>
</form>

	
			

	</div>
</div>


@stop