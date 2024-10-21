<?php
$servername = "localhost";
$username = "root";
$password = "admin1234";
$dbname = "androiddb";

// เชื่อมต่อกับฐานข้อมูล
$conn = new mysqli($servername, $username, $password, $dbname);

// ตรวจสอบการเชื่อมต่อ
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// รับข้อมูล JSON ที่ส่งมาจาก Flutter
$data = json_decode(file_get_contents("php://input"));

// ดึงค่าจาก JSON
$user_id = $data->user_id; 
$user_name = $data->user_name;
$passwd = $data->passwd;

// เตรียม SQL Statement
$sql = "INSERT INTO usertb (id, user_id, user_name, passwd) VALUES (null, '$user_id', '$user_name', '$passwd')";

if ($conn->query($sql) === TRUE) { 
    echo json_encode(array("success" => true, "message" => "New record created successfully"));
} else { 
    echo json_encode(array("success" => false, "error" => $conn->error)); 
}

$conn->close(); 
?>
