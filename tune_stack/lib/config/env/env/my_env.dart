// Package imports:
import 'package:envied/envied.dart';

part 'my_env.g.dart';

@Envied(path: '.env', obfuscate: true)
abstract class MyEnv {
  @EnviedField(varName: 'BASE_URL')
  static String baseUrl = _MyEnv.baseUrl;

  @EnviedField(varName: 'PREFERENCE_HELPER_ENCRYPTION_KEY')
  static String preferenceHelperEncryptionKey =
      _MyEnv.preferenceHelperEncryptionKey;

  @EnviedField(varName: 'SUPABASE_URL')
  static String supaBaseURL = _MyEnv.supaBaseURL;

  @EnviedField(varName: 'SUPABASE_ANON_KEY')
  static String supaBaseAnonKey = _MyEnv.supaBaseAnonKey;

  @EnviedField(varName: 'SUPABASE_STORAGE_URL')
  static String supaBaseStoreUrl = _MyEnv.supaBaseStoreUrl;
}
