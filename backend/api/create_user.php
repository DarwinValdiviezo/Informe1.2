<?php
require_once '../config/database.php';
require_once '../utils/bcrypt.php';

header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");

try {
    $data = json_decode(file_get_contents("php://input"));

    if (!isset($data->name, $data->email, $data->password)) {
        http_response_code(400);
        echo json_encode(["exito" => false, "message" => "Faltan datos obligatorios."]);
        exit();
    }

    // Conectar a la base de datos
    $db = (new Database())->connect();

    // Verificar si el correo ya está registrado
    $query = "SELECT id FROM users WHERE email = :email";
    $stmt = $db->prepare($query);
    $stmt->bindParam(':email', $data->email);
    $stmt->execute();

    if ($stmt->rowCount() > 0) {
        http_response_code(409);
        echo json_encode(["exito" => false, "message" => "El correo ya está registrado."]);
        exit();
    }

    // Insertar usuario
    $query = "INSERT INTO users (name, email, password) VALUES (:name, :email, :password)";
    $stmt = $db->prepare($query);
    $stmt->bindParam(':name', $data->name);
    $stmt->bindParam(':email', $data->email);
    $stmt->bindParam(':password', bcrypt_hash($data->password));

    if ($stmt->execute()) {
        echo json_encode(["exito" => true, "message" => "Usuario creado exitosamente."]);
    } else {
        throw new Exception("Error al ejecutar la consulta.");
    }
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        "exito" => false,
        "message" => "Error interno del servidor.",
        "error" => $e->getMessage()
    ]);
}
