import 'package:chat_app/viewmodels/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/chat_view_model.dart';
import '../views/profile_screen.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';  // Add this import

class ChatScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final chatViewModel = Provider.of<ChatViewModel>(context);
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        actions: [
          // Show user avatar and email in AppBar
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Row(
              children: [
                if (authViewModel.userPhotoUrl != null)
                  CircleAvatar(
                    backgroundImage: NetworkImage(authViewModel.userPhotoUrl!),
                    radius: 15,
                  ),
                SizedBox(width: 8),
                Text(authViewModel.userEmail ?? ''),
                IconButton(
                  icon: Icon(Icons.account_circle),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: chatViewModel.messages,
                builder: (context, snapshot) {
                  // Add error handling
                  if (snapshot.hasError) {
                    return Center(child: Text('Error loading messages'));
                  }

                  // Handle loading state
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  // Handle empty state
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No messages yet'));
                  }

                  final messages = snapshot.data!.docs;

                  return ListView.builder(
                    reverse: true, // Newest messages at bottom
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message =
                          messages[index].data() as Map<String, dynamic>;
                      final isMe =
                          message['senderId'] == authViewModel.currentUser?.uid;

                      return Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            if (!isMe) ...[
                              Padding(
                                padding: EdgeInsets.only(bottom: 4),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          message['senderPhoto'] != null
                                          ? NetworkImage(message['senderPhoto'])
                                          : null,
                                      radius: 12,
                                      child: message['senderPhoto'] == null
                                          ? Text(message['email'][0])
                                          : null,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      message['email'] ?? 'Unknown',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            // Add the message bubble here
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isMe ? Colors.blue : Colors.grey[300],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                message['message'] ?? '',
                                style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                            // Add timestamp
                            Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Text(
                                message['timestamp']
                                        ?.toDate()
                                        .toString()
                                        .substring(0, 16) ??
                                    '',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      border: InputBorder.none,
                    ),
                    focusNode: _focusNode, // Add this
                    textInputAction: TextInputAction.send, // Add this
                    onSubmitted: (text) {
                      // Add this
                      if (text.trim().isNotEmpty) {
                        chatViewModel.sendMessage(text.trim());
                        _controller.clear();
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.trim().isNotEmpty) {
                      chatViewModel.sendMessage(_controller.text.trim());
                      _controller.clear();
                      _focusNode.requestFocus(); // Keep keyboard open
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
