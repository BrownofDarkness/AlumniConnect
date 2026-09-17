import 'package:flutter/widgets.dart';

const double _designWidth = 375;
const double _minScale = 0.85;
const double _maxScale = 1.25;
const double _tabletBreakpoint = 600;
const double _compactBreakpoint = 380;

extension Responsive on BuildContext {
  double get _scale {
    final double w = MediaQuery.sizeOf(this).width;
    return (w / _designWidth).clamp(_minScale, _maxScale);
  }

  double sp(double fontSize) => fontSize * _scale;

  double gap(double value) => value * _scale;

  bool get isCompact => MediaQuery.sizeOf(this).width < _compactBreakpoint;

  bool get isTablet => MediaQuery.sizeOf(this).width >= _tabletBreakpoint;
}

extension ResponsiveTextStyle on TextStyle {
  TextStyle responsive(BuildContext context) {
    final double? size = fontSize;
    if (size == null) return this;
    return copyWith(fontSize: context.sp(size));
  }
}
