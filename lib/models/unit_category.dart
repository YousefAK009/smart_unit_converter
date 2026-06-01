import 'package:flutter/material.dart';

class UnitCategory {
  final String name;
  final IconData icon;
  final Color color;
  final List<Unit> units;

  const UnitCategory({
    required this.name,
    required this.icon,
    required this.color,
    required this.units,
  });
}

class Unit {
  final String name;
  final String symbol;
  final double toBase; // multiplier to convert TO base unit
  final double Function(double)? fromBaseFormula; // for non-linear (temp)
  final double Function(double)? toBaseFormula;

  const Unit({
    required this.name,
    required this.symbol,
    required this.toBase,
    this.fromBaseFormula,
    this.toBaseFormula,
  });
}

final List<UnitCategory> categories = [
  UnitCategory(
    name: 'Length',
    icon: Icons.straighten,
    color: const Color(0xFF6C63FF),
    units: const [
      Unit(name: 'Meter', symbol: 'm', toBase: 1.0),
      Unit(name: 'Kilometer', symbol: 'km', toBase: 1000.0),
      Unit(name: 'Centimeter', symbol: 'cm', toBase: 0.01),
      Unit(name: 'Millimeter', symbol: 'mm', toBase: 0.001),
      Unit(name: 'Mile', symbol: 'mi', toBase: 1609.344),
      Unit(name: 'Yard', symbol: 'yd', toBase: 0.9144),
      Unit(name: 'Foot', symbol: 'ft', toBase: 0.3048),
      Unit(name: 'Inch', symbol: 'in', toBase: 0.0254),
    ],
  ),
  UnitCategory(
    name: 'Weight',
    icon: Icons.fitness_center,
    color: const Color(0xFF00C9A7),
    units: const [
      Unit(name: 'Kilogram', symbol: 'kg', toBase: 1.0),
      Unit(name: 'Gram', symbol: 'g', toBase: 0.001),
      Unit(name: 'Milligram', symbol: 'mg', toBase: 0.000001),
      Unit(name: 'Metric Ton', symbol: 't', toBase: 1000.0),
      Unit(name: 'Pound', symbol: 'lb', toBase: 0.453592),
      Unit(name: 'Ounce', symbol: 'oz', toBase: 0.0283495),
      Unit(name: 'Stone', symbol: 'st', toBase: 6.35029),
    ],
  ),
  UnitCategory(
    name: 'Temperature',
    icon: Icons.thermostat,
    color: const Color(0xFFFF6B6B),
    units: [
      Unit(
        name: 'Celsius',
        symbol: '°C',
        toBase: 1.0,
        toBaseFormula: (v) => v,
        fromBaseFormula: (v) => v,
      ),
      Unit(
        name: 'Fahrenheit',
        symbol: '°F',
        toBase: 1.0,
        toBaseFormula: (v) => (v - 32) * 5 / 9,
        fromBaseFormula: (v) => v * 9 / 5 + 32,
      ),
      Unit(
        name: 'Kelvin',
        symbol: 'K',
        toBase: 1.0,
        toBaseFormula: (v) => v - 273.15,
        fromBaseFormula: (v) => v + 273.15,
      ),
    ],
  ),
  UnitCategory(
    name: 'Area',
    icon: Icons.square_foot,
    color: const Color(0xFFFFA726),
    units: const [
      Unit(name: 'Square Meter', symbol: 'm²', toBase: 1.0),
      Unit(name: 'Square Kilometer', symbol: 'km²', toBase: 1000000.0),
      Unit(name: 'Square Centimeter', symbol: 'cm²', toBase: 0.0001),
      Unit(name: 'Square Foot', symbol: 'ft²', toBase: 0.092903),
      Unit(name: 'Square Inch', symbol: 'in²', toBase: 0.00064516),
      Unit(name: 'Square Mile', symbol: 'mi²', toBase: 2589988.11),
      Unit(name: 'Hectare', symbol: 'ha', toBase: 10000.0),
      Unit(name: 'Acre', symbol: 'ac', toBase: 4046.856),
    ],
  ),
  UnitCategory(
    name: 'Volume',
    icon: Icons.water_drop,
    color: const Color(0xFF42A5F5),
    units: const [
      Unit(name: 'Liter', symbol: 'L', toBase: 1.0),
      Unit(name: 'Milliliter', symbol: 'mL', toBase: 0.001),
      Unit(name: 'Cubic Meter', symbol: 'm³', toBase: 1000.0),
      Unit(name: 'Cubic Centimeter', symbol: 'cm³', toBase: 0.001),
      Unit(name: 'Gallon (US)', symbol: 'gal', toBase: 3.78541),
      Unit(name: 'Quart (US)', symbol: 'qt', toBase: 0.946353),
      Unit(name: 'Pint (US)', symbol: 'pt', toBase: 0.473176),
      Unit(name: 'Cup (US)', symbol: 'cup', toBase: 0.236588),
      Unit(name: 'Fluid Ounce', symbol: 'fl oz', toBase: 0.0295735),
    ],
  ),
  UnitCategory(
    name: 'Speed',
    icon: Icons.speed,
    color: const Color(0xFFAB47BC),
    units: const [
      Unit(name: 'Meter/Second', symbol: 'm/s', toBase: 1.0),
      Unit(name: 'Kilometer/Hour', symbol: 'km/h', toBase: 0.277778),
      Unit(name: 'Mile/Hour', symbol: 'mph', toBase: 0.44704),
      Unit(name: 'Knot', symbol: 'kn', toBase: 0.514444),
      Unit(name: 'Foot/Second', symbol: 'ft/s', toBase: 0.3048),
    ],
  ),
  UnitCategory(
    name: 'Time',
    icon: Icons.access_time,
    color: const Color(0xFF26A69A),
    units: const [
      Unit(name: 'Second', symbol: 's', toBase: 1.0),
      Unit(name: 'Millisecond', symbol: 'ms', toBase: 0.001),
      Unit(name: 'Minute', symbol: 'min', toBase: 60.0),
      Unit(name: 'Hour', symbol: 'hr', toBase: 3600.0),
      Unit(name: 'Day', symbol: 'd', toBase: 86400.0),
      Unit(name: 'Week', symbol: 'wk', toBase: 604800.0),
      Unit(name: 'Month', symbol: 'mo', toBase: 2629800.0),
      Unit(name: 'Year', symbol: 'yr', toBase: 31557600.0),
    ],
  ),
  UnitCategory(
    name: 'Data',
    icon: Icons.storage,
    color: const Color(0xFFEF5350),
    units: const [
      Unit(name: 'Byte', symbol: 'B', toBase: 1.0),
      Unit(name: 'Kilobyte', symbol: 'KB', toBase: 1024.0),
      Unit(name: 'Megabyte', symbol: 'MB', toBase: 1048576.0),
      Unit(name: 'Gigabyte', symbol: 'GB', toBase: 1073741824.0),
      Unit(name: 'Terabyte', symbol: 'TB', toBase: 1099511627776.0),
      Unit(name: 'Bit', symbol: 'bit', toBase: 0.125),
    ],
  ),
];
