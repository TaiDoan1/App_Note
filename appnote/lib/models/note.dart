// lib/models/note.dart

// Model cho 1 ghi chú (Tương ứng với 1 hàng màu be)
class Note {
  final String description;
  // (Bạn có thể thêm isDone, v.v... sau này)

  const Note({
    required this.description,
  });
}

// Model cho nhóm ghi chú (Tương ứng với 1 Card)
class NoteGroup {
  final String date;
  final List<Note> notes;

  const NoteGroup({
    required this.date,
    required this.notes,
  });
}