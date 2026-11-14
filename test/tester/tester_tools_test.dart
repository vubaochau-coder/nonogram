import 'package:flutter_test/flutter_test.dart';
import 'package:nonogram/checkin/check_in_service.dart';
import 'package:nonogram/checkin/game_clock.dart';
import 'package:nonogram/premium/premium_controller.dart';
import 'package:nonogram/premium/purchase_gateway.dart';
import 'package:nonogram/screens/play/bloc/nonogram_play_bloc.dart';
import 'package:nonogram/screens/play/bloc/nonogram_play_event.dart';
import 'package:nonogram/tester/tester_purchase_gateway.dart';
import 'package:nonogram/tester/tester_settings.dart';

import '../mocks/fake_nonogram_repository.dart';
import '../mocks/fake_purchase_gateway.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TesterSettings tester;

  setUp(() => tester = TesterSettings.inMemory());

  group('time travel', () {
    late GameClock clock;
    late CheckInService checkIn;
    late FakeNonogramRepository repository;

    setUp(() {
      clock = GameClock.inMemory(
        trusted: FakeTrustedClock(null),
        device: () => DateTime(2026, 11, 13, 9),
        debugShift: tester.dayShift,
      );
      repository = FakeNonogramRepository(today: () => clock.today);
      checkIn = CheckInService.inMemory(clock: clock)..attach(repository);
    });

    test('shifting days moves the game clock and notifies', () async {
      final today = clock.today;
      var notified = 0;
      clock.addListener(() => notified++);
      await tester.shiftDays(3);
      expect(clock.today, today + 3);
      expect(notified, 1);
      await tester.setDayShift(0);
      expect(clock.today, today);
    });

    test('check in on consecutive days without waiting', () async {
      expect(await checkIn.checkIn(), isNotNull);
      expect(checkIn.canCheckIn, isFalse);
      await tester.shiftDays(1);
      expect(checkIn.canCheckIn, isTrue);
      expect(await checkIn.checkIn(), isNotNull);
      expect(checkIn.count, 2);
    });

    test('going back lifts the anti-cheat ratchet', () async {
      await tester.shiftDays(2);
      await checkIn.checkIn();
      await tester.shiftDays(-2);
      // Như người chơi thật lùi giờ: bị chặn.
      expect(checkIn.canCheckIn, isFalse);
      await checkIn.debugRewindToToday();
      expect(checkIn.count, 0, reason: 'future check-in dropped');
      expect(checkIn.canCheckIn, isTrue);
    });

    test('reset clears the history', () async {
      await checkIn.checkIn();
      await checkIn.debugReset();
      expect(checkIn.count, 0);
      expect(checkIn.canCheckIn, isTrue);
      expect(checkIn.startDay, clock.today);
    });
  });

  group('fake store', () {
    late FakePurchaseGateway real;
    late TesterPurchaseGateway gateway;
    late PremiumController premium;

    setUp(() async {
      real = FakePurchaseGateway(available: false);
      gateway = TesterPurchaseGateway(settings: tester, real: real);
      premium = PremiumController.inMemory(gateway: gateway);
      addTearDown(premium.dispose);
      await premium.initialize();
    });

    test('is the default and sells the pack', () async {
      expect(tester.store, TesterStore.fake);
      expect(premium.canPurchase, isTrue);
      expect(premium.price, TesterPurchaseGateway.fakePrice);
      expect(await premium.buy(), PurchaseOutcome.purchased);
      expect(premium.isPremium, isTrue);
      expect(tester.fakeOwned, isTrue);
    });

    test('returns the chosen outcome', () async {
      await tester.setFakeBuyOutcome(PurchaseOutcome.cancelled);
      expect(await premium.buy(), PurchaseOutcome.cancelled);
      expect(premium.isPremium, isFalse);
    });

    test('a pending purchase goes through later', () async {
      await tester.setFakeBuyOutcome(PurchaseOutcome.pending);
      expect(await premium.buy(), PurchaseOutcome.pending);
      expect(premium.isPremium, isFalse);
      expect(await gateway.completePending(), isTrue);
      await Future<void>.delayed(Duration.zero);
      expect(premium.isPremium, isTrue);
    });

    test('refund revokes the pack', () async {
      await premium.buy();
      await tester.setFakeOwned(false);
      await premium.refresh();
      expect(premium.isPremium, isFalse);
    });

    test('switching to the real store asks Google Play again', () async {
      await premium.buy();
      await tester.setStore(TesterStore.real);
      await premium.refresh();
      expect(premium.canPurchase, isFalse);
      // Không hỏi được Play: giữ trạng thái đã lưu.
      expect(premium.isPremium, isTrue);

      real
        ..available = true
        ..owned = {};
      await premium.refresh();
      expect(premium.isPremium, isFalse);
    });
  });

  test('solve now completes the level', () async {
    final repository = FakeNonogramRepository();
    final bloc = NonogramPlayBloc(repository: repository);
    addTearDown(bloc.close);
    bloc.add(const LevelLoadRequested());
    await bloc.stream.firstWhere((s) => s.puzzle != null && !s.isLoading);

    bloc.add(const DebugSolveRequested());
    await bloc.stream.firstWhere((s) => s.isSolved);
    final completed = await repository.getCompletedProgress();
    expect(completed.map((e) => e.level), contains(bloc.state.puzzle!.level));
  });
}
