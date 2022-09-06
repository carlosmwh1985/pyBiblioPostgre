import pandas as pd
import os

def read_file(filename='dummy.csv', path=None):
    """Read the file in the specified path. If none is given, it is assumed to be a subfolder of the CWD. It returns a pandas DataFrame"""
    if path is None:
        path = os.getcwd() + '/pyBiblioPostgre/'
    filename = path + filename

    if os.path.exists(filename):
        df = pd.read_csv(filename)
        print('Number of rows: {}\n'.format(str(len(df.index))))
    else:
        print('File {} not found. Creating an empty DataFrame\n'.format(filename))
        df = pd.DataFrame()

    return df

def read_files(files, cols=['id']):
    dfs = []
    for name in files:
        tmp = read_file(filename=name)
        dfs.append(tmp)
    df = pd.concat(dfs)
    df.reset_index(inplace=True, drop=True)
    print('Total number of rows: {}\n'.format(str(len(df.index))))
    return df[cols]

def split_names(data, ref_col, new_cols):
    all_cols = ['id']
    all_cols.append(ref_col)
    all_cols.extend(new_cols)
    if 'autor' in data.columns:
        data[new_cols] = data[ref_col].str.split(',', expand=True)
        return data[all_cols]

def drop_duplicates(data, ref_col):
    data.drop_duplicates(subset=[ref_col], inplace=True)
    data.reset_index(inplace=True, drop=True)
    print('Total number of rows after drop duplicates: ' + str(len(data.index)))
    return data

def save_file(df, filename='dummy.csv', cols=['id'], path=None):
    '''Save the given dataframe in the indicated file in the given path. If no path is given, it is assumed to be the CWD'''
    if path is None:
        path = os.getcwd() + '/pyBiblioPostgre/'
    filename = path + filename

    tmp = df[cols]
    tmp.to_csv(filename, index=False)
