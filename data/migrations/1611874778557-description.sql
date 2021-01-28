

/*********************************************************/
/*********** Database Migration: 1611874778557 ***********/
/*********************************************************/

-- Query 1: This will create a second table in the normalized database named authors.
CREATE TABLE authors (id SERIAL PRIMARY KEY, name VARCHAR(255));

-- Query 2: This will use a subquery to retrieve unique author values from the books table and insert each one into the authors table in the 'name' column
INSERT INTO authors(name) SELECT DISTINCT author FROM books;

-- Query 3: This will add a column to the books table named 'author_id'. This will connect each book to a specific author in the author's table.
ALTER TABLE books ADD COLUMN author_id INT;

-- Query 4: This will prepare a connection between the two tables. It runs a subquery for each row in the 'books' table which finds the author row that has a 'name' matching the current book's 'author' value. The 'id' of that author row is then set as the value of the 'author_id' property in the current book row.
UPDATE books SET author_id=author.id FROM (SELECT * FROM authors) AS author WHERE books.author = author.name;

-- Query 5: This will modify the books table by removing the column named 'author'. Because the books table now contains a 'author_id' column (a foreign key), the table does not need an author column with string values for each author.
ALTER TABLE books DROP COLUMN author;

-- Query 6: This will modify the data type of the 'author_id' in the books table, setting it as a foreign key which references the primary key in the authors table. (Note: this is *how* PSQL knows these 2 tables are connected)
ALTER TABLE books ADD CONSTRAINT fk_authors FOREIGN KEY (author_id) REFERENCES authors(id);