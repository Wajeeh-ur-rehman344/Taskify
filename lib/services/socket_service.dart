import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  void connect(String userId) {
    socket = IO.io('http://10.211.0.201:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      print('Connected to socket.io server');
      socket.emit('join', userId); // Join user's room
    });

    socket.onDisconnect((_) {
      print('Disconnected from socket.io server');
    });
  }

  void sendMessage(
      String senderId, String receiverId, String taskId, String messageText) {
    socket.emit('sendMessage', {
      "senderId": senderId,
      "receiverId": receiverId,
      "taskId": taskId,
      "messages": [
        {
          "description": messageText,
          "timestamp": DateTime.now().toIso8601String(),
        }
      ]
    });
  }

  void listenForMessages(Function(dynamic) onMessageReceived) {
    socket.on('newMessage', (data) {
      onMessageReceived(data);
    });
  }

  void disconnect() {
    socket.disconnect();
  }
}
