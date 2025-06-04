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
    v.email, 
    t.booth_no, 
    COUNT(DISTINCT c.listing_no) AS abnormal_listing_count
FROM vendor v
JOIN card c ON v.user_id = c.vendor_id
JOIN ticket t ON v.user_id = t.vendor_id
WHERE c.quantity >= 15
GROUP BY v.user_id, v.first_name, v.last_name, v.email, t.booth_no
ORDER BY abnormal_listing_count DESC
";

$result = $conn->query($sql);
?>

<!DOCTYPE html>
<html>
<head>
    <title>Vendors with Abnormal Listings</title>
</head>
<body>

<h2>Query 9</h2>
<h3>Show the name, email, and booth number of all vendors who have an abnormally large number of the same card (quantity >= 15). Also show the count of abnormal listings for each of these vendors, sorted from greatest to least.</h3>

<?php
if ($result && $result->num_rows > 0) {
    echo "<table border='1'><thead><tr>
            <th>First Name</th>
            <th>Last Name</th>
            <th>Email</th>
            <th>Booth #</th>
            <th>Abnormal Listing Count</th>
        </tr></thead><tbody>";

    while ($row = $result->fetch_assoc()) {
        echo "<tr>
                <td>" . htmlspecialchars($row['first_name']) . "</td>
                <td>" . htmlspecialchars($row['last_name']) . "</td>
                <td>" . htmlspecialchars($row['email']) . "</td>
                <td>" . htmlspecialchars($row['booth_no']) . "</td>
                <td>" . htmlspecialchars($row['abnormal_listing_count']) . "</td>
              </tr>";
    }
    echo "</tbody></table>";
} else {
    echo "<p>No vendors with abnormal listings found.</p>";
}

$conn->close();
?>

</body>
</html>
