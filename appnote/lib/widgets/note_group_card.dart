// lib/widgets/note_group_card.dart

import 'package:appnote/models/note.dart';
import 'package:appnote/widgets/note_item_row.dart'; // <-- Import hàng (row)
import 'package:flutter/material.dart';

class NoteGroupCard extends StatelessWidget {
  final NoteGroup group;
  // (Chúng ta sẽ thêm 'onTap' cho việc Chỉnh sửa sau)
  final VoidCallback? onTap;
  final Function(Note)? onTapNote;
  // CALLBACK MỚI: Nhấn vào hàng để mở NoteEntryScreen
  final Function(Note note, int noteIndex)? onTapNoteItem;
  // CALLBACK MỚI: Vuốt để xoá một Note Item
  final Function(int noteIndex)? onDeleteNoteItem;

  const NoteGroupCard({
    super.key,
    required this.group,
    required this.onTap,
    this.onTapNote,
    this.onTapNoteItem,
    this.onDeleteNoteItem,
  });
  // Hàm vẽ nền đỏ khi vuốt xoá
  Widget _buildDeleteBackground() {
    return Container(
      color: Colors.red,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20.0),
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,

        // padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Color(0xFF0FFF8EEE2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFFAE5CC), width: 1.0),

          // (Thiết kế không có border, giữ cho nó sạch sẽ)
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. TIÊU ĐỀ NGÀY ("Hôm nay", "Ngày 24/10/2025"...)
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: const BoxDecoration(
                color: Color(0xFFFAFAFA),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
              ),
              width: double.infinity,

              child: Text(
                group.date,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Manrope-Bold',
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF141010),
                ),
              ),
            ),
            const SizedBox(height: 4), // Đệm nhỏ
            // 2. DANH SÁCH CÁC HÀNG GHI CHÚ
            Container(
              padding: const EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(group.notes.length, (noteIndex) {
                  final note = group.notes[noteIndex];
                  return Column(
                    // <-- BỌC MỖI HÀNG BẰNG COLUMN
                    children: [
                      // *** BỌC BẰNG DISMISSIBLE VÀ INKWELL ***
                      Dismissible(
                        key: ValueKey(note), // Key duy nhất cho Dismissible
                        direction: DismissDirection
                            .endToStart, // Chỉ vuốt từ phải sang trái
                        background: _buildDeleteBackground(),
                        onDismissed: (direction) {
                          if (onDeleteNoteItem != null) {
                            // Gọi callback xoá về HomeScreen
                            onDeleteNoteItem!(noteIndex);
                          }
                        },
                        // Bọc bằng InkWell để xử lý sự kiện nhấn
                        child: InkWell(
                          onTap: onTapNoteItem != null
                              ? () => onTapNoteItem!(note, noteIndex)
                              : null, // Mở Editor
                          child: NoteItemRow(
                            note: note,
                          ), // Chỉ cần Note Item thuần
                        ),
                      ),

                      // THÊM DIVIDER SAU MỖI HÀNG (trừ hàng cuối)
                      if (noteIndex < group.notes.length - 1)
                        const Divider(
                          height: 1.0,
                          thickness: 1.0,
                          color: Color(0xFFEFEFEF), // Màu trắng/xám nhạt
                          indent: 0,
                          endIndent: 0,
                        ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
