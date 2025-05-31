<?php
require_once 'config.inc.php';
require_once 'header.inc.php';

$queryResults = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $sortingMethod = $_POST['sortMethod'];
    $sortingDirection = $_POST['sortDirection'];
    ob_start(); // store output of query execution
    echo "<div>Sorting by $sortingMethod in $sortingDirection order</div>";
    executeVendorQuery($sortingMethod, $sortingDirection);
    $queryResults = ob_get_clean();
}

function executeVendorQuery($sortingMethod, $sortingDirection)
{
    global $servername, $username, $password, $database, $port;
    $conn = new mysqli($servername, $username, $password, $database, $port);

    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    } else {
        //echo "SELECT * FROM card ORDER BY $cardSortingMethod $cardSortingDirection";
        $sql = "SELECT * FROM vendor ORDER BY $sortingMethod $sortingDirection";
        //$sql = "SELECT * FROM card";
        $stmt = $conn->stmt_init();
        if (!$stmt->prepare($sql)) {
            echo "failed to prepare";
        } else {
            // Execute the Statement
            $stmt->execute();

            // Loop Through Result
            $stmt->bind_result(
                $user_id,
                $first_name,
                $last_name,
                $email,
                $booth_no,
                $checked_in,
            );
            echo "<ul>";
            while ($stmt->fetch()) {
                echo "<li>$first_name $last_name at booth number $booth_no</li>";
            }
            echo "</ul>";
        }
    }
    $conn->close();
}

?>
<html>
<h2>Browse Vendors</h2>
<form method='POST'>
    <label for='sortMethod'>Choose a Sorting Method:</label>
    <select name='sortMethod' id='sortMethod'>
        <option value='first_name'>first name</option>
        <option value='last_name'>last name</option>
        <option value='booth_no'>booth number</option>
    </select>
    <label for='sortDirection'>Choose a Sorting Direction:</label>
    <select name='sortDirection' id='sortDirection'>
        <option value='ASC'>ascending</option>
        <option value='DESC'>descending</option>
    </select>
    <button onclick="this.form.submit()">Execute Query</button>
</form>
<div>
    <?= $queryResults ?>
</div>

</html>