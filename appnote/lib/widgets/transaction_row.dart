import 'package:flutter/material.dart';
import 'package:appnote/models/transaction.dart';

class TransactionRow extends StatelessWidget {
  final Transaction transaction;

  const TransactionRow({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Expanded(
            // Dùng Expanded: Đảm bảo Text chiếm hết không gian còn lại (trừ Số tiền), ngăn tràn.
            // flex: 2,
            // child:
             Flexible(
             flex: 5,
               child: Text(
                transaction.description, // Lấy Mô tả từ Model
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF141010),
                  fontFamily: 'Manrope-Regular'
                ),
                maxLines: null,
               
                // textAlign: TextAlign.start,
                // overflow: TextOverflow.ellipsis, // Nếu mô tả dài sẽ hiển thị "..."
                           ),
             ),
          // ),
          const Spacer(),
          // so tien
          // Expanded(
            // flex: 2,
            // child:
             Flexible(
              flex: 4,
               child: Text(
                // Dùng thuộc tính Helper từ Model: Dấu +/- và định dạng số tiền (ví dụ: +1.200.000đ)
                '${transaction.isIncome ? '' : ''}${transaction.formattedAmount}đ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Manrope-Medium',
                  color: transaction
                      .color, // Lấy màu Đỏ (Chi) / Xanh (Thu) từ thuộc tính Helper
                ),
                maxLines: 2,
               
                // textAlign: TextAlign.end,
                           // ),
                         ),
             ),
        ],
      ),
    );
  }
}
