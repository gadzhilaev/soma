import 'package:flutter/material.dart';
import '../../core/screen_utils.dart';
import '../../generated/l10n.dart';

class EditNameScreen extends StatefulWidget {
  final String currentName;

  const EditNameScreen({
    super.key,
    required this.currentName,
  });

  @override
  State<EditNameScreen> createState() => _EditNameScreenState();
}

class _EditNameScreenState extends State<EditNameScreen> {
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.currentName;
  }

  @override
  void dispose() {
    _nameController.dispose();
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
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtils.adaptiveWidth(context, 20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: ScreenUtils.adaptiveHeight(context, 48)),
              
              // Текст "Введите ваше новое имя"
              Text(
                s.enterNewName,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: ScreenUtils.adaptiveFontSize(context, 13),
                  height: 1.0,
                  letterSpacing: 0,
                  color: const Color(0xFFC5C5C5),
                ),
              ),
              
              SizedBox(height: ScreenUtils.adaptiveHeight(context, 12)),
              
              // Текстовое поле
              Container(
                height: ScreenUtils.adaptiveHeight(context, 48),
                width: double.infinity,
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
                    controller: _nameController,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: ScreenUtils.adaptiveFontSize(context, 14),
                      height: 1.0,
                      letterSpacing: 0,
                      color: Colors.black,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: ScreenUtils.adaptiveHeight(context, 16)),
              
              // Кнопка сохранить
              SizedBox(
                height: ScreenUtils.adaptiveHeight(context, 56),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Сохранить имя
                    Navigator.of(context).pop(_nameController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD580),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        ScreenUtils.adaptiveSize(context, 40),
                      ),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    s.save.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: ScreenUtils.adaptiveFontSize(context, 12),
                      height: 1.0,
                      letterSpacing: 0.04,
                      color: const Color(0xFF59523A),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

