<!DOCTYPE html>
<html>
<?php
require_once 'config.inc.php';
require_once 'header.inc.php';
?>
<head>
    <title>Query Menu</title>
</head>
<body>

<h1>Select a Query</h1>
<ul>
    <?php
    for ($i = 1; $i <= 10; $i++) {
        echo "<li><a href=\"query$i.php\">Query #$i</a></li>";
    }
    ?>
</ul>

</body>
</html>
