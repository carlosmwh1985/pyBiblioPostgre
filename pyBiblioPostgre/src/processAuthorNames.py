from csvFiles import *
from dbConnection.connection import *

import numpy as np

sql = """INSERT INTO tblautores(nombre, apellido) VALUES(%s, %s) RETURNING id;"""

# Files to read
files = ['data/data_tblLibros.csv',
    'data/data_tblLibrosNuevos.csv',
    'data/data_tblLibrosPapiDaniel.csv']

# Columns to consider
ref_col = 'autor'
new_cols = ['aut_nombre', 'aut_apellido']
all_cols = [ref_col]
all_cols.extend(new_cols)
to_read = ['id', 'titulo', 'autor']

def process():  
    # Read and pre-process
    df = read_files(files, cols=to_read)
    df_names = split_names(df, ref_col, new_cols)
    df_names = drop_duplicates(df_names, ref_col)
    # save_file(df_names, filename='data/all_author_names.csv', cols=all_cols)
    # print(df_names.head())
    return df_names

def insert_all(data, new_id_col):
    """ Insert record by record to the DB """

    # Create an empty col in the df
    data[new_id_col] = np.nan

    for index in data.index:
        val0 = str(data.loc[index, 'aut_nombre']).strip()
        val1 = str(data.loc[index, 'aut_apellido']).strip()
        if val0 == 'None' or val0 == '':
            val0 = '-'
        if val1 == 'None' or val1 == '':
            val1 = '-'
        val_id = execute_query(sql, (val0, val1), get_id=True)
        data.loc[index, 'aut_nombre'] = val0
        data.loc[index, 'aut_apellido'] = val1
        data.loc[index, new_id_col] = val_id
        # print(val_id)
    
    return data



if __name__ == '__main__':
    # new columns, id DB new indexes
    new_col = 'db_id'

    # read, drop duplicates
    data = process()

    # Insert to DB and save
    data = insert_all(data, new_col)

    all_cols.append(new_col)
    save_file(data, filename='data/all_author_names.csv', cols=all_cols)

