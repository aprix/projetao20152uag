
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

             {!!Link_to('/', $title='AzulFácil', ['class'=>'navbar-brand'])!!}
      </div>
       
       <div id="navbarCollapse" class="collapse navbar-collapse navbar-form navbar-right">
          {!!Form::open(['url'=>'login/try'])!!}
          
                <div class="form-group">
               {!!Form::text('login', null, ['class'=>'form-control', 'placeholder'=>'Login', 'required'=>''])!!}        
               </div>
                <div class="form-group">
              {!!Form::password('password', ['class'=>'form-control', 'placeholder'=>'Senha', 'required'=>''])!!}        
               </div>
               <div class="form-group">
              {!!Form::submit('Entrar', ['class'=>'btn btn-success'])!!}
                </div>
   {!!Form::close()!!}
       </div>


    </nav>

       <div class="container-fluid">

           <?php $message=Session::get('message')?>

            @if($message=='loginfail')
              <div class="alert alert-warning alert-dismissible" role="alert">
              <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
              Usuário ou senha, incorretos!
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
