import 'package:dongi/shared/widgets/button/button_widget.dart';
import 'package:flutter/material.dart';

class PrimaryButtonWidget extends ButtonWidget {
  const PrimaryButtonWidget({
    super.key,
    required super.onPressed,
    super.title,
    super.isLoading,
    super.icon,
  }) : super(
          backgroundColor: Colors.black,
          textColor: Colors.white,
        );
}
