import socket
import thread
import signal
import sys
import struct
import binascii

client_sockets = {}

def conn_process_thread(conn, addr):
    global client_sockets
    print("Connect with: " + str(addr[0]) + ":" + str(addr[1]))
    key = str(addr[0])+":" + str(addr[1])
    client_sockets[key] = conn
    while True:
        try:
            data = conn.recv(1024)
            conn.send("U Sayed: ")
            conn.sendall(data)
        except:
            conn.close()
            del client_sockets[key]
            return
    conn.close()
    del client_sockets[key]


def listen_thread(socket):
    while True:
        socket.listen(10)
        conn, addr = socket.accept()
        thread.start_new_thread(conn_process_thread, (conn, addr))


def start_server():
    HOST = ''
    PORT = 9009

    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    try:
        server_socket.bind((HOST, PORT))
    except socket.error:
        print("Bind Failed!")
    thread.start_new_thread(listen_thread, (server_socket,))
    return server_socket


def build_command_packet(command, payload):
    packet_size = 4 + len(payload)
    value = (packet_size, command)
    s = struct.Struct('I I')
    data = s.pack(*value)
    compose_data = data + payload
    return compose_data

def list_clients():
    global client_sockets
    for key in client_sockets:
        print(key)

def notify_clients(command, payload):
    global client_sockets
    for key in client_sockets:
        client_sockets[key].send(build_command_packet(command, payload))

if __name__ == '__main__':

    socket = start_server()
    build_command_packet(100, b"client get ready")

    def signal_handler(signal, frame):
        print("U Press Ctrl+C, Exiting...")
        socket.close()
        sys.exit(0)
    signal.signal(signal.SIGINT, signal_handler)
    while True:
        command = raw_input('> ')
        if command.startswith('touch'):
            args = command.split(" ")
            payload = b'{' + str.format(b'"x":{0}, "y":{1}', float(args[1]), float(args[2])) + b'}'
            notify_clients(1001, payload)
        elif command.startswith('ss'):
            notify_clients(1000, b'')
        elif command.startswith('unlock'):
            notify_clients(1002, b'')
        elif command.startswith('restart'):
            notify_clients(1003, b'killall -HUP SpringBoard')
        elif command.startswith('do'):
            args = command[3:]
            notify_clients(1003, args)
        elif command == 'status':
            list_clients()
        elif command == 'exit':
            socket.close()
            sys.exit(0)

