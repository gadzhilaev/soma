import 'package:flutter/material.dart';
import '../../core/screen_utils.dart';
import '../../generated/l10n.dart';

class NotificationItem {
  final String id;
  final String title;
  final String description;
  final String? actionLabel;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    this.actionLabel,
  });
}

class NotificationsCenterScreen extends StatefulWidget {
  final List<NotificationItem> initialNotifications;
  final bool showSampleFallback;

  const NotificationsCenterScreen({
    super.key,
    this.initialNotifications = const [],
    this.showSampleFallback = true,
  });

  @override
  State<NotificationsCenterScreen> createState() =>
      _NotificationsCenterScreenState();
}

class _NotificationsCenterScreenState extends State<NotificationsCenterScreen> {
  late List<NotificationItem> _notifications;
  bool _cleared = false;

  @override
  void initState() {
    super.initState();
    _notifications = List<NotificationItem>.from(widget.initialNotifications);
    if (_notifications.isEmpty && widget.showSampleFallback) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final s = S.of(context);
        setState(() {
          _notifications = [
            NotificationItem(
              id: 'sample',
              title: s.notificationsSampleTitle,
              description: s.notificationsSampleDescription,
              actionLabel: s.notificationsSampleAction,
            ),
          ];
        });
      });
    }
  }

  void _removeNotification(String id) {
    setState(() {
      _notifications.removeWhere((item) => item.id == id);
      if (_notifications.isEmpty) {
        _cleared = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    final shouldPopCleared = _notifications.isEmpty || _cleared;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.of(context).pop(shouldPopCleared);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(shouldPopCleared),
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
              horizontal: ScreenUtils.adaptiveWidth(context, 16),
            ),
            child: _notifications.isEmpty
                ? _EmptyNotifications(message: s.notificationsEmpty)
                : ListView.separated(
                    padding: EdgeInsets.only(
                      top: ScreenUtils.adaptiveHeight(context, 16),
                      bottom: ScreenUtils.adaptiveHeight(context, 24),
                    ),
                    itemBuilder: (context, index) {
                      final item = _notifications[index];
                      return _NotificationCard(
                        item: item,
                        onClose: () => _removeNotification(item.id),
                        onAction: () {
                          // Notification action handling can be implemented here
                          // when specific actions are needed for notifications
                        },
                      );
                    },
                    separatorBuilder: (context, _) => SizedBox(
                      height: ScreenUtils.adaptiveHeight(context, 20),
                    ),
                    itemCount: _notifications.length,
                  ),
          ),
        ),
      ),
    );
  }
}

class _EmptyNotifications extends StatelessWidget {
  final String message;

  const _EmptyNotifications({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: ScreenUtils.adaptiveHeight(context, 32)),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            fontSize: ScreenUtils.adaptiveFontSize(context, 14),
            height: 1.4,
            letterSpacing: 0,
            color: const Color(0xFF282828),
          ),
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationItem item;
  final VoidCallback onClose;
  final VoidCallback onAction;

  const _NotificationCard({
    required this.item,
    required this.onClose,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final contentHeight = ScreenUtils.adaptiveHeight(context, 216);
    final radius = ScreenUtils.adaptiveSize(context, 30);

    return SizedBox(
      height: contentHeight,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: contentHeight,
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F7),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(radius),
                bottomRight: Radius.circular(radius),
              ),
              border: const Border(
                left: BorderSide(width: 4, color: Color(0xFF1ED1D7)),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                top: ScreenUtils.adaptiveHeight(context, 24),
                bottom: ScreenUtils.adaptiveHeight(context, 24),
                left: ScreenUtils.adaptiveWidth(context, 20),
                right: ScreenUtils.adaptiveWidth(context, 16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      fontSize: ScreenUtils.adaptiveFontSize(context, 14),
                      height: 1.0,
                      letterSpacing: 0,
                      color: const Color(0xFF282828),
                    ),
                  ),
                  SizedBox(height: ScreenUtils.adaptiveHeight(context, 8)),
                  Expanded(
                    child: Text(
                      item.description,
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: ScreenUtils.adaptiveFontSize(context, 14),
                        height: 19 / 14,
                        letterSpacing: 0,
                        color: const Color(0xFF717171),
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtils.adaptiveHeight(context, 12)),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: ScreenUtils.adaptiveWidth(context, 190),
                      height: ScreenUtils.adaptiveHeight(context, 36),
                      child: ElevatedButton(
                        onPressed: onAction,
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
                          (item.actionLabel ??
                                  S.of(context).notificationsAction)
                              .toUpperCase(),
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
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: ScreenUtils.adaptiveHeight(context, 16),
            right: ScreenUtils.adaptiveWidth(context, 16),
            child: InkWell(
              onTap: onClose,
              borderRadius: BorderRadius.circular(
                ScreenUtils.adaptiveSize(context, 12),
              ),
              child: SizedBox(
                width: ScreenUtils.adaptiveWidth(context, 16),
                height: ScreenUtils.adaptiveHeight(context, 16),
                child: const Icon(
                  Icons.close,
                  size: 16,
                  color: Color(0xFFC5C5C5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
