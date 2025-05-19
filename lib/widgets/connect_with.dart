import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ro_flutter/gen/assets.gen.dart';
import 'package:ro_flutter/gen/colors.gen.dart';

class ConnectWith extends StatefulWidget {
  const ConnectWith({super.key});

  @override
  State<ConnectWith> createState() => _ConnectWithState();
}

class _ConnectWithState extends State<ConnectWith> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildConnectButton(
            text: 'Connect with Spotify',
            foreground: AppColors.spotifyDark,
            icon: ColorFiltered(
              colorFilter: ColorFilter.mode(
                AppColors.spotifyPrimary,
                BlendMode.srcATop,
              ),
              child: Assets.icons.spotify.svg(),
            ),
          ),
          SizedBox(height: 8.h),
          _buildConnectButton(
            text: 'Connect with Apple Music',
            icon: Assets.icons.appleMusic.svg(),
          ),
          SizedBox(height: 8.h),
          _buildConnectButton(
            text: 'Connect with Google',
            icon: Assets.icons.googleLight.svg(),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectButton({
    required String text,
    required Widget icon,
    Color? background,
    Color? foreground,
    void Function()? onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed ?? () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: background ?? Colors.white,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 13),
        elevation: 6,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            color: Colors.transparent,
            child: icon,
          ),
          SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: foreground ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
