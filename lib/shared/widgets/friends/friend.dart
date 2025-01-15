import 'package:dongi/core/constants/color_config.dart';
import 'package:flutter/material.dart';

class FriendWidget extends Container {
  final Color? backgroundColor;
  final Color? borderColor;
  final String? image;
  final bool isSelected;
  FriendWidget({
    super.key,
    this.backgroundColor,
    this.borderColor,
    super.width = 64,
    super.height = 64,
    this.image,
    this.isSelected = false,
  });

  @override
  Decoration? get decoration => BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ?? ColorConfig.midnight,
        border: Border.all(
          color: isSelected ? ColorConfig.secondary : Colors.transparent,
          width: 5,
        ),
        image: image != null && image != ''
            ? DecorationImage(image: NetworkImage(image!), fit: BoxFit.cover)
            : null,
      );

  FriendWidget.add({
    super.key,
    super.width = 64,
    super.height = 64,
    this.backgroundColor = Colors.transparent,
    this.borderColor,
    this.image,
    this.isSelected = false,
  }) : super(
          child: Icon(
            Icons.add_rounded,
            color: ColorConfig.primarySwatch,
            size: 40,
          ),
        );
}
