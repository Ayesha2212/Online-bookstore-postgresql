DROP TABLE IF EXISTS Books;
CREATE TABLE Books(
	Book_ID SERIAL PRIMARY KEY,
	Title VARCHAR(100),
	Author VARCHAR(100),
	Genre VARCHAR(50),
	Published_Year INT,
	Price NUMERIC(10,2),
	Stock INT
);
DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers(
	Customer_ID SERIAL PRIMARY KEY,
	Name VARCHAR(100),
	Email VARCHAR(100),
	Phone VARCHAR(15),
	City VARCHAR(100),
	Country VARCHAR(100)
);
DROP TABLE IF EXISTS BookOrders;
CREATE TABLE BookOrders(
	Order_ID SERIAL PRIMARY KEY,
	Customer_ID INT REFERENCES Customers(Customer_ID),
	Book_ID INT REFERENCES Books(Book_ID),
	Order_Date DATE,
	Quantity INT,
	Total_Amount NUMERIC(10,2)
);
SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM  BookOrders;	

-- Import data into books table(DIRECT METHOD)
-- Import data into customers table
-- import data into orders table

-- 1. Retrieve all books in the fiction genre:
SELECT * FROM Books
WHERE Genre='Fiction';

-- 2. Find books published after the year 1950:
SELECT * FROM Books
WHERE Published_year>1950;

-- 3. List all customers from Canada:
SELECT * FROM Customers
WHERE Country='Canada';

-- 4. Show orders placed in November 2023:
SELECT * FROM BookOrders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5. Retrieve total stocks of books available:
SELECT SUM(stock) AS Total_stock
FROM Books;

-- 6. Find details of the most expensive book:
SELECT * FROM Books ORDER BY Price DESC
LIMIT 1;

-- 7. Show all customers who ordered more than 1 quantity of a book:
SELECT * FROM BookOrders
WHERE Quantity>1;

-- 8. Retrieve all orders where total amount exceeds $20:
SELECT * FROM BookOrders
WHERE total_amount>20;

-- 9. List all genres available in the books table:
SELECT DISTINCT Genre FROM Books;

-- 10. Find book with lowest stock:
SELECT * FROM Books
ORDER BY stock LIMIT 5;

-- 11. Calculate total revenue generated from all orders:
SELECT SUM(Total_Amount) AS Total_revenue
FROM BookOrders;

-- 12. Retrieve total number of books sold for each genre:
SELECT b.Genre,SUM(o.Quantity) AS Books_sold
FROM BookOrders o
JOIN Books b 
ON o.Book_ID = b.Book_ID
group by b.Genre;

-- 13. Find the average price of books in the fantasy genre:
SELECT AVG(Price) AS Avg_price
FROM Books
WHERE Genre='Fantasy';

-- 14. List customers who have placed atleast 2 orders:
SELECT Customer_ID, COUNT(Order_ID) AS Order_Count
FROM BookOrders
GROUP BY Customer_ID
HAVING COUNT(Order_ID) >=2;
--join method
SELECT o.Customer_ID, c.Name,COUNT(o.Order_ID) AS Order_Count
FROM BookOrders o
JOIN Customers c
ON o.Customer_ID=c.Customer_ID
GROUP BY o.Customer_ID,c.Name
HAVING COUNT(Order_ID) >=2;

-- 15. Find the most frequently order book:
SELECT Book_ID, COUNT(Order_ID) AS Order_Count
FROM BookOrders
GROUP BY Book_ID
ORDER BY Order_Count DESC LIMIT 3;
--join method
SELECT o.Book_ID, b.Title, COUNT(o.Order_ID) AS Order_Count
FROM BookOrders o
JOIN Books b 
ON o.Book_ID=b.Book_ID
GROUP BY o.Book_ID,b.Title
ORDER BY Order_Count DESC LIMIT 3;

-- 16. Show top 3 most expensive books of Fantasy Genre:
SELECT * FROM Books
WHERE Genre = 'Fantasy'
ORDER BY Price DESC LIMIT 3;

-- 17. Retrieve the total quantity of books sold by each author:
SELECT b.author, SUM(o.Quantity) AS Total_books_sold
from BookOrders o
JOIN Books b 
ON o.Book_ID=b.Book_ID
GROUP BY b.author;

-- 18. List cities where customers spent over $30 are located:
SELECT DISTINCT c.City,o.Total_Amount
FROM BookOrders o
JOIN Customers c 
ON c.Customer_ID=o.Customer_ID
WHERE o.Total_Amount>30;

-- 19. Find the customers who spent the most on orders:
SELECT C.Customer_ID,c.Name,SUM(o.Total_Amount) AS Total_Spent
FROM Customers c
JOIN BookOrders o
ON c.Customer_ID=o.Customer_ID
GROUP BY c.Customer_ID,c.Name
ORDER BY Total_Spent DESC LIMIT 1;

-- 20. calculate the stock remaining after fulfilling all orders:
SELECT b.Book_ID,b.Title,b.Stock, COALESCE(SUM(Quantity),0) AS Order_quantity,
						b.stock - COALESCE(SUM(Quantity),0) AS Remaining_quantity 
FROM Books b
LEFT JOIN BookOrders o
ON b.Book_ID=o.Book_ID
GROUP BY b.Book_ID ORDER BY b.Book_ID ASC;



