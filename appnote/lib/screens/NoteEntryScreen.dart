// lib/screens/note_entry_screen.dart

import 'package:appnote/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

class NoteEntryScreen extends StatefulWidget {
  // TẠI SAO: Nội dung hiện tại cần sửa
  final String initialText;

  const NoteEntryScreen({
    super.key,
    required this.initialText,
  });

  @override
  State<NoteEntryScreen> createState() => _NoteEntryScreenState();
}

class _NoteEntryScreenState extends State<NoteEntryScreen> {
  late TextEditingController _controller;
  
  @override
  void initState() {
    super.initState();
    // TẠI SAO: Đặt nội dung cũ vào controller
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // TẠI SAO: Lưu và trả về nội dung đã sửa
  void _saveAndReturn() {
    // Trả về nội dung đã trim (cắt bỏ khoảng trắng thừa)
    Navigator.pop(context, _controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      titleText: 'Chỉnh sửa mục',
      // TẠI SAO: Dùng nút Back mặc định để lưu và thoát
      appBarLeading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF141010)),
        onPressed: _saveAndReturn, // <-- Nhấn back sẽ lưu
      ),
      // TẠI SAO: Thêm nút Save riêng nếu người dùng muốn nhấn
      appBarActions: [
        TextButton(
          onPressed: _saveAndReturn,
          child: const Text(
            'Lưu',
            style: TextStyle(
              color: Color(0xFFCE5127),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        )
      ],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: TextFormField(
          controller: _controller,
          autofocus: true, // Tự động mở bàn phím
          // TẠI SAO: Cho phép nhập nhiều dòng và cuộn thoải mái
          maxLines: null, 
          minLines: 15,
          keyboardType: TextInputType.multiline,
          
          decoration: const InputDecoration(
            hintText: 'Nhập ghi chú của bạn...',
            border: InputBorder.none, // Bỏ viền để trông sạch sẽ hơn
            contentPadding: EdgeInsets.zero,
          ),
          style: const TextStyle(fontSize: 16, color: Color(0xFF141010)),
        ),
      ),
    );
  }
}