<?php
require_once 'api/api.php';
require_once 'functions.php';

// instanciate FB object
$facebook = new Facebook(array(
    'appId'  => FB_APP_ID,
    'secret' => FB_APP_SECRET
));
$user_id = $facebook->getUser();
if(!$user_id)
{
    $oauth_url = 'https://www.facebook.com/dialog/oauth';
    $oauth_url .= '?client_id='.FB_APP_ID;
    $oauth_url .= '&redirect_uri='.  urlencode(APP_URL);
    $oauth_url .= '&scope=email';
    client_redirect($oauth_url);
}
?>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Appointments</title>
        <link type="text/css" rel="stylesheet" href="resources/css/site.css">
    </head>
    <body>
        <script src="resources/js/jquery.js"></script>
        <ul class="menu">
            <li><a href="index.php"<?php active('index') ?>>APPoint</a></li>
            <li><a href="services.php"<?php active('services') ?>>MAKE AN APPOINTMENT</a></li>
            <li><a href="profile.php"<?php active('profile') ?>>MY SERVICE</a></li>
        </ul>
        <div class="content">
