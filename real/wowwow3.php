<?php
$servername = "localhost";
$username = "root";
$password ="admin1234";
$dbname = "androiddb";

$conn = new mysqli($servername, $username, $password, $dbname);

// Create connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Get data from request
$data = json_decode(file_get_contents("php://input"));
$user_id = $data->user_id;

$sql = "DELETE FROM usertb WHERE user_id = '$user_id'";

if ($conn->query($sql) === TRUE) {
    echo json_encode(array("success" => true, "message" => "Record deleted successfully"));
} else {
    echo json_encode(array("success" => false, "error" => $conn->error));
}

$conn->close();
?>
