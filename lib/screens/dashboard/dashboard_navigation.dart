import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nonogram/core/app_route_intent.dart';

import 'bloc/nonogram_dashboard_bloc.dart';
import 'bloc/nonogram_dashboard_event.dart';

/// Mở một màn hình từ dashboard và tải lại dữ liệu khi quay về.
Future<void> openFromDashboard(
  BuildContext context,
  AppRouteIntent<void> intent,
) async {
  final bloc = context.read<NonogramDashboardBloc>();
  await context.navigate(intent);
  if (!bloc.isClosed) bloc.add(const RefreshRequested());
}
