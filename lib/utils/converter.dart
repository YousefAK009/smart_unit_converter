import '../models/unit_category.dart';

class Converter {
  static double convert({
    required double value,
    required Unit fromUnit,
    required Unit toUnit,
  }) {
    // Handle non-linear conversions (temperature)
    if (fromUnit.toBaseFormula != null && toUnit.fromBaseFormula != null) {
      final baseValue = fromUnit.toBaseFormula!(value);
      return toUnit.fromBaseFormula!(baseValue);
    }

    // Linear conversion via base unit
    final inBase = value * fromUnit.toBase;
    return inBase / toUnit.toBase;
  }

  static String formatResult(double value) {
    if (value == 0) return '0';
    if (value.abs() >= 1e12 || (value.abs() < 1e-6 && value != 0)) {
      return value.toStringAsExponential(6).replaceAll(RegExp(r'0+e'), 'e');
    }
    if (value == value.truncate()) {
      return value.toStringAsFixed(0);
    }
    final str = value.toStringAsFixed(10);
    final trimmed = str.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
    final parts = trimmed.split('.');
    if (parts.length > 1 && parts[1].length > 8) {
      return value.toStringAsFixed(8).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
    }
    return trimmed;
  }
}
