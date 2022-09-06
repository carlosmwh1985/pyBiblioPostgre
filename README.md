# pyBiblioPostgre

A small `Python` set of modules, in order to connect to a PostgreSQL Data Base to add and modify entries, which belongs to my personal library.



## Some Historical Notes

I always loved to read, and books, and codding! After a while my personal library started to grow and I wanted to keep track of all my books and to whom I loaned them. That's why I decided to make a small database with all my titles.

The original DB that I developed back in 2000 was made in an old version of MS-Access, in a `mdb` format. All the information was in spanish.

It was migrated later to SQL using `mdb-schema`. So most of the table schemas used here come from such old schema, with some modifications.



## Requirements

For the `Python` modules:
- `psycopg`
- `pandas`
- `numpy`

For the Data Base:
- `PostgreSQL`

The connection string should be stored in:
- `src/dbConnection/.config/database.ini`
- The file should have:
    - The host
    - The database name
    - The user name
    - The password
    - Any other required information to login to the DB



## Setup

```shell
git clone https://github.com/carlosmwh1985/pyBiblioPostgre.git
```



## Running

in the `main` function of the `addBooks` module, the path and the name of the `CSV` file, which contains all book entries, should be specified in the `input_file` variable.

The requiered fields are (the names are in spanish):
- `Id`           : The book catalog Id. For example `'813 H27d1`
- `Titulo`       : The book title. For example: `'Dune' `
- `Autor`        : The book author. For example: `'Herbert, Frank'`
- `Editorial`    : THe book editor. For example: `'Ace'`
- `Pags`         : The number of pages. For example: `884`
- `ISBN`         : Well... The ISBN (useful to check if an entry is repeated). For example: `'978-0-441-17271-9'`
- `Ejemplares`   : The number of copies. For example: `1`
- `Leido`        : A checkbox, to indicate if the book as already red. For example: `1`, or `t` or `true`
- `Observaciones`: Some remarks. It is a string.

Some remarks:
- Before a book is added, the author and the editor are saved in separated tables, and only the `id`s are saved in the book table, as a foreign key.
- The `author_id`, `editor_id`, `book_id` (catalogation) and the `isbn` are used all together to check if a book entry is already present in the Data Base
- Once the module is ran, it will save the comple list of books in a single file: `data/all_books.csv`, where the `id` in the DB is specified.



## The Data Base

In order to develop this module, I considered the following tables:

- `tbllibros`: a table with all the books
- `tblautores`: a table with all the authors
- `tbleditoriales`: a table with all the editors



### Author Table Schema

```sql
CREATE TABLE tblAutores (
    id              SERIAL PRIMARY KEY,
    nombre          varchar(255) NOT NULL,
    apellido        varchar(255) NOT NULL,
    nacionalidad    varchar(100)
);
```



### Editors Table Schema

```sql
CREATE TABLE tblEditoriales (
    id              SERIAL PRIMARY KEY,
    nombre          varchar(255)
);
```



### Authors Table Schema

Here 2 separated schemas were generated, in case that more than one book table were required:

```sql
CREATE TABLE tblBookFields (
    id              SERIAL PRIMARY KEY UNIQUE,
    libro_id        varchar(20),
    titulo          text,
    autor_id        int,
    editorial_id    int,
    pags            int,
    isbn            varchar(21),    -- Based on the present standard + Extras, some have very large values
    ejemplares      int,
    FOREIGN KEY (autor_id)
        REFERENCES tblAutores(id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (editorial_id)
        REFERENCES tblEditoriales(id)
        ON UPDATE CASCADE ON DELETE CASCADE
);
```

and

```sql
CREATE TABLE tblLibros (
    leido           boolean,
    observaciones   text
) INHERITS (tblBookFields);
```


### PostgreSQL

In the Data Base, after creating the superuser, an user for the module should be created along with the database in POstgreSQL. For example, if the name of the user is `pyclient` and the name of the database is `db_books`, one can used the following commands:

```sql
CREATE USER pyclient PASSWORD <password>;
CREATE DATABASE db_books WITH OWNER <superuser_name>;
GRANT ALL PRIVILEGES ON DATABASE db_books TO pyclient;
```

Finally, in order to have access to the actual tables inside the database:

```sql
GRANT SELECT, INSERT, UPDATE ON
    tbllibros, tblautores, tbleditoriales
    TO pyclient;

GRANT SELECT, UPDATE ON
    tblautores_id_seq, tbleditoriales_id_seq, tblbookfields_id_seq
    TO pyclient;
```