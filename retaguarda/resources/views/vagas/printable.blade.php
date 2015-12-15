
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

    <title>&nbsp;</title>

    <!-- Latest compiled and minified CSS -->
   {!!Html::style('https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css')!!}
    {!!Html::style('assets/css/printable.css')!!}
   

    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>

      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>

    <![endif]-->
  </head>
<body>

  <div class="container">
   
    <h2 align="center"><img src="../assets/img/logo.jpg" width="100" height="60"></h2>
    <h5 align="center">RELATÓRIO DE CONSUMO DE VAGAS</h5>
    <br>
 <table class="table">
  <thead>
        <th>Total de vagas consumidas no período:</th>
        <th>Total arrecadado no período:</th>
      </thead> 
      <tbody>
        <td>{!!$total!!}</td>
        <td>{!!"R$ ".$pagamento!!}</td>
      </tbody>
</table>


 <table class="table table-bordered" cellspacing="2" cellpadding="6" border="1">
  
    <thead>
      <th>Id</th>
      
      <th>Placa do veículo</th>
      <th>Data e Hora</th>
      <th>Tempo alocado</th>
      <th>Pagamento total</th>
    </thead>
    @foreach($users as $user)
    <tbody >
        <td>{!!$user->id!!}</td>
        <td>{!!$user->plate!!}</td>
        <td>{!! substr($user->date_location,8,2)."/".substr($user->date_location,5,2)."/".substr($user->date_location,0,4)." - ".substr($user->date_location,10,9)!!}</td>
        <td>{!!$user->time_location!!}</td>
        <td>{!!"R$ ".$user->total_payment!!}</td>
        
    </tbody>
    @endforeach
     

 </table>







</div>

    {!!Html::script('https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js')!!}
    {!!Html::script('https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js')!!}  

  </body>
</html>
