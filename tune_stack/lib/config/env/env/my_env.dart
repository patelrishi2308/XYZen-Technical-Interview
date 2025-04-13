// Package imports:
import 'package:envied/envied.dart';

part 'my_env.g.dart';

@Envied(path: '.env', obfuscate: true)
abstract class MyEnv {
  @EnviedField(varName: 'BASE_URL')
  static String baseUrl = _MyEnv.baseUrl;

  @EnviedField(varName: 'PREFERENCE_HELPER_ENCRYPTION_KEY')
  static String preferenceHelperEncryptionKey = _MyEnv.preferenceHelperEncryptionKey;
}
