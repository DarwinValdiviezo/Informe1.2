<?php
require_once '../config/database.php';
require_once '../utils/bcrypt.php';
require_once '../utils/jwt.php';

header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");

try {
    $data = json_decode(file_get_contents("php://input"));

    if (!isset($data->email, $data->password)) {
        http_response_code(400);
        echo json_encode(["exito" => false, "mensaje" => "Faltan datos obligatorios."]);
        exit();
    }

    $db = (new Database())->connect();

    // Verificar si el usuario existe
    $query = "SELECT id, name, email, password FROM users WHERE email = :email";
    $stmt = $db->prepare($query);
    $stmt->bindParam(':email', $data->email);
    $stmt->execute();

    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$user) {
        http_response_code(401);
        echo json_encode(["exito" => false, "mensaje" => "Usuario no encontrado."]);
        exit();
    }

    // Verificar la contraseña
    if (!bcrypt_verify($data->password, $user['password'])) {
        http_response_code(401);
        echo json_encode(["exito" => false, "mensaje" => "Contraseña incorrecta."]);
        exit();
    }

    // Generar un token JWT
    $token = generate_jwt($user['id']);

    echo json_encode([
        "exito" => true,
        "token" => $token,
        "idUsuario" => (int) $user['id'],
        "nombre" => $user['name'],
    ]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(["exito" => false, "mensaje" => "Error interno del servidor.", "error" => $e->getMessage()]);
}
