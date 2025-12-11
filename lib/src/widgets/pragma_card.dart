import 'package:flutter/material.dart';

import '../tokens/pragma_spacing.dart';

/// Contenedor elevado con padding y radios consistentes.
class PragmaCard extends StatelessWidget {
  const PragmaCard({
    required this.child,
    super.key,
    this.onTap,
    this.padding,
  });
  factory PragmaCard.section({
    required Widget body, Key? key,
    String? headline,
    Widget? action,
  }) {
    return PragmaCard(
      key: key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (headline != null)
            Padding(
              padding: const EdgeInsets.only(bottom: PragmaSpacing.md),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      headline,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  if (action != null) action,
                ],
              ),
            ),
          body,
        ],
      ),
    );
  }

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final Padding content = Padding(
      padding: padding ??
          PragmaSpacing.insetSymmetric(
            horizontal: PragmaSpacing.xl,
            vertical: PragmaSpacing.lg,
          ),
      child: child,
    );

    if (onTap == null) {
      return Card(child: content);
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: content,
      ),
    );
  }
}
