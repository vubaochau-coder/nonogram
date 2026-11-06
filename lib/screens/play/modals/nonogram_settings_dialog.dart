import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/widgets/app_text_field.dart';
import 'package:nonogram/widgets/app_theme_mode_selector.dart';
import 'package:nonogram/widgets/dialogs/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/nonogram_play_bloc.dart';
import '../bloc/nonogram_play_event.dart';
import '../nonogram_transformation_controller_provider.dart';

Future<void> showNonogramSettingsDialog(BuildContext context) {
  final bloc = context.read<NonogramPlayBloc>();
  final controller = NonogramTransformationControllerProvider.of(context);

  return showDialog(
    context: context,
    builder: (dialogContext) {
      return NonogramTransformationControllerProvider(
        controller: controller,
        child: BlocProvider.value(
          value: bloc,
          child: const NonogramSettingsDialog(),
        ),
      );
    },
  );
}

class NonogramSettingsDialog extends StatefulWidget {
  const NonogramSettingsDialog({super.key});

  @override
  State<NonogramSettingsDialog> createState() => _NonogramSettingsDialogState();
}

class _NonogramSettingsDialogState extends State<NonogramSettingsDialog> {
  static const double _customSizeMarker = -1;

  final _formKey = GlobalKey<FormState>();
  late double _selectedSize;
  late TextEditingController _customSizeController;

  final List<double> _presets = [20.0, 30.0, 40.0];

  @override
  void initState() {
    super.initState();
    final state = context.read<NonogramPlayBloc>().state;
    _selectedSize = state.cellSize;

    if (!_presets.contains(_selectedSize)) {
      _customSizeController = TextEditingController(
        text: _selectedSize.toStringAsFixed(0),
      );
    } else {
      _customSizeController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _customSizeController.dispose();
    super.dispose();
  }

  void _onSave() {
    double? finalSize;
    if (_presets.contains(_selectedSize)) {
      finalSize = _selectedSize;
    } else {
      if (!(_formKey.currentState?.validate() ?? false)) {
        return;
      }
      finalSize = double.parse(_customSizeController.text.trim());
    }

    final controller = NonogramTransformationControllerProvider.of(context);
    final translation = controller.value.getTranslation();

    context.read<NonogramPlayBloc>().add(
      CellSizeChanged(
        cellSize: finalSize,
        offsetX: translation.x,
        offsetY: translation.y,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isCustom = !_presets.contains(_selectedSize);

    return AppDialog(
      title: Text(l10n.nonogramSettingsTitle),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.nonogramSettingsCellSize,
              style: context.titleSmall.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            RadioGroup<double>(
              groupValue: isCustom ? _customSizeMarker : _selectedSize,
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _selectedSize = value;
                  if (value == _customSizeMarker &&
                      _customSizeController.text.isEmpty) {
                    _customSizeController.text = '40';
                  }
                });
              },
              child: Column(
                children: [
                  ..._presets.map((size) {
                    return SizedBox(
                      height: 44,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          setState(() {
                            _selectedSize = size;
                          });
                        },
                        child: Row(
                          children: [
                            Radio<double>(value: size),
                            Text(
                              size == 40
                                  ? '${size.toInt()}px ${l10n.nonogramSettingsCellSizeDefault}'
                                  : '${size.toInt()}px',
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  SizedBox(
                    height: 44,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        setState(() {
                          _selectedSize = _customSizeMarker;
                          if (_customSizeController.text.isEmpty) {
                            _customSizeController.text = '40';
                          }
                        });
                      },
                      child: Row(
                        children: [
                          const Radio<double>(value: _customSizeMarker),
                          Text(l10n.nonogramSettingsCellSizeCustom),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isCustom) ...[
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: AppTextField(
                  controller: _customSizeController,
                  labelText: '12 - 80 px',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    final input = value?.trim() ?? '';
                    final parsed = double.tryParse(input);
                    if (parsed == null || parsed < 12 || parsed > 80) {
                      return l10n.nonogramSettingsCellSizeError;
                    }
                    return null;
                  },
                ),
              ),
            ],
            const SizedBox(height: 20),
            Text(
              l10n.appThemeTitle,
              style: context.titleSmall.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const AppThemeModeSelector(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.commonCancel),
        ),
        TextButton(
          onPressed: _onSave,
          style: TextButton.styleFrom(
            foregroundColor: context.color.primary,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
          child: Text(l10n.commonSave),
        ),
      ],
    );
  }
}
