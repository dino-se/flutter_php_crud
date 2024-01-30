<?php

header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Headers: *');
header('Access-Control-Allow-Methods: *');
header('Access-Control-Allow-Credentials: true');
header('Content-type: application/json');

// Database connection parameters
$host = 'localhost';
$username = 'root';
$password = '';
$database = 'inv';

// Check if the request method is PUT
if ($_SERVER['REQUEST_METHOD'] === 'PUT') {
    // Get the category ID from the request parameters
    $id = filter_var($_GET['id'], FILTER_SANITIZE_STRING);

    // Get the updated data from the request body
    $data = json_decode(file_get_contents("php://input"), true);

    // Create a connection to the database
    $mysqli = new mysqli($host, $username, $password, $database);

    // Check connection
    if ($mysqli->connect_error) {
        die(json_encode(["error" => "Connection failed: " . $mysqli->connect_error]));
    }

    // Query to update data in the category table
    $updatedName = $mysqli->real_escape_string($data['name']);
    $sql = "UPDATE category SET name = '$updatedName' WHERE id = '$id'";
    $result = $mysqli->query($sql);

    if (!$result) {
        die(json_encode(["error" => "Error in the query: " . $mysqli->error]));
    }

    // Successful update
    echo json_encode(["message" => "Data updated successfully"]);
    exit();
}

?>