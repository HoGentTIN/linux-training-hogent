## practice: curl

In these exercises, we'll make use of the [httpbun](https://httpbun.com/) service. Be sure to check the documentation on the website to see how the different endpoints work!

If you want to investigate in even more detail how the exercises below work, you can use a network traffic analyzer such as [Wireshark](https://www.wireshark.org/) to see the raw HTTP traffic.

Also `curl` has a `-v` or `--verbose` option that shows the raw HTTP request and response messages in the terminal.

1. Try out the different HTTP methods GET, POST, PUT, DELETE, ... in combination with the endpoints '/get', '/post', '/put', '/delete', ... and observe the output.

    What happens when you combine a method with an endpoint that doesn't match it, e.g. POST with '/get'?

2. Use the endpoint '/svg' render the text "Hi" in an SVG image and save the result to a file (e.g. `hi.svg`). Hide progress output in the terminal.

3. Use the endpoint '/redirect' to test how `curl` handles HTTP redirects. What's the difference in behaviour when you use the option to follow redirects or not?

    In this exercise, show the response headers in the output!

4. Which versions of the HTTP protocol does httpbun.com support? Is there a difference in behaviour between http and https? Search the curl man-page to find how to specify the HTTP version in the request and test the results.

    You will probably need to show the response header in the output. The verbose option will even give more information.

5. Test simple authentication with the endpoint '/basic-auth/{user}/{passwd}'. Choose a username and password. What happens when you provide the correct username and password? What happens when you provide incorrect or no credentials?

6. Use the '/any' endpoint to see how you can send data in a POST request. Try sending form data, JSON data, and URL parameters (e.g. `?color=blue&size=medium`). How does the server interpret each of these types of data?

7. Request the main page of search engine [DuckDuckGo](https://duckduckgo.com/) and observe the language of the response. Use the appropriate header to request the page in a different language (e.g. `nl-BE` and `zh-CN`).

