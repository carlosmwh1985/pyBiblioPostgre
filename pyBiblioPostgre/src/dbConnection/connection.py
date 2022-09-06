import psycopg as psql
from .config import connection_str

def _connect(verbose=False):
    """ Connect to PostgreSQL database server """
    conn = None

    try:
        # Read connection parameters
        params = connection_str()

        # Connect to the PostgreSQL server
        if verbose:
            print('Connecting to the PostgreSQL database...')
        conn = psql.connect(**params)

    except (Exception, psql.DatabaseError) as error:
        print(error)

    return conn

def _close(conn, verbose=False):
    """ Close the connection with the database """
    try:
        if conn is not None:
            conn.close()
            if verbose:
                print('Database connection closed.')
    except (Exception, psql.DatabaseError) as error:
        print(error)

def _cursor(conn):
    """ Creates a new cursor """
    cur = None
    try:
        # Create a cursor
        cur = conn.cursor()

    except (Exception, psql.DatabaseError) as error:
        print(error)
    
    return cur

def _query(conn, str_query):
    try:
        # Create a cursor
        cur = conn.cursor()

        # Execute a statement
        print('PostgreSQL Query result:')
        cur.execute(str_query)

        # Display the PostgreSQL DB server version
        db_answer = cur.fetchone()
        print(db_answer)

        # Close the communication
        cur.close()
    except (Exception, psql.DatabaseError) as error:
        print(error)

def execute_query(sql, vals, get_id=False, get_record=False, verbose=False):
    conn = None
    val_id = None
    try:
        # Connect and create cursor
        conn = _connect(verbose=verbose)
        cur = _cursor(conn)

        # Execute query
        if vals != None:
            cur.execute(sql, vals)
        else:
            cur.execute(sql)

        row = cur.fetchone()

        if get_id:
            val_id = row[0]
            
            # Commit the changes to the DB
            conn.commit()
        
        if get_record:
            val_id = row


        # Close communication with the DB
        cur.close()
    except (Exception, psql.DatabaseError) as error:
        print('Query: {}'.format(sql))
        print('Tuple/dict: {}'.format(vals))
        print('Error: {}'.format(error))
    finally:
        _close(conn, verbose=verbose)
    
    return val_id
