import 'package:flutter/material.dart';
import 'package:db_app/screens/project/create_new_ticket_screen.dart';
import 'package:db_app/screens/project/task_detail_screen.dart';
import 'package:db_app/screens/project/project_screen.dart';
import 'task_list.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:percent_indicator/percent_indicator.dart'; // Cần cài thư viện percent_indicator

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key});

  @override
  _TicketScreenState createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  bool isCompletedSelected = false; // Trạng thái của nút Completed
  bool isApprovedSelected = false; // Trạng thái của nút Approved
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(5, 34, 36, 1),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'TICKET',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Builder(
              builder: (context) => Container(
                margin: const EdgeInsets.only(right: 16.0),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Search...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        onChanged: (value) {
                          // Thực hiện logic tìm kiếm ở đây
                        },
                      ),
                    ),
                    // IconButton(
                    //   icon: const Icon(Icons.clear, color: Colors.grey),
                    //   onPressed: () {
                    //     // Xóa nội dung tìm kiếm
                    //   },
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
        backgroundColor: const Color.fromRGBO(5, 34, 36, 1),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      // Cột thông tin dự án
                      Expanded(
                        flex:
                            1, // Chỉnh lại flex để mỗi cột có không gian như nhau
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .center, // Căn giữa các phần tử trong cột
                          children: [
                            Text(
                              'TOTAL TIKCET', // Tiêu đề dự án cố định
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              '10',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 255, 238, 2),
                              ),
                            ),
                            SizedBox(height: 2),
                          ],
                        ),
                      ),
                      // Khoảng cách giữa các cột
                      SizedBox(width: 10),

                      // Cột tiến độ (vòng tròn)
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: CircularPercentIndicator(
                            radius: 50.0,
                            lineWidth: 4.0,
                            percent: 0.8, // Tiến độ cố định, ví dụ: 80%
                            center: Text(
                              '80%', // Hiển thị 80% cố định
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                            progressColor:
                                Color.fromARGB(255, 255, 238, 2), // Màu vàng
                            backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                      // Khoảng cách giữa các cột
                      SizedBox(width: 10),

                      // Cột thông tin thứ hai
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .center, // Căn giữa các phần tử trong cột
                          children: [
                            Text(
                              'TOTAL TIKCET', // Tiêu đề dự án cố định
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              '10',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF00D09E),
                              ),
                            ),
                            SizedBox(height: 2),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 9.0),
                  child: const Text(
                    'HÌNH ẢNH DỰ ÁN HÔM QUA',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Danh sách cuộn ngang
                SizedBox(
                  height: 200,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: InstaImageViewer(
                              child: Image.asset(
                                  'assets/images/project_img_1.png'),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: InstaImageViewer(
                              child: Image.asset(
                                  'assets/images/project_img_2.png'),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: InstaImageViewer(
                              child: Image.asset(
                                  'assets/images/project_img_3.png'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'ALL TASK FOR TICKET',
                    style: TextStyle(
                      fontSize: 26,
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  children: tasks.map((task) {
                    return GestureDetector(
                      onTap: () {
                        // Điều hướng tới TaskDetailScreen khi nhấn vào task
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskDetailScreen(task: task),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        color: const Color.fromRGBO(69, 90, 100, 1),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 16),
                                  Text(
                                    task["taskTitle"].toString(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                    softWrap: true,
                                  ),
                                  Text(
                                    'Create Date: ${task["create_date"]}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                    softWrap: true,
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Tooltip(
                                  message:
                                      'Completed', // Tiêu đề cho nút Completed
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          isCompletedSelected
                                              ? Icons.check_circle
                                              : Icons.radio_button_unchecked,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            // Chọn hoặc bỏ chọn nút Completed
                                            isCompletedSelected =
                                                !isCompletedSelected;
                                            if (isCompletedSelected) {
                                              isApprovedSelected =
                                                  false; // Bỏ chọn nút Approved
                                            }
                                          });
                                        },
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          'Completed',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Tooltip(
                                  message:
                                      'Approved', // Tiêu đề cho nút Approved
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          isApprovedSelected
                                              ? Icons.check_circle
                                              : Icons.radio_button_unchecked,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            // Chọn hoặc bỏ chọn nút Approved
                                            isApprovedSelected =
                                                !isApprovedSelected;
                                            if (isApprovedSelected) {
                                              isCompletedSelected =
                                                  false; // Bỏ chọn nút Completed
                                            }
                                          });
                                        },
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          'Approved',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Tooltip(
                                  message: 'Delete', // Tiêu đề cho nút Delete
                                  child: IconButton(
                                    icon: const Icon(Icons.delete,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255)),
                                    onPressed: () {
                                      // Logic xóa ticket
                                      // _deleteTicket(ticket);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
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
                onPressed: () {},
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateNewTicketScreen()));
                },
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  backgroundColor: const Color.fromRGBO(254, 211, 106, 1),
                ),
                child: const Text(
                  'Add Ticket',
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
        drawer: SizedBox(
          width: MediaQuery.of(context).size.width * 1,
          child: Drawer(
            backgroundColor: const Color.fromARGB(176, 0, 0, 0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10.0),
                    title: const Text(
                      'THÔNG TIN DỰ ÁN',
                      style: TextStyle(
                        color: Color.fromRGBO(255, 164, 80, 1),
                        fontSize: 26,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TicketScreen()));
                    },
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10.0),
                    title: const Text(
                      'TIẾN ĐỘ DỰ ÁN',
                      style: TextStyle(
                        color: Color.fromRGBO(255, 164, 80, 1),
                        fontSize: 26,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TicketScreen()));
                    },
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10.0),
                    title: const Text(
                      'TÀI CHÍNH DỰ ÁN',
                      style: TextStyle(
                        color: Color.fromRGBO(255, 164, 80, 1),
                        fontSize: 26,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TicketScreen()));
                    },
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10.0),
                    title: const Text(
                      'HÀNG HÓA DỰ ÁN',
                      style: TextStyle(
                        color: Color.fromRGBO(255, 164, 80, 1),
                        fontSize: 26,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TicketScreen()));
                    },
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10.0),
                    title: const Text(
                      'LƯU Ý - NHẮC NHỞ',
                      style: TextStyle(
                        color: Color.fromRGBO(255, 164, 80, 1),
                        fontSize: 26,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const CreateNewTicketScreen()));
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
