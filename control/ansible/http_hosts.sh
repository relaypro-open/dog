#!/bin/bash
curl -s kong:8000/api/V2/hosts -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiIwZDY3NGRhNGFjNzYxMWVkYThmNzhmNzdmYTUyMWI2ZSJ9.PASNsZCTJihOO6ffBO2g-7N-OQWVI5KsnP7bq5Pi3aE" | jq '.'
