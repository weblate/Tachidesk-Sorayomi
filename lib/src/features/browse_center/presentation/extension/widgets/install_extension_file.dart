// Copyright (c) 2022 Contributors to the Suwayomi project
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../i18n/locale_keys.g.dart';
import '../../../../../utils/extensions/custom_extensions.dart';
import '../../../../../utils/misc/toast/toast.dart';
import '../../../data/extension_repository/extension_repository.dart';
import '../controller/extension_controller.dart';

class InstallExtensionFile extends ConsumerWidget {
  const InstallExtensionFile({super.key});

  void extensionFilePicker(WidgetRef ref, BuildContext context) async {
    final toast = ref.read(toastProvider(context));
    final file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['apk'],
    );
    if ((file?.files).isNotBlank) {
      toast.show(LocaleKeys.installingExtension.tr());
    }
    AsyncValue.guard(() => ref
        .read(extensionRepositoryProvider)
        .installExtensionFile(file: file?.files.single)).then(
      (result) => result.whenOrNull(
        error: (error, stackTrace) => result.showToastOnError(toast),
        data: (data) {
          ref.invalidate(extensionProvider);
          toast.instantShow(LocaleKeys.extensionInstalled.tr());
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.add_rounded),
      onPressed: () => extensionFilePicker(ref, context),
    );
  }
}
