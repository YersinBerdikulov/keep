import 'package:flutter/material.dart';
import '../../../../core/constants/color_config.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(ColorConfig.primarySwatch),
      ),
    );
  }
} 