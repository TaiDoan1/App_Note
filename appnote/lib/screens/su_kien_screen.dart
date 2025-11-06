// lib/screens/su_kien_screen.dart

import 'package:flutter/material.dart';
import 'package:appnote/data/mock_event_data.dart';
import 'package:appnote/models/event.dart';
import 'package:appnote/widgets/event_card.dart';

// TẠI SAO: Chuyển SuKienScreen thành StatefulWidget để có thể quản lý danh sách sự kiện
class SuKienScreen extends StatefulWidget {
  final List<Event> events;
  final Function(Event event, int index) onTapEvent;
  final Function(Event event) onToggleReminder;
  final Function(Event, int) onDeleteEvent;
  const SuKienScreen({
    super.key,
    required this.events,
    required this.onTapEvent,
    required this.onToggleReminder,
    required this.onDeleteEvent,
  });

  @override
  State<SuKienScreen> createState() => _SuKienScreenState();
}

class _SuKienScreenState extends State<SuKienScreen> {
  @override
  Widget build(BuildContext context) {
    final events = widget.events; // dùng danh sách từ parent
    return ListView.builder(
      padding: const EdgeInsets.only(
        top: 16.0,
        bottom: 24.0,
        left: 16,
        right: 16,
      ),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Dismissible (
          // 1. Key duy nhất là BẮT BUỘC cho Dismissible
          key: ValueKey(event.id), 
          
          // 2. Định nghĩa hướng vuốt (Chỉ từ phải sang trái)
          direction: DismissDirection.endToStart,
          // 3. Background: Hiển thị khi vuốt
          background: Container(
            // Màu đỏ cho hành động xóa
            color: const Color(0xFFCE5127), 
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20.0),
            child: const Icon(Icons.delete, color: Colors.white, size: 30),
          ),
          
          // 4. HÀNH ĐỘNG XÓA (sau khi vuốt hoàn tất)
          onDismissed: (direction) {
            // Gọi callback để xóa sự kiện ở HomeScreen
            widget.onDeleteEvent(event, index); 
            
            // Lưu ý: Không cần gọi setState hay xóa khỏi danh sách ở đây.
            // Việc xóa sẽ được xử lý trong HomeScreen, sau đó ListView sẽ tự rebuild.
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: EventCard(
              event: event,
              onTap: () {
                widget.onTapEvent(event, index);
              },
              onNotificationTap: () {
                widget.onToggleReminder(event);
              },
            ),
          ),
        );
      },
    );
  }
}
