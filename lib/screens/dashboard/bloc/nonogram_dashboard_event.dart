sealed class NonogramDashboardEvent {
  const NonogramDashboardEvent();
}

class DashboardInitialized extends NonogramDashboardEvent {
  final bool showLoading;
  const DashboardInitialized({this.showLoading = true});
}

class RefreshRequested extends NonogramDashboardEvent {
  const RefreshRequested();
}
