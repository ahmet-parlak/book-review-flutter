import 'package:flutter/material.dart';

class LoadingIndicatorWidget extends StatelessWidget {
  const LoadingIndicatorWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
        color: Theme.of(context).colorScheme.secondary);
  }
}
