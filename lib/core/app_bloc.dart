import 'package:nonogram/core/app_navigator.dart';
import 'package:nonogram/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AppBloc<Event, BlocState> extends Bloc<Event, BlocState> {
  AppBloc(super.initialState);

  BuildContext? get appContext => AppNavigator.context;

  AppLocalizations get l10n {
    final context = appContext;
    final localizations = context == null ? null : AppLocalizations.of(context);
    if (localizations == null) {
      throw StateError(
        'AppBloc.l10n is unavailable because appContext/AppLocalizations is not ready.',
      );
    }
    return localizations;
  }

  AppLocalizations? get tryL10n {
    final context = appContext;
    return context == null ? null : AppLocalizations.of(context);
  }
}
