<?php
require_once 'config.inc.php';
require_once 'header.inc.php';

$conn = new mysqli($servername, $username, $password, $database, $port);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Handle insert
if ($_SERVER["REQUEST_METHOD"] === "POST") {
    if (isset($_POST["insert_vendor"])) {
        $first_name = trim($_POST["first_name"]);
        $last_name = trim($_POST["last_name"]);
        $email = trim($_POST["email"]);
        $booth_no = intval($_POST["booth_no"]);
        $last_managed_by = !empty($_POST["last_managed_by"]) ? intval($_POST["last_managed_by"]) : null;

        $stmt = $conn->prepare("INSERT INTO vendor (first_name, last_name, email, booth_no, last_managed_by) VALUES (?, ?, ?, ?, ?)");
        $stmt->bind_param("sssii", $first_name, $last_name, $email, $booth_no, $last_managed_by);
        if ($stmt->execute()) {
            echo "<p style='color:green;'>Vendor inserted successfully.</p>";
        } else {
            echo "<p style='color:red;'>Insert failed: " . htmlspecialchars($stmt->error) . "</p>";
        }
        $stmt->close();
    }

    // Handle update
    if (isset($_POST["update_vendor"])) {
        $vendor_id = intval($_POST["vendor_id"]);
        $first_name = trim($_POST["first_name"]);
        $last_name = trim($_POST["last_name"]);
        $email = trim($_POST["email"]);
        $booth_no = intval($_POST["booth_no"]);

        $stmt = $conn->prepare("UPDATE vendor SET first_name = ?, last_name = ?, email = ?, booth_no = ? WHERE user_id = ?");
        $stmt->bind_param("sssii", $first_name, $last_name, $email, $booth_no, $vendor_id);
        $stmt->execute();
        $stmt->close();
    }

    // Handle delete
    if (isset($_POST["delete_vendor"])) {
        $vendor_id = intval($_POST["vendor_id"]);
        $stmt = $conn->prepare("DELETE FROM vendor WHERE user_id = ?");
        $stmt->bind_param("i", $vendor_id);
        $stmt->execute();
        $stmt->close();
    }
}

// Fetch all vendors
$vendors = [];
$result = $conn->query("SELECT * FROM vendor ORDER BY user_id ASC");
if ($result) {
    while ($row = $result->fetch_assoc()) {
        $vendors[] = $row;
    }
}
$conn->close();
?>

<!DOCTYPE html>
<html>
<head>
    <title>Manage Vendors</title>
</head>
<body>
    <h2>Insert New Vendor</h2>
    <form method="POST">
        <label>First Name:</label>
        <input type="text" name="first_name" required>
        <label>Last Name:</label>
        <input type="text" name="last_name" required>
        <label>Email:</label>
        <input type="email" name="email" required>
        <label>Booth No:</label>
        <input type="number" name="booth_no" required>
        <label>Checked in By (Admin ID):</label>
        <input type="number" name="checked_in_by">
        <button type="submit" name="insert_vendor">Insert</button>
    </form>

    <h2>All Vendors</h2>
    <?php if (!empty($vendors)): ?>
    <table border="1" cellpadding="8">
        <tr>
            <th>User ID</th>
            <th>First</th>
            <th>Last</th>
            <th>Email</th>
            <th>Booth</th>
            <th>Last Managed By</th>
            <th>Actions</th>
        </tr>
        <?php foreach ($vendors as $vendor): ?>
        <tr>
            <form method="POST">
                <td><?= htmlspecialchars($vendor["user_id"]) ?></td>
                <td><input type="text" name="first_name" value="<?= htmlspecialchars($vendor["first_name"]) ?>" required></td>
                <td><input type="text" name="last_name" value="<?= htmlspecialchars($vendor["last_name"]) ?>" required></td>
                <td><input type="email" name="email" value="<?= htmlspecialchars($vendor["email"]) ?>" required></td>
                <td><input type="number" name="booth_no" value="<?= htmlspecialchars($vendor["booth_no"]) ?>" required></td>
                <td><?= htmlspecialchars($vendor["checked_in_by"]) ?></td>
                <td>
                    <input type="hidden" name="vendor_id" value="<?= $vendor["user_id"] ?>">
                    <button type="submit" name="update_vendor">Update</button>
                    <button type="submit" name="delete_vendor" onclick="return confirm('Delete this vendor?');">Delete</button>
                </td>
            </form>
        </tr>
        <?php endforeach; ?>
    </table>
    <?php else: ?>
        <p>No vendors found.</p>
    <?php endif; ?>
</body>
</html>
