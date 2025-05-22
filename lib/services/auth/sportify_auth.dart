import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pegaplay/data/constants.dart';
import 'package:pegaplay/services/auth/base_auth.dart';

class SpotifyAuthService implements BaseAuthService {
  // Spotify Developer credentials
  final String clientId = dotenv.env['SPOTIFY_CLIENT_ID'] ?? '';
  final String redirectUri = '${KConstants.appScheme}://auth/callback';

  // API endpoints
  final String _tokenEndpoint = 'https://accounts.spotify.com/api/token';
  final String _authEndpoint = 'https://accounts.spotify.com/authorize';

  // AppAuth instance
  final FlutterAppAuth _appAuth = const FlutterAppAuth();

  // Secure storage for tokens
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Token storage keys
  final String _accessTokenKey = 'spotify_access_token';
  final String _refreshTokenKey = 'spotify_refresh_token';
  final String _expiryTimeKey = 'spotify_expiry_time';
  final String _userIdKey = 'spotify_user_id';

  final List<String> _scopes = [
    'user-read-private',
    'user-read-email',
    'playlist-read-private',
    'playlist-modify-public',
    'playlist-modify-private',
  ];

  // Authentication data
  String? _accessToken;
  String? _refreshToken;
  DateTime? _expiryTime;
  String? _userId;

  // Singleton pattern
  static final SpotifyAuthService _instance = SpotifyAuthService._internal();

  factory SpotifyAuthService() {
    return _instance;
  }

  SpotifyAuthService._internal();

  @override
  bool get isAuthenticated {
    if (_accessToken == null || _expiryTime == null) return false;
    return _expiryTime!.isAfter(DateTime.now());
  }

  @override
  String? get userId => _userId;

  @override
  Future<void> initialize() async {
    await _loadTokens();
  }

  @override
  Future<bool> signIn([Map<String, dynamic>? data]) async {
    try {
      // Perform the authorization
      final result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          clientId,
          redirectUri,
          issuer: 'https://accounts.spotify.com',
          serviceConfiguration: AuthorizationServiceConfiguration(
            authorizationEndpoint: _authEndpoint,
            tokenEndpoint: _tokenEndpoint,
          ),
          scopes: _scopes,
        ),
      );

      // Update tokens from the result
      _accessToken = result.accessToken;
      _refreshToken = result.refreshToken;
      _expiryTime = result.accessTokenExpirationDateTime;

      // Get user ID
      await _fetchUserId();

      // Save tokens to secure storage
      await _saveTokens();

      print('Spotify sign in successful');
      print('Access Token received, expiry: $_expiryTime');
      return true;
    } catch (e) {
      print('Spotify sign in error: $e');
      return false;
    }
  }

  @override
  Future<void> signOut() async {
    _accessToken = null;
    _refreshToken = null;
    _expiryTime = null;
    _userId = null;

    // Clear tokens from secure storage
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
    await _secureStorage.delete(key: _expiryTimeKey);
    await _secureStorage.delete(key: _userIdKey);
  }

  @override
  Future<bool> refreshTokens() async {
    if (_refreshToken == null) return false;

    try {
      // Use AppAuth to refresh the token
      final result = await _appAuth.token(
        TokenRequest(
          clientId,
          redirectUri,
          serviceConfiguration: AuthorizationServiceConfiguration(
            authorizationEndpoint: _authEndpoint,
            tokenEndpoint: _tokenEndpoint,
          ),
          refreshToken: _refreshToken,
          grantType: 'refresh_token',
        ),
      );

      // Update tokens from the result
      _accessToken = result.accessToken;
      // Some providers don't return a new refresh token
      if (result.refreshToken != null) {
        _refreshToken = result.refreshToken;
      }
      _expiryTime = result.accessTokenExpirationDateTime;

      await _saveTokens();
      return true;
    } catch (e) {
      print('Token refresh error: $e');
      return false;
    }
  }

  @override
  Future<String?> getAccessToken() async {
    // Check if token is expired or about to expire (within 5 minutes)
    if (_accessToken != null &&
        _expiryTime != null &&
        _expiryTime!.isBefore(DateTime.now().add(const Duration(minutes: 5)))) {
      await refreshTokens();
    }

    return _accessToken;
  }

  // Helper method to fetch user ID from Spotify API
  Future<void> _fetchUserId() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/me'),
        headers: {'Authorization': 'Bearer $_accessToken'},
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        _userId = userData['id'];
      } else {
        print(
          'Error fetching user profile: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  // Helper method to load tokens from secure storage
  Future<void> _loadTokens() async {
    try {
      _accessToken = await _secureStorage.read(key: _accessTokenKey);
      _refreshToken = await _secureStorage.read(key: _refreshTokenKey);
      final expiryString = await _secureStorage.read(key: _expiryTimeKey);
      _userId = await _secureStorage.read(key: _userIdKey);

      if (expiryString != null) {
        _expiryTime = DateTime.fromMillisecondsSinceEpoch(
          int.parse(expiryString),
        );
      }
    } catch (e) {
      print('Error loading tokens: $e');
    }
  }

  // Helper method to save tokens to secure storage
  Future<void> _saveTokens() async {
    try {
      if (_accessToken != null) {
        await _secureStorage.write(key: _accessTokenKey, value: _accessToken);
      }
      if (_refreshToken != null) {
        await _secureStorage.write(key: _refreshTokenKey, value: _refreshToken);
      }
      if (_expiryTime != null) {
        await _secureStorage.write(
          key: _expiryTimeKey,
          value: _expiryTime!.millisecondsSinceEpoch.toString(),
        );
      }
      if (_userId != null) {
        await _secureStorage.write(key: _userIdKey, value: _userId);
      }
    } catch (e) {
      print('Error saving tokens: $e');
    }
  }
}
