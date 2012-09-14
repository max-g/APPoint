<?php
require_once 'facebook/facebook.php';
require_once 'application/config.php';
require_once 'application/enums.php';

function api_autoloader($class_name)
{
    if(starts_with(strtolower($class_name), 'db_'))
        require_once "../api/dal/".strtolower($class_name).'.class.php';
    else
        require_once "../api/model/".strtolower($class_name).'.class.php';
}
spl_autoload_register('api_autoloader');

function redirect($url)
{
    header("Location: $url");
    die;
}
function client_redirect($url)
{
    echo "<script>window.top.location = '$url';</script>";
    die;
}
function starts_with($haystack, $needle)
{
    return strpos($haystack, $needle) === 0;
}
function ends_with($haystack, $needle)
{
    return substr($haystack, -strlen($needle)) == $needle;
}
?>
