import 'package:flutter/material.dart';

// Định nghĩa màu sắc cố định (Hardcoded Colors)
const Color _incomeGreen = Color(0xFF4CAF50); // Màu xanh lá cho Thu nhập
const Color _expenseRed = Color(0xFFF44336); // Màu đỏ cho Chi tiêu

class Transaction {
  // khai bao thuoc tinh trong man hinh
  final String description; //Mô tả 1 giao dịch
  final double amount; // so tien giao dich
  final bool isIncome; // thu nhap hoac chi tieu


  const Transaction({
    required this.description,
    required this.amount,
    required this.isIncome,
    
  });

  // ho tro phan giao dien
  // Lấy màu sắc theo loại giao dịch
  Color get color => isIncome ? _incomeGreen : _expenseRed;

  // định dạng số tiền
  String get formattedAmount {
    String formatted = amount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
    return formatted;
  }
}

// Model cho nhóm giao dịch theo ngày (Tương ứng với 1 Card)
class TransactionGroup {
  final String date;
  final double totalAmount;
  final List<Transaction> transactions;

  const TransactionGroup({
    required this.date, // Ngày
    required this.totalAmount, // Tổng tiền
    required this.transactions, // Danh sách giao dịch
  });
}

// DỮ LIỆU MÔ PHỎNG (MOCK DATA)
