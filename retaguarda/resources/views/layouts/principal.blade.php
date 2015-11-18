
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="icon" href="../../favicon.ico">

    <title>AzulFacil</title>

    <!-- Latest compiled and minified CSS -->
   {!!Html::style('https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css')!!}
    {!!Html::style('assets/css/sticky-footer-navbar.css')!!}
    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>

      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>

    <![endif]-->
  </head>

  <body>

    <nav role="navigation" class="navbar navbar-default">

        <div class="navbar-header">
            <button type="button" data-target="#navbarCollapse" data-toggle="collapse" class="navbar-toggle"> 

                <span class="sr-only">Navegação Responsiva</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>

            </button>

             <!--<a href="painel"layout class="navbar-brand">AzulFácil</a>-->
             {!!Link_to('painel', $title='AzulFácil', ['class'=>'navbar-brand'])!!}

      </div>
       
       <div id="navbarCollapse" class="collapse navbar-collapse">

            <ul class="nav navbar-nav">
                <li>{!!Link_to_route('vendedor.index', $title='Cadastrar vendedor')!!}</li>
                <li>{!!Link_to_route('fiscal.index', $title='Cadastrar fiscal')!!}</li>
                <li>{!!Link_to_route('tabela.index', $title='Tabela de preços')!!}</li>
                <li><a href="#">Perfil</a></li>
            </ul>

       </div>

    </nav>

 

       <div class="container-fluid">
          
          <?php $message=Session::get('message')?>

            @if($message=='store')
              <div class="alert alert-success alert-dismissible" role="alert">
              <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
              Vendedor cadastrado com sucesso!
              </div>
             @endif 

             @if($message=='destroy')
              <div class="alert alert-success alert-dismissible" role="alert">
              <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
              Vendedor excluído com sucesso!
              </div>
             @endif 

             @if($message=='destroysupervisor')
              <div class="alert alert-success alert-dismissible" role="alert">
              <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
              Fiscal excluído com sucesso!
              </div>
             @endif 

             @if($message=='fail')
              <div class="alert alert-warning alert-dismissible" role="alert">
              <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
              A busca não retornou resultados!
              </div>
             @endif 

              @if($message=='primaryseller')
              <div class="alert alert-warning alert-dismissible" role="alert">
              <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
              Vendedor já cadastrado!
              </div>
             @endif 

              @if($message=='primarysupervisor')
              <div class="alert alert-warning alert-dismissible" role="alert">
              <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
              Fiscal já cadastrado!
              </div>
             @endif

             @if($message=='sellerreativar')
              <div class="alert alert-success alert-dismissible" role="alert">
              <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
              Cadastro de vendedor reativado com sucesso!
              </div>
             @endif 

              @if($message=='fiscalreativar')
              <div class="alert alert-success alert-dismissible" role="alert">
              <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
              Cadastro de fiscal reativado com sucesso!
              </div>
             @endif 


            

            @yield('content')
           
        </div>

        <footer class="footer">
      <div class="container">
        <p class="text-muted">Desenvolvido por:</p>
      </div>
    </footer>



    <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
  
    {!!Html::script('https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js')!!}
    {!!Html::script('https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js')!!}  

  </body>
</html>
