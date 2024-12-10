<?php
ini_set('display_errors', 1);
error_reporting(E_ALL);
require_once '../config/database.php';

header('Content-Type: application/json');
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

ini_set('display_errors', 1);
error_reporting(E_ALL);

try {
    // Conexión a la base de datos
    $database = new Database();
    $db = $database->connect();

    // Consulta para obtener los usuarios
    $query = "SELECT id, name, email, created_at FROM users";
    $stmt = $db->prepare($query);
    $stmt->execute();

    $users = $stmt->fetchAll(PDO::FETCH_ASSOC);

    if (empty($users)) {
        http_response_code(404);
        echo json_encode(["message" => "No se encontraron usuarios."]);
        exit();
    }

    // Devolver la lista de usuarios
    echo json_encode([
        "message" => "Usuarios obtenidos correctamente.",
        "data" => $users
    ]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        "message" => "Error interno del servidor.",
        "error" => $e->getMessage()
    ]);
}