from BaseHTTPServer import BaseHTTPRequestHandler, HTTPServer
import cgi
import urlparse
import server

def write_file_to_upload_dst(content, filename='./dst.jpg'):
    with open(filename, 'w') as file:
        file.write(content)

class ImageHttpServer(BaseHTTPRequestHandler):
    def _set_headers(self):
        self.send_response(200)
        self.send_header('Content-Type', 'text/html')
        self.end_headers()

    def do_GET(self):
        print (self.path)
        if self.path.startswith('/screen'):
            self.send_response(200)
            self.send_header('Content-Type', 'image/jpeg')
            self.end_headers()
            with open("./screenshot.jpg", 'rb') as file:
                img = file.read()
                self.wfile.write(img)
        else:
            self._set_headers()
            with open("./index.html", 'r') as file:
                self.wfile.write(file.read())


    def do_POST(self):
        content_length = int(self.headers['content-length'])
        content = self.rfile.read(content_length)
        write_file_to_upload_dst(content, './screenshot.jpg')

        ctype, pdict = cgi.parse_header(self.headers.getheader('content-type'))
        if ctype == 'multipart/form-data':
            postvars = cgi.parse_multipart(self.rfile, pdict)
            print(postvars)
            for key in postvars:
                if key == 'file':
                    write_file_to_upload_dst(postvars[key][0])
        self._set_headers()
        self.wfile.write("<html><body><h1>POST!</h1></body></html>")

    def do_PUT(self):
        ctype, pdict = cgi.parse_header(self.headers.getheader('content-type'))
        content_length = int(self.headers['content-length'])
        var_content = self.rfile.read(content_length)
        vars = urlparse.parse_qs(var_content)
        command = int(vars['command'][0])
        payload = str(vars['payload'][0])
        server.notify_clients(command, payload)
        self._set_headers()
        self.wfile.write("<html><body><h1>PUT!</h1></body></html>")


def run(server_class = HTTPServer, handle_class = ImageHttpServer, port=8070):
    socket = server.start_server()

    server_address = ('', port)
    httpd = server_class(server_address, handle_class)
    print("Image Http Server Started")
    httpd.serve_forever()


run()