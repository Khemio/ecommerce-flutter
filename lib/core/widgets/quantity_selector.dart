import 'package:flutter/material.dart';

class QuantitySelector extends StatefulWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final bool compact;

  const QuantitySelector({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 99,
    this.compact = false,
  });

  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '${widget.value}');
  }

  @override
  void didUpdateWidget(covariant QuantitySelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync external value changes into the field
    if (oldWidget.value != widget.value &&
        _controller.text != '${widget.value}') {
      _controller.text = '${widget.value}';
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isCompact = widget.compact;

    final double fieldWidth = isCompact ? 36 : 60;
    final double fieldFontSize = isCompact ? 13 : 16;
    final double spacing = isCompact ? 4 : 8;

    return SizedBox(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SelectorButton(
            label: '-',
            compact: widget.compact,
            onTap: widget.value > widget.min
                ? () => widget.onChanged(widget.value - 1)
                : null,
          ),
          SizedBox(width: spacing),

          SizedBox(
            width: fieldWidth,
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: fieldFontSize,
              ),
              maxLength: 3,
              onChanged: (v) => widget.onChanged(int.tryParse(v) ?? widget.min),
              decoration: const InputDecoration(
                border: InputBorder.none,
                counterText: '',
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),

          SizedBox(width: spacing),
          _SelectorButton(
            label: '+',
            compact: widget.compact,
            onTap: widget.value < widget.max
                ? () => widget.onChanged(widget.value + 1)
                : null,
          ),
        ],
      ),
    );
  }
}

class _SelectorButton extends StatelessWidget {
  final String label;
  final bool compact;
  final VoidCallback? onTap;

  const _SelectorButton({
    required this.label,
    required this.compact,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double buttonPaddingH = compact ? 14 : 24;
    final double buttonPaddingV = compact ? 6 : 12;
    final double fontSize = compact ? 14 : 18;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: buttonPaddingH,
          vertical: buttonPaddingV,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
        ),
      ),
    );
  }
}
