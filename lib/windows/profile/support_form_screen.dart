import 'package:flutter/material.dart';
import '../../core/screen_utils.dart';
import '../../generated/l10n.dart';
import 'support_success_screen.dart';

class SupportFormScreen extends StatefulWidget {
  final String? initialEmail;

  const SupportFormScreen({super.key, this.initialEmail});

  @override
  State<SupportFormScreen> createState() => _SupportFormScreenState();
}

class _SupportFormScreenState extends State<SupportFormScreen> {
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  final _contactsController = TextEditingController();
  bool _contactsHintApplied = false;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.initialEmail ?? '';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_contactsHintApplied && _contactsController.text.isEmpty) {
      _contactsHintApplied = true;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _messageController.dispose();
    _contactsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final s = S.of(context);
    final message = _messageController.text.trim();
    if (message.length < 12) {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Container(
            width: ScreenUtils.adaptiveWidth(context, 280),
            height: ScreenUtils.adaptiveHeight(context, 172),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                ScreenUtils.adaptiveSize(context, 24),
              ),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtils.adaptiveWidth(context, 20),
              vertical: ScreenUtils.adaptiveHeight(context, 16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  s.supportFormErrorTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: ScreenUtils.adaptiveFontSize(context, 18),
                    height: 22 / 18,
                    letterSpacing: -0.41,
                    color: const Color(0xFF282828),
                  ),
                ),
                SizedBox(height: ScreenUtils.adaptiveHeight(context, 12)),
                Expanded(
                  child: Center(
                    child: Text(
                      s.supportFormErrorBody,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: ScreenUtils.adaptiveFontSize(context, 13),
                        height: 1.4,
                        color: const Color(0xFF9D9D9D),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: ScreenUtils.adaptiveHeight(context, 16)),
                SizedBox(
                  width: ScreenUtils.adaptiveWidth(context, 116),
                  height: ScreenUtils.adaptiveHeight(context, 32),
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD580),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          ScreenUtils.adaptiveSize(context, 40),
                        ),
                      ),
                      padding: EdgeInsets.zero,
                      elevation: 0,
                    ),
                    child: Text(
                      s.supportFormErrorOk.toUpperCase(),
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: ScreenUtils.adaptiveFontSize(context, 10),
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
      return;
    }

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const SupportSuccessScreen()),
    );
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
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtils.adaptiveWidth(context, 20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: ScreenUtils.adaptiveHeight(context, 16)),
              Text(
                s.supportFormTitle.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: ScreenUtils.adaptiveFontSize(context, 14),
                  height: 23 / 14,
                  color: const Color(0xFF282828),
                ),
              ),
              SizedBox(height: ScreenUtils.adaptiveHeight(context, 16)),
              Text(
                s.supportFormDescription,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: ScreenUtils.adaptiveFontSize(context, 13),
                  height: 1.5,
                  color: const Color(0xFF717171),
                ),
              ),
              SizedBox(height: ScreenUtils.adaptiveHeight(context, 16)),
              Padding(
                padding: EdgeInsets.only(
                  left: ScreenUtils.adaptiveWidth(context, 8),
                ),
                child: Text(
                  s.supportFormEmailLabel,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: ScreenUtils.adaptiveFontSize(context, 13),
                    height: 1.0,
                    color: const Color(0xFFC5C5C5),
                  ),
                ),
              ),
              SizedBox(height: ScreenUtils.adaptiveHeight(context, 12)),
              _buildField(
                context,
                controller: _emailController,
                hint: s.supportFormEmailHint,
                height: ScreenUtils.adaptiveHeight(context, 48),
                maxLines: 1,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: ScreenUtils.adaptiveHeight(context, 16)),
              Padding(
                padding: EdgeInsets.only(
                  left: ScreenUtils.adaptiveWidth(context, 8),
                ),
                child: Text(
                  s.supportFormMessageLabel,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: ScreenUtils.adaptiveFontSize(context, 13),
                    height: 1.0,
                    color: const Color(0xFFC5C5C5),
                  ),
                ),
              ),
              SizedBox(height: ScreenUtils.adaptiveHeight(context, 12)),
              _buildField(
                context,
                controller: _messageController,
                hint: s.supportFormMessageHint,
                height: ScreenUtils.adaptiveHeight(context, 240),
                maxLines: null,
                contentTopPadding: ScreenUtils.adaptiveHeight(context, 16),
                contentLeftPadding: ScreenUtils.adaptiveWidth(context, 20),
                keyboardType: TextInputType.multiline,
              ),
              SizedBox(height: ScreenUtils.adaptiveHeight(context, 16)),
              Padding(
                padding: EdgeInsets.only(
                  left: ScreenUtils.adaptiveWidth(context, 8),
                ),
                child: Text(
                  s.supportFormContactsLabel,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: ScreenUtils.adaptiveFontSize(context, 13),
                    height: 1.0,
                    color: const Color(0xFFC5C5C5),
                  ),
                ),
              ),
              SizedBox(height: ScreenUtils.adaptiveHeight(context, 12)),
              _buildField(
                context,
                controller: _contactsController,
                hint: s.supportFormContactsHint,
                height: ScreenUtils.adaptiveHeight(context, 48),
                maxLines: 1,
                contentLeftPadding: ScreenUtils.adaptiveWidth(context, 20),
              ),
              SizedBox(height: ScreenUtils.adaptiveHeight(context, 16)),
              SizedBox(
                height: ScreenUtils.adaptiveHeight(context, 56),
                child: ElevatedButton(
                  onPressed: _submit,
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
                    s.supportFormSubmit.toUpperCase(),
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
              SizedBox(height: ScreenUtils.adaptiveHeight(context, 24)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    BuildContext context, {
    required TextEditingController controller,
    required String hint,
    required double height,
    int? maxLines,
    double? contentTopPadding,
    double? contentLeftPadding,
    TextInputType? keyboardType,
  }) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(
          ScreenUtils.adaptiveSize(context, 24),
        ),
      ),
      padding: EdgeInsets.only(
        left: contentLeftPadding ?? ScreenUtils.adaptiveWidth(context, 20),
        right: ScreenUtils.adaptiveWidth(context, 20),
        top: contentTopPadding ?? ScreenUtils.adaptiveHeight(context, 0),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines ?? 1,
        keyboardType: keyboardType,
        decoration: InputDecoration(border: InputBorder.none, hintText: hint),
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
          fontSize: ScreenUtils.adaptiveFontSize(context, 14),
          height: 1.0,
          color: Colors.black,
        ),
      ),
    );
  }
}
