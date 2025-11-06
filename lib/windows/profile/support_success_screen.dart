import 'package:flutter/material.dart';

import '../../core/screen_utils.dart';
import '../../generated/l10n.dart';

class SupportSuccessScreen extends StatelessWidget {
  const SupportSuccessScreen({super.key});

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: ScreenUtils.adaptiveHeight(context, 48)),
              Icon(
                Icons.check_circle_outline,
                size: ScreenUtils.adaptiveIconSize(context, 72),
                color: const Color(0xFF766DFF),
              ),
              SizedBox(height: ScreenUtils.adaptiveHeight(context, 16)),
              Text(
                s.supportFormSuccessTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: ScreenUtils.adaptiveFontSize(context, 13),
                  height: 1.5,
                  color: const Color(0xFF717171),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: ScreenUtils.adaptiveHeight(context, 56),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
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
                    s.supportFormSuccessOk.toUpperCase(),
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
}
