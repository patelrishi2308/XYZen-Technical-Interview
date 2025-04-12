// Project imports:
import 'package:tune_stack/config/flavours/app.dart';

void main() async {
  await AppConfig().setAppConfig(environment: Environment.dev);
}
