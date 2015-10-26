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

function insert_user($cpf, $password, $email, $nick){
	return "INSERT INTO user(cpf, saldo, senha, email, nickname)
		VALUES ('$cpf', 0.0, '$password', '$email', '$nick');";
}

function update_user($id, $cpf, $password, $email, $nick){
	return "UPDATE user SET
		cpf = '$cpf',
		senha = '$password',
		email = '$email',
		nickname = '$nick'

		WHERE user.id = $id;";
}

function insert_credit_card($id_user, $name, $number, $flag, $month, $year, $status){
	return "INSERT INTO credit_card(id_user, name, num, flag, validate_month, validate_year, status)
		VALUES ($id_user, '$name', '$number', '$flag', $month, $year, $status);";
}

function update_credit_card($id, $id_user, $name, $number, $flag, $month, $year, $status){
	return "UPDATE credit_card SET
		id_user = $id_user,
		name = '$name',
		num = '$number',
		flag = '$flag',
		validate_month = $month,
		validate_year = $year,
		status = $status
		
		WHERE credit_card.id = $id;";
}

function select_credit_card($id_user){
	return "SELECT credit_card.id, credit_card.name, credit_card.num, credit_card.flag, credit_card.validate_month, credit_card.validate_year

		FROM credit_card
		INNER JOIN user ON credit_card.id_user = user.id AND credit_card.id_user = $id_user

		ORDER BY credit_card.id";
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


