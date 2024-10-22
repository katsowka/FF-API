### basic helper functions (exculding for database)

def ask_int(max_int = 1000, msg = ""):
    '''helper function for obtaining an input integer'''
    while True:
        print(msg)
        num = input("Your input: ").strip()
        if not num.isdigit() or int(num) not in range(1, max_int+1):
            print(f"Invalid input, please try again.")
        else:
            return int(num)