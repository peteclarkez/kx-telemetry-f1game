import socket
from f1_telemetry.f1_2018_struct import *

UDP_IP = "127.0.0.1"
UDP_PORT = 20777

def callbacktel(callback):
	"""
	Main function to bind as a server and then run a loop to collect data 
	
	"""

	sock = bindudp()
	while True:
		packet = getcurrentPacket(sock)		
		packettype=type(packet).__name__
		callback(packettype,getClassAsDict(packet))
		
		
def get_telemetry():
	"""
	Generator function which yields UDPPackets from the specified ip address and port

	:yield: A a packet send by F1 2018
	"""
	sock = bindudp()
	while True:
		packet = getcurrentPacket(sock)
		yield packet


def bindudp():
	"""
	Function to initilise the UDP server to listen for F1 telemetry

	:return: A socket which sould be connected to the IP address
	"""
	sock = socket.socket(socket.AF_INET,
						 socket.SOCK_DGRAM)
	sock.bind((UDP_IP, UDP_PORT))
	
	print("Binding to "+UDP_IP+":"+str(UDP_PORT))
	return sock

	
def getcurrentPacket(sock):
	"""
	Function to read the data from the socket and return a complete message in the correct class

	:return: An object representing one of the valid messages
	"""

	data, _ = sock.recvfrom(1341)
	header = Header.from_buffer_copy(data[0:21])
	if int(header.m_packetId) == 0:
		packet = PacketMotionData.from_buffer_copy(data[0:1341])

	elif int(header.m_packetId) == 1:
		packet = PacketSessionData.from_buffer_copy(data[0:147])

	elif int(header.m_packetId) == 2:
		packet = PacketLapData.from_buffer_copy(data[0:841])

	elif int(header.m_packetId) == 3:
		packet = PacketEventData.from_buffer_copy(data[0:25])

	elif int(header.m_packetId) == 4:
		packet = PacketParticipantsData.from_buffer_copy(data[0:1082])

	elif int(header.m_packetId) == 5:
		packet = PacketCarSetupData.from_buffer_copy(data[0:841])

	elif int(header.m_packetId) == 6:
		packet = PacketCarTelemetryData.from_buffer_copy(data[0:1085])

	elif int(header.m_packetId) == 7:
		packet = PacketCarStatusData.from_buffer_copy(data[0:1061])
		
	return packet