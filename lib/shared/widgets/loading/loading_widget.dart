import 'package:flutter/material.dart';
import 'package:dongi/core/constants/color_config.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(ColorConfig.secondary),
      ),
    );
  }
} 