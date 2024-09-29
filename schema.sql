
CREATE TABLE users (
    id INT,
    username VARCHAR(25) UNIQUE NOT NULL,
    password VARCHAR(25) UNIQUE NOT NULL,
    name VARCHAR(50) NOT NULL,
    started DATE DEFAULT (CURRENT_DATE),
    email_id VARCHAR(100) UNIQUE NOT NULL,
    role VARCHAR(25) NOT NULL,
    deleted INT DEFAULT 0 CHECK(deleted BETWEEN 0 AND 1) NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE categories(
    id INT,
    name VARCHAR(100) NOT NULL UNIQUE,
    PRIMARY KEY(id)
);

CREATE TABLE brands(
    id INT,
    name VARCHAR(100) NOT NULL UNIQUE,
    PRIMARY KEY(id)
);

CREATE TABLE guitars(
    id INT AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE,
    category_id INT NOT NULL,
    brand_id INT NOT NULL,
    release_year YEAR,
    status  ENUM('AVAILABLE', 'DISCONTINUED') NOT NULL ,
    PRIMARY KEY(id),
    FOREIGN KEY (brand_id) REFERENCES brands(id),
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

CREATE TABLE guitarists(
    id INT,
    guitar_id INT,
    name TEXT NOT NULL,
    PRIMARY KEY(id),
);

CREATE TABLE colors(
    guitar_id INT,
    name VARCHAR(100) NOT NULL,
    FOREIGN KEY (guitar_id) REFERENCES guitars(id)
);


CREATE TABLE features(
    guitar_id INT,
    body_type VARCHAR(50),
    body_material VARCHAR(50),
    profile VARCHAR(50),
    fret_type VARCHAR(50),
    frets INT,
    neck_material VARCHAR(50) ,
    fingerboard_material VARCHAR(50),
    neck_pickup VARCHAR(50),
    bridge_pickup VARCHAR(50),
    controls VARCHAR(50),
    configuration VARCHAR(50),
    FOREIGN KEY (guitar_id) REFERENCES guitars(id),
    CONSTRAINT CHE_frets CHECK (frets >= 14 AND frets <= 46)
);
CREATE TABLE reviews (
    id INT NOT NULL,
    guitar_id INT,
    user_id INT,
    review LONGTEXT NOT NULL,
    rating FLOAT NOT NULL CHECK (rating >= 1.0 AND rating <= 5.0),
    likes INT NOT NULL CHECK(likes > 0),
    dislikes INT NOT NULL CHECK(dislikes > 0),
    date DATE DEFAULT (CURRENT_DATE),
    PRIMARY KEY(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (guitar_id) REFERENCES guitars(id)
);

CREATE TABLE comments(
    id INT,
    review_id INT,
    user_id INT,
    comment LONGTEXT NOT NULL,
    likes INT NOT NULL CHECK(likes > 0),
    dislikes INT NOT NULL CHECK(dislikes > 0),
    date  DATE DEFAULT (CURRENT_DATE),
    PRIMARY KEY(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE price_comparison (
    guitar_id INT,
    old_price INT NOT NULL,
    current_price INT NOT NULL,
    current_price_added_at DATE NOT NULL,
    FOREIGN KEY(guitar_id) REFERENCES guitars(id)
);

CREATE TABLE wishlists (
    id INT NOT NULL,
    guitar_id INT,
    user_id INT,
    date DATE DEFAULT (CURRENT_DATE),
    PRIMARY KEY(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (guitar_id) REFERENCES guitars(id)
);

CREATE INDEX find_pass ON users(password);
CREATE INDEX find_features ON features(guitar_id, body_type, body_material, profile, fret_type,
frets, neck_material, fingerboard_material, neck_pickup, bridge_pickup, controls, configuration);

CREATE PROCEDURE check_user_status(IN user_id INT)
BEGIN
    DECLARE  user_acc_status INT;
    SELECT deleted INTO user_acc_status FROM users
    WHERE users.id = NEW.user_id;

    IF user_acc_status = 1 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'User account is deleted';
    END IF;
END;

--deleted acc inserts trigger for reviews
CREATE TRIGGER deleted_acc_inserts_reviews
AFTER INSERT ON reviews
FOR EACH ROW
BEGIN
    CALL check_user_status(NEW.user_id);
END

--deleted acc inserts trigger for reviews
CREATE TRIGGER deleted_acc_inserts_comments
AFTER INSERT ON comments
FOR EACH ROW
BEGIN
    CALL check_user_status(NEW.user_id);
END;


--deleted acc inserts trigger for wishlists
CREATE TRIGGER deleted_acc_inserts_wishlists
AFTER INSERT ON wishlists
FOR EACH ROW
BEGIN
    CALL check_user_status(NEW.user_id);
END;

CREATE TRIGGER deleted_acc_updates_reviews
BEFORE UPDATE ON reviews
FOR EACH ROW
BEGIN
    CALL check_user_status(NEW.user_id);
END;

CREATE TRIGGER deleted_acc_updates_comments
BEFORE UPDATE ON comments
FOR EACH ROW
BEGIN
    CALL check_user_status(NEW.user_id);
END;

CREATE TRIGGER deleted_acc_updates_wishlists
BEFORE UPDATE ON wishlists
FOR EACH ROW
BEGIN
    CALL check_user_status(NEW.user_id);
END;

--if old and current prices are the same
CREATE TRIGGER deleted_acc_deletes_from_reviews
BEFORE DELETE ON reviews
FOR EACH ROW
BEGIN
    CALL check_user_status(OLD.user_id);
END;

CREATE TRIGGER deleted_acc_deletes_from_comments
BEFORE DELETE ON comments
FOR EACH ROW
BEGIN
    CALL check_user_status(OLD.user_id);
END;

CREATE TRIGGER deleted_acc_deletes_from_wishlists
BEFORE DELETE ON wishlists
FOR EACH ROW
BEGIN
    CALL check_user_status(OLD.user_id);
END;
--if old and current prices are the same
CREATE TRIGGER
BEFORE  UPDATE ON price_comparison
FOR EACH ROW
BEGIN
    IF OLD.old_price = NEW.current_price
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Old and current price cannot be same';
    END IF;
END;
