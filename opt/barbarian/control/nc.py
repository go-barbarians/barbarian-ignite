#!/usr/bin/python
import sys, getopt
import socket

def main(argv):
   host = ''
   port = 0
   message = ''
   buffer_size = 1024

   try:
      opts, args = getopt.getopt(argv,'ht:p:m:',['target-host=','port=', 'message='])
   except getopt.GetoptError:
      print 'nc -t <host> -p <port> -m <message>'
      sys.exit(2)
   for opt, arg in opts:
      if opt == '-h':
         print 'nc -t <host> -p <port> -m <message>'
         sys.exit()
      elif opt in ('-t', '--target-host'):
         host = arg
      elif opt in ('-p', '--port'):
         port = arg
      elif opt in ('-m', '--message'):
         message = arg
   s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
   s.connect((host, int(port)))
   s.send(message)
   data = s.recv(buffer_size)
   s.close()
   print data

if __name__ == '__main__':
    main(sys.argv[1:])
