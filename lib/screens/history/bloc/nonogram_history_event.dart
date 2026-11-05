abstract class NonogramHistoryEvent {
  const NonogramHistoryEvent();
}

class HistoryInitialized extends NonogramHistoryEvent {
  const HistoryInitialized();
}

class LoadMoreRequested extends NonogramHistoryEvent {
  const LoadMoreRequested();
}
