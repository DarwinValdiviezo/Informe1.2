<?php
function bcrypt_hash($password) {
    return password_hash($password, PASSWORD_BCRYPT);
}

function bcrypt_verify($password, $hash) {
    return password_verify($password, $hash);
}
