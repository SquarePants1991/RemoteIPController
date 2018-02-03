from BaseHTTPServer import BaseHTTPRequestHandler, HTTPServer
from cgi import parse_header, parse_multipart

def write_file_to_upload_dst(content, filename='./dst.jpg'):
    with open(filename, 'w') as file:
        file.write(content)

class ImageHttpServer(BaseHTTPRequestHandler):
    def _set_headers(self):
        self.send_response(200)
        self.send_header('Content-Type', 'text/html')
        self.end_headers()

    def do_GET(self):
        self._set_headers()
        self.wfile.write("<html><body><h1>hi!</h1></body></html>")

    def do_POST(self):
        content_length = int(self.headers['content-length'])
        content = self.rfile.read(content_length)
        write_file_to_upload_dst(content, './content.jpg')

        ctype, pdict = parse_header(self.headers.getheader('content-type'))
        print(ctype)
        if ctype == 'multipart/form-data':
            postvars = parse_multipart(self.rfile, pdict)
            print(postvars)
            for key in postvars:
                if key == 'file':
                    write_file_to_upload_dst(postvars[key][0])
        self._set_headers()
        self.wfile.write("<html><body><h1>POST!</h1></body></html>")


def run(server_class = HTTPServer, handle_class = ImageHttpServer, port=8070):
    server_address = ('', port)
    httpd = server_class(server_address, handle_class)
    print("Image Http Server Started")
    httpd.serve_forever()


run()