import 'package:ayron_crm/data/repositories/auth/auth_repository.dart';
import 'package:ayron_crm/data/services/api/auth_api_client.dart';
import 'package:ayron_crm/utils/result.dart';
import 'package:logging/logging.dart';

class AuthRepositoryRemote extends AuthRepository {
  AuthRepositoryRemote({required AuthApiClient authApiClient})
    : _authApiClient = authApiClient {
    _checkLoginStatus();
  }

  final _log = Logger('AuthRepositoryRemote');

  final AuthApiClient _authApiClient;

  bool _isLoggedIn = false;
  bool _isLoading = false;

  Future<void> _checkLoginStatus() async {
    final accessToken = await _authApiClient.getAccessToken();
    _isLoggedIn = accessToken != null;
    notifyListeners();
  }

  @override
  Future<bool> get isAuthenticated => Future.value(_isLoggedIn);

  @override
  Future<bool> get isLoading => Future.value(_isLoading);

  @override
  Future<Result<void>> login() async {
    _isLoading = true;
    notifyListeners();

    final result = await _authApiClient.login();
    if (result is Error<void>) {
      _log.severe(result.error);
    } else {
      _isLoggedIn = true;
    }
    _isLoading = false;
    notifyListeners();
    return result;
  }

  @override
  Future<Result<void>> logout() async {
    _isLoading = true;
    notifyListeners();

    final result = await _authApiClient.logout();
    if (result is! Error<void>) {
      _isLoggedIn = false;
    }
    _isLoading = false;
    notifyListeners();
    return result;
  }
}
