<?php

require_once 'header.inc.php';

$queryResults = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $sortingMethod = $_POST['sortMethod'];
    $sortingDirection = $_POST['sortDirection'];
    ob_start(); // store output of query execution
    executeVendorQuery($sortingMethod, $sortingDirection);
    $queryResults = ob_get_clean();
}

function executeVendorQuery($sortingMethod, $sortingDirection)
{
    echo '<div>function executed!</div>';
    echo "<div> sorting by $sortingMethod, $sortingDirection</div>";
}

?>
<html>
<h2>Browse Vendors</h2>
<form method='POST'>
    <label for='sortMethod'>Choose a Sorting Method:</label>
    <select name='sortMethod' id='sortMethod'>
        <option value='Name'>name</option>
        <option value='booth number'>booth number</option>
        <option value='placeholder'>placeholder</option>
    </select>
    <label for='sortDirection'>Choose a Sorting Direction:</label>
    <select name='sortDirection' id='sortDirection'>
        <option value='ascending'>ascending</option>
        <option value='descending'>descending</option>
    </select>
    <button onclick="this.form.submit()">The super cool query buttont hat executes the query woo hoo</button>
</form>
<div>
    <?= $queryResults ?>
</div>

</html>