import 'package:flutter/material.dart';

import '../models/chat_models.dart';
import 'chat_screen.dart';
import '../main_navigation.dart';

// Pantalla de lista de chats
class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});
  static final List<Story> _stories = [
    const Story(
      name: 'Cristian',
      avatarUrl:
          'https://okdiario.com/img/vida-sana/2015/01/Chris-Hemsworth.jpg',
      isOnline: true,
    ),
    const Story(
      name: 'María',
      avatarUrl:
          'https://okdiario.com/img/vida-sana/2015/01/Paula-Butrague%C3%B1o.jpg',
      isOnline: false,
    ),
    const Story(
      name: 'Alex',
      avatarUrl: 'https://okdiario.com/img/vida-sana/2015/01/Henry-Cavill.jpg',
      isOnline: false,
    ),
    const Story(
      name: 'Diego',
      avatarUrl: 'https://okdiario.com/img/vida-sana/2015/01/Chris-Evans.jpg',
      isOnline: true,
    ),
  ];

  static final List<Chat> _chats = [
    Chat(
      name: 'Cristian López',
      avatarUrl:
          'https://okdiario.com/img/vida-sana/2015/01/Chris-Hemsworth.jpg',
      lastMessage: '¿Quieres ir al gym esta semana?',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 25)),
      isOnline: true,
      messages: [
        Message(
          text: 'Hola, ¿cómo estás?',
          isMine: false,
          time: DateTime.now().subtract(Duration(minutes: 120)),
        ),
        Message(
          text: '¡Todo bien! ¿Y tú?',
          isMine: true,
          time: DateTime.now().subtract(Duration(minutes: 110)),
        ),
        Message(
          text: 'Listo para entrenar mañana.',
          isMine: false,
          time: DateTime.now().subtract(Duration(minutes: 25)),
        ),
      ],
    ),
    Chat(
      name: 'María Gómez',
      avatarUrl:
          'https://okdiario.com/img/vida-sana/2015/01/Paula-Butrague%C3%B1o.jpg',
      lastMessage: 'Perfecto, nos vemos a las 6.',
      lastMessageTime: DateTime.now().subtract(
        const Duration(hours: 1, minutes: 15),
      ),
      isOnline: false,
      messages: [
        Message(
          text: '¿A qué hora quedamos?',
          isMine: false,
          time: DateTime.now().subtract(Duration(hours: 2)),
        ),
        Message(
          text: 'A las 6 pm en el gimnasio.',
          isMine: true,
          time: DateTime.now().subtract(Duration(hours: 1, minutes: 30)),
        ),
        Message(
          text: 'Perfecto, nos vemos a las 6.',
          isMine: false,
          time: DateTime.now().subtract(Duration(hours: 1, minutes: 15)),
        ),
      ],
    ),
    Chat(
      name: 'Alex Torres',
      avatarUrl: 'https://okdiario.com/img/vida-sana/2015/01/Henry-Cavill.jpg',
      lastMessage: '¿Ya viste la nueva rutina?',
      lastMessageTime: DateTime.now().subtract(
        const Duration(hours: 3, minutes: 20),
      ),
      isOnline: true,
      messages: [
        Message(
          text: '¡Hola! ¿Ya probaste la nueva rutina?',
          isMine: false,
          time: DateTime.now().subtract(Duration(hours: 5)),
        ),
        Message(
          text: 'Todavía no, la voy a revisar hoy.',
          isMine: true,
          time: DateTime.now().subtract(Duration(hours: 3, minutes: 45)),
        ),
        Message(
          text: '¿Ya viste la nueva rutina?',
          isMine: false,
          time: DateTime.now().subtract(Duration(hours: 3, minutes: 20)),
        ),
      ],
    ),
  ];

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    if (diff.inMinutes < 60) return '${diff.inMinutes} min';
    if (diff.inHours < 24) return '${diff.inHours} h';
    return '${diff.inDays} d';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mensajes'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => const MainNavigation(initialIndex: 0),
              ),
              (route) => false,
            );
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Historias (stories)
            SizedBox(
              height: 120,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: _stories.length,
                itemBuilder: (context, index) {
                  final story = _stories[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StoryScreen(story: story),
                              ),
                            );
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFDE0046),
                                      Color(0xFFF7A34B),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: CircleAvatar(
                                    radius: 34,
                                    backgroundImage: NetworkImage(
                                      story.avatarUrl,
                                    ),
                                  ),
                                ),
                              ),
                              if (story.isOnline)
                                const Positioned(
                                  right: -2,
                                  bottom: -2,
                                  child: CircleAvatar(
                                    radius: 8,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: 6,
                                      backgroundColor: Color(0xFF34D399),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 70,
                          child: Text(
                            story.name,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 1),
            // Lista de chats
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 12),
                itemCount: _chats.length,
                separatorBuilder: (context, index) => const Divider(indent: 88),
                itemBuilder: (context, index) {
                  final chat = _chats[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundImage: NetworkImage(chat.avatarUrl),
                        ),
                        if (chat.isOnline)
                          const Positioned(
                            right: -2,
                            bottom: -2,
                            child: CircleAvatar(
                              radius: 8,
                              backgroundColor: Color.fromARGB(
                                255,
                                255,
                                255,
                                255,
                              ),
                              child: CircleAvatar(
                                radius: 6,
                                backgroundColor: Color(0xFF34D399),
                              ),
                            ),
                          ),
                      ],
                    ),
                    title: Text(
                      chat.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      chat.lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                      _formatTime(chat.lastMessageTime),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(chat: chat),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StoryScreen extends StatelessWidget {
  final Story story;

  const StoryScreen({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(story.name), elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(story.avatarUrl),
              ),
              const SizedBox(height: 16),
              Text(
                'Historia de ${story.name}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Historia con contenido multimedia.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
