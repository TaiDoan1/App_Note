appnote/
├── lib/
│   ├── main.dart                    # Entry point của app
│   ├── constants/                   # Các hằng số
│   │   ├── app_colors.dart         # Màu sắc
│   │   ├── app_theme.dart          # Theme tổng thể
│   │   └── app_strings.dart        # Các text cố định
│   ├── models/                      # Định nghĩa dữ liệu
│   │   ├── note.dart               # Model Note
│   │   └── category.dart            # Model Category
│   ├── providers/                   # Quản lý state
│   │   ├── note_provider.dart      # State của Note
│   │   └── theme_provider.dart     # State của Theme
│   ├── screens/                     # Các màn hình
│   │   ├── splash_screen.dart      # Màn hình splash
│   │   ├── home_screen.dart         # Màn hình chính
│   │   ├── add_note_screen.dart     # Thêm/sửa note
│   │   ├── note_detail_screen.dart # Chi tiết note
│   │   └── settings_screen.dart     # Cài đặt
│   ├── widgets/                     # Component tái sử dụng
│   │   ├── note_card.dart          # Card hiển thị note
│   │   ├── category_chip.dart      # Chip category
│   │   └── custom_app_bar.dart     # AppBar tùy chỉnh
│   ├── services/                    # Logic xử lý
│   │   ├── note_service.dart       # CRUD Note
│   │   └── storage_service.dart     # Lưu trữ local
│   └── utils/                       # Tiện ích
│       ├── date_utils.dart          # Xử lý ngày tháng
│       └── validators.dart          # Validation
├── assets/                          # Tài nguyên
│   ├── images/                      # Hình ảnh
│   │   ├── background.png          # Nền splash
│   │   ├── logo.png                # Logo app
│   │   └── empty_notes.png          # Hình trống
│   └── icons/                       # Icon tùy chỉnh
├── pubspec.yaml                     # Dependencies
└── README.md                        # Hướng dẫn