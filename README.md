Ernest's Paper Co. seeks to enhance its understanding of customer preferences, improve inventory management practices, and optimize sales strategies to better meet the needs of its target audience.


# Stationery-Orders
## This project focuses on analyzing sales data from an online store that specializes in selling stationery items in Germany. The data used for this analysis was adapted from [Maven Analytics Playground](https://mavenanalytics.io/data-playground?search=resta), with modifications made to tailor it specifically to the stationery sales domain.

## Project Background
Ernest's Paper Co. is a German e-stationery store meeting the ongoing demand for traditional stationery items in today's digital era. Stationery remains vital in educational and office environments, aiding learning, communication, and organization. Despite digital alternatives, stationery offers tangible benefits and versatility, complementing digital tools with its tactile nature.

The project aims to analyze stationery sales data to uncover trends, customer behavior, and inventory management insights. By leveraging data analysis, the company seeks to improve understanding of customer preferences, enhance inventory management, and optimize sales strategies for better customer satisfaction.

## Data Overview
The original data, which featured restaurant orders, was transformed to suit the stationery sales context. This involved replacing food items with stationery items, adjusting prices, and introducing inventory management metrics. It's important to note that while the data is fictitious, it mirrors real-world scenarios commonly encountered in e-commerce settings.

The data consists of two main tables: Order_Details and Items.

**Order_Details Table:**
This table contains comprehensive information about each order placed on the e-commerce platform.
Key fields include:
- order_details_id: A unique identifier for each order detail.
- order_id: The unique identifier for each order.
- order_date: The date when the order was placed.
- order_time: The time when the order was placed.
- item_id: The identifier of the stationery item purchased.
- quantity: The quantity of the stationery item purchased in the order.
  
**Items Table:**
This table provides detailed information about the stationery items available for sale on the platform.
Key fields include:
- item_id: A unique identifier for each stationery item.
- item: The name or description of the stationery item.
- category: The category or type of the stationery item.
- price_in_€: The price of the stationery item in Euro (€).
- inventory: The current stock level or inventory count of the stationery item.

***Note:** I have included both the csv files and sql scripts of both tables in this repository*

**Code to import the csv file(s) into their respective table:** \COPY table_name FROM '/path/to/your/file.csv' DELIMITER ',' CSV HEADER;

By leveraging the information contained in these two tables, the project aims to gain insights into stationery sales trends, customer behavior, and inventory management practices within the e-stationery store. Analysis of this data will enable the identification of patterns, opportunities for optimization, and potential areas for expansion, ultimately contributing to the enhancement of the store's operational efficiency and customer satisfaction.

## Tools and Technologies Used
For this project, several tools and technologies were employed to efficiently manage and analyze the stationery data:

**1. ChatGPT:** ChatGPT was utilized to generate stationery data based on specific requirements and specifications. ChatGPT's natural language generation capabilities allowed me to create synthetic data tailored to the project needs.

**2. Microsoft Excel:** To transform and organize the generated data, I relied on Microsoft Excel. Excel's versatile features enabled me to manipulate and structure the data effectively, ensuring it was ready for further analysis.

**3. PostgreSQL:** For Exploratory Data Analysis (EDA), data quality checks, and maintaining data integrity, I leveraged PostgreSQL. Its robust querying capabilities and support for complex data operations made it an ideal choice for processing and analyzing the growing data.

**4. Power BI:** To visualize the insights derived from the data and create informative reports and dashboards, I utilized Power BI. Power BI's interactive visualizations allowed me to present key findings in a compelling and understandable manner, enabling effective communication of insights to stakeholders.

By leveraging these tools and technologies, I was able to efficiently manage, analyze, and visualize the stationery data, ultimately deriving valuable insights to inform decision-making and drive project outcomes.

## Project Workflow
Having a project workflow is crucial as it provides structure and clarity to the tasks, ensuring efficient execution and organization of the project's components. Additionally, it facilitates documentation of the process, enabling transparency, reproducibility, and future reference. The workflow for this project is given below:

![](https://github.com/Ernestug/Staionery-Orders/blob/main/images/Project%20Workflow.jpg)

## Continuous Improvement:
As the dataset is growing, it's essential to establish mechanisms for data integrity, regularly updating and refreshing the data to reflect the latest sales transactions and inventory levels. Conduct periodic reviews and performance evaluations to assess the effectiveness of implemented strategies and make necessary adjustments to improve outcomes.

By leveraging PostgreSQL for data Exploratory Data Analysis (EDA) and Power BI for visualization, this project aims to provide actionable insights that drive business growth and enhance the overall efficiency of the online stationery store's operations.

## Report
### Database Creation
Because the data is large and expected to grow, I made a database for the store using PostgreSQL. The database has two tables: order_details and items (see Data Overview section for more about the tables). Constraints were added when creating these tables. In SQL, constraints help keep data accurate and consistent in a database. Here are some of the constraints used in making the E_Stationery_Store database:

- **SERIAL:** It’s a data type, which automatically generates unique integer values for new rows. That is whenever you want to insert new values in to the order_details table, the order_details_id automatically generates a new id.
- **DEFAULT:** The DEFAULT constraint specifies a default value for the column when no explicit value is provided during insertion
- **TO_DATE:** Its used to convert string values to date
- **PRIMARY KEY:** The PRIMARY KEY constraint is applied to the order_details_id and item_id columns in the order_details and items tables respectively. They serve as the primary keys for their respective tables. This constraint ensures that each value in these columns are unique and not null, uniquely identifies each row in their tables.
- **NOT NULL:** This constraint ensures that every row in the specified column must have a valid value, and it cannot contain null values. This constraint helps maintain data integrity by requiring that this column always contains meaningful data.

After creating the database, and the required tables, the next thing I did was to insert values into the tables. Remember I said I modified the data to fit the e-stationery store context. SQL allows insertion of Comma Separated Values (CSV). What I did to save time, was copy and paste the values into the INSERT syntax (Check repository for the script).

### Entity Relationship Diagram (ERD)
A database needs an Entity-Relationship Diagram (ERD) to be fully understood. This diagram displays how data is arranged and connected in the database, helping to see the links between tables and grasp the database's layout. The ERD is important because it gives a straightforward and clear picture of how the database is structured. The below ERD was created using PostgreSQL ERD tool.
![](https://github.com/Ernestug/Staionery-Orders/blob/main/images/ER%20Diagram.pgerd.png)

### Exploratory Data Analysis (EDA)
I picked SQL for my EDA because it lets me talk to my data (through queries), and then my data talks back to me (with results). Before I started writing queries, I made a list of the things I wanted to learn from the data. Then, I wrote queries based on that list. Here are some of the queries I wrote and what I learned from them:

- **Query to view the tables present in the E_Stationery_Store database:** The order_details table (Fact Table) has 2,234 rows, and 6 columns (order_details_id, order_id, order_time, item_id, quantity). While the items table (Dimension Table) has 33 rows, and 5 columns (item_id, item, category, price_in_€, inventory)
- **Query to check for duplicates in tables:** So, this is something I like doing every time, to avoid wrong insights. Its always good to check for and remove duplicates if any. There were no duplicates in both tables.
- **Query to check for nulls/missing values:** I checked both tables for nulls, and discovered that the item_id column in the order_details table had over 25 null values. Apparently, item_id 133 was not recorded hence the nulls. Using the UPDATE syntax, I replaced the nulls with 133. In case you are wondering how I got to know that item_id 133 was not recorded in the order_details table, I checked the unique ids in the items table, and saw that it ranged from 101 – 133, then I checked the unique item_ids in the order_details table, and discovered that item_id 133 was never recorded.
- **Query to return items with the lowest and highest selling price:** Eraser has the lowest selling price of 0.49€, while Whiteboard has the highest selling price of 19.99€.
- **Query to return the earliest and latest order date:** The earliest order date is simply the first date in the database record which was the January 1, 2013, while the latest order date is the last date in database record, which was March 31, 2013.
- **Query to return the sales summary by the date:** I wanted to see the total orders that came in, the total quantity ordered, the average order quantity, and the revenue generated for each day. I sorted the result by the quantity ordered in descending order to see which day the store the sold had high demand by quantity.
- **Query to return the best and least 10 selling items by sales:** The best 10 items by sales featured whiteboard, desk organizer, binder, and calculator. While the least 10 featured eraser, glue stick, paper clips, tape, and rubber bands. 

[Check script for other queries](https://github.com/Ernestug/Staionery-Orders/blob/main/Stationery%20orders%20(EDA).sql)

### Programmability
In simple terms, programmability in SQL means being able to write programs, functions, and scripts in SQL that can do things automatically, like doing math or changing data in a database. This database uses features like views, functions, stored procedures, and triggers for programmability. Using these features can help the store work faster, make fewer mistakes, and make their database work better overall.

**1. Views**
A view is a virtual table that is based on the result set of a SELECT statement. A view does not store data, but rather, it provides a way to access and manipulate data from one or more tables in a database. A view can be used to simplify complex queries, to provide a security layer to restrict access to certain data.
- Orders View
- Order Summary View
- Category Sales View
- Best 10 Orders by total spending View
- Item’s Price Performance View

**2. Procedures**
Procedures are a set of SQL statements that are compiled and stored in a database. Procedures can be reused multiple times without having to recompile the SQL statements each time. Below are the procedures written for the store’s database to help the store access information quickly
- Procedure to insert new order details
- Procedure to update the price of an item

**3. Functions**
A function is a stored program that performs a specific task and returns a value or a set of values. Functions can take input parameters, process the input data, and return a result based on the specified logic.
- Function to return items and their prices based on specific characters in their names
- Function to calculate the total spending of an order

**4. Triggers**
A trigger is a set of actions that automatically execute in response to certain events, such as data modifications, database operations, or system events. Triggers can be used to maintain data integrity, and automate certain tasks.
- Trigger that automatically updates the inventory of an item in the items table whenever a new order is placed in the order_details

The ROLLBACK command was used to cancel the changes made to the database during testing of procedures and triggers. To start a transaction, you use the BEGIN keyword. You can choose to either save changes with COMMIT or cancel changes with ROLLBACK. So, when practicing, it's a good idea to use the ROLLBACK command if you're testing triggers or procedures.

### Visualization
When it comes to reporting your analysis to your audience, visualization is very important. I understand that not everyone can understand complicated codes, so I used Power BI to show my findings, because of its friendly user-interface and diverse functionalities. I connected to the store’s database (Power BI allows you connect to over a 100 data sources, including SQL databases).
To help with my analysis, I created additional columns and tables, using both DAX and the Power Query Editor. Below are the some of the created columns and Tables:

**1. Columns:**
- Hour
- Period of Day
- Availability Status
  
**2. Tables:**
- **Calendar Dim:** A calendar table was created give the date an extensive hierarchy.
- **Inventory Level:** Using the GROUPBY DAX function in Power BI, I was able to create another table to show items and their inventory levels. This helped in showing items that are low in stock and need a restock.
- **Order Combination:** The main purpose of creating this table was to see how different orders combine items ordered (see market basket analysis). This table involved a lot of steps in the Power Query Editor (See file for the M Query Code). Please note that the Power Query Editor automatically writes/generates these codes based on the steps applied in the editor.

### Data Model
The data model below was created in Power BI, to connect related tables.

### DAX Measures
The Model view in Power BI, also displays the measures created. To keep my DAX measures organized, I created 4 tables (Summary, Previous Month, Current Month, and Variance), then grouped the measures in their respective tables.

### Key Insights from Visualization
(Dictionary: PM – Previous Month, CM – Current Month)
Interact with report here.

- The card visuals helped in giving a general summary of the store’s activities, as shown below.

It was observed that more than 5,000 orders were placed, totaling over 40,000 items ordered, resulting in a revenue of more than 150,000 Euros (€).
- Even though March has more days than February, and even though there were a lot of orders in March, February made more money. The store got more orders in the afternoon and evening compared to the morning.
- It was observed that when more items were ordered, the total amount spent on the order increased, as demonstrated below.
- The shop might lose money and customers if restocking doesn't happen soon. Some of the top 5 selling items will run out of stock soon.
- It was observed that items in the Organization and Writing sections are in high demand, and many of them are running low on stock and may soon be unavailable.

### Conclusion
It's important for the store to anticipate and address customer demand effectively to ensure profitability and customer satisfaction. This involves taking proactive measures such as ensuring timely restocking of inventory to avoid stockouts and meet customer needs promptly. Additionally, prioritizing popular items in categories where demand is high allows The store to allocate resources efficiently and capitalize on market trends. By staying ahead of customer demand and strategically managing inventory, the store can maintain profitability and enhance the overall customer experience.
### Recommendation
- Implement a loyalty program to reward returning customers, especially those who frequently order in large quantities. Offer discounts, special deals, or exclusive perks to encourage repeat purchases and enhance customer loyalty.
- Prioritize restocking items with low and very low stock levels to ensure availability for customers. Monitor inventory levels closely and adjust ordering patterns to prevent overstocking while ensuring popular items remain in stock.
- Invest in data collection and analysis tools to gather more information about customer demographics and purchasing behaviors.
