/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2019/5/5 下午2:37
 */

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide RefreshIndicator, RefreshIndicatorState;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tune_stack/config/assets/colors.gen.dart';

/// QQ ios refresh  header effect
class AppWaterDropHeader extends RefreshIndicator {
  const AppWaterDropHeader({
    this.loaderColor = AppColors.primary,
    this.textColor = AppColors.primary,
    super.key,
    this.refresh,
    this.complete,
    super.completeDuration = const Duration(milliseconds: 600),
    this.failed,
    this.waterDropColor = AppColors.primary,
    this.idleIcon = const Icon(
      Icons.autorenew,
      size: 15,
      color: Colors.white,
    ),
  }) : super(height: 60, refreshStyle: RefreshStyle.UnFollow);

  /// refreshing content
  final Widget? refresh;

  /// complete content
  final Widget? complete;

  /// failed content
  final Widget? failed;

  /// idle Icon center in waterCircle
  final Widget idleIcon;

  /// waterDrop color,default grey
  final Color waterDropColor;

  final Color loaderColor;

  final Color textColor;

  @override
  State<StatefulWidget> createState() {
    return _WaterDropHeaderState();
  }
}

class _WaterDropHeaderState extends RefreshIndicatorState<AppWaterDropHeader> with TickerProviderStateMixin {
  AnimationController? _animationController;
  late AnimationController _dismissCtl;

  @override
  void onOffsetChange(double offset) {
    final realOffset = offset - 44.0; //55.0 mean circleHeight(24) + originH (20) in Painter
    if (!_animationController!.isAnimating) _animationController!.value = realOffset;
  }

  @override
  Future<void> readyToRefresh() {
    _dismissCtl.animateTo(0);
    return _animationController!.animateTo(0);
  }

  @override
  void initState() {
    _dismissCtl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400), value: 1);
    _animationController =
        AnimationController(vsync: this, upperBound: 50, duration: const Duration(milliseconds: 400));
    super.initState();
  }

  @override
  bool needReverseAll() {
    return false;
  }

  @override
  Widget buildContent(BuildContext context, RefreshStatus? mode) {
    Widget? child;
    if (mode == RefreshStatus.refreshing) {
      child = widget.refresh ??
          SizedBox(
            width: 25,
            height: 25,
            child: defaultTargetPlatform == TargetPlatform.iOS
                ? CupertinoActivityIndicator(color: widget.loaderColor)
                : CircularProgressIndicator(strokeWidth: 2, color: widget.loaderColor),
          );
    } else if (mode == RefreshStatus.completed) {
      child = widget.complete ??
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.done,
                color: widget.textColor,
              ),
              Container(
                width: 15,
              ),
              Text(
                (RefreshLocalizations.of(context)?.currentLocalization ?? EnRefreshString()).refreshCompleteText!,
                style: TextStyle(color: widget.textColor),
              ),
            ],
          );
    } else if (mode == RefreshStatus.failed) {
      child = widget.failed ??
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.close,
                color: Colors.grey,
              ),
              Container(
                width: 15,
              ),
              Text(
                (RefreshLocalizations.of(context)?.currentLocalization ?? EnRefreshString()).refreshFailedText!,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          );
    } else if (mode == RefreshStatus.idle || mode == RefreshStatus.canRefresh) {
      return FadeTransition(
        opacity: _dismissCtl,
        child: SizedBox(
          height: 60,
          child: Stack(
            children: <Widget>[
              RotatedBox(
                quarterTurns: Scrollable.of(context).axisDirection == AxisDirection.up ? 10 : 0,
                child: CustomPaint(
                  painter: _QqPainter(
                    color: widget.waterDropColor,
                    listener: _animationController,
                  ),
                  child: Container(
                    height: 60,
                  ),
                ),
              ),
              Container(
                alignment: Scrollable.of(context).axisDirection == AxisDirection.up
                    ? Alignment.bottomCenter
                    : Alignment.topCenter,
                margin: Scrollable.of(context).axisDirection == AxisDirection.up
                    ? const EdgeInsets.only(bottom: 12)
                    : const EdgeInsets.only(top: 12),
                child: widget.idleIcon,
              ),
            ],
          ),
        ),
      );
    }
    return SizedBox(
      height: 60,
      child: Center(
        child: child,
      ),
    );
  }

  @override
  void resetValue() {
    _animationController!.reset();
    _dismissCtl.value = 1.0;
  }

  @override
  void dispose() {
    _dismissCtl.dispose();
    _animationController!.dispose();
    super.dispose();
  }
}

class _QqPainter extends CustomPainter {
  _QqPainter({this.color, this.listener}) : super(repaint: listener);
  final Color? color;
  final Animation<double>? listener;

  double get value => listener!.value;
  final Paint painter = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    const originH = 20.0;
    final middleW = size.width / 2;

    const circleSize = 12.0;

    const scaleRatio = 0.1;

    final offset = value;

    painter.color = color!;
    canvas.drawCircle(Offset(middleW, originH), circleSize, painter);
    final path = Path()
      ..moveTo(middleW - circleSize, originH)
      ..cubicTo(
        middleW - circleSize,
        originH,
        middleW - circleSize + value * scaleRatio,
        originH + offset / 5,
        middleW - circleSize + value * scaleRatio * 2,
        originH + offset,
      )
      ..lineTo(middleW + circleSize - value * scaleRatio * 2, originH + offset)
      ..cubicTo(
        middleW + circleSize - value * scaleRatio * 2,
        originH + offset,
        middleW + circleSize - value * scaleRatio,
        originH + offset / 5,
        middleW + circleSize,
        originH,
      )
      ..moveTo(middleW - circleSize, originH)
      ..arcToPoint(Offset(middleW + circleSize, originH), radius: const Radius.circular(circleSize))
      ..moveTo(middleW + circleSize - value * scaleRatio * 2, originH + offset)
      ..arcToPoint(
        Offset(middleW - circleSize + value * scaleRatio * 2, originH + offset),
        radius: Radius.circular(value * scaleRatio),
      )
      ..close();
    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
