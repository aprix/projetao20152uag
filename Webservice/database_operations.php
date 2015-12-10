<?php

function select_vacancy_location($plate){
	return "SELECT vacancy_location.date_location as initialDate, 
		(vacancy_location.date_location + INTERVAL vacancy_location.time_location MINUTE) as finalDate
		FROM vacancy_location
		INNER JOIN vehicle ON vacancy_location.id_vehicle = vehicle.id AND vehicle.plate = '$plate'
		WHERE correct_timestamp() < (vacancy_location.date_location + INTERVAL vacancy_location.time_location MINUTE)";
}

function select_vehicle($plate, $id_user){
	return "SELECT vehicle.id 
		FROM vehicle 
		WHERE vehicle.plate = '$plate' AND vehicle.id_user = $id_user AND vehicle.status = 1";
}

function insert_vehicle($id_user, $plate){
	return "INSERT INTO vehicle (plate, id_user, status) 
		VALUES ('$plate', $id_user, 1);";
}

function insert_vacancy_location($id_user, $plate, $time, $value){
	return "INSERT INTO vacancy_location (id_user, id_vehicle, date_location, time_location, total_payment)
		VALUES ($id_user, (SELECT vehicle.id from vehicle where id_user = $id_user and plate = '$plate')
		, correct_timestamp(), $time, $value );";
}

function select_vacancy_location_user($id_user){
	return "SELECT vacancy_location.date_location
		, vacancy_location.time_location
		, vehicle.plate
			
		FROM vacancy_location
		INNER JOIN vehicle ON vacancy_location.id_vehicle = vehicle.id AND vehicle.status = 1
		WHERE vacancy_location.id_user = $id_user
		ORDER BY vacancy_location.date_location DESC
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

function select_credit_card_for_user($id_user){
	return "SELECT credit_card.id, credit_card.name, credit_card.num, credit_card.flag, credit_card.validate_month, credit_card.validate_year

		FROM credit_card
		INNER JOIN user ON credit_card.id_user = user.id AND credit_card.id_user = $id_user
		WHERE credit_card.status = 1
		ORDER BY credit_card.id";
}

function select_credit_card($id_user, $id_credit_card){
	return "SELECT credit_card.name, credit_card.num
		, credit_card.flag, credit_card.validate_month, credit_card.validate_year

		FROM credit_card
		WHERE credit_card.id_user = $id_user 
		AND credit_card.id = $id_credit_card 
		AND credit_card.status = 1";
}

function select_user($cpf, $password){
	return "SELECT user.id, user.nickname, user.email
			FROM user
			WHERE user.cpf = '$cpf' AND user.senha = '$password'";
}

function insert_payment($id_user, $id_credit_card, $value, $status){
	return "INSERT INTO payment(id_user, id_credit_card, val, date_payment, status)
			VALUES ($id_user, $id_credit_card, $value, correct_timestamp(), $status)";
}

function update_user_saldo($id_user, $value){
	return "UPDATE user
			SET saldo = saldo + $value
			WHERE user.id = $id_user";
}

function select_user_saldo($id_user){
	return "SELECT user.saldo
			FROM user
			WHERE user.id = $id_user";
}

function select_un_price(){
	return "SELECT prices.un_price, prices.max_price as max_time
			FROM prices";
}

function select_vacancy_location_time($plate){
	return "SELECT vacancy_location.id, vacancy_location.time_location
		FROM vacancy_location
		INNER JOIN vehicle ON vacancy_location.id_vehicle = vehicle.id AND vehicle.plate = '$plate'
		WHERE correct_timestamp() < (vacancy_location.date_location + INTERVAL vacancy_location.time_location MINUTE)";
}

function update_vacancy_location_time($id_vl, $time, $value){
	return "UPDATE vacancy_location SET
			date_location = date_location,
			time_location = time_location + $time,
			total_payment = total_payment + $value
			WHERE vacancy_location.id = $id_vl";
}

function select_table_prices($id_user){
	return "SELECT prices.un_price, prices.un_time, prices.min_time, prices.max_price, 
	
			CASE WHEN EXISTS(SELECT seller.id FROM seller WHERE seller.id_user = $id_user) THEN prices.discount_sellers 
			ELSE 0
			END as discount

			FROM prices";
}

function update_senha($cpf, $senha){
	return "UPDATE user
			SET user.senha = md5('$senha')
			WHERE user.cpf = '$cpf'";
}

function select_email($cpf){
	return "SELECT user.nickname, user.email
			FROM user
			WHERE user.cpf = '$cpf'";
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
function payment($name, $creditCardFlag, $creditCardNumber, $creditCardMonth, $creditCardYear, $creditCardCSC){
    return TRUE;
}
