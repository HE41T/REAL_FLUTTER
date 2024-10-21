<?php
$servername = "localhost";
$username = "root";
$password = "admin1234";
$dbname = "androiddb";

// กำหนดให้แสดงข้อผิดพลาด
error_reporting(E_ALL);
ini_set('display_errors', 1);

// สร้างการเชื่อมต่อ
$conn = new mysqli($servername, $username, $password, $dbname);

// ตรวจสอบการเชื่อมต่อ
if ($conn->connect_error) {
    die(json_encode(['success' => false, 'message' => 'Connection failed: ' . $conn->connect_error]));
}

// รับข้อมูลจากคำร้องขอ POST
$data = json_decode(file_get_contents("php://input"), true);

// ตรวจสอบว่ามีการส่งค่าที่จำเป็นหรือไม่
if (!isset($data["id"]) || !isset($data["user_id"]) || !isset($data["user_name"]) || !isset($data["passwd"])) {
    echo json_encode(['success' => false, 'message' => 'Invalid input data']);
    exit;
}

// กำหนดตัวแปรจากข้อมูลที่รับมา
$id = $data["id"];
$user_id = $data["user_id"];
$user_name = $data["user_name"];
$passwd = $data["passwd"];

// เตรียมและดำเนินการคำสั่ง SQL สำหรับการอัปเดต
$sql = "UPDATE usertb SET user_id=?, user_name=?, passwd=? WHERE id=?";
$stmt = $conn->prepare($sql);

// ตรวจสอบว่าการเตรียมคำสั่งสำเร็จหรือไม่
if ($stmt === false) {
    echo json_encode(['success' => false, 'message' => 'SQL prepare failed: ' . $conn->error]);
    exit;
}

$stmt->bind_param("sssi", $user_id, $user_name, $passwd, $id);

// ตรวจสอบการอัปเดตข้อมูล
if ($stmt->execute()) {
    echo json_encode(['success' => true, 'message' => 'Record updated successfully']);
} else {
    echo json_encode(['success' => false, 'message' => 'Error updating record: ' . $stmt->error]);
}

// ปิดการเชื่อมต่อ
$stmt->close();
$conn->close();
?>
