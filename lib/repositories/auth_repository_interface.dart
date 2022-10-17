abstract class AuthRepositoryInterface {
  Future<Map<String, dynamic>?> register(
      String name, String email, String password, String passwordConfirmation);
  Future<Map<String, dynamic>?> login(String email, String password);
  Future<Map<String, dynamic>?> logout({required String token});
}
