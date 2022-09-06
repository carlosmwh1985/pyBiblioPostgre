from csvFiles import *
import numpy as np
from dbConnection.connection import *

sql = """INSERT INTO tbleditoriales(nombre) VALUES(%s) RETURNING id;"""

# Columns to consider
ref_col = 'editorial'
to_use = ['id', ref_col]

# Files to read
files = ['data/data_tblLibros.csv',
    'data/data_tblLibrosNuevos.csv',
    'data/data_tblLibrosPapiDaniel.csv']

def process():
    # Read and pre-process
    df = read_files(files, cols=to_use)
    df_names = drop_duplicates(df, ref_col)
    # save_file(df_names, filename='data/all_editorials.csv', cols=to_use)
    # print(df_names.head())
    return df_names

def insert_all(data, new_id_col):
    """ Insert record by record to the DB """

    # Create an empty col in the df
    data[new_id_col] = np.nan

    for index in data.index:
        val = data.loc[index, 'editorial']
        val_id = execute_query(sql, val, get_id=True)
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

    to_use.append(new_col)
    save_file(data, filename='data/all_editorials.csv', cols=to_use)

