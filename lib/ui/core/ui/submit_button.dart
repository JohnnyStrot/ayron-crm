import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    super.key,
    required this.formKey,
    required this.saveEntity,
  });

  final GlobalKey<FormState> formKey;
  final Command saveEntity;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          saveEntity.execute();
        }
      },
      child: const Text('Submit'),
    );
  }
}
