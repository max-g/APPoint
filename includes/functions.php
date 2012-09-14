<?php
function active($path)
{
    if($_SERVER['SCRIPT_NAME'] == "/$path.php")
        echo ' class="active"';
}
?>
