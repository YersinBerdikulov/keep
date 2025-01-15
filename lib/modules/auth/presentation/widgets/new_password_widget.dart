import 'package:flutter/material.dart';

import '../../../../core/constants/color_config.dart';
import '../../../../core/constants/content/register/new_password_contents.dart';
import '../../../../core/constants/font_config.dart';
import '../../../../shared/widgets/button/button.dart';
import '../../../../shared/widgets/text_field/text_field.dart';

// Title widget
class NewPasswordTitle extends StatelessWidget {
  const NewPasswordTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          NewPasswordContents.title,
          style: FontConfig.h5(),
        ),
        Text(
          NewPasswordContents.subTitle,
          style: FontConfig.body2(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

// Form widget
class NewPasswordForm extends StatelessWidget {
  const NewPasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        TextFieldWidget(hintText: 'new password'),
        SizedBox(height: 10),
        TextFieldWidget(hintText: 'repeat new password'),
        SizedBox(height: 20),
      ],
    );
  }
}

// Action button widget
class NewPasswordActionButton extends StatelessWidget {
  const NewPasswordActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ButtonWidget(
      onPressed: () {},
      title: 'Save',
      textColor: ColorConfig.secondary,
    );
  }
}
