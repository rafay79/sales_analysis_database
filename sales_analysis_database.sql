Create Database sales_analysis
use sales_analysis;

create TABLE customers(
customer_id INT PRIMARY KEY
auto_increment,
first_name varchar(50) not null,
last_name varchar(50) not null,
email varchar(100) UNIQUE,
phone varchar(20),
address Text,
created_at timestamp default
current_timestamp
);

SELECT * FROM customers;

CREATE Table products(
 product_id INT PRIMARY KEY
 auto_increment,
 product_name VARCHAR(100) NOT NULL,
 description TEXT,
 price Decimal(10,2),
 stock_quantity INT NOT NULL DEFAULT 0,
 created_at TIMESTAMP DEFAULT
 CURRENT_TIMESTAMP,
 CHECK(price>=0),
 CHECK(stock_quantity >=0)
 );

create table orders(
order_id int primary key auto_increment,
customer_id int,
order_date timestamp default
current_timestamp,
total_amount decimal(10,2) NOT NULL
DEFAULT 0.00,
status enum('pending','completed','cancelled') DEFAULT 'pending',
Foreign key (customer_id) references customers(customer_id) ON DELETE SET NULL);

create table order_details(
order_detail_id INT PRIMARY KEY
AUTO_INCREMENT,
order_id INT,
product_id INT,
quantity INT not null,
unit_price decimal(10,2) not null,
subtotal decimal(10,2) Generated
always as (quantity * unit_price) STORED,
Foreign key(order_id) references orders(order_id) ON DELETE CASCADE,
FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE SET NULL,
CHECK( quantity > 0)
);

create table reviews(
review_id INT PRIMARY KEY
AUTO_INCREMENT,
customer_id INT,
product_id INT,
rating INT NOT NULL CHECK(rating BETWEEN 1 AND 5),
comment TEXT,
review_date TIMESTAMP DEFAULT
CURRENT_TIMESTAMP,
FOREIGN KEY(customer_id) REFERENCES customers(customer_id) ON DELETE SET NULL,
FOREIGN KEY(product_id) REFERENCES products(product_id) ON DELETE SET NULL
);

CREATE INDEX idx_cus_email ON customers(email);
CREATE INDEX idx_prod_name on products(product_name);
CREATE INDEX idx_order_data on orders(order_date);


DELIMITER //
CREATE TRIGGER after_order_detail_insert
AFTER INSERT ON order_details
FOR EACH ROW
BEGIN
    UPDATE products
    SET stock_quantity = stock_quantity - NEW.quantity
    WHERE product_id = NEW.product_id;
END //
delimiter ;

DELIMITER //
CREATE PROCEDURE GetSalesReport(
IN start_date DATE,
IN end_date DATE
)
BEGIN
	SELECT
		p.product_name,
        SUM(od.quantity) AS total_units_sold,
        SUM(od.subtotal) AS total_revenue
        
FROM order_details od
JOIN products p ON od.product_id = p.product_id
JOIN orders o ON od.order_id = o.order_id
WHERE o.order_date BETWEEN start_date and end_date
	AND o.status = 'completed'
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC;
END //
DELIMITER ;

-- Sample data insertion
INSERT INTO customers (first_name, last_name, email, phone, address) VALUES
('Ali', 'Khan', 'ali.khan@example.com', '0300-1234567', 'Karachi, Pakistan'),
('Sara', 'Ahmed', 'sara.ahmed@example.com', '0312-9876543', 'Lahore, Pakistan');

INSERT INTO products (product_name, description, price, stock_quantity) VALUES
('Laptop', 'High-performance laptop', 999.99, 50),
('Smartphone', 'Latest model smartphone', 499.99, 100);

INSERT INTO orders (customer_id, total_amount, status) VALUES
(1, 1499.98, 'completed'),
(2, 499.99, 'pending');

INSERT INTO order_details (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 999.99),
(1, 2, 1, 499.99),
(2, 2, 1, 499.99);

INSERT INTO reviews (customer_id, product_id, rating, comment) VALUES
(1, 1, 5, 'Amazing laptop, very fast!'),
(2, 2, 4, 'Good phone, but battery could be better.');


SELECT 
    p.product_name,
    SUM(od.quantity) AS units_sold,
    SUM(od.subtotal) AS total_revenue
FROM order_details od
JOIN products p ON od.product_id = p.product_id
JOIN orders o ON od.order_id = o.order_id
WHERE o.status = 'completed'
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC
LIMIT 5;

-- Sample query: Average rating per product
SELECT 
    p.product_name,
    AVG(r.rating) AS average_rating,
    COUNT(r.review_id) AS review_count
FROM reviews r
JOIN products p ON r.product_id = p.product_id
GROUP BY p.product_id, p.product_name
HAVING review_count > 0;


