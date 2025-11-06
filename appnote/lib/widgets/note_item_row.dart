// lib/widgets/note_item_row.dart

import 'package:appnote/models/note.dart';
import 'package:flutter/material.dart';

class NoteItemRow extends StatelessWidget {
  final Note note;
  final VoidCallback? onTapArrow;

  const NoteItemRow({super.key, required this.note,this.onTapArrow,});

  @override
  Widget build(BuildContext context) {
    return Container(
      
      // margin: const EdgeInsets.only(top: 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        // TẠI SAO: Màu be F8EEE2 (từ thiết kế)
        color: const Color(0xFFF8EEE2), 
        borderRadius: BorderRadius.circular(20),
        
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // TẠI SAO: Expanded để text không bị tràn
          Expanded(
            child: Text(
              note.description,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF141010),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 16),
          // TẠI SAO: Icon mũi tên ">" (từ thiết kế)
          // const Icon(
          //   Icons.arrow_forward_ios,
          //   size: 14,
          //   color: Color(0xFF141010),
          // ),
          GestureDetector(
            onTap: onTapArrow, // <-- Gọi callback khi nhấn vào mũi tên
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), // Tăng vùng nhấn
              child: Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Color(0xFF141010),
              ),
            ),
          ),
        ],
      ),
    );
  }
}