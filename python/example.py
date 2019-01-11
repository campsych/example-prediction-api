import json
import requests


def auth(customer_id, api_key):
    try:
        credentials = {
            'customer_id': customer_id,
            'api_key': api_key
        }
        response = requests.post('https://api.applymagicsauce.com/auth', json=credentials)
        response.raise_for_status()
        return response.json()['token']
    except requests.exceptions.HTTPError as e:
        print e.response.json()


def predict_from_text(token, text):
    try:
        response = requests.post(url='https://api.applymagicsauce.com/text',
                                 data=text,
                                 headers={'X-Auth-Token': token})
        response.raise_for_status()
        return response.json()
    except requests.exceptions.HTTPError as e:
        print e.response.json()


def predict_from_like_ids(token, like_ids):
    try:
        response = requests.post(url='https://api.applymagicsauce.com/like_ids',
                                 json=like_ids,
                                 headers={'X-Auth-Token': token})
        response.raise_for_status()
        if response.status_code == 204:
            raise ValueError('Not enough predictive like ids provided to make a prediction')
        else:
            return response.json()
    except requests.exceptions.HTTPError as e:
        print e.response.json()
    except ValueError as e:
        print e

def predict_from_like_names(token, like_names):
    try:
        response = requests.post(url='https://api.applymagicsauce.com/like_names',
                                 json=like_names,
                                 headers={'X-Auth-Token': token})
        response.raise_for_status()
        if response.status_code == 204:
            raise ValueError('Not enough predictive names provided to make a prediction')
        else:
            return response.json()
    except requests.exceptions.HTTPError as e:
        print e.response.json()
    except ValueError as e:
        print e

# /auth
token = auth(1234, 'key')

# /text
prediction_result = predict_from_text(token, 'Lorem ipsum dolor sit amet')
print json.dumps(prediction_result, indent=4)

# /like ids
prediction_result = predict_from_like_ids(token, ["5845317146", "6460713406", "22404294985", "35312278675",
                                                  "105930651606", "171605907303", "199592894970", "274598553922",
                                                  "340368556015", "100270610030980"])
print json.dumps(prediction_result, indent=4)

# /like names
# Populate the array below with proper names (i.e. name of a celebrity, band, organisation, etc.), something well-known.
# Come up with 10 of these.
prediction_result = predict_from_like_names(token, ["Name 1", "Name 2", "Name 3"])
print json.dumps(prediction_result, indent=4)
