import psycopg as psql
from config import connection_str
import subprocess

def _connect():
    """To connect with the PostgreSQL database server"""
    conn = None

    try:
        # Read connection parameters
        params = connection_str()

        # Connect to the PostgreSQL server
        print('Connecting to the PostgreSQL database...')
        conn = psql.connect(**params)

    except (Exception, psql.DatabaseError) as error:
        print(error)

    return conn

def _close(conn):
    """To close the connection with the database"""
    try:
        if conn is not None:
            conn.close()
            print('Database connection closed.')
    except (Exception, psql.DatabaseError) as error:
        print(error)

def _query(conn, str_query):
    try:
        # Create a cursor
        cur = conn.cursor()

        # Execute a statement
        print('PostgreSQL Query result:')
        cur.execute(str_query)

        # Display the PostgreSQL DB server version
        db_answer = cur.fetchall()
        print(db_answer)

        # Close the communication
        cur.close()
    except (Exception, psql.DatabaseError) as error:
        print(error)

def try_sel_all(tbl='libros'):
    if tbl.lower() == 'libros':
        str_query = 'SELECT * FROM tblLibros'
    else:
        str_query = 'SELECT * FROM tbldetnombreautor'
    conn = _connect()
    _query(conn, str_query)
    _close(conn)

def try_see_all_tables():
    str_query = 'SELECT table_name FROM information_schema.tables WHERE table_schema=\'public\' ORDER BY table_name'
    conn = _connect()
    _query(conn, str_query)
    _close(conn)


if __name__ == '__main__':
    #print(sys.version)
    try_sel_all(tbl='')
    try_see_all_tables()