# README

Rails+MongoDB implementation of a simple shipsticks API + front end 

### The Environment
- Amazon AWS virtual server running Ubuntu 16.04
- Front end is hosted at http://34.206.71.174/ 
- Api is hosted at http://34.206.71.174/products
- Ruby version is 2.5.1p57 and Rails version is 5.2.0
- Nginx runs as a proxy to a Puma instance
- Mongo DB 3.4.16 is installed and running. The database is populated using a db/seeds.rb script that loads the products.json file located in lib/seeds/products.json

## The API

The REST API is implemented using Rails routes resources helper, so it specifies a basic set of member functions for the various routes. There is an RSpec script to test the API in spec/requests/products_spec.rb. The following resource was very good for covering all of the bases for creating and testing a Rails 5 API. https://scotch.io/tutorials/build-a-restful-json-api-with-rails-5-part-one. The RSpec script was derived from theirs. 

The call examples are from Postman. You could send the parameters up as JSON in the request body as well.

### Returning All Products
- GET http://34.206.71.17/products 

Note that when we return the objects we don't return the MongoDB ObjectID reference in order to not have a database dependency in the front end code. 

```
[
    {
        "id": "[ID]",
        "name": "Small Package",
        "type": "Golf",
        "length": 48,
        "width": 14,
        "height": 12,
        "weight": 42
    },
    etc
]
```
### Returning One Product
- GET http://34.206.71.174/products/:id

```
{
    "id": "[ID]",
    "name": "Small Package",
    "type": "Golf",
    "length": 48,
    "width": 14,
    "height": 12,
    "weight": 42
}
```
an invalid ID will return a 404 error code
```
{
    "error": "Product Not Found"
}
```

### Returning a product that fits a particular dimension
- GET http://34.206.71.174/products?length=48&width=14&height=12&weight=42 

all 4 fields: length, width, height and weight are required. it will return the smallest package that can contain those dimensions.
```
[
    {
        "id": "[ID]",
        "name": "Small Package",
        "type": "Golf",
        "length": 48,
        "width": 14,
        "height": 12,
        "weight": 42
    }
    
   
]
```
If any parameters are missing it wil fail with the following error. The server actually returns a 500 error code instead 
```
{
    "error": "Missing Parameters"
}
```

the server actually returns a 500 error code instead of the 422. There is a params.require guard that will raise an exception if a parameter is missing. That will trigger and send the 422, but the 500 is raised somewhere else in the framework. Its attempting to serialize a Null value. https://github.com/rails-api/active_model_serializers/issues/2024
```
[active_model_serializers] Rendered ActiveModel::Serializer::Null with Hash (0.07ms)
Completed 500 Internal Server Error in 4ms (Views: 3.7ms)
```

### Updating an Product

- PUT http://34.206.71.174/products/:id?name=value&length=20&width=30&height=50&weight=75

will update the value of any of the fields in the object other than the ID. it returns a 204 No-Content if successful and a 404 Not Found if it didn't find the product with the specified ID

retrieving the product again:

- GET http://34.206.71.174/products/:id

shows the updated data
```
{
    "id": "[ID]",
    "name": "Smaller Package",
    "type": "Golf",
    "length": 48,
    "width": 14,
    "height": 12,
    "weight": 42
}
```

### Deleting a Product

- DELETE http://34.206.71.174/products/:id

will cause the product to be deleted. The server will return a 204 No-Content if successful and a 404 if the product is not found.


## The Front End

The front end is very straightforwrd. It is responsive and works well in both the desktop and the phone. It leverages jquery and twitter bootstrap and no plugins. It implements a claculator that allows the customer to specify the length, width, height and weight of the their package and when they click Calculate we return the closest product that matches those dimensions. The modal is closed after 5 seconds and the selected product is displayed on screen.





