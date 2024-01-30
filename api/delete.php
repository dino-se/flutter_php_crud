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

// Check if the request method is DELETE
if ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
    // Get the category ID from the request parameters
    $id = filter_var($_GET['id'], FILTER_SANITIZE_STRING);

    // Create a connection to the database
    $mysqli = new mysqli($host, $username, $password, $database);

    // Check connection
    if ($mysqli->connect_error) {
        die(json_encode(["error" => "Connection failed: " . $mysqli->connect_error]));
    }

    // Query to delete data from the category table
    $sql = "DELETE FROM category WHERE id = '$id'";
    $result = $mysqli->query($sql);

    if (!$result) {
        die(json_encode(["error" => "Error in the query: " . $mysqli->error]));
    }

    // Successful deletion
    echo json_encode(["message" => "Data deleted successfully"]);
}
?>
