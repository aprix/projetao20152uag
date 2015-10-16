<?php

function select_vacancy_location($plate){
	return "SELECT vacancy_location.id from vacancy_location
		inner join vehicle on vacancy_location.id_vehicle = vehicle.id and vehicle.plate = '$plate'
		where CURRENT_TIMESTAMP < (vacancy_location.date_location + INTERVAL vacancy_location.time_location MINUTE) ";
}

function select_vehicle($plate, $id_user){
	return "SELECT vehicle.id 
		FROM vehicle 
		WHERE vehicle.plate = '$plate' AND vehicle.id_user = $id_user";
}

function insert_vehicle($plate){
	return "INSERT INTO vehicle (plate, id_user, status) 
		VALUES ('$plate', 1, 1);";
}

function insert_vacancy_location($plate, $time){
	return "INSERT INTO vacancy_location (id_user, id_vehicle, date_location, time_location, total_payment)
		VALUES (1, (SELECT vehicle.id from vehicle where id_user = 1 and plate = '$plate')
		, CURRENT_TIMESTAMP, $time, (SELECT prices.un_price * $time from prices) );";
}

function select_vacancy_location_date($plate){
	return "SELECT vacancy_location.date_location as initialDate, (vacancy_location.date_location + INTERVAL vacancy_location.time_location MINUTE) as finalDate
		FROM vacancy_location
		INNER JOIN vehicle ON vacancy_location.id_vehicle = vehicle.id AND vehicle.plate = '$plate'
		LIMIT 10";
}

/**
 * método que simula o pagamento utilizando cartão de crédito
 * @param type $name
 * @param type $creditCardFlag
 * @param type $creditCardNumber
 * @param type $creditCardDate
 * @param type $creditCardCSC
 * @return string
 */
function payment($name, $creditCardFlag, $creditCardNumber, $creditCardDate, $creditCardCSC){
    return "Sucess!";
}


