## solutions: curl

### 1. HTTP methods

We show the POST method as an example, the other methods are similar. Most important is to observe the HTTP response code and the "method" field in the response body.

```console
student@linux:~$ curl -X POST -i httpbun.com/post
HTTP/1.1 200 OK
Content-Length: 342
Content-Type: application/json
Date: Sun, 14 Jun 2026 10:50:28 GMT
Via: 1.1 Caddy
X-Powered-By: httpbun/7a14f228bd735222258f685b6677ad8c564559fc

{
  "method": "POST",
  "args": {},
  "headers": {
    "Accept": "*/*",
    "Accept-Encoding": "gzip",
    "Content-Length": "0",
    "Host": "httpbun.com",
    "User-Agent": "curl/8.14.1",
    "Via": "1.1 Caddy"
  },
  "origin": "192.0.2.137",
  "url": "http://httpbun.com/post",
  "form": {},
  "data": "",
  "json": null,
  "files": {}
}
student@linux:~$ curl -X POST -i httpbun.com/get
HTTP/1.1 405 Method Not Allowed
Access-Control-Allow-Methods: GET, OPTIONS
Allow: GET, OPTIONS
Content-Length: 0
Date: Sun, 14 Jun 2026 10:50:33 GMT
Via: 1.1 Caddy
X-Powered-By: httpbun/7a14f228bd735222258f685b6677ad8c564559fc

```

### 2. Save the result to a file

```console
student@linux:~$ curl -s -o hi.svg "https://httpbun.com/svg/Hi"
student@linux:~$ file hi.svg 
hi.svg: SVG Scalable Vector Graphics image, ASCII text
student@linux:~$ cat hi.svg 
<svg width="100" height="100" xmlns="http://www.w3.org/2000/svg">
    <circle cx="50%" cy="50%" r="45%" fill="#c1a529" stroke="none" />
    <text x="50%" y="53%" text-anchor="middle" dominant-baseline="middle" font-size="36" font-family="sans-serif" fill="#222e">HI</text>
</svg>
```

(if you are working on a Linux system with a graphical desktop environment, you can open the file with an image viewer to see the rendered SVG image)

### 3. Redirects

```console
student@linux:~$ curl -i httpbun.com/redirect/2
HTTP/1.1 302 Found
Content-Length: 174
Content-Type: text/html; charset=utf-8
Date: Sun, 14 Jun 2026 10:53:53 GMT
Location: 1
Via: 1.1 Caddy
X-Powered-By: httpbun/7a14f228bd735222258f685b6677ad8c564559fc

<!doctype html>
<title>Redirecting...</title>
<h1>Redirecting...</h1>
<p>You should be redirected automatically to target URL: <a href="1">1</a>.  If not click the link.</p>
student@linux:~$ curl -i -L httpbun.com/redirect/2
HTTP/1.1 302 Found
Content-Length: 174
Content-Type: text/html; charset=utf-8
Date: Sun, 14 Jun 2026 10:53:59 GMT
Location: 1
Via: 1.1 Caddy
X-Powered-By: httpbun/7a14f228bd735222258f685b6677ad8c564559fc

HTTP/1.1 302 Found
Content-Length: 194
Content-Type: text/html; charset=utf-8
Date: Sun, 14 Jun 2026 10:53:59 GMT
Location: ../anything
Via: 1.1 Caddy
X-Powered-By: httpbun/7a14f228bd735222258f685b6677ad8c564559fc

HTTP/1.1 200 OK
Content-Length: 318
Content-Type: application/json
Date: Sun, 14 Jun 2026 10:53:59 GMT
Via: 1.1 Caddy
X-Powered-By: httpbun/7a14f228bd735222258f685b6677ad8c564559fc

{
  "method": "GET",
  "args": {},
  "headers": {
    "Accept": "*/*",
    "Accept-Encoding": "gzip",
    "Host": "httpbun.com",
    "User-Agent": "curl/8.14.1",
    "Via": "1.1 Caddy"
  },
  "origin": "192.0.2.137",
  "url": "http://httpbun.com/anything",
  "form": {},
  "data": "",
  "json": null,
  "files": {}
}
```

### 4. HTTP versions

First, we try unencrypted HTTP. We only show the first line of the response header, which contains the HTTP version.

```console
student@linux:~$ curl -s -I --http1.0 httpbun.com/any | head -1
HTTP/1.0 200 OK
student@linux:~$ curl -s -I --http1.1 httpbun.com/any | head -1
HTTP/1.1 200 OK
student@linux:~$ curl -s -I --http2 httpbun.com/any | head -1
HTTP/1.1 200 OK
student@linux:~$ curl -s -I --http3 httpbun.com/any | head -1
HTTP/1.1 200 OK
```

We see that only HTTP/1.0 and HTTP/1.1 are supported. Even if the client tries to use HTTP/2 or HTTP/3, the server falls back to HTTP/1.1.

Now we try encrypted HTTPS. We see that HTTP/2 is supported, but not HTTP/3.

```console
student@linux:~$ curl -s -I --http1.0 https://httpbun.com/any | head -1
HTTP/1.0 200 OK
student@linux:~$ curl -s -I --http1.1 https://httpbun.com/any | head -1
HTTP/1.1 200 OK
student@linux:~$ curl -s -I --http2 https://httpbun.com/any | head -1
HTTP/2 200 
student@linux:~$ curl -s -I --http3 https://httpbun.com/any | head -1
HTTP/2 200 
```

In this case, the server does not fall back to HTTP/1.1 when the client tries to use HTTP/2. HTTP/3 is also not supported, and the server falls back to HTTP/2.

### 5. Basic Authentication

```console
student@linux:~$ curl -i https://httpbun.com/basic-auth/admin/password123
HTTP/2 401 
alt-svc: h3=":443"; ma=2592000
date: Sun, 14 Jun 2026 11:13:11 GMT
via: 1.1 Caddy
www-authenticate: Basic realm="httpbun realm"
x-powered-by: httpbun/7a14f228bd735222258f685b6677ad8c564559fc
content-length: 0

student@linux:~$ curl -i --user admin:password123 https://httpbun.com/basic-auth/admin/password123
HTTP/2 200 
alt-svc: h3=":443"; ma=2592000
content-type: application/json
date: Sun, 14 Jun 2026 11:13:30 GMT
via: 1.1 Caddy
x-powered-by: httpbun/7a14f228bd735222258f685b6677ad8c564559fc
content-length: 47

{
  "authenticated": true,
  "user": "admin"
}
student@linux:~$ curl -i --user admin:secret https://httpbun.com/basic-auth/admin/password123
HTTP/2 401 
alt-svc: h3=":443"; ma=2592000
date: Sun, 14 Jun 2026 11:13:44 GMT
via: 1.1 Caddy
www-authenticate: Basic realm="httpbun realm"
x-powered-by: httpbun/7a14f228bd735222258f685b6677ad8c564559fc
content-length: 0
```

### 6. Sending data in a POST request

Passing data using the `-d` option is equivalent to sending form data. The server interprets the data as form data and returns it in the "form" field of the response body.

```console
student@linux:~$ curl -X POST -d color=blue -d size=medium https://httpbun.com/any
{
  "method": "POST",
  "args": {},
  "headers": {
    "Accept": "*/*",
    "Accept-Encoding": "gzip",
    "Content-Length": "22",
    "Content-Type": "application/x-www-form-urlencoded",
    "Host": "httpbun.com",
    "User-Agent": "curl/8.14.1",
    "Via": "2.0 Caddy"
  },
  "origin": "192.0.2.137",
  "url": "https://httpbun.com/any",
  "form": {
    "color": "blue",
    "size": "medium"
  },
  "data": "",
  "json": null,
  "files": {}
}
```

When we specify the parameters in the URL, the server interprets them as URL parameters and returns them in the "args" field of the response body.

**Warning:** because the ampersand character `&` has a special meaning in the shell, you need to escape it with a backslash `\` or put the URL in quotes!

```console
student@linux:~$ curl -X POST 'https://httpbun.com/any?color=blue&size=medium'
{
  "method": "POST",
  "args": {
    "color": "blue",
    "size": "medium"
  },
  "headers": {
    "Accept": "*/*",
    "Accept-Encoding": "gzip",
    "Content-Length": "0",
    "Host": "httpbun.com",
    "User-Agent": "curl/8.14.1",
    "Via": "2.0 Caddy"
  },
  "origin": "192.0.2.137",
  "url": "https://httpbun.com/any?color=blue&size=medium",
  "form": {},
  "data": "",
  "json": null,
  "files": {}
}
```

Finally, when passing JSON data with the `--json` option, the server interprets the data as JSON and returns it in the "json" field of the response body. The "data" field has the raw JSON data as a string.

```console
student@linux:~$ curl -X POST --json '{ "color": "blue", "size": "medium" }' https://httpbun.com/any
{
  "method": "POST",
  "args": {},
  "headers": {
    "Accept": "application/json",
    "Accept-Encoding": "gzip",
    "Content-Length": "37",
    "Content-Type": "application/json",
    "Host": "httpbun.com",
    "User-Agent": "curl/8.14.1",
    "Via": "2.0 Caddy"
  },
  "origin": "192.0.2.137",
  "url": "https://httpbun.com/any",
  "form": {},
  "data": "{ \"color\": \"blue\", \"size\": \"medium\" }",
  "json": {
    "color": "blue",
    "size": "medium"
  },
  "files": {}
}
```

### 7. Setting headers

The output of the following commands are too long to include here, but you can try them out yourself and observe the language used in the returned HTML code.

```console
student@linux:~$ curl https://duckduckgo.com
student@linux:~$ curl -H 'Accept-language: nl-BE' https://duckduckgo.com
student@linux:~$ curl -H 'Accept-language: zh-CN' https://duckduckgo.com
```

The result of the first command may depend on your system locale settings, but you can expect it to be in English. The second command should return the page in Dutch, and the third command should return the page in (simplified)Chinese.

