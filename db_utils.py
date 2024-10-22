### utility functions for interacting with database

from mysql.connector import MySQLConnection, Error
from config import config


# custom exception for when query returns zero rows
class ItemIdError(Exception):
    pass


# selecting all items for sale and returning in nice format
def all_items_for_sale():

    query = "SELECT * FROM view_item_for_sale"

    with MySQLConnection(**config) as conn:
        with conn.cursor() as cur:
            cur.execute(query)

            raw_rows = cur.fetchall()
            columns = cur.column_names
            rows = []
            for raw_row in raw_rows:
                row = dict(zip(columns, raw_row))
                rows.append(row)

            return rows if rows else "There are no items for sale at this time."


# selecting items by id and returning in nice format
def item_for_sale(item_id):

    query = f"SELECT * FROM view_item_for_sale WHERE item_id = {item_id}"

    with MySQLConnection(**config) as conn:
        with conn.cursor() as cur:
            cur.execute(query)

            raw_rows = cur.fetchall()
            if cur.rowcount == 0:
                raise ItemIdError
            columns = cur.column_names        
            row = dict(zip(columns, raw_rows[0]))
            return row


# deleting item by id
def db_delete_item_for_sale(item_id):
    
    query = f"DELETE FROM item_for_sale WHERE item_id = {item_id}"

    with MySQLConnection(**config) as conn:
        with conn.cursor() as cur:
            cur.execute(query)
        conn.commit()


# updating price of item (given by id), returing updated item
def update_item_for_sale(item_id, new_price):
    
    query = f'''UPDATE item_for_sale 
                SET price = {new_price} 
                WHERE item_id = {item_id}'''

    with MySQLConnection(**config) as conn:
        with conn.cursor() as cur:
            cur.execute(query)
        conn.commit()

    updated_item = item_for_sale(item_id) 
    return updated_item



