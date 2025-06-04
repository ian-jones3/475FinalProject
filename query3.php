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
SELECT 
    g.company_name, 
    t.booth_no, 
    c.*
FROM card c
JOIN vendor v ON c.vendor_id = v.user_id
JOIN ticket t ON t.vendor_id = v.user_id
JOIN grading_company g ON c.grading_company_id = g.grading_company_id
WHERE g.company_name = 'PSA'
";

$result = $conn->query($sql);
?>

<!DOCTYPE html>
<html>
<head>
    <title>Cards Graded by PSA</title>
</head>
<body>

<h2>Query 3</h2>
<h3>Show all card listings that use PSA as their grading company, and the booth number that listing is located at.</h3>

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
    echo "<p>No cards graded by PSA found.</p>";
}

$conn->close();
?>

</body>
</html>
