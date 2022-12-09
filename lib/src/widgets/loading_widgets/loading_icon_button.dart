// Copyright (c) 2022 Contributors to the Suwayomi project
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import '../custom_circular_progress_indicator.dart';

class LoadingIconButton extends HookWidget {
  const LoadingIconButton({
    super.key,
    required this.icon,
    this.onPressed,
  });
  final Widget icon;
  final AsyncCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);
    return IconButton(
      icon: isLoading.value
          ? MiniCircularProgressIndicator(
              color: (icon is Icon) ? (icon as Icon).color : null,
              padding: EdgeInsets.zero,
            )
          : icon,
      onPressed: onPressed == null
          ? null
          : isLoading.value
              ? null
              : () async {
                  isLoading.value = true;
                  await onPressed!();
                  isLoading.value = false;
                },
    );
  }
}