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
    t.booth_no
FROM vendor v
JOIN ticket t ON v.user_id = t.vendor_id
JOIN card c ON c.vendor_id = v.user_id
JOIN event e ON t.event_id = e.event_id
JOIN location l ON e.location_id = l.location_id
JOIN `set` s ON c.set_id = s.set_id
WHERE 
    l.venue_name = 'Washington State Convention Center'
    AND e.event_start_date = '2024-01-15 09:00:00'
    AND s.set_name = 'Base Set'
    AND c.card_name = 'Charizard'
";

$result = $conn->query($sql);
?>

<!DOCTYPE html>
<html>
<head>
    <title>Vendor Query Results</title>
</head>
<body>

<h2>Query 1</h2>

<?php
if ($result && $result->num_rows > 0) {
    echo "<table><thead><tr>
            <th>First Name</th>
            <th>Last Name</th>
            <th>Booth #</th>
        </tr></thead><tbody>";

    while ($row = $result->fetch_assoc()) {
        echo "<tr>
                <td>" . htmlspecialchars($row['first_name']) . "</td>
                <td>" . htmlspecialchars($row['last_name']) . "</td>
                <td>" . htmlspecialchars($row['booth_no']) . "</td>
              </tr>";
    }

    echo "</tbody></table>";
} else {
    echo "<p>No vendors match the criteria.</p>";
}

$conn->close();
?>

</body>
</html>
