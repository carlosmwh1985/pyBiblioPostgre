import psycopg as psql
from config import connection_str

import sys

def connect():
    """ Connect to PostgreSQL database server """
    conn = None

    try:
        # Read connection parameters
        params = connection_str()

        # Connect to the PostgreSQL server
        print('Connecting to the PostgreSQL database...')
        conn = psql.connect(**params)

        # Create a cursor
        cur = conn.cursor()

        # Execute a statement
        print('PostgreSQL DB Version:')
        cur.execute('SELECT version()')

        # Display the PostgreSQL DB server version
        db_version = cur.fetchone()
        print(db_version)

        # Close the communication
        cur.close()
    except (Exception, psql.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()
            print('Database connection closed.')



if __name__ == '__main__':
    print(sys.version)
    connect()