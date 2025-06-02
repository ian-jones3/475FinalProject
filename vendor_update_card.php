<?php
require_once 'config.inc.php';
require_once 'header.inc.php';

$conn = new mysqli($servername, $username, $password, $database, $port);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$vendor_id = null;
$vendor_name_input = "";
$first_name = $last_name = "";
$cards = [];

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    if (isset($_POST["vendor_search"])) {
        $vendor_name_input = trim($_POST["vendor_name"]);
        $name_parts = explode(" ", $vendor_name_input, 2);
        $first_name = $name_parts[0];
        $last_name = isset($name_parts[1]) ? $name_parts[1] : "";

        $stmt = $last_name === ""
            ? $conn->prepare("SELECT user_id FROM vendor WHERE first_name = ?")
            : $conn->prepare("SELECT user_id FROM vendor WHERE first_name = ? AND last_name = ?");

        if ($last_name === "") {
            $stmt->bind_param("s", $first_name);
        } else {
            $stmt->bind_param("ss", $first_name, $last_name);
        }

        $stmt->execute();
        $stmt->bind_result($vendor_id);
        if (!$stmt->fetch()) {
            $vendor_id = null;
        }
        $stmt->close();
    }

    if (isset($_POST["update"]) && isset($_POST["vendor_id"])) {
        $vendor_id = intval($_POST["vendor_id"]);
        $listing_no = intval($_POST["listing_no"]);
        $new_quantity = intval($_POST["new_quantity"]);

        $stmt = $conn->prepare("UPDATE card SET quantity = ? WHERE listing_no = ? AND vendor_id = ?");
        $stmt->bind_param("iii", $new_quantity, $listing_no, $vendor_id);
        $stmt->execute();
        $stmt->close();
    }

    if (isset($_POST["delete"]) && isset($_POST["vendor_id"])) {
        $vendor_id = intval($_POST["vendor_id"]);
        $listing_no = intval($_POST["listing_no"]);

        $stmt = $conn->prepare("DELETE FROM card WHERE listing_no = ? AND vendor_id = ?");
        $stmt->bind_param("ii", $listing_no, $vendor_id);
        $stmt->execute();
        $stmt->close();
    }
}

// Load cards if vendor_id is found
if ($vendor_id !== null) {
    $stmt = $conn->prepare("SELECT listing_no, card_name, grade, g.company_name, quantity, price FROM card JOIN grading_company g ON card.grading_company_id = g.grading_company_id WHERE vendor_id = ?");
    $stmt->bind_param("i", $vendor_id);
    $stmt->execute();
    $stmt->bind_result($listing_no, $card_name, $grade, $company_name, $quantity, $price);
    while ($stmt->fetch()) {
        $cards[] = [
            'listing_no' => $listing_no,
            'card_name' => $card_name,
            'grade' => $grade,
            'company_name' => $company_name,
            'quantity' => $quantity,
            'price' => $price
        ];
    }
    $stmt->close();
}

$conn->close();
?>

<!DOCTYPE html>
<html>
<head>
    <title>Manage Vendor Cards</title>
</head>
<body>
    <h2>Manage Vendor Inventory</h2>
    <form method="POST">
        <label for="vendor_name">Enter Vendor Name (First Last):</label>
        <input type="text" id="vendor_name" name="vendor_name" required value="<?= htmlspecialchars($vendor_name_input) ?>">
        <button type="submit" name="vendor_search">Search</button>
    </form>

    <?php if ($vendor_id !== null): ?>
        <h3>Cards for Vendor ID: <?= htmlspecialchars($vendor_id) ?></h3>

        <?php if (count($cards) > 0): ?>
        <table border="1" cellpadding="8">
            <tr>
                <th>Listing No</th>
                <th>Card Name</th>
                <th>Grade</th>
                <th>Grading Company</th>
                <th>Quantity</th>
                <th>Price</th>
                <th>Actions</th>
            </tr>

            <?php foreach ($cards as $card): ?>
            <tr>
                <td><?= htmlspecialchars($card['listing_no']) ?></td>
                <td><?= htmlspecialchars($card['card_name']) ?></td>
                <td><?= htmlspecialchars($card['grade']) ?></td>
                <td><?= htmlspecialchars($card['company_name']) ?></td>
                <td><?= htmlspecialchars($card['quantity']) ?></td>
                <td>$<?= htmlspecialchars($card['price']) ?></td>
                <td>
                    <!-- Update Quantity Form -->
                    <form method="POST" style="display:inline;">
                        <input type="hidden" name="vendor_id" value="<?= $vendor_id ?>">
                        <input type="hidden" name="listing_no" value="<?= $card['listing_no'] ?>">
                        <input type="number" name="new_quantity" value="<?= $card['quantity'] ?>" min="0" required>
                        <button type="submit" name="update">Update</button>
                    </form>

                    <!-- Delete Form -->
                    <form method="POST" style="display:inline;" onsubmit="return confirm('Delete this card?');">
                        <input type="hidden" name="vendor_id" value="<?= $vendor_id ?>">
                        <input type="hidden" name="listing_no" value="<?= $card['listing_no'] ?>">
                        <button type="submit" name="delete">Delete</button>
                    </form>
                </td>
            </tr>
            <?php endforeach; ?>
        </table>
        <?php else: ?>
            <p>This vendor has no cards listed.</p>
        <?php endif; ?>

    <?php elseif ($_SERVER["REQUEST_METHOD"] === "POST"): ?>
        <p><strong>No vendor found with that name.</strong></p>
    <?php endif; ?>
</body>
</html>
