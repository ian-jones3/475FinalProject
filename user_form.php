<!DOCTYPE html>
<html>
<?php
require_once 'header.inc.php';
require_once 'config.inc.php';
?>
<head>
    <title>Default User: Search</title>
</head>
<body>

<h2>Search</h2>
<form method="POST" action="">
    <label for="vendor_name">Search by Vendor:</label>
    <input type="text" id="vendor_name" name="vendor_name">
    <br><br>

    <label for="card_name">Search by Card Name:</label>
    <input type="text" id="card_name" name="card_name">
    <br><br>

    <label for="card_grade">Optional: Enter Card Grade:</label>
    <input type="text" id="card_grade" name="card_grade">
    <br><br>

    <button type="submit">Search</button>
</form>



<?php 

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $vendorInput = isset($_POST["vendor_name"]) ? trim($_POST["vendor_name"]) : "";
    $cardInput = isset($_POST["card_name"]) ? trim($_POST["card_name"]) : "";

    $conn = new mysqli($servername, $username, $password, $database, $port);
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    if (!empty($vendorInput)) {
        // --- VENDOR SEARCH ---

        $fullName = htmlspecialchars($vendorInput);

        // Split full name into first and last names (limit 2 parts)
        $nameParts = explode(" ", $fullName, 2);
        $firstName = $nameParts[0];
        $lastName = isset($nameParts[1]) ? $nameParts[1] : "";

        if ($lastName === "") {
            $stmt = $conn->prepare("SELECT user_id, first_name, last_name, email FROM vendor WHERE first_name = ?");
            if (!$stmt) {
                die("Prepare failed: (" . $conn->errno . ") " . $conn->error);
            }
            $stmt->bind_param("s", $firstName);
        } else {
            $stmt = $conn->prepare("SELECT user_id, first_name, last_name, email FROM vendor WHERE first_name = ? AND last_name = ?");
            if (!$stmt) {
                die("Prepare failed: (" . $conn->errno . ") " . $conn->error);
            }
            $stmt->bind_param("ss", $firstName, $lastName);
        }
        echo "<h3>Vendors named: " . htmlspecialchars($fullName) . "</h3>";

        $stmt->execute();
        $stmt->bind_result($vendor_id, $first_name, $last_name, $email);

        if ($stmt->fetch()) {
            echo "<h3>Vendor Info:</h3>";
            echo "Name: " . htmlspecialchars($first_name . " " . $last_name) . "<br>";
            echo "Email: " . htmlspecialchars($email) . "<br>";
            $stmt->close();

            $stmt2 = $conn->prepare("SELECT c.listing_no, c.card_name, c.grade, c.quantity, c.price, g.company_name FROM card c JOIN grading_company g ON g.grading_company_id = c.grading_company_id WHERE vendor_id = ?");
            if (!$stmt2) {
                die("Prepare failed: (" . $conn->errno . ") " . $conn->error);
            }
            $stmt2->bind_param("i", $vendor_id);
            $stmt2->execute();
            $stmt2->bind_result($listing_no, $card_name, $grade, $quantity, $price, $company_name);

            $hasCards = false;
            while ($stmt2->fetch()) {
                if (!$hasCards) {
                    echo "<h3>Cards Listed by Vendor:</h3>";
                    $hasCards = true;
                }
                echo "Listing No: " . htmlspecialchars($listing_no) . "<br>";
                echo "Card Name: " . htmlspecialchars($card_name) . "<br>";
                echo "Grade: " . htmlspecialchars($grade) . "<br>";
                echo "Quantity: " . htmlspecialchars($quantity) . "<br>";
                echo "Price: $ " . htmlspecialchars($price) . "<br>";
                echo "Grading Company: " . htmlspecialchars($company_name) . "<br><hr>";
            }
            if (!$hasCards) {
                echo "<p>This vendor has no cards listed.</p>";
            }
            $stmt2->close();

        } else {
            echo "<p>No vendor found with the name '$fullName'.</p>";
            $stmt->close();
        }

    } elseif (!empty($cardInput)) {
        // --- CARD SEARCH ---
    
        $cardName = htmlspecialchars($cardInput);
        $cardGrade = isset($_POST["card_grade"]) ? trim($_POST["card_grade"]) : "";
    
        if ($cardGrade !== "") {
            // Search with card name and grade
            $stmt = $conn->prepare("
                SELECT DISTINCT v.first_name, v.last_name, v.email, c.quantity, c.price, c.grade, g.company_name
                FROM vendor v
                JOIN card c ON v.user_id = c.vendor_id
                JOIN grading_company g ON c.grading_company_id = g.grading_company_id
                WHERE c.card_name = ? AND c.grade = ?
            ");
            if (!$stmt) {
                die("Prepare failed: (" . $conn->errno . ") " . $conn->error);
            }
            $stmt->bind_param("ss", $cardName, $cardGrade);
        } else {
            // Search with card name only
            $stmt = $conn->prepare("
                SELECT DISTINCT v.first_name, v.last_name, v.email, c.quantity, c.price, c.grade, g.company_name
                FROM vendor v
                JOIN card c ON v.user_id = c.vendor_id
                JOIN grading_company g ON c.grading_company_id = g.grading_company_id
                WHERE c.card_name = ?
            ");
            if (!$stmt) {
                die("Prepare failed: (" . $conn->errno . ") " . $conn->error);
            }
            $stmt->bind_param("s", $cardName);
        }
    
        $stmt->execute();
        $stmt->bind_result($first_name, $last_name, $email, $quantity, $price, $grade, $company_name);
    
        echo "<h3>Vendors Selling Card: " . htmlspecialchars($cardName);
        if ($cardGrade !== "") {
            echo " (Grade: " . htmlspecialchars($cardGrade) . ")";
        }
        echo "</h3>";
    
        $foundVendor = false;
        while ($stmt->fetch()) {
            $foundVendor = true;
            echo "Name: " . htmlspecialchars($first_name . " " . $last_name) . "<br>";
            echo "Email: " . htmlspecialchars($email) . "<br>";
            echo "Quantity: " . htmlspecialchars($quantity) . "<br>";
            echo "Price: " . htmlspecialchars($price) . "<br>";
            echo "Grade: " . htmlspecialchars($grade) . "<br>";
            echo "Grading Company: " . htmlspecialchars($company_name) . "<br><hr>";
        }
    
        if (!$foundVendor) {
            echo "<p>No vendors found selling the card '" . htmlspecialchars($cardName) . "'";
            if ($cardGrade !== "") {
                echo " with grade '" . htmlspecialchars($cardGrade) . "'";
            }
            echo ".</p>";
        }
    
        $stmt->close();

    } else {
        echo "<p>Please enter either a vendor name or a card name to search.</p>";
    }

    $conn->close();
}

?>

</body>
</html>
