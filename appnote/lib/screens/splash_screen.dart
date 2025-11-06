import 'package:appnote/screens/home_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDFAF7),
      body: Stack(
        children: [
          // hinh anh
          Positioned.fill(
            child: Image.asset('assets/images/splash.png', fit: BoxFit.cover),
          ),

          // 2️⃣ LỚP GRADIENT Ở PHÍA TRÊN
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 350,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(40), // Bo góc phía dưới
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFFF5E2CC).withOpacity(0.8), // nâu nhẹ, mờ 35%
                    const Color(0xFFFDFAF7).withOpacity(0.5),
                    // hoàn toàn trong suốt
                  ],
                  stops: const [0.0, 1.0],
                ),
              ),
            ),
          ),

          // LOGO VỚI VỊ TRÍ TÙY CHỈNH --------------------
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 175),
                  // logo
                  Center(
                    child: Image.asset(
                      'assets/images/LogoSplash.png',
                      width: 303,
                      height: 296,
                    ),
                  ),
                  SizedBox(height: 94),
                  // text
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 21,
                    ), // cùng khoảng cách 2 bên
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.center, // căn giữa theo trục ngang
                      children: [
                        Text(
                          'Quản lý dễ dàng hơn',
                          style: TextStyle(
                            color: Color(0xFF290A00),
                            fontWeight: FontWeight.w800,
                            fontSize: 32,
                            fontFamily: 'Phudu',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Ghi chú nhanh mọi ý tưởng, theo dõi chi tiêu,\n và nhắc việc đúng giờ — để bạn chẳng quên \n điều gì và luôn vui vẻ mỗi ngày!',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color(0xFF141010),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),

                        // button
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ), // 👈 giảm để nút dài hơn
                    child: SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD25A2E),
                          foregroundColor: Colors.white,

                          shadowColor: Colors.black.withOpacity(
                            0.3,
                          ), // Shadow màu đen với opacity 30%
                        ),
                        child: const Text(
                          'Bắt đầu ngay',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
