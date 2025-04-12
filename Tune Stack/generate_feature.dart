import 'dart:developer';
import 'dart:io';

void main(List<String> args) {
  if (args.isEmpty) {
    log('Please provide a feature name.');
    return;
  }

  final featureName = args[0];
  const projectName = 'tune_stack'; //! Add your project name here
  final className = _toPascalCase(featureName);
  final camelCaseName = _toCamelCase(featureName);
  final basePath = 'lib/features/$featureName';

  if (Directory(basePath).existsSync()) {
    log('Error: The folder "$basePath" already exists. Please choose a different feature name.');
    return;
  }

  // Define folder structure
  final folders = [
    '$basePath/controllers',
    '$basePath/repository',
    '$basePath/models',
    '$basePath/views',
    '$basePath/views/widgets',
  ];

  // Define file content
  final stateNotifierContent = '''
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:$projectName/features/$featureName/controllers/${featureName}_state.dart';
import 'package:$projectName/features/$featureName/repository/${featureName}_repository.dart';

final ${camelCaseName}StateNotifierProvider = StateNotifierProvider<${className}StateNotifier, ${className}State>(
  (ref) => ${className}StateNotifier(
    ${camelCaseName}Repository: ref.read(_${camelCaseName}Repository),
  ),
);

final _${camelCaseName}Repository = Provider((ref) => ${className}Repository());

class ${className}StateNotifier extends StateNotifier<${className}State> {
  ${className}StateNotifier({
    required I${className}Repository ${camelCaseName}Repository,
  })  : _${camelCaseName}Repository = ${camelCaseName}Repository,
        super(${className}State.initial());

  final I${className}Repository _${camelCaseName}Repository;
}
''';

  final stateContent = '''
class ${className}State {
  ${className}State({
    required this.isLoading,
  });

  ${className}State.initial();

  bool isLoading = false;

  ${className}State copyWith({
    bool? isLoading,
  }) {
    return ${className}State(
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
''';

  final repositoryContent = '''
abstract interface class I${className}Repository {}

class ${className}Repository implements I${className}Repository {}
''';

  final screenContent = '''
import 'package:flutter/material.dart';

class ${className}Screen extends StatefulWidget {
  const ${className}Screen({super.key});

  @override
  State<StatefulWidget> createState() => _${className}ScreenState();
}

class _${className}ScreenState extends State<${className}Screen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
''';

  // Create folders
  for (final folder in folders) {
    Directory(folder).createSync(recursive: true);
    log('Created folder: $folder');
  }

  // Create files
  _createFile('$basePath/controllers/${featureName}_state_notifier.dart', stateNotifierContent);
  _createFile('$basePath/controllers/${featureName}_state.dart', stateContent);
  _createFile('$basePath/repository/${featureName}_repository.dart', repositoryContent);
  _createFile('$basePath/views/${featureName}_screen.dart', screenContent);

  log("Feature '$featureName' created successfully.");
}

void _createFile(String path, String content) {
  File(path).writeAsStringSync(content);
  log('Created file: $path');
}

String _toPascalCase(String input) {
  return input.split('_').map((word) => word[0].toUpperCase() + word.substring(1)).join();
}

String _toCamelCase(String input) {
  final parts = input.split('_');
  return parts[0] + parts.skip(1).map((word) => word[0].toUpperCase() + word.substring(1)).join();
}
