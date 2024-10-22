-- MySQL file for creating required database (run in MySQL!)

DROP DATABASE IF EXISTS rescued_items_DB;


-- CREATING DATABASE ---------------------------------------------------

CREATE DATABASE IF NOT EXISTS rescued_items_DB;
use rescued_items_DB;

CREATE TABLE item_source( 
     id INT PRIMARY KEY AUTO_INCREMENT,
     name VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE item_type( 
     id INT PRIMARY KEY AUTO_INCREMENT,
     name VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE item_status(  
     id INT PRIMARY KEY AUTO_INCREMENT,
     name VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE item_overall_status(  
     id INT PRIMARY KEY AUTO_INCREMENT,
     name VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE item_status_link( 
     item_status_id INT NOT NULL DEFAULT 1, -- FK
     item_overall_status_id INT NOT NULL DEFAULT 1, -- FK
     FOREIGN KEY (item_status_id) REFERENCES item_status(id),
     FOREIGN KEY (item_overall_status_id) REFERENCES item_overall_status(id),
     PRIMARY KEY (item_status_id, item_overall_status_id) 
);

CREATE TABLE item( 
     id INT PRIMARY KEY AUTO_INCREMENT,
     item_type_id INT NOT NULL, -- FK
     description VARCHAR(100),
     item_source_id INT NOT NULL DEFAULT 1, -- FK (most come from RR, so it's default)
     item_status_id INT NOT NULL DEFAULT 1, -- FK (default is 'acquired')
     FOREIGN KEY (item_type_id) REFERENCES item_type(id),
	 FOREIGN KEY (item_source_id) REFERENCES item_source(id),
	 FOREIGN KEY (item_status_id) REFERENCES item_status(id)
);

CREATE TABLE fixer(  
     id INT PRIMARY KEY AUTO_INCREMENT,
     first_name VARCHAR(30) NOT NULL,
     last_name VARCHAR(30) NOT NULL,
     email VARCHAR(30) UNIQUE,
     start_date DATE NOT NULL DEFAULT (CURRENT_DATE())
);

CREATE TABLE event_type( 
     id INT PRIMARY KEY AUTO_INCREMENT,
     name VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE item_event( 
	 id INT PRIMARY KEY AUTO_INCREMENT,
	 date DATE NOT NULL DEFAULT (CURRENT_DATE()), 
     fixer_id INT DEFAULT 1, -- FK
     item_id INT NOT NULL, -- FK
     event_type_id INT NOT NULL DEFAULT 1,
     notes VARCHAR(100),  
     outcome_status_id INT NOT NULL DEFAULT 1, -- FK 
     FOREIGN KEY (fixer_id) REFERENCES fixer(id)
		ON DELETE SET NULL,
	 FOREIGN KEY (item_id) REFERENCES item(id),
	 FOREIGN KEY (event_type_id) REFERENCES event_type(id),
	 FOREIGN KEY (outcome_status_id) REFERENCES item_status(id)
);

CREATE TABLE item_for_sale( 
     id INT PRIMARY KEY AUTO_INCREMENT,
     date_listed DATE NOT NULL DEFAULT (CURRENT_DATE()),
     item_id INT NOT NULL UNIQUE, -- FK
     price DECIMAL(6, 2) NOT NULL,  
	 FOREIGN KEY (item_id) REFERENCES item(id),
     CONSTRAINT chk_min_price CHECK (price >= 5) 
);


-- ADDING DATA TO TABLES ---------------------------------------------------

INSERT INTO item_source (name)
VALUES ('Regis Road Recycling Centre'), ('donation'), ('street find');

INSERT INTO item_type (name)
VALUES 
('kettle'), ('toaster'), ('vacuum cleaner'), ('hair dryer'), 
('radio'), ('laptop'), ('cell phone'), ('lamp'), ('iron');

INSERT INTO item_status (name)
VALUES 
('needs testing'), ('needs repair'), ('ready to list'), ('for sale'), ('gone: e-waste'), ('gone: sold');

INSERT INTO item_overall_status (name)
VALUES 
('open'), ('closed');

INSERT INTO item_status_link(item_status_id, item_overall_status_id)
VALUES (1, 1), (2, 1), (3, 1), (4, 1), (5, 2), (6, 2);

INSERT INTO fixer (first_name, last_name, email, start_date) 
VALUES 
('Meg', 'Flyer', 'meg@fixer.org', '2021-10-31'), 
('Mog', 'Catston', Null, '2021-10-31'), 
('Jess', 'Friendly', 'jess@fixer.org', '2022-01-04'),
('Bess', 'Batsy', 'bess@fixer.org', '2022-03-31'),
('Tess', 'Cook', 'tess@fixer.org', '2022-10-31');

INSERT INTO event_type (name) -- !! will more here
VALUES 
('acquired'), ('tested'), ('attempted repair'), 
('completed repair'), ('listed for sale'), ('sold'), ('price_changed');

INSERT INTO item (item_type_id, description, item_source_id, item_status_id)
VALUES 
(1, "donation from Anne's shop", 2, 6),
(1, "donation from Anne's shop", 2, 4),
(1, "donation from Anne's shop", 2, 4),
(1, "donation from Anne's shop", 2, 6),
(2, 'toaser teardown - black plastic', 1, 6),
(2, 'toaser teardown - red plastic', 1, 4),
(2, 'toaser teardown - stainless steel, missing fuse', 1, 6),
(2, 'toaser teardown - stainless steel', 1, 4),
(2, 'toaser teardown - Bosch, stainless steel', 1, 6),
(1, 'Dualit, stainless steel', 1, 3),
(8, 'desk lamp, white', 1, 4),
(4, 'Tesco, red plastic', 1, 5),
(2, 'no brand, white plastic', 1, 4),
(4, 'Boots, D1000, white plastice', 2, 3),
(3, 'Henry Hoover, dual power', 3, 5),
(2, 'Russel Hobbs, stainless steel', 1, 3),
(3, 'Dyson handheld XP303', 1, 4),
(8, 'standing lamp, brass', 1, 1),
(2, 'John Lewis, black', 2, 3);

INSERT INTO item_event (date, fixer_id, item_id, event_type_id, notes, outcome_status_id)
VALUES
('2021-11-01', 1, 1, 1, 'is base correct?', 1),
('2021-11-01', 1, 2, 1, 'we should have correct bulb', 1),
('2021-11-01', 1, 3, 1, Null, 1),
('2021-11-01', 1, 4, 1, Null, 1),
('2021-11-01', 2, 1, 2, 'base good, contacts cleaned, needs cord replacement', 2),
('2021-11-01', 1, 3, 2, Null, 5),
('2021-11-01', 2, 4, 2, 'safe and works just fine!', 3),
('2021-12-05', 1, 5, 1, 'donor says works fine', 1),
('2021-12-05', 1, 5, 2, Null, 3),
('2021-12-05', 1, 6, 1, 'if broken, can use for parts', 1),
('2022-01-04', 1, 7, 1, 'looks like new', 1),
('2022-01-04', 1, 8, 1, 'high value item', 1),
('2022-01-04', 1, 9, 1, Null, 1),
('2022-01-04', 2, 6, 2, 'sadly broken, but kept filter and accessories', 5);

INSERT INTO item_for_sale(date_listed, item_id, price)
VALUES 
('2021-11-01', 1, 5.00),
('2021-11-14', 4, 6.00),
('2021-11-07', 5, 8.00),
('2021-11-20', 8, 5.00),
('2021-11-22', 9, 10.00);


-- CREATING VIEWS ---------------------------------------------------


CREATE VIEW view_item_full
AS
	SELECT 
		item.id AS 'item_id',
		item_type.name AS 'item_type',
		item.description,
		item_source.name AS 'source',
        item_status.id AS 'status_id',
		item_status.name AS 'status',
        item_overall_status.id AS 'overall_status_id',
        item_overall_status.name AS 'overall_status'
	FROM item
	LEFT JOIN item_type  
	ON item.item_type_id = item_type.id
	LEFT JOIN item_source 
	ON item.item_source_id = item_source.id
    LEFT JOIN item_status
	ON item.item_status_id = item_status.id
    LEFT JOIN item_status_link
	ON item_status.id = item_status_link.item_status_id
    LEFT JOIN item_overall_status
	ON item_status_link.item_overall_status_id = item_overall_status.id;


CREATE VIEW view_item
AS
	SELECT item_type, description, source, status, overall_status
	FROM view_item_full;
    
    
CREATE VIEW view_event_full 
AS
	SELECT 
		item_event.id,
		item_event.date,
        fixer.first_name AS 'fixer',
        item_event.item_id,
		view_item_full.item_type,
		view_item_full.description AS 'item_description',
        event_type.name AS 'action', 
        item_event.notes,
        item_status.id AS 'outcome_status_id',
        item_status.name AS 'outcome_status',
        item_overall_status.id AS 'outcome_overall_status_id',
        item_overall_status.name AS 'outcome_overall_status'
	FROM item_event
	LEFT JOIN fixer
	ON item_event.fixer_id = fixer.id
	LEFT JOIN view_item_full
	ON item_event.item_id = view_item_full.item_id
    LEFT JOIN event_type
	ON item_event.event_type_id = event_type.id
	LEFT JOIN item_status
	ON item_event.outcome_status_id = item_status.id
    
	LEFT JOIN item_status_link
	ON item_status.id = item_status_link.item_status_id
    LEFT JOIN item_overall_status
	ON item_status_link.item_overall_status_id = item_overall_status.id;



CREATE VIEW view_event
AS
	SELECT 
		date, 
        fixer, 
        item_type, 
        item_description, 
        action, 
        notes, 
        outcome_status, 
        outcome_overall_status
	FROM view_event_full;
    

CREATE VIEW view_item_for_sale_full
AS
	SELECT 
		item_for_sale.id AS 'listing_id',
        item_for_sale.date_listed,
        item_for_sale.item_id,
		view_item_full.item_type,
		view_item_full.description AS 'item_description',
		item_for_sale.price
	FROM item_for_sale
	LEFT JOIN view_item_full
	ON item_for_sale.item_id = view_item_full.item_id
    ORDER BY date_listed;
    
    
CREATE VIEW view_item_for_sale
AS
	SELECT date_listed, item_id, item_type, item_description, price
	FROM view_item_for_sale_full
    ORDER BY date_listed;
    

-- CREATING STORED FUNCTION ---------------------------------------------------

-- calculates percents, used in 'view_item_status_stats' below
DELIMITER //  
CREATE FUNCTION ToPercent(part INT, whole INT)  
RETURNS INT DETERMINISTIC
BEGIN	
    RETURN FORMAT(part/whole*100, 0);
END // 
DELIMITER ;  
 

-- USING GROUPBY, COUNT, STORED FUNCTION, SUBQUERY and SUM --------------------------


CREATE VIEW view_item_status_stats
AS
	SELECT 
		view_item.status,
		COUNT(*) AS 'number_of_items',
		ToPercent(COUNT(*), (SELECT COUNT(*) FROM view_item)) AS 'percent'
	FROM view_item
	GROUP BY status
    ORDER BY number_of_items DESC;
    

CREATE VIEW view_item_sale_stats
AS
	SELECT 
		item_type,
		SUM(price) AS 'Total_sales_from_item_type'
	FROM view_item_for_sale
	GROUP BY item_type WITH ROLLUP
    ORDER BY Total_sales_from_item_type DESC;


-- CREATING STORED PROCEDURES ---------------------------------------------------


DELIMITER //
-- adds new item to 'item' and 'item_event' tables
CREATE PROCEDURE AddItem( 
	fixer_id INT, 
	item_source_id INT,
    item_type_id INT, 
    description VARCHAR(100),
    notes VARCHAR(100))
BEGIN
	DECLARE new_item_id INT;
    SET new_item_id = (SELECT MAX(id) FROM item) + 1;
    
    INSERT INTO item (item_type_id, description, item_source_id)
	VALUES (item_type_id, description, item_source_id);

    INSERT INTO item_event (fixer_id, item_id, notes)
	VALUES (fixer_id, new_item_id, notes);
END//
DELIMITER ;



DELIMITER //
-- searches 'description' and 'notes' columns (which are "free form") for keyword
CREATE PROCEDURE SearchText(word VARCHAR(30)) 
BEGIN
	DECLARE with_wildcards VARCHAR(30);
    SET with_wildcards = CONCAT("%", word, "%");
    
    SELECT date, fixer, item_type, item_description, notes 
	FROM view_event
	WHERE item_description LIKE with_wildcards
	OR notes LIKE with_wildcards;

END//
DELIMITER ;


DELIMITER //
-- displays items that need testing or repair, in descending order by date
CREATE PROCEDURE SeeUnfinished()
BEGIN
    SELECT id, item_type, item_description, outcome_status
	FROM view_event_full
	WHERE outcome_status_id IN (1, 2)
	ORDER BY date DESC;
END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE LogItemEvent(
	fixer_id INT,
	item_id INT,
    notes VARCHAR(100),
    new_status_id INT)
BEGIN
    INSERT INTO item_event (fixer_id, item_id, notes, outcome_status_id)
    VALUES (fixer_id, item_id, notes, new_status_id);
END//
DELIMITER ;


DELIMITER //
-- dispays items that are ready to be listed for sale
CREATE PROCEDURE SeeReadyToList() 
BEGIN
	SELECT item_id, item_type, description
	FROM view_item_full
	WHERE status_id = 3
    ORDER BY item_id;
END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE ListItemForSale(
	item_id INT,
    price DECIMAL(4, 2))
BEGIN
    INSERT INTO item_for_sale (item_id, price)
	VALUES (item_id, price);
END//
DELIMITER ;


-- CREATING TRIGGERS ---------------------------------------------------


-- after insertion to 'item_event' table, updates corresponding item status in 'item' table 
CREATE TRIGGER after_item_event_insert
	AFTER INSERT ON item_event 
	FOR EACH ROW
		UPDATE item
        SET item_status_id = NEW.outcome_status_id
        WHERE id = NEW.item_id;


-- after insertion to 'item_for_sale' table
-- logs correspondng item event in 'item_event' table 
-- (which automatically updates corresponding item status in 'item' table) 
CREATE TRIGGER after_item_for_sale_insert
	AFTER INSERT ON item_for_sale
	FOR EACH ROW
	INSERT INTO item_event (item_id, event_type_id, outcome_status_id)
	VALUES (NEW.item_id, 5, 4);

-- after deletion from 'item_for_sale' table
-- logs correspondng item event in 'item_event' table 
-- (which automatically updates corresponding item status in 'item' table)     
CREATE TRIGGER after_item_for_sale_delete
	AFTER DELETE ON item_for_sale
	FOR EACH ROW
	INSERT INTO item_event (item_id, event_type_id, outcome_status_id)
	VALUES (OLD.item_id, 6, 6);
    
-- after update to 'item_for_sale' table
-- logs correspondng item event in 'item_event' table 
-- (which automatically updates corresponding item status in 'item' table)     
CREATE TRIGGER after_item_for_sale_update
	AFTER UPDATE ON item_for_sale
	FOR EACH ROW
	INSERT INTO item_event (item_id, event_type_id, outcome_status_id)
	VALUES (NEW.item_id, 7, 4);

