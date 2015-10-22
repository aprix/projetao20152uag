<?php

function select_vacancy_location($plate){
	return "SELECT vacancy_location.date_location as initialDate, (vacancy_location.date_location + INTERVAL vacancy_location.time_location MINUTE) as finalDate
		FROM vacancy_location
		INNER JOIN vehicle ON vacancy_location.id_vehicle = vehicle.id AND vehicle.plate = '$plate'
		WHERE correct_timestamp() < (vacancy_location.date_location + INTERVAL vacancy_location.time_location MINUTE)";
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
		, correct_timestamp(), $time, (SELECT prices.un_price * $time from prices) );";
}

function select_vacancy_location_date($plate){
	return "SELECT vacancy_location.date_location as initialDate, (vacancy_location.date_location + INTERVAL vacancy_location.time_location MINUTE) as finalDate
		FROM vacancy_location
		INNER JOIN vehicle ON vacancy_location.id_vehicle = vehicle.id AND vehicle.plate = '$plate'
		LIMIT 10";
}

function insert_user($cpf, $password, $email){
	return "INSERT INTO user(cpf, saldo, senha, email)
		VALUES ($cpf, 0.0, '$password', '$email');";
}

function update_user($id, $cpf, $password, $email){
	return "UPDATE user SET
		cpf = $cpf,
		senha = '$password',
		email = '$email'
		WHERE user.id = $id;";
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


