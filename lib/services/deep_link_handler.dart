import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:pegaplay/data/constants.dart';

class DeepLinkHandler {
  final AppLinks _appLinks = AppLinks();

  Future<void> initDeepLinks(BuildContext context) async {
    // Get the initial link if the app was launched from a link
    final Uri? initialLink = await _appLinks.getInitialLink();
    if (initialLink != null) {
      _handleLink(initialLink.toString(), context);
    }

    // Listen for app links while the app is running
    _appLinks.uriLinkStream.listen((Uri uri) {
      final link = uri.toString();
      print('onAppLink: $link');

      // Skip auth callback links - these should be handled by FlutterWebAuth2
      if (link.startsWith('${KConstants.appScheme}://auth/')) {
        print(
          'Auth callback link detected - letting FlutterWebAuth2 handle it',
        );
        return;
      }

      // Process other deep links
      print('Processing deep link: $link');
      _handleLink(link, context);
    });
  }

  void _handleLink(String link, BuildContext context) {
    // Process all non-auth deep links here
    print('Handling deep link: $link');
  }
}
