from configparser import ConfigParser
import os

def connection_str(path='', filename='.config/database.ini', section='postgresql'):
    '''It reads the string connection parameters to a given DB.

    PARAMETERS:
    path     : The path where the file is located. By default it is empty
    filename : The file name of the configuration file. By default it is `database-ini`
    section  : The section in the configuration file, where the connection strings are located.\n
               By default it is `postgresql`
    
    RETURNS:
    Dictionary with the readed connection strings. If none, an Exception is thrown'''

    if path == '' or not path.endswith('DbConnection/'):
        path = os.getcwd() + '/pyBiblioPostgre/src/dbConnection/'
    filename = path + filename

    if not os.path.exists(filename):
        print('Config file for Connection to Db does not exist\n')
        raise Exception('File Path not found: {}'.format(filename))

    # Create a parser
    parser = ConfigParser()

    # Read config file
    parser.read(filename)

    # Get section, default to postgresql
    db_str_connection = {}
    if parser.has_section(section):
        params = parser.items(section)
        for param in params:
            db_str_connection[param[0]] = param[1]
    else:
        raise Exception('Section {0} not found in the {1} file'.format(section, filename))
    
    return db_str_connection
