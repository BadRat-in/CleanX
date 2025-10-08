import 'package:flutter/cupertino.dart';

// A basic implementation of CupertinoListTile to match the style.
class CustomCupertinoListTile extends StatelessWidget {
  const CustomCupertinoListTile(
      {super.key,
      this.leading,
      required this.title,
      this.subtitle,
      this.trailing});

  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                    style:
                        CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                              fontSize: 16,
                            ),
                    child: title),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  DefaultTextStyle(
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .textStyle
                          .copyWith(
                              fontSize: 12,
                              color: CupertinoColors.secondaryLabel),
                      child: subtitle!),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 16),
            DefaultTextStyle(
                style: CupertinoTheme.of(context).textTheme.textStyle,
                child: trailing!),
          ],
        ],
      ),
    );
  }
}
