#!/bin/env python3
import jwt

payload_data = {
        "iss": "0d674da4ac7611eda8f78f77fa521b6e"
}

my_secret = 'guest'

token = jwt.encode(
    payload=payload_data,
    key=my_secret,
    algorithm="HS256"
)
print(token)

print(jwt.decode(token, key=my_secret, algorithms=['HS256', ]))
