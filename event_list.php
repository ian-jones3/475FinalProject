<?php
require_once 'config.inc.php';
require_once 'header.inc.php';

// Create connection
$conn = new mysqli($servername, $username, $password, $database, $port);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// SQL query with specific fields
$sql = "
SELECT 
    e.event_id, 
    e.location_id, 
    e.event_start_date, 
    e.event_end_date, 
    l.city, 
    l.address, 
    l.zip_code, 
    l.venue_name
FROM event e
JOIN location l ON e.location_id = l.location_id
";

$result = $conn->query($sql);
?>

<!DOCTYPE html>
<html>
<head>
    <title>Event List</title>
    <style>
        table {
            border-collapse: collapse;
            width: 100%;
            margin-top: 20px;
        }
        th, td {
            padding: 8px 12px;
            border: 1px solid #999;
            text-align: left;
            vertical-align: top;
            word-break: break-word;
        }
        th {
            background-color: #f4f4f4;
        }
    </style>
</head>
<body>

<h2>Event List with Location</h2>

<?php
if ($result && $result->num_rows > 0) {
    echo "<table><thead><tr>
        <th>Event ID</th>
        <th>Location ID</th>
        <th>Start Date</th>
        <th>End Date</th>
        <th>City</th>
        <th>Address</th>
        <th>Zip Code</th>
        <th>Venue Name</th>
    </tr></thead><tbody>";

    while ($row = $result->fetch_assoc()) {
        echo "<tr>
            <td>" . htmlspecialchars($row['event_id']) . "</td>
            <td>" . htmlspecialchars($row['location_id']) . "</td>
            <td>" . htmlspecialchars($row['event_start_date']) . "</td>
            <td>" . htmlspecialchars($row['event_end_date']) . "</td>
            <td>" . htmlspecialchars($row['city']) . "</td>
            <td>" . htmlspecialchars($row['address']) . "</td>
            <td>" . htmlspecialchars($row['zip_code']) . "</td>
            <td>" . htmlspecialchars($row['venue_name']) . "</td>
        </tr>";
    }

    echo "</tbody></table>";
} else {
    echo "No results found.";
}

$conn->close();
?>

</body>
</html>
