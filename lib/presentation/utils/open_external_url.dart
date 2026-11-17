import 'package:clean_movie_app/config/core/constants/core_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openExternalUrl(BuildContext context, Uri url) async {
  final messenger = ScaffoldMessenger.of(context);
  bool opened;
  try {
    opened = await launchUrl(url, mode: LaunchMode.externalApplication);
  } on PlatformException {
    opened = false;
  }
  if (!opened) {
    messenger.showSnackBar(
      const SnackBar(content: Text(CoreStrings.openLinkError)),
    );
  }
}

Uri youtubeVideoUrl(String videoKey) =>
    Uri.https('www.youtube.com', '/watch', {'v': videoKey});