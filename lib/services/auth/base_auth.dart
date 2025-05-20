abstract class BaseAuthService {
  /// Check if user is currently authenticated
  bool get isAuthenticated;

  /// Get user ID from the current authentication
  String? get userId;

  /// Initialize the auth service
  Future<void> initialize();

  /// Sign in user and return success status
  Future<bool> signIn();

  /// Sign out user
  Future<void> signOut();

  /// Refresh auth tokens if needed
  Future<bool> refreshTokens();

  /// Get current access token
  Future<String?> getAccessToken();
}
