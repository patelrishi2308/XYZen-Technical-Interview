// Dart imports:

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:master_utility/master_utility.dart';
import 'package:permission_handler/permission_handler.dart' as handler;
import 'package:tune_stack/config/assets/colors.gen.dart';
import 'package:tune_stack/constants/app_dimensions.dart';
import 'package:tune_stack/helpers/device_info_helper.dart';
import 'package:path/path.dart' as p;

class AppUtils {
  AppUtils._();

  static bool _isRequestingPermission = false;
  static Future<void> mediaPermission({
    void Function()? onGrantedCallback,
    bool isCamera = false,
  }) async {
    if (_isRequestingPermission) {
      return;
    }
    handler.PermissionStatus? permissionStatus;
    _isRequestingPermission = true;
    try {
      if (isCamera) {
        permissionStatus = await handler.Permission.camera
            .onDeniedCallback(() async {
              LogHelper.logWarning('onDeniedCallback');
            })
            .onGrantedCallback(
              onGrantedCallback,
            )
            .onPermanentlyDeniedCallback(() async {
              LogHelper.logWarning('onPermanentlyDeniedCallback');
              await handler.openAppSettings();
            })
            .onProvisionalCallback(() {
              LogHelper.logWarning('onProvisionalCallback');
            })
            .onRestrictedCallback(() {
              LogHelper.logWarning('onRestrictedCallback');
            })
            .request();

        LogHelper.logSuccess('permissionStatus:- $permissionStatus');
      } else {
        if (Platform.isAndroid) {
          final version = DeviceInfoHelper.instance.androidVersion;

          if (version >= 13) {
            permissionStatus = await handler.Permission.photos
                .onDeniedCallback(() {
                  LogHelper.logWarning('onDeniedCallback');
                })
                .onGrantedCallback(onGrantedCallback)
                .onPermanentlyDeniedCallback(() {
                  LogHelper.logWarning('onPermanentlyDeniedCallback');
                  handler.openAppSettings();
                })
                .onProvisionalCallback(() {
                  LogHelper.logWarning('onProvisionalCallback');
                })
                .onRestrictedCallback(() {
                  LogHelper.logWarning('onRestrictedCallback');
                })
                .request();
          } else {
            permissionStatus = await handler.Permission.storage
                .onDeniedCallback(() {
                  LogHelper.logWarning('onDeniedCallback');
                })
                .onGrantedCallback(onGrantedCallback)
                .onPermanentlyDeniedCallback(() async {
                  LogHelper.logWarning('onPermanentlyDeniedCallback');
                  await handler.openAppSettings();
                })
                .onProvisionalCallback(() {
                  LogHelper.logWarning('onProvisionalCallback');
                })
                .onRestrictedCallback(() {
                  LogHelper.logWarning('onRestrictedCallback');
                })
                .request();
          }
        } else {
          permissionStatus = await handler.Permission.photos
              .onDeniedCallback(() {
                LogHelper.logWarning('onDeniedCallback');
              })
              .onLimitedCallback(() {
                onGrantedCallback?.call();
              })
              .onGrantedCallback(onGrantedCallback)
              .onPermanentlyDeniedCallback(() async {
                LogHelper.logWarning('onPermanentlyDeniedCallback');
                await handler.openAppSettings();
              })
              .onProvisionalCallback(() {
                LogHelper.logWarning('onProvisionalCallback');
              })
              .onRestrictedCallback(() {
                LogHelper.logWarning('onRestrictedCallback');
              })
              .request();
        }
      }
    } on PlatformException catch (error) {
      LogHelper.logError('MediaPermission PlatformException:- $error');
    } finally {
      _isRequestingPermission = false;
    }
    LogHelper.logSuccess('permissionStatus:- $permissionStatus');
  }

  static Future<void> audioPermission({
    void Function()? onGrantedCallback,
  }) async {
    if (_isRequestingPermission) {
      return;
    }
    handler.PermissionStatus? permissionStatus;
    _isRequestingPermission = true;
    try {
      if (Platform.isAndroid) {
        final version = DeviceInfoHelper.instance.androidVersion;

        if (version >= 13) {
          // For Android 13+ (API 33+), we need to request specific permissions
          permissionStatus = await handler.Permission.audio
              .onDeniedCallback(() {
                LogHelper.logWarning('Audio permission denied');
              })
              .onGrantedCallback(onGrantedCallback)
              .onPermanentlyDeniedCallback(() {
                LogHelper.logWarning('Audio permission permanently denied');
                handler.openAppSettings();
              })
              .onProvisionalCallback(() {
                LogHelper.logWarning('Audio permission provisional');
              })
              .onRestrictedCallback(() {
                LogHelper.logWarning('Audio permission restricted');
              })
              .request();
        } else {
          // For older Android versions, storage permission covers audio files
          permissionStatus = await handler.Permission.storage
              .onDeniedCallback(() {
                LogHelper.logWarning('Storage permission denied');
              })
              .onGrantedCallback(onGrantedCallback)
              .onPermanentlyDeniedCallback(() async {
                LogHelper.logWarning('Storage permission permanently denied');
                await handler.openAppSettings();
              })
              .onProvisionalCallback(() {
                LogHelper.logWarning('Storage permission provisional');
              })
              .onRestrictedCallback(() {
                LogHelper.logWarning('Storage permission restricted');
              })
              .request();
        }
      } else {
        // For iOS, we use the media library permission for audio files
        permissionStatus = await handler.Permission.mediaLibrary
            .onDeniedCallback(() {
              LogHelper.logWarning('Media library permission denied');
            })
            .onGrantedCallback(onGrantedCallback)
            .onPermanentlyDeniedCallback(() async {
              LogHelper.logWarning('Media library permission permanently denied');
              await handler.openAppSettings();
            })
            .onProvisionalCallback(() {
              LogHelper.logWarning('Media library permission provisional');
            })
            .onRestrictedCallback(() {
              LogHelper.logWarning('Media library permission restricted');
            })
            .request();
      }
    } on PlatformException catch (error) {
      LogHelper.logError('AudioPermission PlatformException:- $error');
    } finally {
      _isRequestingPermission = false;
    }
    LogHelper.logSuccess('Audio permission status:- $permissionStatus');
  }

  static InputBorder textFieldBorder() {
    return OutlineInputBorder(
      borderSide: const BorderSide(
        color: AppColors.divider,
        width: 0.5,
      ),
      borderRadius: BorderRadius.circular(AppConst.k8),
    );
  }

  static Future<void> checkKeyboardVisibility(ScrollController? controller) async {
    final hasClients = controller?.hasClients ?? false;
    if (!hasClients) {
      return;
    }
    await Future.delayed(
      Durations.long1,
      () async {
        final isKeyboardOpen = AppConst.viewInsets.bottom != 0;
        LogHelper.logSuccess('Keyboard:- $isKeyboardOpen');
        if (!isKeyboardOpen && !hasClients) {
          return;
        }
        final maxScrollExtent = controller?.position.maxScrollExtent ?? AppConst.k200;
        await controller?.animateTo(
          maxScrollExtent,
          duration: Durations.long1,
          curve: Curves.easeInOut,
        );
      },
    );
  }

  static String getExtensionFromPath(String path) {
    return p.extension(path).replaceFirst('.', '');
  }
}
