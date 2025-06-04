<?php
require_once 'config.inc.php';
require_once 'header.inc.php';

$conn = new mysqli($servername, $username, $password, $database, $port);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$sql = "
SELECT 
    c.listing_no,
    c.card_name,
    c.grade,
    c.price,
    v.first_name,
    v.last_name
FROM card c
JOIN vendor v ON c.vendor_id = v.user_id
WHERE v.first_name = 'John'
  AND v.last_name = 'Example'
ORDER BY c.card_name ASC;
";

$result = $conn->query($sql);
?>

<!DOCTYPE html>
<html>
<head>
    <title>John Example's Cards</title>
</head>
<body>

<h2>Query 2</h2>
<h3>Show the current inventory of the vendor named “John Example”, ordered alphabetically a-z.</h3>

<?php
if ($result && $result->num_rows > 0) {
    echo "<table border='1'><thead><tr>";

    $row = $result->fetch_assoc();
    foreach (array_keys($row) as $field) {
        echo "<th>" . htmlspecialchars($field) . "</th>";
    }
    echo "</tr></thead><tbody>";

    echo "<tr>";
    foreach ($row as $value) {
        echo "<td>" . htmlspecialchars($value) . "</td>";
    }
    echo "</tr>";

    while ($row = $result->fetch_assoc()) {
        echo "<tr>";
        foreach ($row as $value) {
            echo "<td>" . htmlspecialchars($value) . "</td>";
        }
        echo "</tr>";
    }

    echo "</tbody></table>";
} else {
    echo "<p>No cards found for John Example.</p>";
}

$conn->close();
?>

</body>
</html>
