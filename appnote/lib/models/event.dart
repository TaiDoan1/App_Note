// lib/models/event.dart

class Event {
  final String title;
  final DateTime dateTime;
 
  final bool isReminderSet; 
  final String id; // Thêm ID để dễ dàng quản lý (sửa/xoá)

  Event({
    required this.title,
 
    required this.dateTime,
    this.isReminderSet = false,
    required this.id,
  });

  // TẠI SAO: Tạo hàm copyWith để dễ dàng cập nhật trạng thái (ví dụ: đặt thông báo)
  Event copyWith({
    String? title,
    DateTime? dateTime,
    bool? isReminderSet,
    String? id,
  }) {
    return Event(
      title: title ?? this.title,
      dateTime: dateTime ?? this.dateTime,
      isReminderSet: isReminderSet ?? this.isReminderSet,
      id: id ?? this.id,
    );
  }
}