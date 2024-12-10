<?php
require_once '../config/database.php';

header('Content-Type: application/json');
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

try {
    $data = json_decode(file_get_contents("php://input"));

    // Validaciones
    if (!isset($data->id) || !isset($data->name) || !isset($data->email)) {
        http_response_code(400);
        echo json_encode(["message" => "Faltan datos obligatorios."]);
        exit();
    }

    if (!is_numeric($data->id)) {
        http_response_code(400);
        echo json_encode(["message" => "El ID debe ser un número entero."]);
        exit();
    }

    if (!filter_var($data->email, FILTER_VALIDATE_EMAIL)) {
        http_response_code(400);
        echo json_encode(["message" => "El correo electrónico no tiene un formato válido."]);
        exit();
    }

    $database = new Database();
    $db = $database->connect();

    // Verificar que el usuario existe
    $checkQuery = "SELECT * FROM users WHERE id = :id";
    $checkStmt = $db->prepare($checkQuery);
    $checkStmt->bindParam(':id', $data->id);
    $checkStmt->execute();

    if ($checkStmt->rowCount() === 0) {
        http_response_code(404);
        echo json_encode(["message" => "Usuario no encontrado."]);
        exit();
    }

    // Actualizar el usuario
    $query = "UPDATE users SET name = :name, email = :email WHERE id = :id";
    $stmt = $db->prepare($query);

    $stmt->bindParam(':id', $data->id);
    $stmt->bindParam(':name', $data->name);
    $stmt->bindParam(':email', $data->email);

    if ($stmt->execute()) {
        echo json_encode(["message" => "Usuario actualizado correctamente."]);
    } else {
        http_response_code(500);
        echo json_encode(["message" => "Error al actualizar el usuario."]);
    }
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(["message" => "Error interno del servidor.", "error" => $e->getMessage()]);
}
