import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:image_painter/image_painter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:db_app/screens/project/ticket_screen.dart';
import 'package:db_app/screens/project/project_screen.dart';
import 'task_list.dart';
import 'package:intl/intl.dart';

// Biến trạng thái để lưu giá trị được chọn
String _selectedFloor = 'Floor 1'; // Giá trị mặc định
String _selectedDepartment = 'Living Area'; // Giá trị mặc định
String _floorImage = 'assets/images/layout_floor_1_ticket.png';
String? _editedImagePath;
String? _capturedImagePath;
String? _description;
String? _tasktitle;

class CreateNewTicketScreen extends StatefulWidget {
  const CreateNewTicketScreen({super.key});

  @override
  _CreateNewTicketScreenState createState() => _CreateNewTicketScreenState();
}

class _CreateNewTicketScreenState extends State<CreateNewTicketScreen> {
  List<Map<String, String>> tickets = []; // List to hold ticket data
  Future<void> _showTicketDetails(Map<String, dynamic> ticket) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateDialog) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppBar(
                      title: const Text("View Ticket"),
                      automaticallyImplyLeading: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Description",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: TextEditingController(
                                text: ticket["description"]),
                            decoration: InputDecoration(
                              hintText: "Nhập mô tả lỗi...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              filled: true,
                              fillColor: Colors.grey[200],
                            ),
                            readOnly:
                                true, // Make this field read-only for viewing
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                "Vị Trí",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Hình Lỗi",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    if (ticket["editedImagePath"] != null)
                                      Image.file(
                                        File(ticket["editedImagePath"]),
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                  ],
                                ),
                              ),
                              const VerticalDivider(
                                  width: 1, color: Colors.grey),
                              Expanded(
                                child: Column(
                                  children: [
                                    if (ticket["capturedImagePath"] != null)
                                      Image.file(
                                        File(ticket["capturedImagePath"]),
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context); // Close the dialog
                              },
                              child: const Text("Close"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _deleteTicket(Map<String, dynamic> ticket) {
    setState(() {
      // Xóa ticket từ danh sách
      tickets.remove(ticket);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ticket đã được xóa!")),
      );
    });
  }

  Future<void> _openEditDialog() async {
    final ImagePainterController localController = ImagePainterController(
      color: const Color.fromARGB(255, 255, 0, 0),
      strokeWidth: 2,
      mode: PaintMode.rect,
    );

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateDialog) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Column(
                  children: [
                    AppBar(
                      title: const Text("Edit Image"),
                      automaticallyImplyLeading: false,
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.save_alt),
                          onPressed: () async {
                            Uint8List? byteArray =
                                await localController.exportImage();
                            if (byteArray != null) {
                              final directory =
                                  await getApplicationDocumentsDirectory();
                              final timestamp =
                                  DateTime.now().millisecondsSinceEpoch;
                              final filePath =
                                  '${directory.path}/edited_image_$timestamp.png';
                              final file = File(filePath);
                              await file.writeAsBytes(byteArray);

                              setState(() {
                                _editedImagePath = filePath;
                              });

                              Navigator.pop(
                                  context); // Close the dialog after saving
                              _openFormDialog(
                                  filePath); // Open form dialog after saving image
                            }
                          },
                        ),
                      ],
                    ),
                    Expanded(
                      child: ImagePainter.asset(
                        _floorImage,
                        controller: localController,
                        scalable: true,
                        textDelegate: TextDelegate(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );

    localController.dispose();
  }

  Future<void> _openFormDialog(String imagePath) async {
    final ImagePicker picker = ImagePicker();

    // Reset lại các giá trị ảnh trước khi mở dialog
    setState(() {
      _capturedImagePath = null; // Xóa đường dẫn ảnh chụp cũ
    });

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateDialog) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppBar(
                      title: const Text("Create Ticket 2"),
                      automaticallyImplyLeading: false,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Description",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            decoration: InputDecoration(
                              hintText: "Nhập mô tả lỗi...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              filled: true,
                              fillColor: Colors.grey[200],
                            ),
                            onChanged: (value) {
                              setStateDialog(() {
                                _description = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                "Vị Trí",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Hình Lỗi",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    if (_editedImagePath != null)
                                      Image.file(
                                        File(_editedImagePath!),
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                  ],
                                ),
                              ),
                              const VerticalDivider(
                                  width: 1, color: Colors.grey),
                              Expanded(
                                child: Column(
                                  children: [
                                    if (_capturedImagePath != null)
                                      Image.file(
                                        File(_capturedImagePath!),
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    const SizedBox(height: 16),
                                    IconButton(
                                      icon: const Icon(Icons.camera_alt,
                                          size: 50),
                                      onPressed: () async {
                                        final XFile? image =
                                            await picker.pickImage(
                                                source: ImageSource.camera);
                                        if (image != null) {
                                          // Tạo tên tệp duy nhất cho ảnh chụp
                                          final directory =
                                              await getApplicationDocumentsDirectory();
                                          final timestamp = DateTime.now()
                                              .millisecondsSinceEpoch;
                                          final newImagePath =
                                              '${directory.path}/captured_image_$timestamp.png';

                                          await image.saveTo(newImagePath);

                                          setStateDialog(() {
                                            _capturedImagePath = newImagePath;
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_description != null &&
                                    _editedImagePath != null &&
                                    _capturedImagePath != null) {
                                  final ticket = {
                                    "description": _description!,
                                    "editedImagePath": _editedImagePath!,
                                    "capturedImagePath": _capturedImagePath!,
                                  };
                                  setState(() {
                                    tickets.add(ticket);
                                    print("Ticket added: $tickets");
                                  });
                                  Navigator.pop(
                                      context); // Close the form dialog
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Saved!")),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("Chưa điền đầy đủ thông tin")),
                                  );
                                  print("Chưa điền đầy đủ thông tin");
                                }
                              },
                              child: const Text("Kết thúc"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(5, 34, 36, 1),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color.fromARGB(255, 255, 255, 255)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Create New Ticket',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: const Color.fromRGBO(5, 34, 36, 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Task Title
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Task Title',
                  style: TextStyle(
                    fontSize: 26,
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                alignment: Alignment.centerLeft,
                child: TextField(
                  textInputAction: TextInputAction.send,
                  textCapitalization: TextCapitalization.words,
                  cursorColor: Colors.white,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color.fromRGBO(69, 90, 100, 1),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _tasktitle = value;
                    });
                  },
                  style: const TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 26,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Task Details
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Task Details',
                  style: TextStyle(
                    fontSize: 26,
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Floor',
                        style: TextStyle(
                          fontSize: 24,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(69, 90, 100, 1),
                      ),
                      child: DropdownButton<String>(
                        value: _selectedFloor,
                        dropdownColor: const Color.fromRGBO(69, 90, 100, 1),
                        style: const TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                        ),
                        isExpanded: true,
                        underline: const SizedBox(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedFloor = newValue!;
                            if (_selectedFloor == 'Floor 1') {
                              _floorImage =
                                  'assets/images/layout_floor_1_ticket.png';
                            } else if (_selectedFloor == 'Floor 2') {
                              _floorImage =
                                  'assets/images/layout_floor_2_ticket.png';
                            } else if (_selectedFloor == 'Floor 3') {
                              _floorImage =
                                  'assets/images/layout_floor_3_ticket.png';
                            }
                          });
                        },
                        items: <String>['Floor 1', 'Floor 2', 'Floor 3']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Department',
                        style: TextStyle(
                          fontSize: 26,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                        overflow: TextOverflow
                            .ellipsis, // Cắt ngắn nếu không đủ không gian
                        softWrap: false, // Không xuống dòng
                      ),
                    ),
                  ),
                  const SizedBox(width: 8), // Khoảng cách giữa nhãn và Dropdown
                  Flexible(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(69, 90, 100, 1), // Màu nền
                      ),
                      child: DropdownButton<String>(
                        value: _selectedDepartment, // Giá trị mặc định
                        dropdownColor: const Color.fromRGBO(
                            69, 90, 100, 1), // Màu nền của danh sách
                        style: const TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                        ),
                        isExpanded: true, // Mở rộng theo chiều ngang
                        underline: const SizedBox(), // Xóa gạch dưới
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedDepartment = newValue!;
                          });
                        },
                        items: <String>['Living Area', 'Kitchen', 'Bedroom']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18), // Khoảng cách giữa các dòng
              // Layout and List Ticket
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 9.0),
                child: const Text(
                  'LAYOUT',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(255, 122, 0, 1),
                  ),
                ),
              ),
              Container(
                height: 300,
                width: double.infinity,
                margin: const EdgeInsets.all(10),
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: InstaImageViewer(
                    child: Image.asset(_floorImage),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'List Ticket',
                  style: TextStyle(
                    fontSize: 26,
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ...tickets.map((ticket) {
                return Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  color: const Color.fromRGBO(69, 90, 100, 1),
                  child: Row(
                    children: [
                      // Phần nội dung của ticket
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 16),
                            Text(
                              '01 - : ${_tasktitle.toString()}',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                              softWrap: true,
                            ),
                            Text(
                              'Description: ${ticket["description"]}',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                              softWrap: true,
                            ),
                          ],
                        ),
                      ),
                      // Phần biểu tượng ở bên phải
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Tooltip(
                            message: 'Edit', // Tiêu đề cho nút Edit
                            child: IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Color.fromARGB(255, 255, 255, 255)),
                              onPressed: () {
                                // Logic sửa ticket
                                // _editTicket(ticket);
                              },
                            ),
                          ),
                          Tooltip(
                            message: 'Delete', // Tiêu đề cho nút Delete
                            child: IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Color.fromARGB(255, 255, 255, 255)),
                              onPressed: () {
                                // Logic xóa ticket
                                _deleteTicket(ticket);
                              },
                            ),
                          ),
                          Tooltip(
                            message: 'View Details', // Tiêu đề cho nút View
                            child: IconButton(
                              icon: const Icon(Icons.visibility,
                                  color: Color.fromARGB(255, 255, 255, 255)),
                              onPressed: () {
                                _showTicketDetails(ticket);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(38, 50, 56, 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: _openEditDialog,
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(10),
                backgroundColor: const Color.fromRGBO(254, 211, 106, 1),
              ),
              child: const Icon(
                Icons.add,
                size: 26,
                color: Colors.black,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm");
                final task = {
                  "taskTitle": _tasktitle!, // Ví dụ lấy từ biến _tasktitle
                  "floor": _selectedFloor, // Ví dụ lấy từ biến _selectedFloor
                  "department":
                      _selectedDepartment, // Ví dụ lấy từ biến _selectedDepartment
                  "create_date": dateFormat.format(DateTime.now()),
                  "tickets": List.from(tickets), // Thêm tickets vào task
                };
                setState(() {
                  tasks.add(task); // Thêm task vào tasks
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TicketScreen()));
              },
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: const Color.fromRGBO(254, 211, 106, 1),
              ),
              child: const Text(
                'Apply',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => const ProjectScreen()));
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: const Color.fromRGBO(254, 211, 106, 1),
              ),
              child: const Icon(
                Icons.settings,
                size: 24,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
