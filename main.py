from f1_telemetry.server import *
import signal
import sys
def signal_handler(sig, frame):
	print('You pressed Ctrl+C!')
	sys.exit(0)

	signal.signal(signal.SIGINT, signal_handler)
#print('Press Ctrl+C')
#signal.pause()

if __name__ == '__main__':
    for packet in get_telemetry():	
        print(packet)
