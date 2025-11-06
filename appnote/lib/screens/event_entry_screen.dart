// lib/screens/event_entry_screen.dart

import 'package:flutter/material.dart';
import 'package:appnote/models/event.dart';
import 'package:appnote/widgets/app_scaffold.dart';
import 'package:intl/intl.dart';
import '../utils/dialog_helper.dart'; // Cần thêm intl package trong pubspec.yaml

class EventEntryScreen extends StatefulWidget {
  // 1. CẬP NHẬT CONSTRUCTOR (Đã sửa lỗi trước đó)
  final Event? eventToEdit;

  const EventEntryScreen({super.key, this.eventToEdit});

  @override
  State<EventEntryScreen> createState() => _EventEntryScreenState();
}

class _EventEntryScreenState extends State<EventEntryScreen> {
  // 2. KHAI BÁO STATE & CONTROLLER
  late String _titleText;
  late TextEditingController _noteController; // chỉ dùng ghi chú

  // State cho Date/Time Picker
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late bool _isReminderSet;

  @override
  void initState() {
    super.initState();
    final event = widget.eventToEdit;

    // Xác định tiêu đề
    _titleText = event != null ? 'Chỉnh sửa sự kiện' : 'Thêm sự kiện';

    // Controllers
    _noteController = TextEditingController(text: event?.title ?? '');
    _isReminderSet = event?.isReminderSet ?? false;

    // Xử lý Date và Time
    if (event != null) {
      _selectedDate = event.dateTime;
      _selectedTime = TimeOfDay.fromDateTime(event.dateTime);
    } else {
      _selectedDate = DateTime.now();
      _selectedTime = TimeOfDay.now();
    }
  }

  // Xử lý khi đóng màn hình
  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  // HÀM 1: Mở Date Picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(
        const Duration(days: 365),
      ), // Cho phép lùi 1 năm
      lastDate: DateTime.now().add(
        const Duration(days: 365 * 10),
      ), // Cho phép tiến 10 năm
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // HÀM 2: Mở Time Picker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // HÀM 3: Xử lý Lưu
  // void _saveEvent() {
  //   // 1. Tạo DateTime hoàn chỉnh
  //   final DateTime finalDateTime = DateTime(
  //     _selectedDate.year,
  //     _selectedDate.month,
  //     _selectedDate.day,
  //     _selectedTime.hour,
  //     _selectedTime.minute,
  //   );

  //   // 2. Tạo Event Object
  //   final Event newEvent = Event(
  //     // Nếu chỉnh sửa thì giữ lại ID cũ, nếu tạo mới thì dùng ID ngẫu nhiên/mặc định
  //     id: widget.eventToEdit?.id ?? UniqueKey().toString(),
  //     title: _titleController.text.trim(),
  //     // note: _noteController.text.trim(),
  //     dateTime: finalDateTime,
  //     isReminderSet: _isReminderSet,
  //   );

  //   // 3. Đóng màn hình và trả về Event
  //   Navigator.pop(context, newEvent);
  // }

  // HÀM 3: Xử lý Lưu (CẬP NHẬT LOGIC SNACKBAR & XEM NGAY)
  void _saveEvent() async {
    final String eventTitle = _noteController.text
        .trim(); // dùng ghi chú làm tiêu đề
    if (eventTitle.isEmpty) {
      return;
    }

    final DateTime finalDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final Event newEvent = Event(
      id: widget.eventToEdit?.id ?? UniqueKey().toString(),
      title: eventTitle,
      dateTime: finalDateTime,
      isReminderSet: _isReminderSet,
    );

    await showAppSuccessDialog(
      context: context,
      title: 'Tạo sự kiện thành công',
      content: 'Bạn có thể xem lại sự kiện vừa tạo ở mục sự kiện',
      buttonText: 'Xem ngay',
      onButtonPressed: () {
        Navigator.pop(context, newEvent);
      },
      onClosePressed: () {
        Navigator.pop(context, newEvent);
      },
    );
  }

  // HÀM 4: Xử lý Xóa (THÊM LOGIC XÁC NHẬN)
  void _deleteEvent() async {
    // <--- THÊM 'async'
    final String eventTitle = widget.eventToEdit?.title ?? 'Sự kiện này';

    // 1. HIỂN THỊ DIALOG XÁC NHẬN
    final bool? confirmDelete = await showAppConfirmationDialog(
      context: context,
      title: 'Xoá sự kiện',
      content:
          'Bạn có chắc chắn muốn xoá sự kiện "$eventTitle" không? Hành động này không thể hoàn tác.',
      confirmText: 'Xoá ngay',
      cancelText: 'Huỷ',
      // Tùy chọn: Thêm đường dẫn ảnh nếu muốn (imageAssetPath: 'assets/images/delete_icon.png')
    );

    // 2. XỬ LÝ KẾT QUẢ
    // Nếu confirmDelete là true (người dùng nhấn 'Xoá ngay')
    if (mounted && (confirmDelete == true)) {
      // Trả về chuỗi 'DELETE' cho HomeScreen xử lý việc xóa
      Navigator.pop(context, 'DELETE');
    }
    // Nếu confirmDelete là false hoặc null, Dialog đã tự đóng và không làm gì cả.
  }

  @override
  Widget build(BuildContext context) {
    // Định dạng hiển thị Ngày và Giờ
    final dateFormatter = DateFormat('dd/MM/yyyy');
    final timeFormatter = DateFormat.jm();

    // Tạo DateTime giả định để định dạng Time
    final DateTime timeOnly = DateTime(
      2000,
      1,
      1,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    return AppScaffold(
      titleText: _titleText,
      // Nút X (Đóng màn hình)
      appBarLeading: IconButton(
        icon: const Icon(Icons.close, color: Color(0xFF141010)),
        onPressed: () => Navigator.of(context).pop(),
      ),
      // Nút Xóa (Chỉ hiện khi chỉnh sửa)
      appBarActions: widget.eventToEdit != null
          ? [
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Color(0xFFCE5127),
                ),
                onPressed: _deleteEvent,
              ),
            ]
          : null,

      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: <Widget>[
          // 1. Ngày diễn ra
          const Text(
            'Ngày diễn ra',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              fontFamily: 'Manrope-SemiBold',
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF).withOpacity(0.5),
                borderRadius: BorderRadius.circular(1000),
                border: Border.all(
                  color: const Color(0xFFF1D8D0).withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dateFormatter.format(_selectedDate),
                    style: const TextStyle(
                      fontFamily: 'Manrope-Regular',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Color(0xFF141010),
                    ),
                  ),
                  const Icon(
                    Icons.calendar_today,
                    size: 20,
                    color: Color(0xFF141010),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 2. Giờ diễn ra
          const Text(
            'Giờ diễn ra',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              fontFamily: 'Manrope-SemiBold',
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _selectTime(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF).withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFFF1D8D0).withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    // Định dạng giờ (ví dụ: 09:30 AM/PM)
                    timeFormatter.format(timeOnly),
                    style: const TextStyle(
                      fontFamily: 'Manrope-Regular',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Color(0xFF141010),
                    ),
                  ),
                  const Icon(
                    Icons.access_time,
                    size: 20,
                    color: Color(0xFF141010),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 3. Viết ghi chú (Textarea)
          const Text(
            'Viết ghi chú',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              fontFamily: 'Manrope-SemiBold',
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF).withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFFF1D8D0).withOpacity(0.3),
              ),
            ),
            child: TextField(
              controller: _noteController,
              maxLines: 5,
              minLines: 5,
              decoration: const InputDecoration(
                hintText: 'Nhập ghi chú của bạn ở đây',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12.0),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // 4. Bật thông báo (Switch)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  // Icon(
                  //   Icons.notifications_active_outlined,
                  //   color: Color(0xFFCE5127),
                  // ),
                  Image(
                    image: AssetImage('assets/icons/Bell Bing.png'),
                    width: 20,
                    height: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Bật thông báo',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Manrope-SemiBold',
                      color: Color(0xFF383838),
                    ),
                  ),
                ],
              ),
              // Wrap to enforce width:60, height:24, outline 1px, padding -2xs (~4)
              Padding(
                padding: const EdgeInsets.all(4),
                child: SwitchTheme(
                  data: SwitchThemeData(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    trackOutlineWidth: const WidgetStatePropertyAll(1.0),
                    trackOutlineColor: WidgetStatePropertyAll(
                      const Color(0xFFCE5127).withOpacity(0.35),
                    ),
                  ),
                  child: SizedBox(
                    width: 72,
                    height: 32,
                    child: Transform.scale(
                      scale: 1.2,
                      child: Switch(
                        value: _isReminderSet,
                        onChanged: (bool value) {
                          setState(() {
                            _isReminderSet = value;
                          });
                        },
                        activeColor: Colors.white,
                        activeTrackColor: const Color(0xFFCE5127),
                        inactiveThumbColor: const Color(0xFF7A7A7A),
                        inactiveTrackColor: const Color(0xFFF1D8D0),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),

          // 5. Nút Lưu
          ElevatedButton(
            onPressed: _saveEvent,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFCE5127),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
              elevation: 0,
            ),
            child: Text(
              widget.eventToEdit != null ? 'Cập nhật' : 'Lưu',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: 'Manrope-Regular',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
