import json
filepath = 'C:/Users/omaru/Desktop/PP2_Spring/test/food.json    '
with open(filepath, 'r') as file:
    data = json.load(file)

for result in data['results']:
    event_id = result['event_id']
    print(event_id)

def print_words_starting_with_f(json_data):
    if isinstance(json_data, dict):  
        for key, value in json_data.items():
            print_words_starting_with_f(value) 
    elif isinstance(json_data, list):  # If the data is a list
        for item in json_data:
            print_words_starting_with_f(item)  # Recursively check each item
    elif isinstance(json_data, str):  # If the data is a string
        # Split the string into words and check each word
        for word in json_data.split():
            if word.lower().startswith('f'):  # Case-insensitive check
                print(word)

# Call the function to print words starting with 'f'
print_words_starting_with_f(data)