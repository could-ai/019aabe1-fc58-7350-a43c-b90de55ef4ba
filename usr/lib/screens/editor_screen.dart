import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditorScreen extends StatefulWidget {
  final String initialTheme;

  const EditorScreen({super.key, required this.initialTheme});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  // Image Pickers
  final ImagePicker _picker = ImagePicker();
  List<XFile> _sourceImages = [];
  XFile? _modelImage;
  XFile? _productImage;

  // Settings
  String _selectedResolution = '4k';
  String _selectedRatio = 'Facebook';
  final TextEditingController _promptController = TextEditingController();

  // 20 Auto Features State
  final Map<int, bool> _features = {
    1: true, // Nhan dien chu de
    2: true, // Goi y phong cach
    3: true, // Can bang mau
    4: true, // Tang do net
    5: true, // Chinh sang toi
    6: false, // Filter le hoi
    7: true, // Cat khung
    8: false, // Thay nen
    9: true, // Lam dep khuon mat
    10: true, // Bo cuc
    11: false, // Upscale 8k
    12: false, // Chen chu
    13: false, // Album collage
    14: false, // Xoa vat the
    15: false, // Anh quang cao
    16: true, // Caption goi y
    17: true, // Mau sac nganh nghe
    18: true, // Luu anh goc
    19: true, // Phuc hoi ban truoc
    20: true, // Tao nhieu phien ban
  };

  final Map<int, String> _featureNames = {
    1: 'Nhận diện chủ đề tự động',
    2: 'Gợi ý phong cách phù hợp',
    3: 'Cân bằng màu & tối ưu',
    4: 'Tăng độ nét & giữ chi tiết mặt',
    5: 'Chỉnh sáng tối tự động',
    6: 'Filter theo sự kiện/lễ hội',
    7: 'Cắt khung chuẩn MXH',
    8: 'Tự động thay nền',
    9: 'Làm đẹp khuôn mặt tự nhiên',
    10: 'Tạo bố cục tự động',
    11: 'Upscale ảnh lên 8K',
    12: 'Chèn chữ/thông điệp',
    13: 'Tạo Album Collage',
    14: 'Xóa vật thể thừa',
    15: 'Tạo ảnh quảng cáo thương mại',
    16: 'Tạo caption gợi ý',
    17: 'Màu sắc theo ngành nghề',
    18: 'Lưu ảnh gốc riêng biệt',
    19: 'Phục hồi bản cũ an toàn',
    20: 'Tạo nhiều phiên bản gợi ý',
  };

  @override
  void initState() {
    super.initState();
    _promptController.text = "Thiết kế ảnh cho chủ đề ${widget.initialTheme}...";
  }

  Future<void> _pickSourceImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _sourceImages.addAll(images);
      });
    }
  }

  Future<void> _pickSingleImage(bool isModel) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        if (isModel) {
          _modelImage = image;
        } else {
          _productImage = image;
        }
      });
    }
  }

  void _generateDesign() {
    // Mock generation process
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã tạo xong 4 phiên bản ảnh! (Giả lập)'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thiết kế: ${widget.initialTheme}'),
        actions: [
          TextButton.icon(
            onPressed: _generateDesign,
            icon: const Icon(Icons.auto_awesome),
            label: const Text('TẠO ẢNH'),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).primaryColor,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Upload Section
            _buildSectionHeader('1. Tải dữ liệu đầu vào'),
            _buildUploadSection(),

            const Divider(height: 32),

            // 2. Settings Section
            _buildSectionHeader('2. Cấu hình đầu ra'),
            _buildSettingsSection(),

            const Divider(height: 32),

            // 3. Prompt Section
            _buildSectionHeader('3. Yêu cầu thiết kế (Tiếng Việt)'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _promptController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Nhập mô tả chi tiết (VD: Ảnh cưới lãng mạn, tông màu pastel...)',
                  helperText: 'AI sẽ tự động nhận diện tiếng Việt',
                ),
              ),
            ),

            const Divider(height: 32),

            // 4. 20 Auto Features
            _buildSectionHeader('4. 20 Tính năng tự động (Bật/Tắt)'),
            _buildFeaturesList(),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildUploadSection() {
    return SizedBox(
      height: 140,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // Source Images
          _buildUploadCard(
            'Kho ảnh nguồn',
            Icons.photo_library,
            _sourceImages.length.toString(),
            Colors.blue,
            _pickSourceImages,
          ),
          const SizedBox(width: 12),
          // Model Image
          _buildUploadCard(
            'Ảnh người mẫu',
            Icons.person,
            _modelImage != null ? 'Đã chọn' : 'Chưa chọn',
            Colors.pink,
            () => _pickSingleImage(true),
          ),
          const SizedBox(width: 12),
          // Product Image
          _buildUploadCard(
            'Ảnh sản phẩm',
            Icons.shopping_bag,
            _productImage != null ? 'Đã chọn' : 'Chưa chọn',
            Colors.orange,
            () => _pickSingleImage(false),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadCard(String label, IconData icon, String status, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 110,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              status,
              style: TextStyle(fontSize: 11, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Độ phân giải:', style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['1k', '2k', '4k', '6k', '8k'].map((res) {
              final isSelected = _selectedResolution == res;
              return ChoiceChip(
                label: Text(res),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() => _selectedResolution = res);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text('Khung hình MXH:', style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['YouTube (16:9)', 'TikTok (9:16)', 'Facebook (4:5)', 'Instagram (1:1)'].map((ratio) {
              final isSelected = _selectedRatio == ratio;
              return ChoiceChip(
                label: Text(ratio),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() => _selectedRatio = ratio);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 20,
      itemBuilder: (context, index) {
        final featureId = index + 1;
        return SwitchListTile(
          title: Text(
            '$featureId. ${_featureNames[featureId]}',
            style: const TextStyle(fontSize: 14),
          ),
          value: _features[featureId] ?? false,
          dense: true,
          activeColor: Theme.of(context).primaryColor,
          onChanged: (bool value) {
            setState(() {
              _features[featureId] = value;
            });
          },
        );
      },
    );
  }
}
