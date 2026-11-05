import 'package:nonogram/core/app_spacing.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.initText,
    this.enabled = true,
    this.readOnly = false,
    this.labelText,
    this.hintText,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.validator,
    this.autovalidateMode,
    this.minLines,
    this.maxLines = 1,
    this.maxLength,
    this.showCounter = true,
    this.obscureText = false,
    this.enableObscureTextToggle = false,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? initText;
  final bool enabled;
  final bool readOnly;
  final String? labelText;
  final String? hintText;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode? autovalidateMode;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final bool showCounter;
  final bool obscureText;
  final bool enableObscureTextToggle;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  @override
  State<AppTextField> createState() {
    return _AppTextFieldState();
  }
}

class _AppTextFieldState extends State<AppTextField> {
  TextEditingController? _localController;
  TextEditingController? _boundController;
  late bool _hasText;
  late bool _isObscured;

  TextEditingController get _effectiveController {
    final externalController = widget.controller;
    if (externalController != null) return externalController;
    return _localController!;
  }

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
    if (widget.controller == null) {
      _localController = TextEditingController(text: widget.initText ?? '');
    }
    _bindController();
  }

  @override
  void didUpdateWidget(covariant AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.obscureText != widget.obscureText) {
      _isObscured = widget.obscureText;
    }
    final hasControllerChanged = oldWidget.controller != widget.controller;
    if (hasControllerChanged) {
      _unbindController();
      if (oldWidget.controller == null && widget.controller != null) {
        _localController?.dispose();
        _localController = null;
      }
      if (oldWidget.controller != null && widget.controller == null) {
        _localController = TextEditingController(text: widget.initText ?? '');
      }
      _bindController();
      return;
    }

    final isUsingLocalController = widget.controller == null;
    final hasInitTextChanged = oldWidget.initText != widget.initText;
    if (isUsingLocalController && hasInitTextChanged) {
      final nextText = widget.initText ?? '';
      if (_localController?.text == nextText) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final controller = _localController;
        if (controller == null || controller.text == nextText) return;
        controller.value = controller.value.copyWith(
          text: nextText,
          selection: TextSelection.collapsed(offset: nextText.length),
          composing: TextRange.empty,
        );
      });
    }
  }

  @override
  void dispose() {
    _unbindController();
    _localController?.dispose();
    super.dispose();
  }

  void _bindController() {
    final controller = _effectiveController;
    _boundController = controller;
    _hasText = controller.text.isNotEmpty;
    controller.addListener(_handleControllerChanged);
  }

  void _unbindController() {
    _boundController?.removeListener(_handleControllerChanged);
    _boundController = null;
  }

  void _handleControllerChanged() {
    final nextHasText = _effectiveController.text.isNotEmpty;
    if (_hasText == nextHasText) return;
    setState(() {
      _hasText = nextHasText;
    });
  }

  void _onClearPressed() {
    final controller = _effectiveController;
    if (controller.text.isEmpty) return;
    controller.clear();
    widget.onClear?.call();
  }

  Widget? _buildSuffixIcon() {
    final color = context.color;

    final suffixIcons = <Widget>[
      if (widget.suffixIcon != null) widget.suffixIcon!,
      if (widget.enableObscureTextToggle && widget.obscureText)
        IconButton(
          onPressed: () {
            setState(() {
              _isObscured = !_isObscured;
            });
          },
          style: IconButton.styleFrom(
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.all(6),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          icon: Icon(
            _isObscured ? Icons.visibility_off : Icons.visibility,
            size: 20,
            color: color.primary,
          ),
        ),
    ];
    final shouldShowClearButton = widget.onClear != null && _hasText;
    if (!shouldShowClearButton) {
      if (suffixIcons.isEmpty) return null;
      final suffixContent =
          suffixIcons.length == 1
              ? suffixIcons.first
              : Row(mainAxisSize: MainAxisSize.min, children: suffixIcons);
      return IconTheme(
        data: IconThemeData(color: color.primary),
        child: suffixContent,
      );
    }

    final clearButton = IconButton(
      onPressed: _onClearPressed,
      style: IconButton.styleFrom(
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.all(6),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      icon: Icon(Icons.cancel, size: 18, color: color.primary),
    );
    suffixIcons.add(clearButton);
    final suffixContent =
        suffixIcons.length == 1
            ? suffixIcons.first
            : Row(mainAxisSize: MainAxisSize.min, children: suffixIcons);
    return IconTheme(
      data: IconThemeData(color: color.primary),
      child: suffixContent,
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.color;
    final secondaryHintColor = color.secondary.withValues(alpha: 0.72);

    return TextFormField(
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      controller: _effectiveController,
      focusNode: widget.focusNode,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      obscureText: _isObscured,
      obscuringCharacter: '*',
      enableSuggestions: !_isObscured,
      autocorrect: !_isObscured,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      inputFormatters: widget.inputFormatters,
      buildCounter:
          widget.showCounter
              ? null
              : (_, {required currentLength, required isFocused, maxLength}) {
                return null;
              },
      decoration: InputDecoration(
        labelText: widget.labelText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: widget.hintText,
        hintStyle: TextStyle(color: secondaryHintColor),
        prefixIcon: widget.prefixIcon,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.componentVerticalSpacing,
          vertical: AppSpacing.buttonVerticalPadding,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: color.surfaceContainerHigh.withValues(alpha: 0.9),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: color.surfaceContainerHigh.withValues(alpha: 0.9),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color.primary),
        ),
        suffixIcon: _buildSuffixIcon(),
      ),
    );
  }
}
