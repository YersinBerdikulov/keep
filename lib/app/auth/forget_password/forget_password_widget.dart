import 'package:flutter/material.dart';

import '../../../core/constants/color_config.dart';
import '../../../core/constants/content/register/forget_password_contents.dart';
import '../../../core/constants/font_config.dart';
import '../../../widgets/button/button.dart';
import '../../../widgets/text_field/text_field.dart';

class ForgetPasswordTitle extends StatelessWidget {
  const ForgetPasswordTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ForgetPasswordContents.title,
          style: FontConfig.h5(),
        ),
        Text(
          ForgetPasswordContents.subTitle,
          style: FontConfig.body2(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class ForgetPasswordForm extends StatelessWidget {
  const ForgetPasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: TextFieldWidget(hintText: 'phone number'),
    );
  }
}

class ForgetPasswordActionButton extends StatelessWidget {
  const ForgetPasswordActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ButtonWidget(
      onPressed: () {},
      title: 'Next',
      textColor: ColorConfig.secondary,
    );
  }
}
