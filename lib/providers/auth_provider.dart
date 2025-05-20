import 'package:flutter/material.dart';
import 'package:pegaplay/services/auth/base_auth.dart';

enum AuthServiceType {
  internal(1 << 0),
  spotify(1 << 1),
  apple(1 << 2),
  google(1 << 3);

  // Add other services here as needed

  final int value;
  const AuthServiceType(this.value);
}

class AuthProvider extends ChangeNotifier {
  static final AuthProvider _instance = AuthProvider._internal();
  factory AuthProvider() => _instance;
  AuthProvider._internal();

  final Map<AuthServiceType, BaseAuthService> _authServices = {};
  int _authenticatedServices = 0;
  AuthServiceType? _activeAuthType;

  // Initialize with required services
  void initializeServices(Map<AuthServiceType, BaseAuthService> services) {
    _authServices.addAll(services);
  }

  // Getter for the singleton instance
  static AuthProvider get instance => _instance;

  AuthServiceType? get activeAuthType => _activeAuthType;

  bool get isAuthenticated => _authenticatedServices != 0;

  // Check if authenticated with specific service
  bool isAuthenticatedWith(AuthServiceType? type) {
    return (_authenticatedServices & type!.value) != 0;
  }

  // Get all services user is authenticated with
  List<AuthServiceType> get authenticatedServices {
    return AuthServiceType.values
        .where((type) => isAuthenticatedWith(type))
        .toList();
  }

  // Get user ID from the primary authenticated service
  String? get userId {
    if (!isAuthenticated) return null;
    return _authServices[activeAuthType]?.userId;
  }

  // Initialize all auth services
  Future<void> initializeAll() async {
    await Future.wait(
      _authServices.values.map((service) => service.initialize()),
    );
    _updateAuthenticationStatus();
  }

  // Sign in with a specific service
  Future<bool> signIn(AuthServiceType type) async {
    final service = _authServices[type];
    if (service == null) return false;

    try {
      // Store context before starting auth flow
      final success = await service.signIn();

      if (success) {
        _authenticatedServices |= type.value;
        _activeAuthType = type;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('SignIn error: $e');
      return false;
    }
  }

  // Sign out of a specific service
  Future<void> signOut(AuthServiceType type) async {
    final service = _authServices[type];
    if (service == null) return;

    await service.signOut();
    _authenticatedServices &= ~type.value;

    if (_activeAuthType == type) {
      _activeAuthType = authenticatedServices.firstOrNull;
    }

    notifyListeners();
  }

  // Sign out of all services
  Future<void> signOutAll() async {
    await Future.wait(authenticatedServices.map((type) => signOut(type)));
    _activeAuthType = null;
  }

  // Refresh tokens for all authenticated services
  Future<bool> refreshAllTokens() async {
    final results = await Future.wait(
      authenticatedServices.map((type) => _authServices[type]!.refreshTokens()),
    );
    return results.every((result) => result);
  }

  // Get access token for active service
  Future<String?> getActiveAccessToken() async {
    if (_activeAuthType == null) return null;
    return await _authServices[_activeAuthType]!.getAccessToken();
  }

  // Private method to update authentication status
  void _updateAuthenticationStatus() {
    int newStatus = 0;

    for (final entry in _authServices.entries) {
      if (entry.value.isAuthenticated) {
        newStatus |= entry.key.value;
      }
    }

    if (newStatus != _authenticatedServices) {
      _authenticatedServices = newStatus;

      // Update active auth type if needed
      if (!isAuthenticatedWith(_activeAuthType)) {
        _activeAuthType = authenticatedServices.firstOrNull;
      }

      notifyListeners();
    }
  }
}
