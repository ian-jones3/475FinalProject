<?php
require_once 'config.inc.php';
require_once 'header.inc.php';

$cardQueryResults = '';

// handle selection of sorting methods
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $cardSortingMethod = $_POST['sortMethod'];
    $cardSortingDirection = $_POST['sortDirection'];
    ob_start(); // store output of query execution
    executeCardQuery($cardSortingMethod, $cardSortingDirection);
    $cardQueryResults = ob_get_clean();
}

// still need to add basic filtering. Once that is implemented we can basically just lift this code
// to vendor query.
function executeCardQuery($cardSortingMethod, $cardSortingDirection)
{
    global $servername, $username, $password, $database, $port;
    $conn = new mysqli($servername, $username, $password, $database, $port);

    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    } else {
        echo 'Connection successful!';
        //echo "SELECT * FROM card ORDER BY $cardSortingMethod $cardSortingDirection";
        $sql = "SELECT * FROM card ORDER BY $cardSortingMethod $cardSortingDirection";
        //$sql = "SELECT * FROM card";
        $stmt = $conn->stmt_init();
        if (!$stmt->prepare($sql)) {
            echo "failed to prepare";
        } else {
            // Execute the Statement
            $stmt->execute();

            // Loop Through Result
            $stmt->bind_result($listing_no, 
            $vendor_id, 
            $grading_company_id, 
            $card_name, 
            $grade,
            $card_quantity,
            $set_id,
            $price,
        );
            echo "<ul>";
            while ($stmt->fetch()) {
                echo "<li>$card_name price is $price</li>";
            }
            echo "</ul>";
        }
    }
    $conn->close();
}

?>
<html>
<h2>Browse Cards</h2>
<form method='POST'>
    <label for='sortMethod'>Choose a Sorting Method:</label>
    <select name='sortMethod' id='sortMethod'>
        <option value='card_name'>name</option>
        <option value='price'>price</option>
        <option value=''>placeholder, do not use</option>
    </select>
    <label for='sortDirection'>Choose a Sorting Direction:</label>
    <select name='sortDirection' id='sortDirection'>
        <option value='ASC'>ascending</option>
        <option value='DESC'>descending</option>
    </select>
    <button onclick="this.form.submit()">Execute Query</button>
</form>
<div>
    <?= $cardQueryResults ?>
</div>

</html>