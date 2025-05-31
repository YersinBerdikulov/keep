import 'package:flutter/material.dart';

class LongPressMenuWidget extends StatelessWidget {
  final List<PopupMenuEntry> items;
  final Widget child;
  final VoidCallback? onTap;

  const LongPressMenuWidget({
    Key? key,
    required this.items,
    required this.child,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: () {
        final RenderBox overlay = 
            Overlay.of(context).context.findRenderObject() as RenderBox;
        
        showMenu(
          context: context,
          position: RelativeRect.fromRect(
            Rect.fromPoints(
              Offset.zero,
              Offset.zero,
            ),
            Offset.zero & overlay.size,
          ),
          items: _wrapItems(items),
        );
      },
      child: child,
    );
  }
  
  List<PopupMenuEntry> _wrapItems(List<PopupMenuEntry> originalItems) {
    // Filter out any Builder widgets from the list and keep only valid PopupMenuEntry items
    return originalItems.whereType<PopupMenuEntry>().toList();
  }
} 