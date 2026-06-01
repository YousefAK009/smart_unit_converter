import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/unit_category.dart';
import '../utils/converter.dart';

class ConverterScreen extends StatefulWidget {
  final UnitCategory category;

  const ConverterScreen({super.key, required this.category});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  late Unit _fromUnit;
  late Unit _toUnit;
  final _controller = TextEditingController();
  String _result = '';
  String _formula = '';

  @override
  void initState() {
    super.initState();
    _fromUnit = widget.category.units.first;
    _toUnit = widget.category.units.length > 1
        ? widget.category.units[1]
        : widget.category.units.first;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _convert(String raw) {
    if (raw.isEmpty) {
      setState(() {
        _result = '';
        _formula = '';
      });
      return;
    }
    final value = double.tryParse(raw);
    if (value == null) {
      setState(() {
        _result = 'Invalid input';
        _formula = '';
      });
      return;
    }
    final converted = Converter.convert(
      value: value,
      fromUnit: _fromUnit,
      toUnit: _toUnit,
    );
    setState(() {
      _result = Converter.formatResult(converted);
      _formula =
          '${Converter.formatResult(value)} ${_fromUnit.symbol} = ${Converter.formatResult(converted)} ${_toUnit.symbol}';
    });
  }

  void _swap() {
    setState(() {
      final tmp = _fromUnit;
      _fromUnit = _toUnit;
      _toUnit = tmp;
      _convert(_controller.text);
    });
  }

  void _copyResult() {
    if (_result.isEmpty || _result == 'Invalid input') return;
    Clipboard.setData(ClipboardData(text: '$_result ${_toUnit.symbol}'));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied: $_result ${_toUnit.symbol}'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = widget.category.color;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        actions: [
          IconButton(
            onPressed: _copyResult,
            icon: const Icon(Icons.copy_rounded),
            tooltip: 'Copy result',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero icon
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(widget.category.icon, color: color, size: 36),
                ),
              ),
              const SizedBox(height: 24),

              // Input field
              Container(
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: color.withOpacity(0.3), width: 1.5),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: TextField(
                  controller: _controller,
                  onChanged: _convert,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: scheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '0',
                    hintStyle: TextStyle(color: scheme.onSurface.withOpacity(0.3)),
                    suffixText: _fromUnit.symbol,
                    suffixStyle: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // From / Swap / To row
              Row(
                children: [
                  Expanded(
                    child: _UnitDropdown(
                      label: 'From',
                      selectedUnit: _fromUnit,
                      units: widget.category.units,
                      color: color,
                      onChanged: (u) {
                        if (u != null) {
                          setState(() {
                            _fromUnit = u;
                            _convert(_controller.text);
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: _swap,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.swap_horiz_rounded, color: color),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _UnitDropdown(
                      label: 'To',
                      selectedUnit: _toUnit,
                      units: widget.category.units,
                      color: color,
                      onChanged: (u) {
                        if (u != null) {
                          setState(() {
                            _toUnit = u;
                            _convert(_controller.text);
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Result card
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withOpacity(0.85),
                      color.withOpacity(0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Result',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            _result.isEmpty ? '—' : _result,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -1,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _result.isEmpty ? '' : _toUnit.symbol,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if (_formula.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _formula,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // All conversions list
              Text(
                'All Conversions',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _AllConversions(
                category: widget.category,
                fromUnit: _fromUnit,
                inputText: _controller.text,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UnitDropdown extends StatelessWidget {
  final String label;
  final Unit selectedUnit;
  final List<Unit> units;
  final Color color;
  final ValueChanged<Unit?> onChanged;

  const _UnitDropdown({
    required this.label,
    required this.selectedUnit,
    required this.units,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: scheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.25), width: 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Unit>(
              value: selectedUnit,
              isExpanded: true,
              borderRadius: BorderRadius.circular(12),
              items: units
                  .map(
                    (u) => DropdownMenuItem(
                      value: u,
                      child: Text(
                        '${u.name} (${u.symbol})',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: u == selectedUnit
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: u == selectedUnit ? color : null,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class _AllConversions extends StatelessWidget {
  final UnitCategory category;
  final Unit fromUnit;
  final String inputText;
  final Color color;

  const _AllConversions({
    required this.category,
    required this.fromUnit,
    required this.inputText,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final value = double.tryParse(inputText) ?? 0;
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: category.units.map((unit) {
        final converted = Converter.convert(
          value: value,
          fromUnit: fromUnit,
          toUnit: unit,
        );
        final isActive = unit == fromUnit;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isActive
                ? color.withOpacity(0.12)
                : scheme.surfaceContainerHighest.withOpacity(0.4),
            borderRadius: BorderRadius.circular(12),
            border: isActive
                ? Border.all(color: color.withOpacity(0.4), width: 1.5)
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  unit.name,
                  style: TextStyle(
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    color: isActive ? color : scheme.onSurface,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  Text(
                    Converter.formatResult(converted),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isActive ? color : scheme.onSurface,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    unit.symbol,
                    style: TextStyle(
                      color: color.withOpacity(0.8),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
