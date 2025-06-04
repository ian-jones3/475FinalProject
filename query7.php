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
SELECT v.name, COUNT(c.card_id) AS total_cards
FROM vendor v
JOIN card c ON v.user_id = c.user_id
JOIN grading_company g ON c.grading_company_id = g.grading_company_id
WHERE g.company_name = 'PSA' AND c.grade >= 9.0
GROUP BY v.user_id
HAVING COUNT(c.card_id) > 100
";

$result = $conn->query($sql);
?>

<!DOCTYPE html>
<html>
<head>
    <title>High Volume PSA Vendors</title>
</head>
<body>

<h2>Query 7</h2>
<h3>Which vendors have more than 100 cards listed in their inventory, including PSA 9.0 and above?</h3>

<?php
if ($result && $result->num_rows > 0) {
    echo "<table border='1'><thead><tr>
            <th>Vendor Name</th>
            <th>Total PSA Cards (Grade ≥ 9.0)</th>
        </tr></thead><tbody>";

    while ($row = $result->fetch_assoc()) {
        echo "<tr>
                <td>" . htmlspecialchars($row['name']) . "</td>
                <td>" . htmlspecialchars($row['total_cards']) . "</td>
              </tr>";
    }

    echo "</tbody></table>";
} else {
    echo "<p>No vendors found with more than 100 PSA graded cards (Grade ≥ 9.0).</p>";
}

$conn->close();
?>

</body>
</html>
