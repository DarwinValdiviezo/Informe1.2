<?php

// Codificar datos
function base64url_encode($data) {
    return rtrim(strtr(base64_encode($data), '+/', '-_'), '=');
}

//decodificar datos en base64url
function base64url_decode($data) {
    return base64_decode(strtr($data, '-_', '+/'));
}

// Generar token JWT
function generate_jwt($user_id) {
    $key = "super_secret_local_key";
    $header = json_encode(['typ' => 'JWT', 'alg' => 'HS256']);
    $payload = json_encode([
        "iss" => "localhost",
        "iat" => time(),    
        "exp" => time() + 3600, 
        "data" => ["id" => $user_id] 
    ]);

    $header_base64 = base64url_encode($header);
    $payload_base64 = base64url_encode($payload);

    // Crear la firma
    $signature = hash_hmac('sha256', "$header_base64.$payload_base64", $key, true);
    $signature_base64 = base64url_encode($signature);

    // Retornar el token
    return "$header_base64.$payload_base64.$signature_base64";
}

// Verificar token JWT
function verify_jwt($token) {
    $key = "super_secret_local_key";
    $parts = explode('.', $token);

    if (count($parts) !== 3) {
        return null;
    }

    list($header_base64, $payload_base64, $signature_base64) = $parts;

    $expected_signature = base64url_encode(hash_hmac('sha256', "$header_base64.$payload_base64", $key, true));

    // Comparar la firma
    if (!hash_equals($expected_signature, $signature_base64)) {
        return null;
    }

    // Decodificar el payload
    //El payload es un JSON que contiene la información del usuario
    $payload = json_decode(base64url_decode($payload_base64), true);

    // Verificar expiración
    if (isset($payload['exp']) && time() > $payload['exp']) {
        return null;
    }

    return $payload; 
}
