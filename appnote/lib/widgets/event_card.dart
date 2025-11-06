// lib/widgets/event_card.dart

import 'package:appnote/models/event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Cần import thư viện intl cho định dạng ngày giờ

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback? onTap;
  // Callback khi nhấn nút Thông báo
  final VoidCallback? onNotificationTap;

  const EventCard({
    super.key,
    required this.event,
    this.onTap,
    this.onNotificationTap,
  });

  // TẠI SAO: Hàm định dạng ngày tháng và thời gian
  String _formatDateTime(DateTime dt) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('HH:mm');
    return '${dateFormat.format(dt)} • ${timeFormat.format(dt)}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,

        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white, // Nền trắng
          borderRadius: BorderRadius.circular(16),
          // Viền bên trái màu cam
          border: const Border(
            left: BorderSide(color: Color(0xFFD77250), width: 4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 5,
              offset: const Offset(0, 6),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. HEADER (Lịch + Thời gian)
            Row(
              children: [
                // TẠI SAO: Icon lịch
                Image.asset(
                  'assets/icons/Prefix-icon.png',
                  width: 28,
                  height: 28,
                ),
                const SizedBox(width: 8),

                // TẠI SAO: Ngày và giờ
                Text(
                  _formatDateTime(event.dateTime),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF141010),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // 2. TIÊU ĐỀ SỰ KIỆN
            Padding(
              padding: const EdgeInsets.only(left: 36),
              child: Text(
                event.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Manrope-Regular',
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF141010),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 12),

            // 3. NÚT THÔNG BÁO
            Padding(
              padding: const EdgeInsets.only(left: 36),
              child: GestureDetector(
                onTap: onNotificationTap,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  decoration: BoxDecoration(
                    // TẠI SAO: Màu nền phụ thuộc vào trạng thái đặt thông báo
                    color: event.isReminderSet
                        ? const Color(0xFFFAE5CC) // Màu cam nhạt (Đã đặt)
                        : const Color(0xFFEFEFEF), // Màu xám nhạt (Chưa đặt)
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon(
                      //   event.isReminderSet
                      //       ? Icons.notifications_active
                      //       : Icons.notifications_none,
                      //   size: 14,
                      //   color: event.isReminderSet
                      //       ? const Color(0xFFCE5127)
                      //       : const Color(0xFF7A7A7A),
                      // ),
                      Image.asset(
                        'assets/icons/Bell Bing.png',
                        width: 20,
                        height: 20,
                        color: event.isReminderSet
                            ? const Color(0xFFCE5127)
                            : const Color(0xFF7A7A7A),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        event.isReminderSet ? 'Thông báo' : 'Đặt thông báo',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w400,
                          color: event.isReminderSet
                              ? const Color(0xFFCE5127)
                              : const Color(0xFF7A7A7A),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
