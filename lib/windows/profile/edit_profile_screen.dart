import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../core/screen_utils.dart';
import '../../generated/l10n.dart';
import 'edit_name_screen.dart';
import 'edit_email_screen.dart';
import 'edit_password_screen.dart';

class EditProfileScreen extends StatefulWidget {
  final String? currentName;
  final String? currentEmail;
  final String? currentAvatarUrl;

  const EditProfileScreen({
    super.key,
    this.currentName,
    this.currentEmail,
    this.currentAvatarUrl,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordIsPlaceholder = true;
  String? _avatarUrl;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.currentName ?? '';
    _emailController.text = widget.currentEmail ?? '';
    _avatarUrl = widget.currentAvatarUrl;
    // Для пароля показываем 8 символов как будто уже введен
    _passwordController.text = '•' * 8;
  }
  
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if (image != null) {
        setState(() {
          _avatarUrl = image.path;
        });
        // TODO: Загрузить изображение на сервер
      }
    } catch (e) {
      // Ошибка при выборе изображения
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при выборе изображения: $e')),
        );
      }
    }
  }
  
  void _openEditNameScreen() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EditNameScreen(currentName: widget.currentName ?? ''),
      ),
    );
    if (result != null && mounted) {
      setState(() {
        _nameController.text = result;
      });
      // TODO: Сохранить имя на сервере
    }
  }
  
  void _openEditEmailScreen() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EditEmailScreen(currentEmail: widget.currentEmail ?? ''),
      ),
    );
    if (result != null && mounted) {
      setState(() {
        _emailController.text = result;
      });
      // TODO: Сохранить email на сервере
    }
  }
  
  void _openEditPasswordScreen() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const EditPasswordScreen(),
      ),
    );
    // TODO: Сохранить пароль на сервере
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back, color: Color(0xFF282828)),
        ),
        title: SizedBox(
          width: ScreenUtils.adaptiveWidth(context, 48),
          height: ScreenUtils.adaptiveHeight(context, 50),
          child: Image.asset('assets/logo/logo.png', fit: BoxFit.contain),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtils.adaptiveWidth(context, 16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              SizedBox(height: ScreenUtils.adaptiveHeight(context, 16)),
              
              // Аватарка с кнопкой редактирования (слева)
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: ScreenUtils.adaptiveWidth(context, 120),
                    height: ScreenUtils.adaptiveHeight(context, 120),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                      image: _avatarUrl != null && _avatarUrl!.isNotEmpty
                          ? DecorationImage(
                              image: _avatarUrl!.startsWith('http')
                                  ? NetworkImage(_avatarUrl!) as ImageProvider
                                  : FileImage(File(_avatarUrl!)) as ImageProvider,
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _avatarUrl == null || _avatarUrl!.isEmpty
                        ? Icon(
                            Icons.person,
                            size: ScreenUtils.adaptiveIconSize(context, 60),
                            color: Colors.grey[600],
                          )
                        : null,
                  ),
                  // Круг с иконкой редактирования
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: ScreenUtils.adaptiveWidth(context, 40),
                        height: ScreenUtils.adaptiveHeight(context, 40),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F1F1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.edit_outlined,
                          size: ScreenUtils.adaptiveIconSize(context, 20),
                          color: const Color(0xFF766DFF),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: ScreenUtils.adaptiveHeight(context, 24)),

              // Поле "Имя"
              _buildLabel(s.nameLabel),
              SizedBox(height: ScreenUtils.adaptiveHeight(context, 12)),
              _buildTextField(
                controller: _nameController,
                hintText: s.nameHint,
                rightText: s.change,
                onEditTap: _openEditNameScreen,
              ),

              SizedBox(height: ScreenUtils.adaptiveHeight(context, 16)),

              // Поле "Электронная почта"
              _buildLabel(s.emailLabel),
              SizedBox(height: ScreenUtils.adaptiveHeight(context, 12)),
              _buildTextField(
                controller: _emailController,
                hintText: s.emailHint,
                rightText: s.change,
                onEditTap: _openEditEmailScreen,
              ),

              SizedBox(height: ScreenUtils.adaptiveHeight(context, 16)),

              // Поле "Пароль"
              _buildLabel(s.passwordLabel),
              SizedBox(height: ScreenUtils.adaptiveHeight(context, 12)),
              _buildTextField(
                controller: _passwordController,
                hintText: s.passwordHint,
                rightText: s.change,
                isPassword: true,
                onEditTap: _openEditPasswordScreen,
              ),

              SizedBox(height: ScreenUtils.adaptiveHeight(context, 40)),

              // Кнопка удаления аккаунта
              _buildDeleteAccountButton(),

              SizedBox(height: ScreenUtils.adaptiveHeight(context, 20)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(
        left: ScreenUtils.adaptiveWidth(context, 8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
          fontSize: ScreenUtils.adaptiveFontSize(context, 13),
          height: 1.0,
          letterSpacing: 0,
          color: const Color(0xFFC5C5C5),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String rightText,
    bool isPassword = false,
    required VoidCallback onEditTap,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final padding = ScreenUtils.adaptiveWidth(context, 16);
        final textWidth = _measureTextWidth(
          rightText,
          ScreenUtils.adaptiveFontSize(context, 13),
        );
        final rightTextOffset = textWidth + ScreenUtils.adaptiveWidth(context, 24);
        final fieldWidth = screenWidth - (padding * 2) - rightTextOffset;
        
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: fieldWidth,
              height: ScreenUtils.adaptiveHeight(context, 48),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F1F1),
                borderRadius: BorderRadius.circular(
                  ScreenUtils.adaptiveSize(context, 24),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: ScreenUtils.adaptiveWidth(context, 20),
                ),
                child: TextField(
                  controller: controller,
                  enabled: false, // Поле неактивно
                  obscureText: isPassword && (!_passwordIsPlaceholder || controller.text != '•' * 8),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: ScreenUtils.adaptiveFontSize(context, 14),
                    height: 1.0,
                    letterSpacing: 0,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: ScreenUtils.adaptiveFontSize(context, 14),
                      height: 1.0,
                      letterSpacing: 0,
                      color: Colors.black.withOpacity(0.5),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
            SizedBox(width: ScreenUtils.adaptiveWidth(context, 24)),
            GestureDetector(
              onTap: onEditTap,
              child: Text(
                rightText,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: ScreenUtils.adaptiveFontSize(context, 13),
                  height: 1.0,
                  letterSpacing: 0,
                  color: const Color(0xFF766DFF),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  double _measureTextWidth(String text, double fontSize) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
          fontSize: fontSize,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    return textPainter.width;
  }

  Widget _buildDeleteAccountButton() {
    return Row(
      children: [
        Icon(
          Icons.delete_outline,
          size: ScreenUtils.adaptiveIconSize(context, 20),
          color: const Color(0xFFFE8E8E),
        ),
        SizedBox(width: ScreenUtils.adaptiveWidth(context, 8)),
        Text(
          S.of(context).deleteAccount,
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            fontSize: ScreenUtils.adaptiveFontSize(context, 13),
            height: 1.0,
            letterSpacing: 0,
            color: const Color(0xFFC5C5C5),
          ),
        ),
      ],
    );
  }
}

