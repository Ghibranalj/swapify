import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/home/home_page.dart';
import 'dart:convert'; 

class UploadCertificatePage extends StatefulWidget {
  const UploadCertificatePage({super.key});

  @override
  State<UploadCertificatePage> createState() => _UploadCertificatePageState();
}

class PlatformFileWrapper {
  final PlatformFile file;
  final Uint8List? bytes;

  PlatformFileWrapper({required this.file, this.bytes});
}

class _UploadCertificatePageState extends State<UploadCertificatePage> {
  final List<PlatformFileWrapper> _uploadedCertificates = [];

  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
        allowMultiple: true,
        withData: true, 
      );

      if (result != null) {
        setState(() {
          for (var file in result.files) {
            if (file.size <= 50 * 1024 * 1024) {
              bool isDuplicate = _uploadedCertificates.any((element) => element.file.name == file.name);
              if (!isDuplicate) {
                _uploadedCertificates.add(
                  PlatformFileWrapper(file: file, bytes: file.bytes),
                );
              }
            }
          }
        });
      }
    } catch (e) {
      if (kDebugMode) print("Error picking file: $e");
    }
  }

  void _deleteCertificate(int index) {
    setState(() {
      _uploadedCertificates.removeAt(index);
    });
  }

  String _getFileSizeString(int bytes) {
    double mb = bytes / (1024 * 1024);
    return "${mb.toStringAsFixed(0)}MB";
  }

  void _handleSaveAndContinue() async {
    if (_uploadedCertificates.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFFFFF1F2),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 100,
            left: 24,
            right: 24,
          ),
          duration: const Duration(seconds: 3),
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Color(0xFFE11D48), size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Upload Required!', style: TextStyle(color: Color(0xFFE11D48), fontWeight: FontWeight.bold, fontSize: 15)),
                    SizedBox(height: 2),
                    Text('Please upload at least 1 certificate to continue.', style: TextStyle(color: Color(0xFFE11D48), fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      
      List<String> certData = [];

      if (kIsWeb) {
        certData = _uploadedCertificates.map((e) {
          if (e.bytes != null) {
            return 'base64,${base64Encode(e.bytes!)}';
          }
          return e.file.name;
        }).toList();
      } else {
        certData = _uploadedCertificates
            .where((e) => e.file.path != null)
            .map((e) => e.file.path!)
            .toList();
      }
      
      await prefs.setStringList('savedCertificates', certData);

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false,
      );
      
    } catch (e) {
      if (kDebugMode) print("Navigation/Save Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F0FF),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: Color(0xFFDDD6FE),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xFF7C3AED)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) => const LinearGradient(
                                  colors: [
                                    Color(0xFF7C3AED),
                                    Color(0xFFF472B6),
                                    Color(0xFF06B6D4),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                                child: const Text(
                                  'Upload Your Certificate',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                "Let's get you started!",
                                style: TextStyle(color: Colors.grey, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    GestureDetector(
                      onTap: _pickFiles,
                      child: Container(
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFE5D7FF),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.cloud_upload_outlined,
                              size: 48,
                              color: Color(0xFF7C3AED),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Drop your files here or Browse',
                              style: TextStyle(
                                color: Color(0xFF7C3AED),
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Max file size up to 50MB',
                              style: TextStyle(
                                color: const Color(0xFF7C3AED).withOpacity(0.49),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _uploadedCertificates.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = _uploadedCertificates[index];
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE5D7FF)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: const Color(0xFFF1F5F9),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: item.bytes != null
                                    ? Image.memory(item.bytes!, fit: BoxFit.cover)
                                    : const Icon(Icons.description, color: Color(0xFF7C3AED)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.file.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _getFileSizeString(item.file.size),
                                      style: const TextStyle(
                                        color: Color(0xFF7C3AED),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline_rounded,
                                  color: Color(0xFF7C3AED),
                                  size: 24,
                                ),
                                onPressed: () => _deleteCertificate(index),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF7C3AED),
                          Color(0xFFF472B6),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () => _handleSaveAndContinue(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Save & Continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                        (route) => false,
                      );
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Color(0xFF7C3AED),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}