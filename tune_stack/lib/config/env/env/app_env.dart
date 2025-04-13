// Project imports:
import 'package:tune_stack/config/env/env/my_env.dart';

class AppEnv {
  static String get baseUrl => MyEnv.baseUrl;
  static String get preferenceHelperEncryptionKey => MyEnv.preferenceHelperEncryptionKey;
}
