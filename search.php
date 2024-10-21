<?php
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    
    // รับข้อมูล JSON ที่ส่งมาจาก Flutter
    $input = file_get_contents('php://input');
    $data = json_decode($input, true);

    if (isset($data['id'])) {
        $user_id = $data['id'];

        $servername = "localhost";
        $username = "root";
        $password = "admin1234";
        $dbname = "androiddb";

        $conn = new mysqli($servername, $username, $password, $dbname);

        if ($conn->connect_error) {
            die(json_encode(array("error" => "Connection failed: " . $conn->connect_error)));
        }

        $sql = "SELECT * FROM usertb WHERE id = ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("s", $user_id);
        $stmt->execute();
        $result = $stmt->get_result();

        $data = array();

        if ($result->num_rows > 0) {
            while($row = $result->fetch_assoc()) {
                $data[] = $row;
            }
        }


        echo json_encode($data);

        $stmt->close();
        $conn->close();
    } else {

        echo json_encode(array("error" => "ID is required."));
    }
} else {

    echo json_encode(array("error" => "Invalid request method."));
}
?>
