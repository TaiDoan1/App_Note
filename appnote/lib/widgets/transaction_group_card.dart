import 'package:flutter/material.dart';
import 'package:appnote/models/transaction.dart';
import 'package:appnote/widgets/transaction_row.dart';
import 'package:appnote/screens/edit_transaction_screen.dart';

class TransactionGroupCard extends StatelessWidget {
  final TransactionGroup group;
  final VoidCallback? onTap; //Đối tượng nhóm giao dịch
  const TransactionGroupCard({super.key, required this.group, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Định dạng tổng tiền cho Header Card
    // (Lưu ý: Bạn có thể thêm thuộc tính Helper này vào TransactionGroup Model)
    final formattedTotal = group.totalAmount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
    // Màu nền Card: Giả sử bạn đã định nghĩa hoặc sử dụng giá trị này

    return GestureDetector(
      onTap: onTap,
      child: Container(
      clipBehavior: Clip.antiAlias,
      // padding: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          // (Bạn có thể có shadow hoặc border ở đây)
        ),

      child: SizedBox(
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFF5E2CC), // Màu nền trong suốt
            borderRadius: BorderRadius.circular(16), // Góc bo tròn
            border: Border.all(
              // <--- ĐỊNH NGHĨA BORDER MÀU
              color: const Color(0xFFF5E2CC),
              width: 1.0,
            ),
          ),
          child: Card(
            elevation: 0,
            margin: EdgeInsets.zero,

            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(formattedTotal, group),

                _buildTransactionList(group),

                _buildFooter(context),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

Widget _buildHeader(String formattedTotal, TransactionGroup group) {
  return Container(
    decoration: const BoxDecoration(
      color: Color(0xFFFAFAFA), // MÀU NỀN TRẮNG
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      // Chỉ bo tròn góc trên
    ),
    padding: const EdgeInsets.all(12), // Padding cho Header
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,

      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Text(
              group.date,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF141010),
              ),
            ),
            Text(
              '${formattedTotal}đ',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF141010),
                fontFamily: 'Manrope',
              ),
            ),
          ],
        ),
        // const SizedBox(height: 10), // Đường phân cách mỏng
      ],
    ),
  );
}

Widget _buildTransactionList(TransactionGroup group) {
  return Container(
    decoration: const BoxDecoration(
      color: const Color(0xFFF8EEE2), // MÀU NỀN TRẮNG
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(16),
      ), // Chỉ bo tròn góc trên
    ),
    // MÀU NỀN XÁM
    padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),

    // ĐÃ CHUYỂN LẠI SANG COLUMN
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,

      children: group.transactions.map((t) {
        // Lặp qua từng giao dịch để thêm Row và Gap
        return Column(
          children: [
            TransactionRow(transaction: t),
            // Thêm SizedBox (gap 12px) sau mỗi dòng (trừ dòng cuối)
            if (t != group.transactions.last)
              const Divider(
                height: 16,
                thickness: 1.5,
                color: Color(0xFFFDFAF7),
              ),
          ],
        );
      }).toList(),
    ),
  );
}

Widget _buildFooter(BuildContext context) {
  return Container(
    decoration: const BoxDecoration(
      color: Color(0xFFF5E2CC), // MÀU NỀN CAM/HỒNG
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      // Chỉ bo tròn góc dưới
    ),
    child: Padding(
      padding: EdgeInsets.fromLTRB(6, 12, 6, 12),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.center,
          child: Align(
            alignment: Alignment.center,
            // BỌC TRONG INKWELL
            
              child: Text(
                'Chỉnh sửa',
                style: TextStyle(
                  color: Color(0xFFCE5127),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Manrope',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  
}
