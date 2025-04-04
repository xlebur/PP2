import re

def start_with_a():
    s = input('Input your string: ')
    check = re.compile('^A')
    n = check.search(s)

    if n:
        print("Found: ", n.group())

    else:
        print('No match')


start_with_a()