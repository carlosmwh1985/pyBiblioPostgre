from asyncore import read
from os import write
import numpy as np
from csvFiles import *
from dbConnection.connection import *


# Author Queries
sql_select_author = """SELECT * FROM tblautores WHERE nombre=%(nombre)s AND apellido=%(apellido)s;"""
sql_insert_author = """INSERT INTO tblautores(nombre, apellido) VALUES(%(nombre)s, %(apellido)s) RETURNING id;"""


# Editorial Queries
sql_select_editorial = """SELECT * FROM tbleditoriales WHERE nombre=%(nombre)s;"""
sql_insert_editorial = """INSERT INTO tbleditoriales(nombre) VALUES(%(nombre)s) RETURNING id;"""


# Book Queries
sql_select_book = """SELECT Id, libro_id, titulo, autor_id, editorial_id, isbn FROM tbllibros
    WHERE libro_id=%(lid)s AND autor_id=%(author_id)s AND editorial_id=%(editorial_id)s AND isbn=%(isbn)s;"""
sql_insert_book = """INSERT INTO tbllibros(libro_id, titulo, autor_id, editorial_id, pags, isbn, ejemplares, leido, observaciones)
    VALUES(%(lid)s, %(titulo)s, %(author_id)s, %(editorial_id)s, %(pags)s, %(isbn)s, %(numl)s, %(read)s, %(obs)s)
    RETURNING id;"""


# Additional comments
obs_default = '-'
obs_in_house = 'En Halle'
new_col = 'db_id'


# Columns to consider
to_read = ['id', 'titulo', 'autor', 'editorial', 'pags',
    'isbn', 'ejemplares', 'leido', 'observaciones']
to_write = ['Id', 'Titulo', 'Autor', 'Editorial', 'Pags',
    'ISBN', 'Ejemplares', 'Leido', 'Observaciones', 'db_id']

failed_ids = []
failed_entries = []


def find_author_id(name):
    parts = name.split(',')
    if len(parts) > 1:
        name = str(parts[1]).strip()
        surname = str(parts[0]).strip()
    else:
        name = '-'
        surname = name
    vals = {
        'nombre'   : name,
        'apellido' : surname
    }
    val_id = execute_query(sql_select_author, vals, get_record=True)
    if val_id == None:
        val_id = execute_query(sql_insert_author, vals, get_id=True)
    elif type(val_id) is tuple:
        val_id = val_id[0]
    return val_id

def get_author_id(vals):
    try:
        author_id = find_author_id(vals['auth'])
        vals['author_id'] = author_id
    except:
        print('Problems with Author: {}'.format(vals['auth']))
        failed_ids.append(vals)

def find_editorial_id(name):
    if name is None or name == '' or name == '-':
        name = '-'

    vals = {
        'nombre'   : str(name).strip()
    }
    val_id = execute_query(sql_select_editorial, vals, get_record=True)
    if val_id == None:
        val_id = execute_query(sql_insert_editorial, vals, get_id=True)
    elif type(val_id) is tuple:
        val_id = val_id[0]
    return val_id

def get_editorial_id(vals):
    try:
        editorial_id = find_editorial_id(vals['edit'])
        vals['editorial_id'] = editorial_id
    except:
        print('Problems with Editorial: {}\n'.format(vals['edit']))
        failed_ids.append(vals)

def find_book_id(entry):
    book_id = execute_query(sql_select_book, entry, get_record=True)
    if book_id is None:
        book_id = execute_query(sql_insert_book, entry, get_id=True)
    elif type(book_id) is tuple:
        book_id = -book_id[0]

    return book_id

def get_book_id(index, df, vals):
    try:
        # val_id = execute_query(sql_insert_book, vals, get_id=True)
        val_id = find_book_id(vals)
        if val_id >= 0:
            df.loc[index, new_col] = val_id
        else:
            print('Book with Id {} is already in DB. db_Id: {}'.format(vals['lid'], -val_id))
            # TODO: Eliminate the row from df
    except:
        failed_entries.append(vals)

def prepare_aux_entries(df, obs_text=None):
    empties = [np.nan, 'nan', 'None', None]
    df['Leido'].replace(empties, False, inplace=True)
    df['Leido'].replace(0, False, inplace=True)
    df['Leido'].replace(1, True, inplace=True)
    df['Observaciones'].replace(empties, obs_default, inplace=True)
    if obs_text is not None:
        df['Observaciones'] = obs_text

def get_vals(df, index):
    # String vars
    lid       = str(df.loc[index, 'Id']).strip()
    titulo    = str(df.loc[index, 'Titulo']).strip()
    isbn      = str(df.loc[index, 'ISBN']).strip()
    obs       = str(df.loc[index, 'Observaciones']).strip()
    read      = str(df.loc[index, 'Leido']).strip()
    author    = str(df.loc[index, 'Autor']).strip()
    editorial = str(df.loc[index, 'Editorial']).strip()

    # Numbers
    pags = int(str(df.loc[index, 'Pags']))
    numl = int(str(df.loc[index, 'Ejemplares']))

    # Validate 'read' values
    if read == 't' or read == 1:
        read = True
    elif read == 'f' or read == 0:
        read = False
    
    if isbn is None or isbn == 'nan':
        isbn = '-'

    if obs == 'nan':
        obs = '-'

    # Pack all values in a dict
    vals = {
        'lid'   : lid,
        'titulo': titulo,
        'pags'  : pags,
        'isbn'  : isbn,
        'numl'  : numl,
        'read'  : read,
        'obs'   : obs,
        'auth'  : author,
        'edit'  : editorial
    }

    return vals

def list_to_file(filename, relative_path, a_list):
    path = os.getcwd() + '/pyBiblioPostgre/'
    if relative_path.startswith('/'):
        path += relative_path[1:]
    else:
        path += relative_path
    
    if relative_path.endswith('/'):
        path += filename
    else:
        path += '/' + filename

    print('Printing list to {}'.format(path))

    with open(path, 'w+') as file:
        for v in a_list:
            file.write('{}\n'.format(v))

def write_failed():
    if failed_ids:
        list_to_file(filename='failed_ids.txt', relative_path='/data', a_list=failed_ids)

    if failed_entries:
        list_to_file('failed_entries.txt', relative_path='/data', a_list=failed_entries)

def insert_items(df):
    # Id in the DB. Create it as an empty column    
    df[new_col] = np.nan

    # Read author and editorial names and add them to the DB if needed
    for index in df.index:
        
        vals = get_vals(df, index)
        author_id = None
        editorial_id = None

        # External Author ID
        get_author_id(vals)
        
        # External Editorial ID
        get_editorial_id(vals)

        del vals['auth']
        del vals['edit']

        get_book_id(index, df, vals)
    
    write_failed()

    return df

def join_dfs(df_old, df):
    df.columns = to_write
    df_joined = pd.concat([df_old, df])
    df_joined.reset_index(inplace=True, drop=True)
    print('New total number of rows: {}'.format(len(df_joined.index)))
    return df_joined


if __name__ == '__main__':
    # input_file = 'allBooks.csv'   # This contains the first books in the old DB
    input_file = 'data/csvCatalog/all_books_bkp_1.csv'
    output_file = 'data/all_books.csv'
    df = read_file(input_file)
    # df_old = read_file(output_file)
    prepare_aux_entries(df)
    insert_items(df)
    # df_all = join_dfs(df_old, df)
    df_all = df
    print(df_all.head())
    save_file(df_all, filename=output_file, cols=to_write)
