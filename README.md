# Sales Analysis Database

## Overview
This project is an intermediate-level SQL database for an e-commerce store, designed to track customers, products, orders, and reviews. It showcases skills in schema design, normalization, triggers, stored procedures, and complex queries for sales analysis.

## Features
- **Schema**: Normalized tables for customers, products, orders, order details, and reviews.
- **Triggers**: Automatically update stock quantity when orders are placed.
- **Stored Procedures**: Generate sales reports for a given date range.
- **Queries**: Top-selling products, average product ratings, and more.
- **Indexes**: Optimized for fast searches on customer email, product name, and order date.

## Setup
1. Install MySQL (or use a cloud service like MySQL Workbench).
2. Run the `sales_analysis_database.sql` script to create and populate the database.
3. Use a SQL client to execute queries or procedures.

## ER Diagram
[Include an ER diagram image here, created using tools like Draw.io]

## Sample Queries
- Top 5 products by revenue.
- Average rating per product.

## Tech Stack
- MySQL
- SQL

## How to Run
1. Clone this repository: `git clone https://github.com/rafay79/sales_analysis_database.git`
2. Import `sales_analysis_database.sql` into MySQL.
3. Test queries using a SQL client.

## Future Improvements
- Add a frontend (e.g., Flask or Node.js) for visualization.
- Implement user authentication for secure access.
- Export reports to CSV/JSON.
