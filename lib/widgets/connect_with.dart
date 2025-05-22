import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pegaplay/gen/assets.gen.dart';
import 'package:pegaplay/gen/colors.gen.dart';
import 'package:pegaplay/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ConnectWith extends StatefulWidget {
  const ConnectWith({super.key});

  @override
  State<ConnectWith> createState() => _ConnectWithState();
}

class _ConnectWithState extends State<ConnectWith> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            "Connect With",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.transparent,
              decoration: TextDecoration.underline,
              decorationColor: Theme.of(context).colorScheme.onSurface,
              decorationStyle: TextDecorationStyle.solid,
              shadows: [
                Shadow(
                  color: Theme.of(context).colorScheme.onSurface,
                  offset: Offset(0, -5),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildConnectButton(
                text: 'Spotfy',
                foreground: AppColors.spotifyDark,
                icon: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    AppColors.spotifyPrimary,
                    BlendMode.srcATop,
                  ),
                  child: Assets.icons.spotify.svg(),
                ),
                onPressed: () async {
                  if (_isLoading) {
                    return;
                  }
                  setState(() => _isLoading = true);
                  try {
                    await auth.signIn(AuthServiceType.spotify);
                  } finally {
                    if (mounted) setState(() => _isLoading = false);
                  }
                },
              ),
              _buildConnectButton(
                text: 'Apple Music',
                foreground: AppColors.spotifyDark,
                icon: Assets.icons.appleMusic.svg(),
              ),
              _buildConnectButton(
                text: 'Google',
                foreground: AppColors.spotifyDark,
                icon: Assets.icons.googleLight.svg(),
              ),
            ],
          ),
          SizedBox(height: 30.h),

          Text(
            "Social Login",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.transparent,
              decoration: TextDecoration.underline,
              decorationColor: Theme.of(context).colorScheme.onSurface,
              decorationStyle: TextDecorationStyle.solid,
              shadows: [
                Shadow(
                  color: Theme.of(context).colorScheme.onSurface,
                  offset: Offset(0, -5),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    // return Padding(
    //   padding: EdgeInsets.all(10),
    //   child: SizedBox(
    //     height: 40,
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         _buildConnectButton(
    //           text: 'Connect with Spotify',
    //           foreground: AppColors.spotifyDark,
    //           icon: ColorFiltered(
    //             colorFilter: ColorFilter.mode(
    //               AppColors.spotifyPrimary,
    //               BlendMode.srcATop,
    //             ),
    //             child: Assets.icons.spotify.svg(),
    //           ),
    //           onPressed:
    //               _isLoading
    //                   ? null
    //                   : () async {
    //                     setState(() => _isLoading = true);
    //                     try {
    //                       await auth.signIn(AuthServiceType.spotify);
    //                     } finally {
    //                       if (mounted) setState(() => _isLoading = false);
    //                     }
    //                   },
    //         ),
    //         SizedBox(height: 8.h),
    //         _buildConnectButton(
    //           text: 'Connect with Apple Music',
    //           icon: Assets.icons.appleMusic.svg(),
    //         ),
    //         SizedBox(height: 8.h),
    //         _buildConnectButton(
    //           text: 'Connect with Google',
    //           icon: Assets.icons.googleLight.svg(),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  Widget _buildConnectButton({
    required String text,
    required Widget icon,
    Color? foreground,
    void Function()? onPressed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 40,
          height: 40,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(0),
            ),
            child: icon,
          ),
        ),
        Text(text, style: TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}
