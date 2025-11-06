// lib/widgets/app_scaffold.dart (Phiên bản Hoàn Chỉnh)

import 'package:flutter/material.dart';
// Đảm bảo import file màu sắc của bạn

class AppScaffold extends StatelessWidget {
  // --- THUỘC TÍNH LINH HOẠT ---
  final Widget body;
  final String? titleText;

  final List<Widget>? appBarActions;
  final Widget? appBarLeading;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;

  // Bạn có thể thêm tham số cho hoạ tiết nếu muốn thay đổi nó theo màn hình
  final String backgroundAsset;

  const AppScaffold({
    super.key,
    required this.body,
    this.titleText,
    this.appBarLeading,
    this.appBarActions,
    this.bottomNavigationBar,
    this.floatingActionButton,
    // Đặt giá trị mặc định cho backgroundAsset nếu không được truyền vào
    this.backgroundAsset = 'assets/images/splash.png',
  });

  // Widget Tùy chỉnh để xây dựng AppBar cố định
  PreferredSizeWidget? _buildAppBar(BuildContext context) {
    if (titleText == null) return null;

    return AppBar(
      title: Text(
        titleText!,
        style: const TextStyle(
          color: Color(0xFF141010),
          fontWeight: FontWeight.w600,
          fontFamily: 'Manrope-SemiBold',
          fontSize: 16,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent, // Cố định màu nền AppBar
      elevation: 0,
      actions: appBarActions,
      leading: appBarLeading,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final backgroundHeight = screenHeight / 3;

    final customAppBar = _buildAppBar(context);
    final appBarHeight = customAppBar?.preferredSize.height ?? 0;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final topPadding = appBarHeight + statusBarHeight;

    const double verticalSpacing = 4.0;

    return Scaffold(
      backgroundColor: Colors.white, // Đảm bảo nền trắng toàn bộ
      extendBody: true,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      body: Stack(
        children: [
          const Positioned.fill(
            child: ColoredBox(color: Colors.white), // Nền thấp nhất trắng
          ),

          // LỚP 2: HÌNH NỀN/HOẠ TIẾT (1/3 từ trên xuống)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: backgroundHeight,
              // Sử dụng tham số backgroundAsset của bạn
              child: Image.asset(backgroundAsset, fit: BoxFit.cover),
            ),
          ),

          // LỚP 3 (TRÊN CÙNG): NỘI DUNG CUỘN THỰC TẾ
          Padding(
            // Padding tự động tính toán để tránh AppBar và Status Bar
            padding: EdgeInsets.only(top: topPadding),
            child: body,
          ),

          // LỚP 4: APP BAR (Nằm trên cùng)
          if (customAppBar != null)
            Positioned(top: 0, left: 0, right: 0, child: customAppBar),
        ],
      ),
    );
  }
}
