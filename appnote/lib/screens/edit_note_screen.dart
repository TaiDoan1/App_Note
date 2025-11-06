// lib/screens/edit_note_screen.dart (CODE HOÀN CHỈNH)

import 'package:appnote/models/note.dart';
import 'package:appnote/utils/dialog_helper.dart';
import 'package:appnote/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:appnote/screens/Noteentryscreen.dart';


// TẠI SAO: Lớp (Class) này để giữ Controller cho mỗi hàng ghi chú
class _NoteEntry {
  final TextEditingController noteController;

  _NoteEntry({String? description})
      : noteController = TextEditingController(text: description ?? '');

  void dispose() {
    noteController.dispose();
  }
}

class EditNoteScreen extends StatefulWidget {
  // TẠI SAO: Cần dữ liệu để biết phải sửa nhóm nào
  final NoteGroup groupToEdit;

  const EditNoteScreen({super.key, required this.groupToEdit});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  // TẠI SAO: Dùng 1 List để quản lý các ô nhập liệu
  final List<_NoteEntry> _noteEntries = [];
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    
    // TẠI SAO: Lặp qua các ghi chú cũ và điền vào List
    for (var note in widget.groupToEdit.notes) {
      _addNoteEntry(description: note.description, notify: false);
    }

    // TẠI SAO: Nếu nhóm trống, thêm 1 ô
    if (_noteEntries.isEmpty) {
      _addNoteEntry(notify: false);
    }
    
    _checkFormValidity();
  }

  @override
  void dispose() {
    for (var entry in _noteEntries) {
      entry.dispose();
    }
    super.dispose();
  }

  // TẠI SAO: Kiểm tra xem có ít nhất 1 ô được nhập không
  void _checkFormValidity() {
    // Tìm xem có ít nhất 1 ô có chữ không
    bool hasText = _noteEntries.any((e) => e.noteController.text.isNotEmpty);
    
    if (hasText != _isFormValid) {
      setState(() {
        _isFormValid = hasText;
      });
    }
  }

  // TẠI SAO: Thêm một ô ghi chú rỗng
  void _addNoteEntry({String? description, bool notify = true}) {
    final newEntry = _NoteEntry(description: description);
    
    // Thêm listener để kiểm tra form khi gõ
    newEntry.noteController.addListener(_checkFormValidity);
    
    if (notify) {
      setState(() {
        _noteEntries.add(newEntry);
      });
    } else {
      _noteEntries.add(newEntry);
    }
    _checkFormValidity();
  }

  // TẠI SAO: Hàm xây dựng 1 ô nhập liệu (TextFormField)
  // Widget _buildNoteInput(TextEditingController controller) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8.0),
  //     child: TextFormField(
  //       controller: controller,
  //       decoration: InputDecoration(
  //         hintText: 'Nhập ghi chú của bạn',
  //         hintStyle: const TextStyle(color: Color(0xFF7A7A7A)),
  //         filled: true,
  //         fillColor: Colors.white,
  //         // TẠI SAO: Style viền giống hệt ManualNoteScreen
  //         enabledBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(12),
  //           borderSide: const BorderSide(color: Color(0xFFF1D8D0), width: 1.0),
  //         ),
  //         focusedBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(12),
  //           borderSide: const BorderSide(color: Color(0xFFCE5127), width: 1.5),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  void _openNoteEntry(TextEditingController controller) async {
    // 1. Mở màn hình Editor (NoteEntryScreen) và đợi kết quả
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        // TẠI SAO: Truyền nội dung hiện tại vào màn hình mới
        builder: (context) => NoteEntryScreen(initialText: controller.text),
      ),
    );

    // 2. Nếu có kết quả trả về (người dùng nhấn "Lưu" hoặc "Back")
    if (result != null && result is String && mounted) {
      // 3. Cập nhật controller của ô cũ bằng nội dung mới
      // TẠI SAO: Dùng setState để cập nhật UI và kích hoạt _checkFormValidity
      setState(() {
        controller.text = result;
      });
    }
  }
  // HÀM MỚI: Xây dựng giao diện cho 1 ô ghi chú (giờ là GestureDetector)
  // Widget _buildNoteItem(TextEditingController controller) {
  //   // TẠI SAO: Dùng ListTile hoặc Container bọc để trông giống ô nhập liệu
  //   return GestureDetector(
  //     onTap: () => _openNoteEntry(controller), // <-- NHẤN SẼ MỞ MÀN HÌNH MỚI
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
  //       margin: const EdgeInsets.symmetric(vertical: 8.0),
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(12),
  //         border: Border.all(color: const Color(0xFFF1D8D0), width: 1.0),
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           // TẠI SAO: Chỉ hiển thị 2 dòng đầu tiên và dùng ...
  //           Text(
  //             controller.text.isEmpty ? 'Nhập ghi chú của bạn' : controller.text,
  //             style: TextStyle(
  //               color: controller.text.isEmpty ? const Color(0xFF7A7A7A) : const Color(0xFF141010),
  //               fontSize: 16,
  //             ),
  //             maxLines: 2,
  //             overflow: TextOverflow.ellipsis,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Hàm xây dựng giao diện cho 1 ô ghi chú
  Widget _buildNoteItem(TextEditingController controller) {
    // TẠI SAO: InkWell giúp tạo hiệu ứng nhấn cho toàn bộ hàng
    return InkWell(
      onTap: () => _openNoteEntry(controller), // <-- NHẤN HÀNG SẼ MỞ EDITOR TOÀN MÀN HÌNH
      
      // ********** THAY ĐỔI CẤU TRÚC ĐỂ PHÙ HỢP VỚI THIẾT KẾ MỚI **********
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    controller.text.isEmpty ? 'Nhấn để chỉnh sửa' : controller.text,
                    style: TextStyle(
                      color: controller.text.isEmpty ? const Color(0xFF7A7A7A) : const Color(0xFF141010),
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                // Icon mũi tên (KHÔNG CÓ onTap ở đây, chỉ hiển thị)
                const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF141010)), 
              ],
            ),
            // Thêm Divider để phân cách các mục
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Divider(height: 1.0, thickness: 1.0, color: Color(0xFFE0E0E0)),
            ),
          ],
        ),
      ),
    );
  }

  // TẠI SAO: Hàm vẽ nền đỏ khi vuốt
  Widget _buildDeleteBackground() {
    return Container(
      color: Colors.red,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }

  // TẠI SAO: Hàm khi nhấn nút "Lưu"
  void _saveNotes() {
    final List<Note> newNotes = [];
    
    // 1. Thu thập tất cả text từ các controller
    for (var entry in _noteEntries) {
      final text = entry.noteController.text.trim();
      if (text.isNotEmpty) {
        newNotes.add(Note(description: text));
      }
    }

    // 2. Đóng gói lại
    final newGroup = NoteGroup(
      date: widget.groupToEdit.date, // Giữ lại ngày cũ
      notes: newNotes,
    );

    // 3. Trả về HomeScreen
    Navigator.pop(context, newGroup);
  }

  // TẠI SAO: Hàm khi nhấn nút "Xoá"
  void _handleDelete() async {
    final bool? didConfirm = await showAppConfirmationDialog(
      context: context,
      title: 'Xác nhận xoá',
      content: 'Bạn có chắc chắn muốn xoá nhóm ghi chú này không?',
      confirmText: 'Xoá',
      // (Bạn có thể thêm ảnh warning ở đây nếu muốn)
      // imageAssetPath: 'assets/images/warning.png',
    );

    if (didConfirm == true && mounted) {
      // TẠI SAO: Gửi tín hiệu 'DELETE' về HomeScreen
      Navigator.pop(context, 'DELETE');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      titleText: 'Chỉnh sửa Ghi chú',
      appBarLeading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF141010)),
        onPressed: () => Navigator.of(context).pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. DANH SÁCH CÁC Ô NHẬP LIỆU
            ListView.builder(
              shrinkWrap: true, // Quan trọng khi lồng ListView
              physics: const NeverScrollableScrollPhysics(), // Không cho cuộn
              itemCount: _noteEntries.length,
              itemBuilder: (context, index) {
                final entry = _noteEntries[index];
                
                // TẠI SAO: Bọc bằng Dismissible để "Vuốt Xoá"
                return Dismissible(
                  key: ValueKey(entry), // Key duy nhất
                  direction: DismissDirection.endToStart,
                  background: _buildDeleteBackground(),
                  onDismissed: (direction) {
                    setState(() {
                      entry.noteController.removeListener(_checkFormValidity);
                      entry.dispose();
                      _noteEntries.removeAt(index);
                    });
                    _checkFormValidity();
                  },
                  child: _buildNoteItem(entry.noteController),
                );
              },
            ),
            
            // 2. NÚT "THÊM GHI CHÚ"
            GestureDetector(
              
              onTap: () => _addNoteEntry(), // Gọi hàm thêm 1 ô rỗng
              child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/icons/AddCircle.png', width: 20, height: 20),
                    const SizedBox(width: 4),
                    const Text(
                      'Thêm ghi chú',
                      style: TextStyle(
                        color: Color(0xFFCE5127),
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 128), // Đệm lớn

            // 3. NÚT "XOÁ" VÀ "LƯU"
            Row(
              children: [
                // NÚT XOÁ
                Expanded(
                  child: OutlinedButton(
                    onPressed: _handleDelete,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1000),
                      ),
                    ),
                    child: const Text('Xoá', style: TextStyle(color: Colors.red, fontSize: 14)),
                  ),
                ),
                const SizedBox(width: 16),
                
                // NÚT LƯU
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isFormValid ? _saveNotes : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isFormValid ? const Color(0xFFCE5127) : const Color(0xFFEFEFEF),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      elevation: 0,
                    ),
                    child: Text('Lưu', style: TextStyle(color: _isFormValid ? Colors.white : const Color(0xFFBDBDBD), fontSize: 14)),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 46), // Đệm dưới cùng
          ],
        ),
      ),
    );
  }
}