--EXPLORATORY DATA ANALYSIS

--1. Viewing the order_details table
SELECT * FROM order_details;
/*
- facts table (FK=item_id)
- 12,234 rows of data
- 6 columns (order_details_id, order_id, order_time, item_id, quantity)
*/

--2. Viewing the order_details table
SELECT * FROM items;
/*
- dimension table (PK=item_id)
- 33 rows of data
- 5 columns (item_id, item, category, price_in_€, inventory)
*/

--3. checking for duplicates in both tables
SELECT * FROM order_details GROUP BY order_details_id HAVING COUNT(order_details_id)>1;

SELECT item_id FROM items GROUP BY item_id HAVING COUNT(item_id)>1;
/*
- both tables are free of duplicate rows
*/

--4. Checking for nulls in both tables
SELECT * FROM order_details WHERE order_id is null;
SELECT * FROM order_details WHERE order_date is null;
SELECT * FROM order_details WHERE order_time is null;
SELECT * FROM order_details WHERE item_id is null;
SELECT * FROM order_details WHERE quantity is null;
SELECT * FROM items WHERE item_id is null;
SELECT * FROM items WHERE item is null;
SELECT * FROM items WHERE category is null;
SELECT * FROM items WHERE price_in_€ is null;
SELECT * FROM items WHERE inventory is null;
/*
- only the item_id in the order_details table have nulls (137 in total)
- apparently item_id 133 was not recorded hence the nulls
*/

--5. replacing the nulls in the item_id column of the order_details table
UPDATE order_details
SET item_id = 133
WHERE item_id is null;

--6. Total number of items in each category
SELECT category, count(item) AS total_items
FROM items
GROUP BY category
ORDER BY total_items DESC;

--7. data range
SELECT CONCAT(MIN(order_date),' -- ',MAX(order_date)) AS date,
	CONCAT(MIN(order_time),' -- ',MAX(order_time)) AS time,
	CONCAT(MIN(order_id),' -- ',MAX(order_id)) AS order_id,
	CONCAT(MIN(item_id),' -- ',MAX(item_id)) AS item_id,
	CONCAT(MIN(quantity),' -- ',MAX(quantity)) AS quantity
FROM order_details;

--8. items with the lowest and Highest selling price
SELECT item,
	price_in_€
FROM items
JOIN (
    SELECT
        MAX(price_in_€) AS max_price,
        MIN(price_in_€) AS min_price
    FROM items) AS price_range
ON items.price_in_€ = price_range.max_price
	OR items.price_in_€ = price_range.min_price;

--9. Total inventory
SELECT SUM(inventory) AS total_inventory
FROM items;

--10. Total inventory by item category
SELECT category, SUM(inventory) AS inventory
FROM items
GROUP BY category
ORDER BY inventory DESC;

--11. Total orders so far
SELECT COUNT(DISTINCT(order_id)) AS total_orders
FROM order_details;

--12. Earliest and Latest order date
SELECT MIN(order_date) AS earliest_order_date,
	MAX(order_date) AS latest_order_date
FROM order_details;

--13. Total Ordered
SELECT SUM(quantity) AS total_ordered
FROM order_details;

--14. Total sales from orders
SELECT CONCAT('€ ',SUM(price_in_€*quantity)) AS sales
FROM order_details o
INNER JOIN items i
ON o.item_id=i.item_id;

--15. Total orders, ordered, sales, and inventory by item category
SELECT category,
	COUNT(DISTINCT(order_id)) orders,
	SUM(quantity) ordered,
	SUM(price_in_€*quantity) sales,
	SUM(inventory) inventory
FROM order_details o
INNER JOIN items i
ON o.item_id=i.item_id
GROUP BY category
ORDER BY ordered;

--16. Total orders, ordered, sales, and inventory by item and item category
SELECT i.item_id,
	item,
	category,
	COUNT(DISTINCT(order_id)) orders,
	SUM(quantity) ordered,
	SUM(price_in_€*quantity) sales,
	inventory
FROM order_details o
INNER JOIN items i
ON o.item_id=i.item_id
GROUP BY i.item_id,item,category, inventory
ORDER BY ordered DESC;

--17. orders by month
SELECT TO_CHAR(order_date, 'Month') AS month_name,
	COUNT(DISTINCT(order_id)) orders,
	SUM(quantity) ordered,
	SUM(price_in_€*quantity) sales
FROM order_details o
INNER JOIN items i
ON o.item_id=i.item_id
GROUP BY TO_CHAR(order_date, 'Month')
ORDER BY ordered DESC;

--18. orders by weekday
SELECT TO_CHAR(order_date, 'Day') AS day,
	COUNT(DISTINCT(order_id)) orders,
	SUM(quantity) ordered,
	SUM(price_in_€*quantity) sales
FROM order_details o
INNER JOIN items i
ON o.item_id=i.item_id
GROUP BY TO_CHAR(order_date, 'Day')
ORDER BY ordered DESC;

--19. orders by month also showing the weekday
SELECT TO_CHAR(order_date, 'Month') AS month_name,
	TO_CHAR(order_date, 'Day') AS Day,
	COUNT(DISTINCT(order_id)) orders,
	SUM(quantity) ordered,
	SUM(price_in_€*quantity) sales
FROM order_details o
INNER JOIN items i
	ON o.item_id=i.item_id
GROUP BY TO_CHAR(order_date, 'Month'), TO_CHAR(order_date, 'Day')
ORDER BY ordered DESC;

--20. average order quantity
SELECT i.item,
	SUM(quantity)/COUNT(DISTINCT(order_id)) AS average_order_quantity
FROM order_details o
INNER JOIN items i
	ON o.item_id=i.item_id
GROUP BY i.item;

--21. total orders by date
SELECT order_date,
	TO_CHAR(order_date, 'Day') AS day_of_week,
	COUNT(DISTINCT(order_id)) orders,
	SUM(quantity) ordered,
	SUM(quantity)/COUNT(DISTINCT(order_id)) AS average_order_quantity,
	SUM(price_in_€*quantity) sales
FROM order_details o
INNER JOIN items i
	ON o.item_id=i.item_id
GROUP BY order_date, TO_CHAR(order_date, 'Day')
ORDER BY ordered DESC;

--22. average price of items in each category
SELECT category,
	ROUND(AVG(price_in_€),2) avg_price
FROM order_details o
INNER JOIN items i
	ON o.item_id=i.item_id
GROUP BY category
ORDER BY avg_price DESC;

--23. top 10 items by sales
SELECT i.item,
	SUM(price_in_€*quantity) sales
FROM order_details o
INNER JOIN items i
	ON o.item_id=i.item_id
GROUP BY i.item
ORDER BY sales DESC
LIMIT 10;

--24. bottom 10 items by sales
SELECT i.item,
	SUM(price_in_€*quantity) sales
FROM order_details o
INNER JOIN items i
	ON o.item_id=i.item_id
GROUP BY i.item
ORDER BY sales ASC
LIMIT 10;

--25. oldest order
WITH oldest_order AS(
SELECT *
FROM order_details o
INNER JOIN items i
	ON o.item_id=i.item_id
WHERE order_date = (
	SELECT MIN(order_date) AS order_date
	FROM order_details)
)
SELECT order_date,
	order_time,
	TO_CHAR(order_date, 'Day') AS day,
	order_id,
	item,
	price_in_€,
	quantity,
	SUM(price_in_€*quantity) sales
FROM oldest_order
WHERE order_time = (
	SELECT MIN(order_time) AS order_time
	FROM oldest_order)
GROUP BY order_date, order_time, order_id, item, price_in_€, quantity;

--26. most recent order
WITH most_recent_order AS(
SELECT *
FROM order_details o
INNER JOIN items i
	ON o.item_id=i.item_id
WHERE order_date = (
	SELECT MAX(order_date) AS order_date
	FROM order_details)
)
SELECT order_date,
	order_time,
	TO_CHAR(order_date, 'Day') AS day,
	order_id,
	item,
	price_in_€,
	quantity,
	SUM(price_in_€*quantity) sales
FROM most_recent_order
WHERE order_time = (
	SELECT MAX(order_time) AS order_time
	FROM most_recent_order)
GROUP BY order_date, order_time, order_id, item, price_in_€, quantity;

--27. top 10 orders by total spending
SELECT order_id,
	order_date,
	order_time,
	COUNT(o.item_id) AS No_of_items,
	SUM(quantity) AS total_quantity,
	SUM(i.price_in_€*o.quantity) AS total_spending
FROM order_details o
INNER JOIN items i
	ON o.item_id=i.item_id
GROUP BY order_id, order_date, order_time
ORDER BY total_spending DESC
LIMIT 10;

--28. bottom 10 orders by total spending
SELECT order_id,
	order_date,
	order_time,
	COUNT(o.item_id) AS No_of_items,
	SUM(quantity) AS total_quantity,
	SUM(i.price_in_€*o.quantity) AS total_spending
FROM order_details o
INNER JOIN items i
	ON o.item_id=i.item_id
GROUP BY order_id, order_date, order_time
ORDER BY total_spending ASC
LIMIT 10;

--29. Display items along with their availability status
SELECT item,
	SUM(quantity) as quantity,
	inventory,
	CASE
		WHEN inventory <=0 THEN 'Out of Stock'
		WHEN inventory < 0.3 * SUM(quantity) THEN 'Very Low Stock'
		WHEN inventory < 0.5 * SUM(quantity) THEN 'Low Stock'
		WHEN inventory >= 3 * SUM(quantity) THEN 'Overstock'
		WHEN inventory >= 0.5 * SUM(quantity) THEN 'In Stock'
	END AS inventory_status
FROM order_details o
INNER JOIN items i
	ON o.item_id=i.item_id
GROUP BY item, inventory
--------------------------------------------------------------------------------

--PROGRAMMABILITY


--CREATING VIEWS

--1. orders view
CREATE OR REPLACE VIEW orders
AS
SELECT o.order_id,
	i.item,
	i.category,
	i.price_in_€,
	o.quantity,
	(i.price_in_€*o.quantity) AS sales_in_€
FROM order_details o
INNER JOIN items i
	ON o.item_id=i.item_id
ORDER BY order_id;

--2. order summary view
CREATE OR REPLACE VIEW order_summary
AS
SELECT o.order_id,
	COUNT(i.item_id) AS items_ordered,
	SUM(o.quantity) AS total_quantity,
	SUM(i.price_in_€*o.quantity) AS sales_in_€
FROM order_details o
INNER JOIN items i
	ON o.item_id=i.item_id
GROUP BY o.order_id
ORDER BY order_id;

--3. category sales view
CREATE OR REPLACE VIEW category_sales
AS
SELECT i.category,
	COUNT(order_id) AS orders,
	SUM(o.quantity) AS total_quantity,
	SUM(i.price_in_€*o.quantity) AS sales_in_€
FROM order_details o
INNER JOIN items i
	ON o.item_id=i.item_id
GROUP BY i.category
ORDER BY sales_in_€ DESC;
	
--4. top 10 orders view by total spending
CREATE OR REPLACE VIEW top_10_orders
AS
SELECT order_id,
	order_date,
	order_time,
	COUNT(o.item_id) AS No_of_items,
	SUM(quantity) AS total_quantity,
	SUM(i.price_in_€*o.quantity) AS total_spending
FROM order_details o
INNER JOIN items i
	ON o.item_id=i.item_id
GROUP BY order_id, order_date, order_time
ORDER BY total_spending DESC
LIMIT 10;
	
--5. price performance view
CREATE OR REPLACE VIEW price_performance
AS
SELECT item,
	i.price_in_€,
	COUNT(o.item_id) orders,
	SUM(quantity) ordered,
	SUM(i.price_in_€*o.quantity) AS sales_in_€
FROM order_details o
INNER JOIN items i
	ON o.item_id=i.item_id
GROUP BY i.item, i.price_in_€
ORDER BY ordered DESC;
--------------------------------------------------------------------------------

--CREATING PROCEDURES
--1. Procedure to insert new order details
CREATE OR REPLACE PROCEDURE insert_into_order_details(
	p_order_id INT,
	p_order_date DATE,
	p_order_time TIME,
	p_item_id INT,
	p_quantity INT
)
LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO order_details(order_id, order_date, order_time, item_id, quantity)
	VALUES(p_order_id, p_order_date, p_order_time, p_item_id, p_quantity);
END;
$$;

--testing procedure
BEGIN;
CALL insert_into_order_details(5371,'02/04/2023', '09:06:16',101,2);
ROLLBACK;
--------------------------------------------------------------------------------

--2. Procedure to update the price of an item
CREATE OR REPLACE PROCEDURE update_item_price(p_item_id INT, p_price_in_€ DECIMAL(6,2))
LANGUAGE SQL
AS $$
	UPDATE items
	SET price_in_€ = p_price_in_€
	WHERE item_id = p_item_id
$$;

--testing procedure
BEGIN;
CALL update_item_price(101, 1.05);
ROLLBACK;
--------------------------------------------------------------------------------


-- CREATING FUNCTIONS
/*1. Funtion to return items and thier prices based on specific characters in their names
	example: returning items that have 'paper' in their name*/
CREATE OR REPLACE FUNCTION search_items(word VARCHAR(50))
RETURNS TABLE (
    item_id INT,
    item VARCHAR(150),
    price DECIMAL(6,2)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT i.item_id, i.item, i.price_in_€ AS price
    FROM items i
    WHERE i.item ILIKE '%' || word || '%'
    ORDER BY i.item_id ASC;
END;
$$;

--searching for items have the word 'book' in their names
SELECT * FROM search_items('book');
-- returned 2 items (Notebook and Notebook Paper)
--------------------------------------------------------------------------------

--2. Function to calculate the total spending of an order
CREATE OR REPLACE FUNCTION total_spending(order_id INT)
RETURNS DECIMAL(10,2)
LANGUAGE SQL
AS $$
    SELECT SUM(i.price_in_€ * o.quantity)
    FROM order_details o
    INNER JOIN items i ON
	o.item_id = i.item_id
    WHERE o.order_id = total_spending.order_id;
$$;

--calculating the total spending of order with id 2
SELECT total_spending(2);
--returned 95.31 €
--------------------------------------------------------------------------------


--CREATING TRIGGERS
/*1. trigger that automatically updates the inventory of an item in the items table
whenever a new order is placed in the order_details*/
CREATE OR REPLACE FUNCTION update_inventory_trigger_function()
RETURNS TRIGGER AS $$
BEGIN
    -- Decrease the inventory of the item in the items table
    UPDATE items
    SET inventory = inventory - NEW.quantity
    WHERE item_id = NEW.item_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER update_inventory_trigger
AFTER INSERT ON order_details
FOR EACH ROW
EXECUTE FUNCTION update_inventory_trigger_function();

--testing trigger
BEGIN; -- transaction so we can rollback changes made to the database
CALL insert_into_order_details(5371,'02/04/2023', '09:06:16',101,2)
ROLLBACK;


--select*from order_details order by order_details_id desc;
--select*from items;
