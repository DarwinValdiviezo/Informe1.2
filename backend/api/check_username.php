<?php
require_once '../config/database.php';

header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");

try {
    $data = json_decode(file_get_contents("php://input"));

    if (!isset($data->name)) {
        http_response_code(400);
        echo json_encode(["message" => "Falta el nombre de usuario."]);
        exit();
    }

    $db = (new Database())->connect();

    $query = "SELECT name FROM users WHERE name = :name";
    $stmt = $db->prepare($query);
    $stmt->bindParam(':name', $data->name);
    $stmt->execute();

    if ($stmt->rowCount() > 0) {
        $suggestions = array_map(function ($i) use ($data) {
            return $data->name . $i;
        }, range(1, 5));

        echo json_encode([
            "available" => false,
            "message" => "El nombre ya está en uso.",
            "suggestions" => $suggestions
        ]);
    } else {
        echo json_encode([
            "available" => true,
            "message" => "El nombre está disponible."
        ]);
    }
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        "message" => "Error interno del servidor.",
        "error" => $e->getMessage()
    ]);
}
