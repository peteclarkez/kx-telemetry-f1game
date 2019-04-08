from f1_telemetry.server import *
import signal
import sys

def signal_handler(sig, frame):
    print('You pressed Ctrl+C!')
    sys.exit(0)

    signal.signal(signal.SIGINT, signal_handler)

def callback(type,data):
    print(type," ",data)
    
if __name__ == '__main__':
    callbacktel(callback)
