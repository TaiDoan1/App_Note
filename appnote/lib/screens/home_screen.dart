import 'package:appnote/screens/NoteEntryScreen.dart';
import 'package:appnote/widgets/add_item_popup.dart';
import 'package:appnote/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

import 'package:appnote/widgets/transaction_group_card.dart';



// TẠI SAO: Import Model (TransactionGroup) để kiểm tra kiểu dữ liệu
import 'package:appnote/models/transaction.dart';
import 'package:appnote/data/mock_data.dart';
import 'package:appnote/widgets/app_bottom_navigation_bar.dart';
// import 'package:appnote/screens/ghi_chu_screen.dart';
import 'package:appnote/screens/su_kien_screen.dart';
import 'package:appnote/screens/edit_transaction_screen.dart';
// import 'package:appnote/utils/dialog_helper.dart';
import 'package:appnote/screens/manual_transaction_screen.dart';
import 'package:appnote/screens/event_entry_screen.dart';
import 'package:appnote/models/event.dart'; 
import 'package:appnote/data/mock_event_data.dart';




// Imports cho GHI CHÚ (MỚI)
import 'package:appnote/models/note.dart';
import 'package:appnote/data/mock_note_data.dart'; 
import 'package:appnote/widgets/note_group_card.dart';
import 'package:appnote/screens/manual_note_screen.dart';
import 'package:appnote/screens/edit_note_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 1. KHAI BÁO TRẠNG THÁI & CONTROLLER
  AppTab _currentTab = AppTab.thuChi;
  late List<TransactionGroup> _currentGroups;

  // THÊM MỚI: State cho Ghi chú
  late List<NoteGroup> _currentNotes;
  late List<Event> _currentEvents;

  @override
  void initState() {
    super.initState();
    // TẠI SAO: Tạo một BẢN SAO (copy) của mock data.
    _currentGroups = List.from(mockTransactionGroups); 
    _currentNotes = List.from(mockNoteGroups);
    _currentEvents = List.from(mockEvents);
  }

  // Hàm xử lý nhấn Tab (đơn giản hơn)
  void _selectTab(AppTab tab) {
    setState(() {
      _currentTab = tab;
      // Không cần PageController.animateToPage()
    });
  }

 Widget _buildThuChiList() {
    // Nội dung này chính là danh sách Card Thu Chi của bạn
    return ListView.builder(
      
      // TẠI SAO: Thêm padding trên/dưới cho đẹp
      padding: const EdgeInsets.only(top: 16.0, bottom: 24.0), 
      
      itemCount: _currentGroups.length,
      itemBuilder: (context, index) { // <-- 'index' rất quan trọng
        
        // TẠI SAO: Lấy 'group' và 'index'
        final group = _currentGroups[index];
        
        return Padding(
          // TẠI SAO: Thêm padding dọc cho mỗi Card
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12.0),
          child: TransactionGroupCard(
            group: group,
            // TẠI SAO: SỬA LỖI Ở ĐÂY
            // Truyền callback, gọi _openEditScreen với 'group' và 'index'
            onTap: () => _openEditScreen(group, index), 
          ),
        );
      },
    );
  }

  // *** THÊM: HÀM XỬ LÝ DỮ LIỆU MỚI (Từ Bước trước) ***
  void _handleNewTransactionData(TransactionGroup newGroup) {
    // TẠI SAO: Gọi setState để cập nhật UI
    setState(() {
      // 1. Tìm xem đã có nhóm "Hôm nay" chưa
      final todayGroupIndex = _currentGroups.indexWhere(
        (group) => group.date == 'Hôm nay'
      );

      if (todayGroupIndex != -1) {
        // 2a. NẾU CÓ: Hợp nhất (Merge)
        final existingGroup = _currentGroups[todayGroupIndex];
        
        // Tạo một nhóm mới đã được hợp nhất
        final mergedGroup = TransactionGroup(
          date: existingGroup.date,
          // TẠI SAO: Thêm các giao dịch mới vào ĐẦU danh sách con
          transactions: [...newGroup.transactions, ...existingGroup.transactions],
          // TẠI SAO: Cộng tổng mới vào tổng cũ
          totalAmount: existingGroup.totalAmount + newGroup.totalAmount, 
        );
        
        // Thay thế nhóm cũ bằng nhóm đã hợp nhất
        _currentGroups[todayGroupIndex] = mergedGroup;

      } else {
        // 2b. NẾU KHÔNG CÓ: Thêm nhóm mới vào ĐẦU danh sách
        _currentGroups.insert(0, newGroup);
      }
    });
  }


  // HÀM MỚI 1: Xử lý Vuốt Xoá một Note Item trên HomeScreen
  void _handleNoteItemDismiss(int groupIndex, int noteIndex) {
    setState(() {
      final removedNote = _currentNotes[groupIndex].notes.removeAt(noteIndex);
      
      if (_currentNotes[groupIndex].notes.isEmpty) {
        _currentNotes.removeAt(groupIndex);
      }
    });
    // TẠM THỜI BỎ qua phần lưu data vào storage
  }

  // HÀM MỚI 2: Hàm MỞ EDITOR TRỰC TIẾP khi nhấn vào hàng ghi chú
  void _openNoteItemEntry(NoteGroup group, int groupIndex, Note note, int noteIndex) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEntryScreen(initialText: note.description),
      ),
    );

    if (result != null && result is String && mounted) {
      final newDescription = result.trim();
      
      setState(() {
        if (newDescription.isNotEmpty) {
          _currentNotes[groupIndex].notes[noteIndex] = Note(description: newDescription);
        } else {
          // Nếu nội dung trống, coi như người dùng muốn xoá
          _handleNoteItemDismiss(groupIndex, noteIndex);
          return;
        }
      });
      // TẠM THỜI BỎ qua phần lưu data vào storage
    }
  }

  

  // HÀM MỞ MÀN HÌNH EDIT (MỚI)
  // ========================================================
  void _openEditScreen(TransactionGroup groupToEdit, int index) async {
    // TẠI SAO: Mở màn hình Edit và "ĐỢI" (await) kết quả
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        // TẠI SAO: Truyền group cần sửa vào
        builder: (context) => EditTransactionScreen(groupToEdit: groupToEdit),
      ),
    );

    // TẠI SAO: Sau khi màn hình Edit đóng, kiểm tra xem có dữ liệu trả về không
    if (result != null && result is TransactionGroup && mounted) {
      
      // TẠI SAO: Gọi setState và THAY THẾ nhóm cũ tại 'index'
      setState(() {
        _currentGroups[index] = result;
      });
    }
    // TRƯỜNG HỢP 2: Người dùng nhấn "Xoá" (THÊM MỚI TẠI ĐÂY)
    else if (result == 'DELETE' && mounted) {
      setState(() {
        // Xoá item tại 'index'
        _currentGroups.removeAt(index);
      });
    }
  }


// 3. CÁC HÀM CỦA GHI CHÚ (THÊM MỚI)
  // ========================================================

  Widget _buildNoteList() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 16.0, bottom: 24.0), 
      itemCount: _currentNotes.length, 
      itemBuilder: (context, groupIndex) { // Đổi index thành groupIndex cho rõ ràng
        final group = _currentNotes[groupIndex];
        return Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12.0),
          child: NoteGroupCard(
            group: group,
            // 1. Nhấn vào Thẻ vẫn mở EditNoteScreen
            onTap: () => _openEditNoteScreen(group, groupIndex),
            
            // 2. CALLBACK NHẤN ITEM (Mở Editor trực tiếp)
            onTapNoteItem: (note, noteIndex) {
              _openNoteItemEntry(group, groupIndex, note, noteIndex);
            },
            
            // 3. CALLBACK XOÁ ITEM (Vuốt sang trái)
            onDeleteNoteItem: (noteIndex) {
              _handleNoteItemDismiss(groupIndex, noteIndex);
            },
          ),
        );
      },
    );
  }

  // HÀM MỚI 2: Xử lý khi nhận NoteGroup mới
  void _handleNewNoteData(NoteGroup newGroup) {
    setState(() {
      final todayNoteIndex = _currentNotes.indexWhere((g) => g.date == 'Hôm nay');

      if (todayNoteIndex != -1) {
        final existingGroup = _currentNotes[todayNoteIndex];
        final mergedGroup = NoteGroup(
          date: existingGroup.date,
          notes: [...newGroup.notes, ...existingGroup.notes],
        );
        _currentNotes[todayNoteIndex] = mergedGroup;
      } else {
        _currentNotes.insert(0, newGroup);
      }
    });
  }

  // HÀM MỚI: Mở màn hình Chỉnh sửa Ghi chú
  void _openEditNoteScreen(NoteGroup groupToEdit, int index) async {
    // TẠI SAO: Logic y hệt _openEditScreen
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        // TẠI SAO: Gọi màn hình EditNoteScreen (Bước 1)
        builder: (context) => EditNoteScreen(groupToEdit: groupToEdit),
      ),
    );

    // TẠI SAO: Xử lý kết quả trả về
    
    // TRƯỜNG HỢP 1: Người dùng nhấn "Lưu" (Sửa)
    if (result != null && result is NoteGroup && mounted) {
      setState(() {
        _currentNotes[index] = result;
      });
    } 
    // TRƯỜNG HỢP 2: Người dùng nhấn "Xoá"
    else if (result == 'DELETE' && mounted) {
      setState(() {
        _currentNotes.removeAt(index);
      });
    }
  }

  // HÀM MỚI 3: Điều hướng đến màn hình Nhập Ghi chú
  void _navigateManualNote() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ManualNoteScreen()),
    );
    
    if (result != null && result is NoteGroup && mounted) {
      _handleNewNoteData(result);
    }
  }


  // 4. LOGIC MỞ POPUP (ĐÃ NÂNG CẤP)
  // HÀM CHUNG: Quyết định mở popup nào
  void _openAddItemPopup() async {
    final bool isTransactionTab = (_currentTab == AppTab.thuChi);
    final bool isNoteTab = (_currentTab == AppTab.ghiChu);
    final bool isEventTab = (_currentTab == AppTab.suKien);
    final String title;
    final String description;
   
    // TẠI SAO: XÁC ĐỊNH TITLE VÀ DESCRIPTION
    if (isTransactionTab) {
      title = 'Tạo thu chi mới';
      description = 'Bạn có thể bắt đầu bằng việc nói với AI hoặc nhập thủ công';
    } else if (isNoteTab) { // <--- THIẾU KIỂM TRA isNoteTab
      title = 'Tạo ghi chú mới';
      description = 'Bạn có thể bắt đầu bằng việc nói với AI hoặc nhập thủ công';
    } else if (isEventTab) { // <--- BỔ SUNG LOGIC CHO SỰ KIỆN
      title = 'Tạo sự kiện mới';
      description = 'Bạn có thể bắt đầu bằng tạo bảng việc nói với AI hoặc nhập thủ công';
    } else {
      return; // Không nên xảy ra
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (popupContext) { 
        return AddItemPopup(
          title: title,
          description: description,
          imageAsset: isTransactionTab 
              ? 'assets/images/PREVIEW.png' // Ảnh Thu chi
              : 'assets/images/PREVIEW.png', // Ảnh Ghi chú
          
          onManualTap: () {
            Navigator.pop(popupContext); // Đóng popup
            if (isTransactionTab) {
              _navigateManualTransaction(); 
            } else if (isNoteTab) { // <-- THÊM ĐIỀU KIỆN
              _navigateManualNote();
            } else if (isEventTab) { // <-- BỔ SUNG ĐIỀU KIỆN
              _navigateManualEvent(); // Cần đảm bảo hàm này đã được định nghĩa
            }
          },
          onAiTap: () {
            Navigator.pop(popupContext);
            
          },
        ); 
      },
    );
  }
  // HÀM ĐIỀU HƯỚNG 1: THU CHI
  void _navigateManualTransaction() async {
    // TẠI SAO: Đây chính là logic bên trong hàm _openAdd... cũ của bạn
    // (nhưng không còn phần showModalBottomSheet)
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ManualTransactionScreen()),
    );

    if (result != null && result is TransactionGroup && mounted) {
      _handleNewTransactionData(result);
    }
  }

  // 4. CÁC HÀM XỬ LÝ SỰ KIỆN
// ========================================================

  // Xử lý khi nhận Event mới hoặc đã chỉnh sửa
  void _handleNewEventData(Event newEvent) {
    setState(() {
      _currentEvents.insert(0, newEvent);
    });
  }

  // Điều hướng đến màn hình Nhập Sự kiện (Thủ công)
  void _navigateManualEvent() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EventEntryScreen()),
    );
    
    if (result != null && result is Event && mounted) {
      _handleNewEventData(result);
    }
  }

  // Mở màn hình Chỉnh sửa Sự kiện (Khi nhấn vào EventCard)
  void _openEditEventScreen(Event eventToEdit, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventEntryScreen(
          eventToEdit: eventToEdit,
        ),
      ),
    );
    
    if (result != null && result is Event && mounted) {
      setState(() {
        _currentEvents[index] = result;
      });
    }
    // 2. XỬ LÝ XÓA <--- THÊM ĐOẠN CODE NÀY (HOẶC XÁC NHẬN ĐÃ CÓ)
    else if (result == 'DELETE' && mounted) {
      setState(() {
        _currentEvents.removeAt(index);
      });
    }
  }

  // TẠM THỜI: HÀM RECORD VỚI AI CHỈ IN RA LỖI (KHÔNG CẦN CODE CHI TIẾT)
  void _navigateRecordPlaceholder() {
     print('TODO: Tính năng Record với AI chưa được triển khai.');
  }

  // HÀM MỚI: Xử lý Xoá Sự kiện khi Vuốt
  void _handleEventDismiss(Event event, int index) {
    setState(() {
      // 1. Xóa Event khỏi danh sách _currentEvents
      // Dùng index được truyền về từ SuKienScreen để xóa chính xác
      _currentEvents.removeAt(index);
    });
    
    // Tùy chọn: Hiển thị SnackBar "Đã xóa [Tên sự kiện]"
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã xoá sự kiện "${event.title}"'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  

  @override
  Widget build(BuildContext context) {
    // Lấy chỉ số hiện tại để IndexStack hiển thị
    final int currentIndex = AppTab.values.indexOf(_currentTab);

    // THÊM MỚI: Đổi tiêu đề App Bar dựa trên Tab
    final String titleText;
    switch (_currentTab) {
      case AppTab.thuChi:
        titleText = 'Thu Chi';
        break;
      case AppTab.ghiChu:
        titleText = 'Ghi chú';
        break;
      case AppTab.suKien:
        titleText = 'Sự kiện';
        break;
    }
    // *** SỬA LỖI 2: KHAI BÁO _screens BÊN TRONG HÀM build() ***
    // TẠI SAO: Để khi 'setState' chạy, '_buildThuChiList()' được gọi lại
    // và 'ListView' được vẽ lại với dữ liệu '_currentGroups' mới.
    final List<Widget> screens = [
      _buildThuChiList(), // 0: Thu Chi (giờ đã động)
      _buildNoteList(), // 1: Ghi chú
      SuKienScreen( // <--- CẦN TRUYỀN DỮ LIỆU ĐỘNG VÀ CALLBACK
        events: _currentEvents, 
        onTapEvent: _openEditEventScreen, 
        onToggleReminder: (event) {
          // Xử lý logic bật/tắt thông báo
          setState(() {
            final index = _currentEvents.indexWhere((e) => e.id == event.id);
            if (index != -1) {
              // Cập nhật trạng thái isReminderSet
              _currentEvents[index] = event.copyWith(isReminderSet: !event.isReminderSet); 
            }
          });
        }, onDeleteEvent: _handleEventDismiss,
      ),
    ];
    return AppScaffold(
      titleText: titleText,
      backgroundAsset: 'assets/images/splash.png',
      body: IndexedStack(
        index: currentIndex, // Chỉ số của Widget con sẽ được hiển thị
        children: screens, // Danh sách các màn hình
      ),
      // 2. BOTTOM NAVIGATION BAR (Liên kết với hàm _selectTab)
      bottomNavigationBar: CustomNavBar(
        selectedTab: _currentTab,
        onTabSelected: _selectTab,
      ),
      // 3. FLOATING ACTION BUTTON (Giữ nguyên logic ẩn hiện)
      floatingActionButton:
       (_currentTab == AppTab.thuChi || _currentTab == AppTab.ghiChu || _currentTab == AppTab.suKien)
          ? Padding(
              // ... style FAB ...
              padding: const EdgeInsets.only(right: 0),
              child: SizedBox(
                width: 60,
                height: 60,
                child: FloatingActionButton(
                  onPressed: _openAddItemPopup,
                  backgroundColor: const Color(0xFFCE5127),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: const CircleBorder(),
                  child: const Icon(Icons.add, size: 30),
                ),
              ),
            )
          : null,
    );

    // Lấy số lượng nhóm giao dịch từ dữ liệu mẫu
  }
}
