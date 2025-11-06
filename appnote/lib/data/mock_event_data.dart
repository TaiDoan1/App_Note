// lib/data/mock_event_data.dart

import 'package:appnote/models/event.dart';

// TẠI SAO: Dữ liệu giả lập cho màn hình Sự kiện
final List<Event> mockEvents = [
  Event(
    id: 'e1',
    title: 'Đi ăn cưới Khánh Huyền',
    dateTime: DateTime(2025, 10, 20, 15, 0), // 20/10/2025 15:00
    isReminderSet: true,
  ),
  Event(
    id: 'e2',
    title: 'Họp team dự án Q4',
    dateTime: DateTime(2025, 10, 25, 10, 30), // 25/10/2025 10:30
    isReminderSet: false,
  ),
  Event(
    id: 'e3',
    title: 'Sinh nhật mẹ',
    dateTime: DateTime(2025, 11, 01, 18, 0), // 01/11/2025 18:00
    isReminderSet: true,
  ),
];