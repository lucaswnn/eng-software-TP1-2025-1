import 'package:diary_fit/values/app_sizes.dart';
import 'package:flutter/material.dart';

// Useful widget to wrap child in wide screens
class WebLayoutConstrainedBox extends ConstrainedBox {
  WebLayoutConstrainedBox({super.key, super.child})
      : super(
          constraints: BoxConstraints(
            maxWidth: AppSizes.maxWidthWebConstraint,
            maxHeight: AppSizes.maxHeightWebConstraint,
          ),
        );
}
