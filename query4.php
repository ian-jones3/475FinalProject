<?php
require_once 'config.inc.php'; // assumes your DB settings are here
require_once 'header.inc.php'; // optional header layout

// Create DB connection
$conn = new mysqli($servername, $username, $password, $database, $port);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// SQL query
$sql = "
SELECT * 
FROM card c
JOIN grading_company g ON c.grading_company_id = g.grading_company_id
JOIN `set` s ON c.set_id = s.set_id
WHERE c.grade >= 9.0
AND g.company_name = 'CGC'
AND s.set_name = 'Team Rocket'
ORDER BY c.grade DESC
";

$result = $conn->query($sql);
?>

<!DOCTYPE html>
<html>
<head>
    <title>CGC 9.0+ Team Rocket Cards</title>
</head>
<body>

<h2>Query 4</h2>
<h3>Show all card listings of CGC grade 9.0 or higher that are part of the Team Rocket card set,  sorted from highest grade to lowest.</h3>

<?php
if ($result && $result->num_rows > 0) {
    echo "<table border='1'><thead><tr>";

    // Dynamically generate headers
    $fields = $result->fetch_fields();
    foreach ($fields as $field) {
        echo "<th>" . htmlspecialchars($field->name) . "</th>";
    }
    echo "</tr></thead><tbody>";

    // Reset pointer and print rows
    $result->data_seek(0);
    while ($row = $result->fetch_assoc()) {
        echo "<tr>";
        foreach ($row as $value) {
            echo "<td>" . htmlspecialchars($value) . "</td>";
        }
        echo "</tr>";
    }

    echo "</tbody></table>";
} else {
    echo "<p>No cards match the criteria.</p>";
}

$conn->close();
?>

</body>
</html>
