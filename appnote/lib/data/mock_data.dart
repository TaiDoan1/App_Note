// lib/data/mock_data.dart

// import 'package:flutter/material.dart';
// **QUAN TRỌNG:** Đảm bảo đường dẫn này khớp với vị trí file Model của bạn
import 'package:appnote/models/transaction.dart';

// Hàm Helper để định dạng số tiền (ví dụ: 1.200.000)
String _formatAmount(double amount) {
  // Loại bỏ dấu âm nếu có, sau đó định dạng số có dấu chấm phân cách hàng nghìn
  return amount
      .abs()
      .toStringAsFixed(0)
      .replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      );
}

// ----------------------------------------------------
// Dữ liệu Mẫu cho các Giao dịch và Nhóm
// ----------------------------------------------------

// 1. Giao dịch Chi tiêu và Thu nhập cho Nhóm 1 (Hôm nay)
final transaction1_1 = Transaction(
  description:
      "Mua 10kg thịt gà và rau củ quả tại siêu thị", // Mô tả dài để test flex: 4
  amount: 200000,
  isIncome: false,
);

final transaction1_2 = Transaction(
  description: "Tiền hoa hồng từ dự án mới",
  amount: 1500000,
  isIncome: true,
);

// final transaction1_3 = Transaction(
//   description: "Phí vận chuyển đơn hàng",
//   amount: 50000,
//   isIncome: false,

// );

final group1 = TransactionGroup(
  date: "Hôm nay",
  transactions: [transaction1_1, transaction1_2],
  totalAmount: 1250000, // Tổng: -200k + 1500k - 50k = 1250k
);

// 2. Giao dịch Chỉ Chi tiêu cho Nhóm 2 (Tuần trước)
final transaction2_1 = Transaction(
  description: "Thanh toán học phí khóa học UI/UX",
  amount: 5500000,
  isIncome: false,
);

final group2 = TransactionGroup(
  date: "Thứ Hai, 27/10/2025",
  transactions: [transaction2_1],
  totalAmount: 5500000,
);

final group3 = TransactionGroup(
  date: "Thứ Hai, 27/10/2025",
  transactions: [transaction2_1],
  totalAmount: 5500000,
);
final group4 = TransactionGroup(
  date: "Thứ Hai, 27/10/2025",
  transactions: [transaction2_1],
  totalAmount: 5500000,
);

// ----------------------------------------------------
// Danh sách chính được dùng trong HomeScreen
// ----------------------------------------------------
final List<TransactionGroup> mockTransactionGroups = [group1, group2];
