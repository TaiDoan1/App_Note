// lib/screens/manual_note_screen.dart (CODE ĐẦY ĐỦ)

import 'package:appnote/models/note.dart'; // <-- Import model
import 'package:appnote/utils/dialog_helper.dart'; // <-- Import popup
import 'package:appnote/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

class ManualNoteScreen extends StatefulWidget {
  const ManualNoteScreen({super.key});

  @override
  State<ManualNoteScreen> createState() => _ManualNoteScreenState();
}

class _ManualNoteScreenState extends State<ManualNoteScreen> {
  final TextEditingController _noteController = TextEditingController();
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    // TẠI SAO: Lắng nghe thay đổi để bật/tắt nút Lưu
    _noteController.addListener(_checkFormValidity);
  }

  @override
  void dispose() {
    _noteController.removeListener(_checkFormValidity);
    _noteController.dispose();
    super.dispose();
  }

  void _checkFormValidity() {
    setState(() {
      _isFormValid = _noteController.text.isNotEmpty;
    });
  }

  // TẠI SAO: Logic khi nhấn "Lưu"
  void _saveNote() async {
    final noteText = _noteController.text.trim();
    if (noteText.isEmpty) return;

    // 1. Đóng gói dữ liệu
    final newNote = Note(description: noteText);
    final newGroup = NoteGroup(date: 'Hôm nay', notes: [newNote]);
    
    if (!mounted) return;

    // 2. Gọi Popup Thành công (giống hệt Thu Chi)
    await showAppSuccessDialog(
      context: context,
      title: 'Tạo ghi chú thành công',
      content: 'Bạn có thể xem lại ghi chú vừa tạo ở mục ghi chú',
      buttonText: 'Xem ngay',
      
      // Khi nhấn "Xem ngay" -> Pop màn hình VÀ gửi dữ liệu
      onButtonPressed: () {
        if (mounted) {
          Navigator.pop(context, newGroup);
        }
      },
      // Khi nhấn "X" (đóng) -> Vẫn Pop màn hình VÀ gửi dữ liệu
      onClosePressed: () {
          if (mounted) {
            Navigator.pop(context, newGroup);
          }
      }
    );
  }

  // TẠI SAO: Xây dựng UI (y hệt thiết kế)
  @override
  Widget build(BuildContext context) {
    // TẠI SAO: Dùng LayoutBuilder + ConstrainedBox + Column + Spacer
    // để đẩy nút "Lưu" xuống dưới cùng của màn hình
    return LayoutBuilder(
      builder: (context, constraints) {
        return AppScaffold(
          titleText: 'Thêm ghi chú',
          appBarLeading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF141010)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          body: SingleChildScrollView(
            child: ConstrainedBox(
              // TẠI SAO: Buộc Column phải cao ít nhất bằng chiều cao màn hình
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - (kToolbarHeight + MediaQuery.of(context).padding.top),
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 1. Tiêu đề "Viết ghi chú"
                      const Text(
                        'Viết ghi chú',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF383838),
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // 2. Ô nhập liệu (giống thiết kế)
                      TextFormField(
                        controller: _noteController,
                        autofocus: true, // Tự động mở bàn phím
                        maxLines: 10, // Số dòng tối đa (cho phép cuộn)
                        minLines: 5,  // Chiều cao tối thiểu (5 dòng)
                        decoration: InputDecoration(
                          hintText: 'Nhập ghi chú của bạn ở đây',
                          hintStyle: const TextStyle(color: Color(0xFF7A7A7A)),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFF1D8D0), width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFCE5127), width: 1.5),
                          ),
                        ),
                      ),
                      
                      const Spacer(), // TẠI SAO: Đẩy nút "Lưu" xuống dưới
                      const SizedBox(height: 24), 

                      // 3. Nút "Lưu"
                      ElevatedButton(
                        onPressed: _isFormValid ? _saveNote : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isFormValid
                              ? const Color(0xFFCE5127)
                              : const Color(0xFFEFEFEF),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1000),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Lưu',
                          style: TextStyle(
                            color: _isFormValid ? Colors.white : const Color(0xFFBDBDBD),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      
                      SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}