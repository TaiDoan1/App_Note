// import 'package:appnote/models/transaction.dart';
// import 'package:appnote/screens/manual_transaction_screen.dart';
import 'package:flutter/material.dart';

class AddItemPopup extends StatelessWidget {
  final String title;
  final String description;
  final String imageAsset;
  final VoidCallback onManualTap; // <-- Hàm gọi khi nhấn "Nhập thủ công"
  final VoidCallback onAiTap;     // <-- Hàm gọi khi nhấn "Record với AI"
  const AddItemPopup({
    super.key,
    required this.title,
    required this.description,
    required this.imageAsset,
    required this.onManualTap,
    required this.onAiTap,});

  // Widget Tùy chỉnh cho Nút
  Widget _buildActionButton({
    required String text,
    required String assetPath, // Vẫn là đường dẫn asset (String)
    required VoidCallback onPressed,
    
  }) {
    return Expanded(
      // THAY ĐỔI LỚN TẠI ĐÂY: Dùng OutlinedButton thường thay vì OutlinedButton.icon
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.fromLTRB(
            12,
            8,
            12,
            8,
          ), // Thêm padding ngang
          side: const BorderSide(
            color: Color.fromRGBO(0, 0, 0, 0.2),
            width: 1.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        // SỬ DỤNG CHILD: Tự xây dựng cấu trúc Row cho Icon và Text
        child: Row(
          mainAxisSize: MainAxisSize.min, // Giữ Row vừa khít nội dung
          mainAxisAlignment: MainAxisAlignment.center, // Căn giữa nội dung
          children: [
            // 1. Image (ICON) - Sử dụng đường dẫn asset (String)
            Image.asset(
              assetPath,
              width: 20,
              height: 20,
              color: const Color(0xFF141010), // Áp dụng màu đen cho Icon
            ),
            const SizedBox(width: 8), // Khoảng cách giữa Icon và Label
            // 2. Text (LABEL)
            Text(
              text,
              style: const TextStyle(
                color: Color(0xFF141010),
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        // Màu nền trắng cho Popup
        color: Colors.white,
        padding: EdgeInsets.only(
          left: 30,
          right: 30,
          top: 30,
          // Padding cho bàn phím và khoảng trống dưới đáy
          bottom: MediaQuery.of(context).viewInsets.bottom + 30,
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Nút đóng (X)
            Align(
              alignment: Alignment.topRight,

              child: Container(
                width: 24, // Tăng nhẹ kích thước để nút trông rõ ràng hơn
                height: 24,
                padding: const EdgeInsets.all(4), // Tăng nhẹ kích thước
                decoration: BoxDecoration(
                  shape: BoxShape.circle, // Vẫn là hình tròn
                  // THAY ĐỔI TẠI ĐÂY:
                  // 1. Thêm màu nền xám nhạt (#F2F2F2 hoặc tương tự)
                  color: const Color(0xFFF2F2F2),
                  // 2. BỎ HOÀN TOÀN 'border' (hoặc đặt width: 0)
                  // border: Border.all(color: const Color(0xFF787878), width: 1.0),
                ),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Center(
                    // TẠI SAO: Đảm bảo Icon nằm chính giữa 24x24 Container
                    child: Icon(
                      Icons.close,
                      color: Color(0xFF827D89),
                      size:
                          16, // TẠI SAO: Giảm size để Icon nằm gọn trong 24x24
                    ),
                  ),
                ),
              ),
            ),

            // Hình minh họa
            Image.asset(imageAsset, height: 120),
            const SizedBox(height: 20),

            // Tiêu đề và Mô tả (Giữ nguyên)
             Text(
              title,
              style: TextStyle(
                fontSize: 18,
                // fontFamily: 'Manrope-Bold', // Giữ nguyên hoặc xóa nếu chưa khai báo
                fontWeight: FontWeight.w700,
                color: Color(0xFF141010),
              ),
            ),
            const SizedBox(height: 8),

             Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                // fontFamily: 'Manrope-Regular', // Giữ nguyên hoặc xóa nếu chưa khai báo
                color: Color(0xFF141010),
              ),
            ),
            const SizedBox(height: 20),

            // Hai Nút Chức năng
            Row(
              children: [
                _buildActionButton(
                  text: 'Nhập thủ công',
                  // SỬA LỖI 1: TRUYỀN STRING ĐƯỜNG DẪN ASSET
                  assetPath: 'assets/icons/Pen 2.png',
                  onPressed: onManualTap,
                ),
                const SizedBox(width: 7),
                _buildActionButton(
                  text: 'Record với AI',
                  // SỬA LỖI 2: TRUYỀN STRING ĐƯỜNG DẪN ASSET (Thay thế IconData cũ)
                  assetPath:
                      'assets/icons/Stars.png', // Thay thế bằng asset AI thực tế của bạn
                  onPressed: onAiTap,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
