import socket
import thread


def conn_process_thread(conn, addr):
    print("Connect with: " + str(addr[0]) + ":" + str(addr[1]))
    while True:
        data = conn.recv(1024)
        conn.send("U Sayed: ")
        conn.sendall(data)
    conn.close()

def start_server():
    HOST = ''
    PORT = 9001

    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    try:
        s.bind((HOST, PORT))
    except socket.error, msg:
        print("Bind Failed: " + str(msg))

    while True:
        s.listen(10)
        conn, addr = s.accept()
        thread.start_new_thread(conn_process_thread, (conn, addr))
    s.close()

start_server()
