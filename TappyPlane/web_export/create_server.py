#!/usr/bin/env python3

import http.server
import socketserver

class CustomHandler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Cross-Origin-Opener-Policy', 'same-origin')
        self.send_header('Cross-Origin-Embedder-Policy', 'require-corp')
        super().end_headers()


PORT = 8000 

with socketserver.TCPServer(("", PORT), CustomHandler) as httpd:
    print(f"Server running on port {PORT}")
    httpd.serve_forever()
