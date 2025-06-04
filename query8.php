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
    v.first_name, 
    v.last_name, 
    v.user_id
FROM vendor v
JOIN ticket t ON t.vendor_id = v.user_id
JOIN event e ON t.event_id = e.event_id
JOIN location l ON e.location_id = l.location_id
WHERE 
    l.venue_name = 'Las Vegas Convention Center'
    AND e.event_start_date = '2024-03-22 10:00:00'
    AND t.checked_in = 0
";

$result = $conn->query($sql);
?>

<!DOCTYPE html>
<html>
<head>
    <title>Unchecked Vendors at Las Vegas Convention Center</title>
</head>
<body>

<h2>Query 8</h2>
<h3>Who are the vendors who have a ticket to the Las Vegas Convention Event on June 12, 2025 but are not checked in?</h3>

<?php
if ($result && $result->num_rows > 0) {
    echo "<table border='1'><thead><tr>
            <th>First Name</th>
            <th>Last Name</th>
            <th>User ID</th>
        </tr></thead><tbody>";

    while ($row = $result->fetch_assoc()) {
        echo "<tr>
                <td>" . htmlspecialchars($row['first_name']) . "</td>
                <td>" . htmlspecialchars($row['last_name']) . "</td>
                <td>" . htmlspecialchars($row['user_id']) . "</td>
              </tr>";
    }

    echo "</tbody></table>";
} else {
    echo "<p>No vendors found who have not checked in at this event.</p>";
}

$conn->close();
?>

</body>
</html>
