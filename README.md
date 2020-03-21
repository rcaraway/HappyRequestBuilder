# HappyRequestBuilder

Easily build common API requests in less lines.

## How To Use

### Creating a builder
```
let requestBuilder = RequestBuilder()
                    .set(.host("yourApi.com"))
                    .set(.pathExtension("/api/")
                    .set(.path("product")
                    .set(.method(.post))
                    .set(.headers(yourHeadersAsDict))
```
See `RequestParameters` for all options

### Build a `URLRequest`:

` let request = requestBuilder.build()`

### Set a default builder:

```
requestBuilder.commitDefault()
```

So then you can access the default later with everything you've set:

```
let builder = RequestBuilder.defaultBuild //has common elements set 
              .set(.path("images"))
```

### Basic Authentication convenience

Login:

``` 
builder.addCredentials(username: yourName, password: password)
```
Adding a token:
``` 
builder.addAuth(token: "yourToken")
```




