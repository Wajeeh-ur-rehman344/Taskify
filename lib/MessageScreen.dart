import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:intl/intl.dart';

class MessageScreen extends StatefulWidget {
  final String middId;
  final String custId;
  final String taskId; // Added taskId for fetching messages

  const MessageScreen({
    super.key,
    required this.middId,
    required this.custId,
    required this.taskId,
  });

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  late IO.Socket socket;
  TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    _connectSocket();
  }

  void _connectSocket() {
    socket = IO.io('http://10.211.0.201:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    // Listen for incoming messages
    socket.on('newMessage', (data) {
      if (data['taskId'] == widget.taskId) {
        setState(() {
          for (var msg in data['messages']) {
            messages.add({
              'sender': data['senderId'] == widget.custId ? 'You' : 'Middleman',
              'message': msg['description'],
              'timestamp': msg['timestamp'],
            });
          }
        });
      }
    });
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      String messageText = _controller.text;
      socket.emit('sendMessage', {
        'senderId': widget.custId,
        'receiverId': widget.middId,
        'taskId': widget.taskId,
        'messages': [
          {
            'description': messageText,
            'timestamp': DateTime.now().toIso8601String(),
          }
        ]
      });

      setState(() {
        messages.add({
          'sender': 'You',
          'message': messageText,
          'timestamp': DateTime.now().toIso8601String(),
        });
        _controller.clear();
      });
    }
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TASKIFY",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Color(0xFF6D1B1B),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[messages.length - 1 - index];
                final isSender = message['sender'] == 'You';
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment:
                        isSender ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                        color: isSender ? Color(0xFF6D1B1B) : Colors.grey[300],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message['message']!,
                            style: TextStyle(
                              color: isSender ? Colors.white : Colors.black,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            DateFormat('hh:mm a').format(
                                DateTime.parse(message['timestamp']!)),
                            style: TextStyle(
                              fontSize: 10,
                              color: isSender ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.attach_file),
                  onPressed: () {
                    // Handle attachment
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
