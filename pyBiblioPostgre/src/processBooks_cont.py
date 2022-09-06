from csvFiles import *
from dbConnection.connection import *

import numpy as np

sql = """INSERT INTO tbllibrospapidaniel(libro_id, titulo, autor_id, editorial_id, pags, isbn, ejemplares, leido)
    VALUES(%(lid)s, %(titulo)s, %(aid)s, %(eid)s, %(pags)s, %(isbn)s, %(numl)s, %(readed)s)
    RETURNING id;"""

# Files to read
files = ['data/data_tblLibrosPapiDaniel.csv']

# Columns to consider
to_read = ['id', 'titulo', 'autor', 'editorial', 'pags',
    'isbn', 'ejemplares', 'leido']

read_authors = ['autor', 'aut_nombre', 'aut_apellido', 'db_id']
read_editorials = ['editorial', 'db_id']

db_editorial = 'data/all_editorials.csv'
db_authors = 'data/all_author_names.csv'

edit_id = 'edit_id'
aut_id = 'aut_id'

def find_id(df_db, col, val):
    listPos = list()
    result = df_db.isin([val])
    df = result.any()
    rows = list(result[col][result[col] == True].index)
    return rows[0]

def add_ids(df, df_ids, col_name, new_col):
    df[new_col] = np.nan
    for index in df.index:
        val0 = str(df.loc[index, col_name])
        row = find_id(df_ids, col_name, val0)
        df.loc[index, new_col] = df_ids.loc[row, 'db_id']
    return df

def process():
    # Read previously processed tables
    df_editorials = read_files([db_editorial], cols=read_editorials)
    df_authors = read_files([db_authors], cols=read_authors)

    # Read new tables
    df = read_files(files, cols=to_read)

    # Add Author and Editorial IDs
    df = add_ids(df, df_editorials, 'editorial', edit_id)
    df = add_ids(df, df_authors, 'autor', aut_id)
    return df

def insert_all(data, new_id_col):
    """ Insert record by record to the DB """

    # Create an empty col in the df
    data[new_id_col] = np.nan

    for index in data.index:
        # String vars
        lid = str(data.loc[index, 'id']).strip()
        titulo = str(data.loc[index, 'titulo']).strip()
        isbn = str(data.loc[index, 'isbn']).strip()
        readed = str(data.loc[index, 'leido']).strip()

        # Numbers
        pags = int(str(data.loc[index, 'pags']))
        numl = int(str(data.loc[index, 'ejemplares']))

        # External IDs
        aid = data.loc[index, aut_id]
        eid = data.loc[index, edit_id]

        # Validate values
        if readed == 't':
            readed = True
        else:
            readed = False
        
        if isbn == 'nan':
            isbn = '-'

        # All values in a dict
        vals = {
            'lid'   : lid,
            'titulo': titulo,
            'aid'   : aid,
            'eid'   : eid,
            'pags'  : pags,
            'isbn'  : isbn,
            'numl'  : numl,
            'readed': readed
        }

        val_id = execute_query(sql, vals, get_id=True)
        data.loc[index, new_id_col] = val_id
    
    return data



if __name__ == '__main__':
    # new columns, id DB new indexes
    new_col = 'db_id'

    # read, drop duplicates
    data = process()
    
    # Insert to DB and save
    data = insert_all(data, new_col)
    print(data.head())

    all_cols = to_read
    all_cols.append(new_col)
    save_file(data, filename='data/all_books_papiDaniel.csv', cols=all_cols)

