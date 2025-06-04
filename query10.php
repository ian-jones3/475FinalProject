<?php
require_once 'config.inc.php'; // DB settings
require_once 'header.inc.php'; // optional header layout

$conn = new mysqli($servername, $username, $password, $database, $port);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$sql = "
SELECT 
    v.first_name, 
    v.last_name, 
    COUNT(DISTINCT t.ticket_id) AS ticket_count
FROM vendor v
JOIN ticket t ON v.user_id = t.vendor_id
JOIN event e ON t.event_id = e.event_id
WHERE 
    t.checked_in = 0
    AND e.event_start_date > '2024-01-01 00:00:00'
GROUP BY v.user_id
HAVING COUNT(DISTINCT t.ticket_id) > 1
";

$result = $conn->query($sql);
?>

<!DOCTYPE html>
<html>
<head>
    <title>Vendors with Multiple Unchecked Tickets</title>
</head>
<body>

<h2>Query 10</h2>
<h3>Which vendors have tickets to more than one upcoming event (events past Jan 1 2024), but have not checked in to any of them yet?</h3>

<?php
if ($result && $result->num_rows > 0) {
    echo "<table border='1'><thead><tr>
            <th>First Name</th>
            <th>Last Name</th>
            <th>Ticket Count</th>
        </tr></thead><tbody>";

    while ($row = $result->fetch_assoc()) {
        echo "<tr>
                <td>" . htmlspecialchars($row['first_name']) . "</td>
                <td>" . htmlspecialchars($row['last_name']) . "</td>
                <td>" . htmlspecialchars($row['ticket_count']) . "</td>
              </tr>";
    }
    echo "</tbody></table>";
} else {
    echo "<p>No vendors found with more than one unchecked ticket.</p>";
}

$conn->close();
?>

</body>
</html>
