// lib/data/mock_note_data.dart

import 'package:appnote/models/note.dart';


// 1. Ghi chú cho "Hôm nay"
final note1_1 = Note(description: "Mua hoa hồng tặng mẹ");
final note1_2 = Note(description: "Đi bảo dưỡng xe máy");
final note1_3 = Note(description: "Đến lớp tiếng Trung");

final noteGroup1 = NoteGroup(
  date: "Hôm nay",
  notes: [note1_1, note1_2, note1_3],
);

// 2. Ghi chú cho "Ngày 24/10/2025"
final note2_1 = Note(description: "Đến trường nhận áo khai giảng");
final note2_2 = Note(description: "Đưa Nem đi nha sĩ");

final noteGroup2 = NoteGroup(
  date: "Ngày 24/10/2025",
  notes: [note2_1, note2_2],
);

// 3. Ghi chú cho "Ngày 14/09/2025"
final note3_1 = Note(description: "Đi bảo tàng với Nam Anh và Văn Vũ");

final noteGroup3 = NoteGroup(
  date: "Ngày 14/09/2025",
  notes: [note3_1],
);

// ----------------------------------------------------
// DANH SÁCH CHÍNH SẼ DÙNG
// ----------------------------------------------------
final List<NoteGroup> mockNoteGroups = [
  noteGroup1,
  noteGroup2,
  noteGroup3,
];