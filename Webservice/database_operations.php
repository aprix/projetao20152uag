<?php

function select1($plate){
	return "SELECT vacancy_location.id from vacancy_location

		inner join vehicle on vacancy_location.id_vehicle = vehicle.id and vehicle.plate = '"+$plate+"'

		where CURRENT_TIMESTAMP < (vacancy_location.date_location + INTERVAL vacancy_location.time_location MINUTE) ";
}

function insert1($plate, $time){
	return "INSERT INTO vehicle (plate, id_user, status) VALUES ("+$plate+", 0, 1);
	
		INSERT INTO vacancy_location (id_user, id_vehicle, date_location, time_location, total_payment)
				      VALUES (0, SELECT vehicle.id from vehicle where id_user = 0 and plate = "+$plate+"
					     , CURRENT_TIMESTAMP, "+$time+", SELECT prices.un_price * "+$time+" from prices);"
}

?>
