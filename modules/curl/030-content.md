## simple http requests

Try the following:

```console
student@linux:~$ curl 'https://icanhazdadjoke.com/'
What has a bed that you can’t sleep in? A river.
```

or:

```console
student@linux:~$ curl https://httpbun.com/any
{
  "method": "GET",
  "args": {},
  "headers": {
    "Accept": "*/*",
    "Accept-Encoding": "gzip",
    "Host": "httpbun.com",
    "User-Agent": "curl/8.14.1",
    "Via": "2.0 Caddy"
  },
  "origin": "192.0.2.137",
  "url": "https://httpbun.com/any",
  "form": {},
  "data": "",
  "json": null,
  "files": {}
}
```

The `curl` command, when given a URL as argument, will send an HTTP GET request to the specified webserver and print the body of the response to standard output.

For a "normal" website, the output would consist of the HTML source code of the page (try this yourself!). In the examples above, however, the respective webservers responded with plain text and JSON data.

The website [httpbun.com](https://httpbun.com/) is a useful tool for testing HTTP requests and we will use it in many of the examples below. The URL `https://httpbun.com/any` is a kind of "echo" service that replies with a detailed overview of the contents of the HTTP request in JSON format. This allows us to see in detail how the `curl` command constructs the HTTP request and what information is sent to the server.

Another useful exercise to see exactly how `curl` constructs the HTTP request is to use a network traffic analyzer such as [Wireshark](https://www.wireshark.org/). This allows you to see the raw HTTP request and response messages, including all headers and the body of the messages.

## redirecting output

When redirected, progress information is printed to standard error. To turn off this progress information, use the `-s` or `--silent` option:

```console
student@linux:~$ curl 'https://icanhazdadjoke.com/' > joke.txt
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    95  100    95    0     0    320      0 --:--:-- --:--:-- --:--:--   319
student@linux:~$ curl -s 'https://icanhazdadjoke.com/' > joke.txt
student@linux:~$
```

## HTTP request methods

By default, `curl` sends an HTTP GET request. To specify a different HTTP method, use the `-X` option, e.g.:

```bash
curl -X GET https://httpbun.com/any
curl -X POST https://httpbun.com/anything
curl -X PUT https://httpbun.com/anything
curl -X DELETE https://httpbun.com/anything
```

We show one example below, the output for the other methods is similar:

```console
student@linux:~$ curl -X POST https://httpbun.com/anything
{
  "method": "POST",
  "args": {},
  "headers": {
    "Accept": "*/*",
    "Accept-Encoding": "gzip",
    "Content-Length": "0",
    "Host": "httpbun.com",
    "User-Agent": "curl/8.14.1",
    "Via": "2.0 Caddy"
  },
  "origin": "192.0.2.137",
  "url": "https://httpbun.com/any",
  "form": {},
  "data": "",
  "json": null,
  "files": {}
}
```

## saving the result

To save the result of a `curl` command to a file, you can use the `-o` or `--output` option, followed by the name of the file you want to save to. For example:

```console
student@linux:~$ curl -s -o anything.json https://httpbun.com/anything
student@linux:~$ cat anything.json
{
  "method": "GET",
  "args": {},
[...output truncated...]
```

Alternatively, you can use the `-O` or `--remote-name` option to save the file with the same name as it has on the server. For example:

```console
student@linux:~$ curl -s -O https://www.google.com/robots.txt
```

## show headers

To include the HTTP response headers in the output, use the `-i` or `--include` option. To show only the headers, use the `-I` or `--head` option. For example:

```console
student@linux:~$ curl -i http://google.com
HTTP/1.1 301 Moved Permanently
Location: http://www.google.com/
Content-Type: text/html; charset=UTF-8
Content-Security-Policy-Report-Only: object-src 'none';base-uri 'self';script-src 'nonce-kLqF3UVItnFOPwGGRvQIKg' 'strict-dynamic' 'report-sample' 'unsafe-eval' 'unsafe-inline' https: http:;report-uri https://csp.withgoogle.com/csp/gws/other-hp
Date: Fri, 12 Jun 2026 14:58:25 GMT
Expires: Sun, 12 Jul 2026 14:58:25 GMT
Cache-Control: public, max-age=2592000
Server: gws
Content-Length: 219
X-XSS-Protection: 0
X-Frame-Options: SAMEORIGIN

<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>301 Moved</TITLE></HEAD><BODY>
<H1>301 Moved</H1>
The document has moved
<A HREF="http://www.google.com/">here</A>.
</BODY></HTML>
```

## set request headers

To set a custom HTTP request header, use the `-H` or `--header` option followed by the header name and value. For example:

```console
student@linux:~$ curl -H 'x-custom: custom header value' httpbun.com/headers
{
  "headers": {
    "Accept": "*/*",
    "Accept-Encoding": "gzip",
    "Host": "httpbun.com",
    "User-Agent": "curl/8.14.1",
    "Via": "1.1 Caddy",
    "X-Custom": "custom header value"
  }
}
```

## follow redirects

In the example above, we saw that the `curl` command sent a GET request to `http://google.com`, but the response indicated that the document has moved to `http://www.google.com/`. By default, `curl` does not follow redirects. To enable this behavior, use the `-L` or `--location` option:

```console
student@linux:~$ curl http://google.com
<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>301 Moved</TITLE></HEAD><BODY>
<H1>301 Moved</H1>
The document has moved
<A HREF="https://www.google.com/">here</A>.
</BODY></HTML>
student@linux:~$ curl -L http://google.com
<!doctype html><html itemscope="" itemtype="http://schema.org/WebPage" lang="nl-BE"><head>
[...output truncated...]
```

The last command follows the redirect and retrieves the content of the page at `https://www.google.com/`. It will print a considerable amount of HTML code to the terminal, which we didn't show here. Be sure to try it yourself!

## POST data

To send data in the body of an HTTP request, use the `-d` or `--data` option followed by the data you want to send. For example:

```console
student@linux:~$ curl -X POST -d 'user=admin&password=secret' https://httpbun.com/anything
{
  "method": "POST",
  "args": {},
  "headers": {
    "Accept": "*/*",
    "Accept-Encoding": "gzip",
    "Content-Length": "29",
    "Content-Type": "application/x-www-form-urlencoded",
    "Host": "httpbun.com",
    "User-Agent": "curl/8.14.1",
    "Via": "2.0 Caddy"
  },
  "origin": "192.0.2.137",
  "url": "https://httpbun.com/any",
  "form": {
    "password": "secret",
    "user": "admin"
  },
  "data": "",
  "json": null,
  "files": {}
}
```

