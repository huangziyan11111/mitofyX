#!/usr/bin/env python
import posixpath
import argparse
import urllib
import os

from CGIHTTPServer import CGIHTTPRequestHandler
from BaseHTTPServer import HTTPServer

class CGIHandler(CGIHTTPRequestHandler):
    cgi_directories = ["/cgi"]

    def translate_path(self, path):
        path = path.split('?',1)[0]
        path = path.split('#',1)[0]
        path = posixpath.normpath(urllib.unquote(path))
        words = path.split('/')
        words = filter(None, words)
        path = self.base_path
        for word in words:
            drive, word = os.path.splitdrive(word)
            head, word = os.path.split(word)
            if word in (os.curdir, os.pardir): continue
            path = os.path.join(path, word)
        return path

class RHTTPServer(HTTPServer):
    def __init__(self, base_path, *args, **kwargs):
        HTTPServer.__init__(self, *args, **kwargs)
        self.RequestHandlerClass.base_path = base_path


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--port', '-p', default=8000, type=int, help="Port")
    parser.add_argument('--dir', '-d', default=os.getcwd(), type=str, help="Root directory of server")
    args = parser.parse_args()

    server_address = ('', args.port)
    httpd = RHTTPServer(args.dir, server_address, CGIHandler)
    sa = httpd.socket.getsockname()
    print "Serving on", sa[0], "port", sa[1], "..."
    httpd.serve_forever()