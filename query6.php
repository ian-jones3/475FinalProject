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
SELECT c.card_name, COUNT(*) as listing_count
FROM card c
GROUP BY c.card_name
ORDER BY listing_count DESC;
";

$result = $conn->query($sql);
?>

<!DOCTYPE html>
<html>
<head>
    <title>Card Listing Counts</title>
</head>
<body>

<h2>Query 6</h2>
<h3>Which card has the most listings across all the vendors, and how many listings are there?</h3>

<?php
if ($result && $result->num_rows > 0) {
    echo "<table border='1'><thead><tr>
            <th>Card Name</th>
            <th>Listing Count</th>
        </tr></thead><tbody>";

    while ($row = $result->fetch_assoc()) {
        echo "<tr>
                <td>" . htmlspecialchars($row['name']) . "</td>
                <td>" . htmlspecialchars($row['listing_count']) . "</td>
              </tr>";
    }

    echo "</tbody></table>";
} else {
    echo "<p>No listings found.</p>";
}

$conn->close();
?>

</body>
</html>
