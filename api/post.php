<?php

header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Headers: *');
header('Access-Control-Allow-Methods: *');
header('Access-Control-Allow-Credentials: true');
header('Content-type: json/application');

// Database connection parameters
$host = 'localhost';
$username = 'root';
$password = '';
$database = 'inv';


echo var_dump($_SERVER['REQUEST_METHOD']);

$name = filter_var($_POST['name'], FILTER_SANITIZE_STRING);

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    // Create a connection to the database
    $mysqli = new mysqli($host, $username, $password, $database);

    // Check connection
    if ($mysqli->connect_error) {
        die("Connection failed: " . $mysqli->connect_error);
    }

    var_dump($_POST);

    // Query to fetch data from the users table
    $sql = "INSERT INTO category (name) value ('$name')";
    $result = $mysqli->query($sql);

    if (!$result) {
        die("Error in the query: " . $mysqli->error);
    }
    
    // Return a success message as JSON
    echo json_encode(array("message" => "Client data inserted successfully"));
}

?>