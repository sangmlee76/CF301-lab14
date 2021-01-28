# CF301-lab14
Lab 14 - Database Normalization


## Database Migration

Query 1: `CREATE TABLE AUTHORS (id SERIAL PRIMARY KEY, name VARCHAR(255));`

+ This query will create a second table in the `lab14_normal` database named `authors`. Confirm the success of this command by typing `\d authors` in your SQL shell. You should see the authors table schema, as shown above.

Query 2: `INSERT INTO authors(name) SELECT DISTINCT author FROM books;`

+ This query will use a simple subquery to retrieve unique author values from the books table and insert each one into the authors table in the name column. This is a great pattern for copying lots of data between tables.
+ Confirm the success of this command by typing `SELECT COUNT(*) FROM authors;` in your SQL shell. The number should be greater than zero.

Query 3: `ALTER TABLE books ADD COLUMN author_id INT;`

+ This query will add a column to the books table named `author_id`. This will connect each book to a specific author in the other table.
+ Confirm the success of this command by typing `\d books` in your SQL shell. The table schema should now include a column for `author_id`, in addition to the column for the string `author`; the `author` column will be removed in Query 5.

Query 4: `UPDATE books SET author_id=author.id FROM (SELECT * FROM authors) AS author WHERE books.author = author.name;`

+ This query will prepare a connection between the two tables. It works by running a subquery for every row in the `books` table. The subquery finds the author row that has a `name` matching the current book’s `author` value. The `id` of that author row is then set as the value of the `author_id` property in the current book row.
+ Confirm the success of this command by typing `SELECT author_id FROM books;` in your SQL shell. The result should display a column containing the unique ids for the authors. The numbers should match the total number returned from Query 2 when you confirmed the success of the insertion of names into the authors table.

Query 5: `ALTER TABLE books DROP COLUMN author;`

+ This query will modify the books table by removing the column named `author`. Now that the books table contains a `author_id` column which will become a foreign key, your table does not need to contain a string representing each author.
+ Confirm the success of this command by typing `\d books` in your SQL shell. The books table schema should be updated to reflect the schema provided above, without the `author` column.

Query 6: `ALTER TABLE books ADD CONSTRAINT fk_authors FOREIGN KEY (author_id) REFERENCES authors(id);`

+ This query will modify the data type of the `author_id` in the books table, setting it as a foreign key which references the primary key in the authors table. Now PostgreSQL knows HOW these 2 tables are connected.
+ Confirm the success of this command by typing `\d books` in your SQL shell. You should see details about the foreign key constraints, as shown in the schema above.

****

## Stretch Goal: Modify the existing book app code base (if you choose to normalize your actual book app database)

Your code will need to be modified in several ways now that the data is being retrieved from two tables. Some of the following items will need to be changed, depending on how your server and EJS files are structured.

### In the server code:
+ Your query to view the details of a single book will need to request information from both the books table and the authors table. This should be done as a single JOIN query.
+ If you have a query to request the authors from the books table, it will now need to request `name` of rows from the `authors` table.
+ Your query to add a single book might need to create records in both tables. Ensure a author doesn’t already exist before adding to the authors table!

### In the EJS files:
+ Any reference to the `author` from the `books` table will now need to refer to the `name` of the shelf from the `authors` table.