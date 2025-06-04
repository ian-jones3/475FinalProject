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
    $questions = [
        "What vendors are selling the Base set Charizard at the Seattle Card Convention that is on January 15th, 2024?",
        "Show the current inventory of the vendor named “John Example”, ordered alphabetically a-z.",
        "Show all card listings that use PSA as their grading company, and the booth number that listing is located at.",
        "Show all card listings of CGC grade 9.0 or higher that are part of the Team Rocket card set, sorted from highest grade to lowest.",
        "What is the average price of Base Set Charizard across all vendors at all locations?",
        "Which card has the most listings across all the vendors, and how many listings are there?",
        "Which vendors have more than 5 cards in their inventory which are PSA 9.0 and above?",
        "Who are the vendors who have a ticket to the Las Vegas Convention Event on June 12, 2025 but are not checked in?",
        "Show the name, email, and booth number of all vendors who have an abnormally large number of the same card (quantity >= 15). Also show the count of abnormal listings for each of these vendors, sorted from greatest to least.",
        "Which vendors have tickets to more than one upcoming event (events past Jan 1 2024), but have not checked in to any of them yet?"
    ];

    foreach ($questions as $i => $question) {
        $queryNum = $i + 1;
        echo "<li><a href=\"query$queryNum.php\">Query #$queryNum</a>: $question</li>";
    }
    ?>
</ul>

</body>
</html>
