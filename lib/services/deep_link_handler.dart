import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:pegaplay/data/constants.dart';

class DeepLinkHandler {
  final AppLinks _appLinks = AppLinks();

  Future<Uri?> getInitialLink() async {
    try {
      final Uri? initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        print('Initial deep link captured: ${initialLink.toString()}');

        if (initialLink.toString().startsWith(
          '${KConstants.appScheme}://auth/',
        )) {
          print(
            'Auth callback link detected - letting FlutterWebAuth2 handle it',
          );
          return null;
        }
      }
      return initialLink;
    } catch (e) {
      print('Error retrieving initial deep link: $e');
      return null;
    }
  }

  void initDeepLinks(BuildContext context) {
    _appLinks.uriLinkStream.listen((Uri uri) {
      final link = uri.toString();
      print('onAppLink: $link');

      if (link.startsWith('${KConstants.appScheme}://auth/')) {
        print(
          'Auth callback link detected - letting flutter_appauth handle it',
        );
        return;
      }

      print('Processing deep link: $link');
      handleLink(uri, context);
    });
  }

  void handleLink(Uri uri, BuildContext context) {
    final link = uri.toString();
    print('Handling deep link: $link');

    _handleLink(link, context);
  }

  void _handleLink(String link, BuildContext context) {
    print('Handling deep link: $link');

    final uri = Uri.parse(link);

    final pathSegments = uri.pathSegments;

    if (pathSegments.isNotEmpty) {
      final firstSegment = pathSegments.first;

      switch (firstSegment) {
        case 'home':
          if (pathSegments.length > 1) {
            final secondSegment = pathSegments[1];
            switch (secondSegment) {
              case 'main':
                Navigator.of(context).pushNamed('/home/main');
                break;
              case 'onboarding':
                Navigator.of(context).pushNamed('/home/onboarding');
                break;
              default:
                Navigator.of(context).pushNamed('/home');
            }
          } else {
            Navigator.of(context).pushNamed('/home');
          }
          break;

        default:
          Navigator.of(context).pushNamed('/');
      }
    }
  }
}
