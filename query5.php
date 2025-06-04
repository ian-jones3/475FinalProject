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
SELECT AVG(c.price) AS avg_price
FROM card c
JOIN card_set s ON c.set_id = s.set_id
WHERE c.name = 'Pikachu'
AND s.set_name = 'Base'
";

$result = $conn->query($sql);
?>

<!DOCTYPE html>
<html>
<head>
    <title>Average Pikachu Card Price (Base Set)</title>
</head>
<body>

<h2>Query 5</h2>
<h3>What is the average price of Base Set Pikachu across all vendors?</h3>

<?php
if ($result && $row = $result->fetch_assoc()) {
    echo "<p>Average Price: $" . number_format($row['avg_price'], 2) . "</p>";
} else {
    echo "<p>No data found.</p>";
}

$conn->close();
?>

</body>
</html>
