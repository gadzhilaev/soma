import 'package:flutter/material.dart';
import '../core/screen_utils.dart';
import '../generated/l10n.dart';

class ConfirmChangeDialog extends StatelessWidget {
  final String bodyText;
  final VoidCallback onConfirm;
  final String? confirmButtonText;
  final double? dialogHeight;

  const ConfirmChangeDialog({
    super.key,
    required this.bodyText,
    required this.onConfirm,
    this.confirmButtonText,
    this.dialogHeight,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String bodyText,
    required VoidCallback onConfirm,
    String? confirmButtonText,
    double? dialogHeight,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConfirmChangeDialog(
        bodyText: bodyText,
        onConfirm: onConfirm,
        confirmButtonText: confirmButtonText,
        dialogHeight: dialogHeight,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: ScreenUtils.adaptiveWidth(context, 20),
        vertical: ScreenUtils.adaptiveHeight(context, 16),
      ),
      child: Container(
        width: ScreenUtils.adaptiveWidth(context, 280),
        height: ScreenUtils.adaptiveHeight(context, dialogHeight ?? 154),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Заголовок "Внимание!"
            Text(
              s.validationTitle,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: ScreenUtils.adaptiveFontSize(context, 18),
                height: 22 / 18,
                letterSpacing: -0.41,
                color: const Color(0xFF282828),
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: ScreenUtils.adaptiveHeight(context, 12)),
            
            // Описание (1-2 строки) - по центру
            Expanded(
              child: Center(
                child: Text(
                  bodyText,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: ScreenUtils.adaptiveFontSize(context, 13),
                    height: 1.4,
                    letterSpacing: 0,
                    color: const Color(0xFF9D9D9D),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: dialogHeight != null ? 3 : 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            
            // Две кнопки внизу
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Кнопка "Изменить" (слева)
                SizedBox(
                  width: ScreenUtils.adaptiveWidth(context, 116),
                  height: ScreenUtils.adaptiveHeight(context, 32),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD580),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          ScreenUtils.adaptiveSize(context, 40),
                        ),
                      ),
                      elevation: 0,
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      (confirmButtonText ?? s.change).toUpperCase(),
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
                
                // Кнопка "Отмена" (справа)
                SizedBox(
                  width: ScreenUtils.adaptiveWidth(context, 116),
                  height: ScreenUtils.adaptiveHeight(context, 32),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF1F1F1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          ScreenUtils.adaptiveSize(context, 40),
                        ),
                      ),
                      elevation: 0,
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      s.cancel.toUpperCase(),
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
          ],
        ),
      ),
    );
  }
}

