// lib/widgets/custom_nav_bar.dart

import 'package:flutter/material.dart';

// Đảm bảo import enum AppTab (ví dụ từ file cũ hoặc định nghĩa lại)
enum AppTab { thuChi, ghiChu, suKien } 

class CustomNavBar extends StatelessWidget {
  final AppTab selectedTab; 
  final ValueChanged<AppTab> onTabSelected; 

  const CustomNavBar({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  // --- HÀM TẠO MỖI ITEM ---
  Widget _buildItem(AppTab tab, String assetPath, String label, int index) {
    final isSelected = selectedTab == tab;
    final color = isSelected 
        ? const Color(0xFFFFFEFC) // Màu trắng khi được chọn
        : const Color(0xFF787878); // Màu xám mặc định
    
    // Sử dụng InkWell hoặc GestureDetector để xử lý Tap
    return Expanded(
      child: InkWell(
        onTap: () => onTabSelected(tab),
        child: Container(
          // Kích thước cố định của mỗi item không cần thiết nếu dùng Expanded
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon (Image.asset)
              ColorFiltered(
                    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                    child: Image.asset(assetPath, width: 24, height: 24),
                  ), 
              const SizedBox(height: 2),
              // Label
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  fontSize: 12,
                  height: 1.0, 
                ),
              ),
            

              
               // Khoảng trống bằng chiều cao elip để giữ cân bằng dọc
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Padding ngoài (tạo khoảng cách 30, 46)
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 46),
      child: Container(
        // KIỂM SOÁT CHIỀU CAO TẠI ĐÂY
        height: 80, // Ví dụ: Chiều cao mong muốn (cao hơn mặc định 56)
        
        decoration: BoxDecoration(
          color: const Color(0xFF1F0800), // Màu nền đậm
          borderRadius: BorderRadius.circular(16), // Bo tròn 4 góc
          border: Border.all(
            color: const Color.fromARGB(255, 16, 13, 8), 
            width: 1.0,
          ),
        ),
        
        // Nội dung: Sử dụng Row thay vì BottomNavigationBar
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildItem(AppTab.thuChi, 'assets/icons/Card.png', 'Thu Chi', 0),
            _buildItem(AppTab.ghiChu, 'assets/icons/Notes.png', 'Ghi chú', 1),
            _buildItem(AppTab.suKien, 'assets/icons/Calendar.png', 'Sự kiện', 2),
          ],
        ),
      ),
    );
  }
}