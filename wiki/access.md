
# seding a request
In order to access the API you have to send a HTTP POST package to the server.
The request can be formattet in every supported format, and have to be placed in the body of the HTTP package.

# Requests
A request usually should obtain at least the folowwing variables:  
MD TABLE...

# Request / response format
With the HTTP headers 'request-format' and 'response-format' you can define how your request / response body is formattet.  

For example, if you want to send a requst in form of a serialized lua table you have to set the 'request-format' header to 'lua-table'.
The API then knows that the request body have to be interpretet as lua table.
Pretty much the same with the 'response-format' header, but for the response body that is send back to you from the API.

Per default the API uses the standard HTML format (e.g.: name=example+value%21&token=TOKEN...)

### New formatts
If you are interessted in getting support for a new format, you can suggest it at the DAMS github forum.  

# Auth token
There are 2 ways of providing the auth token to the API.  
The first is to send it as cookie header named 'token'.  
The second way is to simply put it into the request body, also named 'token'.  

The auth token can be obtained at the default web-interface.