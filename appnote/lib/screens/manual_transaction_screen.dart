// lib/screens/manual_transaction_screen.dart

import 'package:appnote/widgets/app_scaffold.dart'; // Import nền chung
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// TẠI SAO: Import này cần thiết cho Navigator.pop(context, ...)
// (Chúng ta sẽ dùng nó trong logic "Lưu")
// import 'package:intl/intl.dart'; // Sẽ dùng sau
// import 'home_screen.dart';
// import '../data/mock_data.dart';
import '../models/transaction.dart';
import '../utils/dialog_helper.dart';

// Cần import để Navigator.pop

class ManualTransactionScreen extends StatefulWidget {
  const ManualTransactionScreen({super.key});

  @override
  State<ManualTransactionScreen> createState() =>
      _ManualTransactionScreenState();
}

// ========================================================
// BÊN NGOÀI CLASS STATE
// ========================================================
// TẠI SAO: Lớp (Class) phải được khai báo ở top-level (bên ngoài)
class _TransactionEntry {
  final TextEditingController amountController;
  final TextEditingController noteController;

  _TransactionEntry()
    : amountController = TextEditingController(),
      noteController = TextEditingController();

  // Hàm tiện ích để hủy
  void dispose() {
    amountController.dispose();
    noteController.dispose();
  }

  // Hàm tiện ích để thêm listener
  void addListeners(VoidCallback listener) {
    amountController.addListener(listener);
    // Ghi chú không cần listener vì nó không ảnh hưởng nút Lưu/Tổng cộng
  }

  // Hàm tiện ích để gỡ listener
  void removeListeners(VoidCallback listener) {
    amountController.removeListener(listener);
  }
}

// ========================================================
// BÊN TRONG CLASS STATE
// ========================================================
class _ManualTransactionScreenState extends State<ManualTransactionScreen> {
  // ========================================================
  // 1. KHAI BÁO BIẾN (ĐÃ SỬA)
  // ========================================================
  final _formKey = GlobalKey<FormState>();

  // TẠI SAO: Xóa _allControllers, _expenseCount, _incomeCount
  // Thay bằng 2 List mới này
  final List<_TransactionEntry> _expenseEntries = [];
  final List<_TransactionEntry> _incomeEntries = [];

  final TextEditingController _totalController = TextEditingController();
  bool _isFormValid = false;
  bool _isTotalManuallyEdited = false;

  // ========================================================
  // 2. HÀM VÒNG ĐỜI (initState, dispose) (ĐÃ SỬA)
  // ========================================================
  @override
  void initState() {
    super.initState();
    // TẠI SAO: Khởi tạo 1 cặp Chi và 1 cặp Thu
    _addExpenseEntry();
    _addIncomeEntry();
    _totalController.addListener(_checkFormValidity);
  }

  @override
  void dispose() {
    _totalController.removeListener(_checkFormValidity);
    _totalController.dispose();

    // TẠI SAO: Hủy List mới
    for (var entry in _expenseEntries) {
      entry.removeListeners(_calculateAndUpdateTotal);
      entry.dispose();
    }
    for (var entry in _incomeEntries) {
      entry.removeListeners(_calculateAndUpdateTotal);
      entry.dispose();
    }
    super.dispose();
  }

  // ========================================================
  // 3. HÀM LOGIC (ĐÃ SỬA)
  // ========================================================

  // HÀM MỚI: Thêm một Cặp (Khoản chi)
  void _addExpenseEntry() {
    final newEntry = _TransactionEntry();
    newEntry.addListeners(_calculateAndUpdateTotal);
    setState(() {
      _expenseEntries.add(newEntry);
    });
    // Tính toán lại tổng ngay khi thêm
    _calculateAndUpdateTotal();
  }

  // HÀM MỚI: Thêm một Cặp (Khoản thu)
  void _addIncomeEntry() {
    final newEntry = _TransactionEntry();
    newEntry.addListeners(_calculateAndUpdateTotal);
    setState(() {
      _incomeEntries.add(newEntry);
    });
    // Tính toán lại tổng ngay khi thêm
    _calculateAndUpdateTotal();
  }

  // HÀM SỬA LỖI: _checkFormValidity
  void _checkFormValidity() {
    if (_formKey.currentState == null) return;

    // TẠI SAO: Lỗi 'Undefined' ở đây đã được sửa
    // Nó phải kiểm tra List MỚI
    bool isNotEmpty =
        _totalController.text.isNotEmpty ||
        _expenseEntries.any((e) => e.amountController.text.isNotEmpty) ||
        _incomeEntries.any((e) => e.amountController.text.isNotEmpty);

    bool isValid = _formKey.currentState!.validate();
    bool finalFormValid = isNotEmpty && isValid;

    if (finalFormValid != _isFormValid) {
      setState(() {
        _isFormValid = finalFormValid;
      });
    }
  }

  // TẠI SAO: Hàm tiện ích để chuyển "123.45" thành 123.45
  double _parseAmount(String text) {
    if (text.isEmpty) return 0.0;
    // Validator đã đảm bảo đây là số hợp lệ
    return double.tryParse(text) ?? 0.0;
  }

  // HÀM SỬA LỖI: _calculateAndUpdateTotal
  void _calculateAndUpdateTotal() {
    if (_isTotalManuallyEdited) {
      _checkFormValidity();
      return;
    }
    double totalExpense = 0.0;
    double totalIncome = 0.0;

    // TẠI SAO: Dùng hàm _parseAmount
    for (var entry in _expenseEntries) {
      totalExpense += _parseAmount(entry.amountController.text);
    }
    for (var entry in _incomeEntries) {
      totalIncome += _parseAmount(entry.amountController.text);
    }

    double netTotal = (totalIncome) + (totalExpense);
    // TẠI SAO: Chuyển về số nguyên (vì validator của chúng ta không cho phép .0)
    _totalController.text = netTotal.toStringAsFixed(0);

    _checkFormValidity();
  }

  // ========================================================
  // 4. HÀM DỰNG UI (Widget _build...)
  // ========================================================

  // (Hàm _buildAddButton của bạn đã đúng, giữ nguyên)
  Widget _buildAddButton({required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icons/AddCircle.png', width: 20, height: 20),
            const SizedBox(width: 4),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFFCE5127),
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========================================================
  // LOGIC LƯU (SAVE)
  // ========================================================
  void _saveTransaction() async {
    // 1. Tạo List rỗng để chứa các giao dịch con
    final List<Transaction> newTransactions = [];

    // 2. Thu thập Khoản chi
    for (var entry in _expenseEntries) {
      final double amount = _parseAmount(entry.amountController.text);
      if (amount > 0) {
        newTransactions.add(
          Transaction(
            // TẠI SAO: Lấy ghi chú, hoặc dùng text mặc định
            description: entry.noteController.text.isNotEmpty
                ? entry.noteController.text
                : 'Khoản chi',
            amount: amount,
            isIncome: false, // Loại: Chi
          ),
        );
      }
    }

    // 3. Thu thập Khoản thu
    for (var entry in _incomeEntries) {
      final double amount = _parseAmount(entry.amountController.text);
      if (amount > 0) {
        newTransactions.add(
          Transaction(
            description: entry.noteController.text.isNotEmpty
                ? entry.noteController.text
                : 'Khoản thu',
            amount: amount,
            isIncome: true, // Loại: Thu
          ),
        );
      }
    }

    // 4. Lấy Tổng cộng
    final double total = _parseAmount(_totalController.text);

    // 5. Đóng gói tất cả vào một TransactionGroup
    // TẠI SAO: Gửi về 1 nhóm mới cho "Hôm nay"
    final TransactionGroup newGroup = TransactionGroup(
      date: 'Hôm nay', // (Sẽ được merge vào nhóm "Hôm nay" ở HomeScreen)
      totalAmount: total,
      transactions: newTransactions,
    );

    // 6. GỬI DỮ LIỆU VỀ: Pop màn hình và gửi 'newGroup' về
    // Navigator.pop(context, newGroup);
    if (!mounted) return;
    // 6. GỌI POPUP THÀNH CÔNG (THAY VÌ NAVIGATOR.POP)
    await showAppSuccessDialog(
      context: context,
      title: 'Tạo thu chi thành công',
      content: 'Bạn có thể xem lại thu chi vừa tạo ở mục thu chi',
      buttonText: 'Xem ngay',

      // TẠI SAO: Khi nhấn "Xem ngay" -> Pop màn hình VÀ gửi dữ liệu
      onButtonPressed: () {
        if (mounted) {
          Navigator.pop(context, newGroup);
        }
      },

      // TẠI SAO: Khi nhấn "X" (đóng) -> Vẫn Pop màn hình VÀ gửi dữ liệu
      onClosePressed: () {
        if (mounted) {
          Navigator.pop(context, newGroup);
        }
      },
    );
  }

  // HÀM SỬA LỖI: _buildInput (Sửa viền lỗi)
  Widget _buildInput(
    String hint, {
    TextEditingController? controller,
    bool isAmountField = false,
    Function(String)? onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        keyboardType: isAmountField
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        validator: (value) {
          if (isAmountField && value != null && value.isNotEmpty) {
            final RegExp numRegExp = RegExp(r'^\d*\.?\d*$');
            if (!numRegExp.hasMatch(value)) {
              return 'Bạn chỉ được nhập số';
            }
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFF7A7A7A),
            fontFamily: 'Manrope-Regular',
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(1000),
            borderSide: BorderSide(color: Color(0xFFF1D8D0), width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(1000),
            borderSide: const BorderSide(color: Color(0xFFF1D8D0), width: 1.5),
          ),

          // SỬA LỖI TẠI ĐÂY: Viền lỗi phải là màu ĐỎ
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(1000),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1.0,
            ), // Đổi sang màu đỏ
          ),

          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(1000),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          errorStyle: const TextStyle(
            color: Colors.red,
            fontSize: 12,
            fontFamily: 'Manrope-Regular',
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  // (Hàm _buildSection của bạn đã đúng, giữ nguyên)
  Widget _buildSection({
    required String title,
    required List<_TransactionEntry> entries,
  }) {
    Color sectionColor = const Color(0xFFF8EEE2);

    return Container(
      margin: const EdgeInsets.only(top: 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: sectionColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF5E2CC), width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title /* ... style ... */),
          const Divider(height: 16, thickness: 1.5, color: Color(0xFFFDFAF7)),

          // LẶP LẠI CÁC TRƯỜNG NHẬP LIỆU
          for (int i = 0; i < entries.length; i++) ...[
            const SizedBox(height: 8),
            const Text('Số tiền' /* ... style ... */),
            _buildInput(
              'Nhập số tiền bạn ${title == 'Khoản chi' ? 'chi' : 'thu'}',
              controller: entries[i].amountController,
              isAmountField: true,
            ),
            const Text('Ghi chú' /* ... style ... */),
            _buildInput('Nhập ghi chú', controller: entries[i].noteController),
          ],
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  // ========================================================
  // 5. HÀM build() (Đã sửa lỗi)
  // ========================================================
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      titleText: 'Thêm thu chi',
      appBarLeading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF141010)),
        onPressed: () => Navigator.of(context).pop(),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. KHU VỰC KHOẢN CHI
              _buildSection(
                title: 'Khoản chi',
                // TẠI SAO: Lỗi 'Undefined' ở đây đã được sửa
                entries: _expenseEntries,
              ),
              _buildAddButton(
                title: 'Thêm khoản chi',
                // TẠI SAO: Lỗi 'Undefined' ở đây đã được sửa
                onTap: _addExpenseEntry,
              ),

              // 2. KHU VỰC KHOẢN THU
              _buildSection(
                title: 'Khoản thu',
                // TẠI SAO: Lỗi 'Undefined' ở đây đã được sửa
                entries: _incomeEntries,
              ),
              _buildAddButton(
                title: 'Thêm khoản thu',
                // TẠI SAO: Lỗi 'Undefined' ở đây đã được sửa
                onTap: _addIncomeEntry,
              ),

              // 3. KHU VỰC TỔNG CỘNG
              Container(
                margin: const EdgeInsets.only(top: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tổng cộng' /* ... style ... */),
                    const SizedBox(height: 12),
                    _buildInput(
                      'Nhập số liệu tổng',
                      controller: _totalController,
                      isAmountField: true,
                      onChanged: (value) {
                        setState(() {
                          _isTotalManuallyEdited = true;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 128), // Khoảng đệm
              // 4. NÚT LƯU
              ElevatedButton(
                // TẠI SAO: Logic này ĐÃ ĐÚNG (theo cách làm của chúng ta)
                onPressed: _isFormValid
                    ? () {
                        // TẠI SAO: Đảm bảo validate lần cuối
                        if (_formKey.currentState!.validate()) {
                          // GỌI HÀM LƯU MỚI TẠI ĐÂY
                          _saveTransaction();
                        }
                      }
                    : null,

                style: ElevatedButton.styleFrom(
                  backgroundColor: _isFormValid
                      ? const Color(0xFFCE5127)
                      : const Color(0xFFEFEFEF),
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1000),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Lưu',
                  style: TextStyle(
                    // Đổi màu chữ
                    color: _isFormValid
                        ? Colors.white
                        : const Color(0xFFBDBDBD),
                    fontFamily: 'Manrope-Regular',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 46), // Khoảng trống dưới cùng
            ],
          ),
        ),
      ),
    );
  }
}
