### creating endpoints using FastAPI

from mysql.connector import MySQLConnection, Error
from fastapi import FastAPI, HTTPException, Request
from pydantic import BaseModel
from decimal import Decimal
from db_utils import (all_items_for_sale, item_for_sale, update_item_for_sale, 
                      db_delete_item_for_sale, ItemIdError)


class NewPrice(BaseModel):
    price: Decimal 


app = FastAPI()


# error handling -----------------------------------------


@app.exception_handler(Error)  
def handle_db_error(request: Request, exc: Error):
    print(exc)
    msg = "a database error occurred"
    raise HTTPException(500, detail=msg)


@app.exception_handler(ItemIdError)  
def handle_db_error(request: Request, exc: ItemIdError):
    print(exc)
    msg = "invalid item id"
    raise HTTPException(500, detail=msg)


@app.exception_handler(Exception)  
def handle_db_error(request: Request, exc: Exception):
    print(exc)
    msg = "an exception occurred"
    raise HTTPException(500, detail=msg)


# GET requests -----------------------------------------


# just testing connection
@app.get("/")
def root():
    return {"message": "we are connected!"}


@app.get("/api/items-for-sale")
def get_all_items_for_sale():
    all_items = all_items_for_sale()
    return {"items for sale": all_items}


@app.get("/api/items-for-sale/{item_id}")
def get_item_for_sale(item_id: int):
    item = item_for_sale(item_id)
    return {"item for sale": item}


# DELETE request -----------------------------------------


@app.delete("/api/items-for-sale/{del_item_id}", status_code=204)
def delete_item_for_sale(del_item_id: int):
    db_delete_item_for_sale(del_item_id)



# PATCH request -----------------------------------------


@app.patch("/api/items-for-sale/{changed_item_id}")
def change_item_price(changed_item_id: int, new_price: NewPrice):
    """
    sample body:
    {
    "price": 20
    }
    """
    new_price_dict = new_price.model_dump() # turns input into a dict
    updated_item = update_item_for_sale(changed_item_id, new_price_dict['price'])
    return {"updated item for sale": updated_item}

