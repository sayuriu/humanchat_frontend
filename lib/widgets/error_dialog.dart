import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ErrorDialog extends StatelessWidget {
  final String? message;
  final Function? onRetry;

  final String? additionalInformation;

  const ErrorDialog({super.key, this.message, this.additionalInformation, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Error'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message ?? 'An error occurred'),
          const Gap(8),
          if (additionalInformation != null)
            ...[
              const Text('Additional Information', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(additionalInformation!),
            ]
          ]
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            if (onRetry != null) onRetry!();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}