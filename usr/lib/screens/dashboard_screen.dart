import 'package:flutter/material.dart';
import 'editor_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  final List<Map<String, dynamic>> _categories = const [
    {'icon': Icons.favorite, 'label': 'Ảnh Cưới', 'color': Colors.pink},
    {'icon': Icons.cake, 'label': 'Sinh Nhật', 'color': Colors.orange},
    {'icon': Icons.celebration, 'label': 'Tết Nguyên Đán', 'color': Colors.red},
    {'icon': Icons.beach_access, 'label': 'Tết Dương Lịch', 'color': Colors.blue},
    {'icon': Icons.nightlight_round, 'label': 'Trung Thu', 'color': Colors.amber},
    {'icon': Icons.ac_unit, 'label': 'Giáng Sinh', 'color': Colors.teal},
    {'icon': Icons.family_restroom, 'label': 'Gia Đình', 'color': Colors.green},
    {'icon': Icons.shopping_bag, 'label': 'Quảng Cáo', 'color': Colors.purple},
    {'icon': Icons.woman, 'label': '8/3 & 20/10', 'color': Colors.pinkAccent},
    {'icon': Icons.school, 'label': '20/11', 'color': Colors.indigo},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Trợ Lý AI', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Chọn chủ đề để bắt đầu', style: TextStyle(fontSize: 14)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {},
            tooltip: 'Lịch sử',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
            tooltip: 'Cài đặt',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6200EE), Color(0xFF9955FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Thiết kế ảnh chuyên nghiệp',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tự động hóa với 20 tính năng AI mạnh mẽ',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.auto_awesome, color: Colors.white, size: 32),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Chủ đề phổ biến',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final item = _categories[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditorScreen(initialTheme: item['label']),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 2,
                      color: (item['color'] as Color).withOpacity(0.1),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(item['icon'], size: 32, color: item['color']),
                          const SizedBox(height: 8),
                          Text(
                            item['label'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
           Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EditorScreen(initialTheme: 'Tùy chỉnh'),
            ),
          );
        },
        label: const Text('Thiết kế mới'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
