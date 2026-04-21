import 'package:flutter/material.dart';

/// 消息提示 - 从底部弹出的气泡框，3 秒后自动消失
class MessageSnackBar extends StatefulWidget {
  final String message;
  final VoidCallback? onDismiss;

  const MessageSnackBar({
    super.key,
    required this.message,
    this.onDismiss,
  });

  @override
  State<MessageSnackBar> createState() => _MessageSnackBarState();
}

class _MessageSnackBarState extends State<MessageSnackBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();

    // 3 秒后自动消失
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _dismiss();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _dismiss() {
    _controller.reverse().then((_) {
      if (mounted && widget.onDismiss != null) {
        widget.onDismiss!();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSuccess = widget.message.contains('成功') ||
        widget.message.contains('✓');
    final isError = widget.message.contains('失败') ||
        widget.message.contains('✗');

    Color backgroundColor;
    IconData iconData;

    if (isSuccess) {
      backgroundColor = Colors.green[600]!;
      iconData = Icons.check_circle;
    } else if (isError) {
      backgroundColor = Colors.red[600]!;
      iconData = Icons.error;
    } else {
      backgroundColor = Colors.blue[600]!;
      iconData = Icons.info;
    }

    return SlideTransition(
      position: _offsetAnimation,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    iconData,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _dismiss,
                    child: const Icon(
                      Icons.close,
                      color: Colors.white70,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
