<?php

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

function executeCardQuery($cardSortingMethod, $cardSortingDirection) {
    echo '<div>function executed!</div>';
    echo "<div> sorting by $cardSortingMethod, $cardSortingDirection</div>";
}
?>
<html>
    <h2>Browse Cards</h2>
        <form method='POST'>
            <label for='sortMethod'>Choose a Sorting Method:</label>
            <select name='sortMethod' id='sortMethod'> 
                <option value='name'>name</option> 
                <option value='price'>price</option> 
                <option value='rarity'>rarity</option> 
            </select>
            <label for='sortDirection'>Choose a Sorting Direction:</label>
            <select name='sortDirection' id='sortDirection'> 
                <option value='ascending'>ascending</option> 
                <option value='descending'>descending</option> 
            </select>
            <button onclick="this.form.submit()">The super cool query buttont hat executes the query woo hoo</button>
        </form>
        <div>
            <?= $cardQueryResults ?>
        </div>
</html>