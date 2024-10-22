### 'client side' 

# demo of making requests to my API to preview status codes and responses

import requests
import json
from pprint import pprint
from utils import ask_int


# GET all items
def request_get_all_items_for_sale():
    result = requests.get('http://127.0.0.1:8000/api/items-for-sale/')
    print(result)
    print("\n")
    pprint(result.json())


# GET one item by id
def request_get_item_for_sale(item_id):
    result = requests.get(f'http://127.0.0.1:8000/api/items-for-sale/{item_id}')
    print(result)
    print("\n")
    pprint(result.json())


# DELETE one item by id
def request_delete_item_for_sale(item_id):
    result = requests.delete(f'http://127.0.0.1:8000/api/items-for-sale/{item_id}')
    print(result)


# PATCH one item by id, changing it's price
def request_patch_item_price(item_id, new_price):
    body = {"price": new_price}
    result = requests.patch(f'http://127.0.0.1:8000/api/items-for-sale/{item_id}', data=json.dumps(body))
    print(result)
    print("\n")
    pprint(result.json())


def run():

    print("\n> > > Welcome to the FF Rescued Items API! < < <")

    while True:
        print('''\nChoose a request type by indicating it's corresponding number:\n
              \t 1. GET info on all items currently for sale\n
              \t 2. GET info on one item\n
              \t 3. DELETE an items (after it sells)\n
              \t 4. PATCH (update) the listed price of an item''')
        
        choice_request = ask_int(max_int = 4); print("\n")

        if choice_request == 1:
            request_get_all_items_for_sale()

        elif choice_request == 2:
            choice_id = ask_int(msg = "Indicate the item id.")
            request_get_item_for_sale(choice_id)

        elif choice_request == 3:
            choice_id = ask_int(msg = "Indicate the item id.")
            request_delete_item_for_sale(choice_id)

        else: 
            choice_id = ask_int(msg = "Indicate the item id.")
            new_price = ask_int(msg = "\nEnter a new price for the item, as an integer.")
            request_patch_item_price(choice_id, new_price)

        print("\nWould you like to make another request?")
        ans = ask_int(max_int = 2, msg = "Enter '1' for YES or '2' for NO.")
        if ans == 2:
            print("\n~ * More request types coming soon - see you next time! * ~\n")
            break


if __name__ == '__main__':
    run()