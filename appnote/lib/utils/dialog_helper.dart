// lib/utils/dialog_helper.dart

import 'package:flutter/material.dart';

// ====================================================================
// HÀM 1: POPUP XÁC NHẬN (CHO NÚT "XOÁ")
// Tái sử dụng cho bất kỳ hành động nào cần xác nhận.
// ====================================================================
// HÀM 1: POPUP XÁC NHẬN (ĐÃ VIẾT LẠI)
// Tái sử dụng cấu trúc của Hàm 2 (dùng Dialog thay vì AlertDialog)
// ====================================================================
Future<bool?> showAppConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
  String confirmText = 'Xoá',
  String cancelText = 'Huỷ', // Thêm chữ cho nút Huỷ
 
  String? imageAssetPath = 'assets/images/Taomoithanhcong.png', // TẠI SAO: Đổi default thành null (an toàn hơn)
  double imageSize = 80,
  EdgeInsets? insetPadding = const EdgeInsets.symmetric(horizontal: 16.0),
  double? width,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, // Người dùng phải chọn
    builder: (BuildContext context) {
      // TẠI SAO: Dùng Dialog y hệt Hàm 2
      return Dialog(
        insetPadding: insetPadding,
        backgroundColor: Color(0xFFFFFEFC),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        // TẠI SAO: Bọc SizedBox để ép chiều rộng
        child: SizedBox(
          width: width,
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Cực kỳ quan trọng
              children: [
                // TẠI SAO: Không có nút "X" (vì đây là popup xác nhận)
                
                const SizedBox(height: 16), // Thêm khoảng trống trên cùng

                // 1. HÌNH ẢNH (NẾU CÓ)
                if (imageAssetPath != null) ...[
                  Image.asset(
                    imageAssetPath,
                    height: imageSize,
                    width: imageSize,
                  ),
                  const SizedBox(height: 24),
                ],

                // 2. TIÊU ĐỀ
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18, // (Bạn có thể sửa style)
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF141010),
                  ),
                ),
                const SizedBox(height: 8),

                // 3. NỘI DUNG
                Text(
                  content,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14, // (Bạn có thể sửa style)
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF141010),
                  ),
                ),
                const SizedBox(height: 24),

                // 4. CÁC NÚT HÀNH ĐỘNG (THAY ĐỔI LỚN)
                Row(
                  children: [
                    // Nút "Huỷ" (Giống nút "Xem ngay" ở Hàm 2)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context, false); // Trả về false
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(
                            color: Color.fromRGBO(0, 0, 0, 0.2),
                            width: 1.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: Text(
                          cancelText,
                          style: const TextStyle(
                            color: Color(0xFF141010),
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16), // Khoảng cách

                    // Nút "Xoá" (Nút chính, màu đỏ)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, true); // Trả về true
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFCE5127), // Màu đỏ
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          confirmText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

// ====================================================================
// HÀM 2: POPUP THÀNH CÔNG (CHO "TẠO THÀNH CÔNG")
// Tái sử dụng cho bất kỳ thông báo thành công nào.
// ====================================================================
Future<void> showAppSuccessDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String buttonText,
  required VoidCallback onButtonPressed,
  VoidCallback? onClosePressed,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // Người dùng phải nhấn nút
    builder: (BuildContext context) {
      // TẠI SAO: Dùng Dialog để nó nổi lên
      return Dialog(
        backgroundColor: Color(0xFFFFFEFC),
        insetPadding: EdgeInsets.fromLTRB(16, 16, 16, 32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Cực kỳ quan trọng
            children: [
              // 1. Nút Đóng (X)
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    // Chỉ đóng popup
                    Navigator.of(context).pop();
                    // 2. Gọi callback (nếu có)
                    if (onClosePressed != null) {
                      onClosePressed();
                    }
                  },
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF4F4F4),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Color(0xFF827D89),
                      size: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 2. Hình ảnh (Giả sử bạn đã có ảnh này)
              Image.asset(
                'assets/images/Taomoithanhcong.png', // <-- THAY ĐƯỜNG DẪN NẾU SAI
                height: 120,
              ),
              const SizedBox(height: 24),

              // 3. Tiêu đề
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF141010),
                ),
              ),
              const SizedBox(height: 8),

              // 4. Nội dung
              Text(
                content,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF141010),
                ),
              ),
              const SizedBox(height: 24),

              // 5. Nút "Xem ngay"
              SizedBox(
                width: double.infinity, // Kéo dãn nút
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onButtonPressed();
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(
                      color: Color.fromRGBO(0, 0, 0, 0.2),
                      width: 1.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(
                      color: Color(0xFF141010),
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
