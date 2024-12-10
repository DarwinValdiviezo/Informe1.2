<?php
require_once '../utils/jwt.php';

header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

try {
    $headers = getallheaders();
    $authHeader = isset($headers['Authorization']) ? $headers['Authorization'] : null;

    if (!$authHeader) {
        http_response_code(401);
        echo json_encode(["message" => "Token no proporcionado."]);
        exit();
    }

    $token = str_replace('Bearer ', '', $authHeader);
    $decoded = verify_jwt($token);

    if ($decoded) {
        echo json_encode([
            "message" => "Token válido.",
            "data" => $decoded
        ]);
    } else {
        http_response_code(401);
        echo json_encode(["message" => "Token inválido o expirado."]);
    }
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        "message" => "Error interno del servidor.",
        "error" => $e->getMessage()
    ]);
}
