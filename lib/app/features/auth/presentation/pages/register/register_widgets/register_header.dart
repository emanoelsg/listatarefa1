import 'package:flutter/material.dart';

class BuildHeader extends StatelessWidget {
  const BuildHeader({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Sign Up',
            style: Theme.of(
              context,
            ).textTheme.headlineLarge!.apply(color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            'Create an Account',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall!.apply(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
