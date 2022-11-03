#! /usr/bin/env python3


import http.server
import functools
import ssl

CERT_FILE = "tls-certs/service.pem"
KEY_FILE = "tls-certs/service.key"
DIRECTORY = "./"

handler = functools.partial(http.server.SimpleHTTPRequestHandler, directory=DIRECTORY)
httpd = http.server.HTTPServer(("localhost", 4443), handler)
httpd.socket = ssl.wrap_socket(httpd.socket, certfile=CERT_FILE, keyfile=KEY_FILE, server_side=True)
httpd.serve_forever()
