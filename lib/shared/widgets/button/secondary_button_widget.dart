import 'package:dongi/shared/widgets/button/button_widget.dart';
import 'package:flutter/material.dart';

class SecondaryButtonWidget extends ButtonWidget {
  const SecondaryButtonWidget({
    super.key,
    required super.onPressed,
    super.title,
    super.isLoading,
    super.icon,
  }) : super(
          backgroundColor: const Color(0xffE0E0E0),
          textColor: Colors.black,
        );
}
