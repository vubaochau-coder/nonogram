// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Nonopix';

  @override
  String get commonCancel => 'İptal';

  @override
  String get commonRetry => 'Tekrar dene';

  @override
  String get commonSave => 'Kaydet';

  @override
  String nonogramDashboardContinueLevel(int level) {
    return 'Bölüm $level';
  }

  @override
  String get nonogramDashboardProgressSectionTitle => 'İlerlemen';

  @override
  String get nonogramDashboardStatCompleted => 'Tamamlanan';

  @override
  String get nonogramGuideIntro =>
      'Nonogramlar basit kuralları ve zorlayıcı çözümleri olan mantık bulmacalarıdır. Amaç, ızgaranın kenarındaki sayılara göre kareleri doldurarak gizli resmi ortaya çıkarmaktır.';

  @override
  String get nonogramGuideMethodDivisionDesc =>
      'İki mevcut bloğu birleştirmek, elindeki tüm ipuçlarından daha büyük bir şekil oluşturacaksa aradaki boşluk X olmalıdır.';

  @override
  String get nonogramGuideMethodDivisionTitle => '5. Ayırma';

  @override
  String get nonogramGuideMethodDoublePositioningDesc =>
      'Dolu bir kare bir bloğun yalnızca birkaç belirli yerleşimine ait olabiliyorsa, bu yerleşimlerin hiçbirinde dolmayan tüm kareler X ile işaretlenmelidir.';

  @override
  String get nonogramGuideMethodDoublePositioningTitle =>
      '6. Çift konumlandırma';

  @override
  String get nonogramGuideMethodInaccessibilityDesc =>
      'Kalan hiçbir şekle ait olamayacak kareleri çarpı (X) ile işaretle.';

  @override
  String get nonogramGuideMethodInaccessibilityTitle => '3. Erişilemezlik';

  @override
  String get nonogramGuideMethodNotFitDesc =>
      'Çarpılar arasındaki boş alan o satırdaki tüm ipuçlarından küçükse X ile işaretlenmelidir.';

  @override
  String get nonogramGuideMethodNotFitTitle => '4. Sığmıyor';

  @override
  String get nonogramGuideMethodSuperpositionMultiDesc =>
      'Birden fazla sayı varsa, aynı renkteki bloklar arasındaki zorunlu en az bir karelik boşluğu hesaba katarak tüm grubun en sol ve en sağ konumlarını üst üste koy. Bir bloğun her iki konumda da kendisiyle çakıştığı kareler doldurulur.';

  @override
  String get nonogramGuideMethodSuperpositionMultiTitle =>
      'Üst üste koyma (birden fazla ipucu)';

  @override
  String get nonogramGuideMethodSuperpositionSimpleDesc =>
      'Bir sayı satırın yarısından uzunsa ortadaki bazı kareler kesinlikle doludur. En sol ve en sağ konumları üst üste koy; çakıştıkları kareler doldurulur.';

  @override
  String get nonogramGuideMethodSuperpositionSimpleTitle =>
      'Üst üste koyma (tek ipucu)';

  @override
  String get nonogramGuideMethodWallPushingDesc =>
      'Bilinen dolu bir kare kenara ilk ipucunun uzunluğundan daha yakınsa, ait olduğu şekil o kenardan uzağa doğru uzanmalıdır.';

  @override
  String get nonogramGuideMethodWallPushingTitle => '2. Kenardan itme';

  @override
  String get nonogramGuideRuleDesc =>
      'Her sayı, o satır ya da sütundaki kesintisiz bir dolu kare bloğunu gösterir. Birden fazla sayı varsa bunlar ayrı bloklardır ve her blok bir sonrakinden en az bir boş kareyle ayrılmalıdır. Örneğin `3 1`, 3 dolu karelik bir blok, ardından en az 1 boş kare, ardından 1 dolu karelik bir blok demektir.';

  @override
  String get nonogramGuideRuleTitle => 'Temel kural: sayılar ne anlama gelir';

  @override
  String get nonogramGuideTitle => 'Nasıl çözülür';

  @override
  String nonogramHistoryCompletedOn(String date) {
    return 'Tamamlanma: $date';
  }

  @override
  String get nonogramHistoryDetailNotFound => 'Bölüm ayrıntıları bulunamadı.';

  @override
  String get nonogramHistoryEmpty => 'Henüz tamamlanan bölüm yok.';

  @override
  String nonogramHistoryLevel(int n) {
    return 'Bölüm $n';
  }

  @override
  String get nonogramHistoryTitle => 'Sonuçlar';

  @override
  String get nonogramPlayActionNextLevelFixed => 'Sonraki bölüm';

  @override
  String get nonogramPlayActionShowClues => 'İpuçlarını göster';

  @override
  String nonogramPlayCompletionMessage(int level) {
    return 'Tebrikler! $level. bölümü tamamladın.';
  }

  @override
  String get nonogramPlayCompletionTitle => 'Bulmaca çözüldü!';

  @override
  String nonogramPlayDurationFormat(int minutes, int seconds) {
    return '$minutes dk $seconds sn';
  }

  @override
  String nonogramPlayHintLabel(int count) {
    return 'İpucu ($count)';
  }

  @override
  String get nonogramPlayNoNextLevelToast => 'Henüz sonraki bölüm yok.';

  @override
  String get nonogramPlayPageTitle => 'Nonogram';

  @override
  String get nonogramSettingsTitle => 'Ayarlar';

  @override
  String get nonogramDashboardContinueNext => 'Sıradaki bulmaca';

  @override
  String get nonogramDashboardPlay => 'Oyna';

  @override
  String get nonogramDashboardResumeAction => 'Devam et';

  @override
  String get nonogramDashboardInProgressBadge => 'Devam ediyor';

  @override
  String nonogramDashboardDifficulty(String value) {
    return 'Zorluk $value';
  }

  @override
  String nonogramDashboardSolvedOfTotal(int completed, int total) {
    return '$total bulmacadan $completed tanesi çözüldü';
  }

  @override
  String get nonogramDashboardStatFastest => 'En hızlı';

  @override
  String get nonogramDashboardStatTotalTime => 'Toplam süre';

  @override
  String get nonogramDashboardRecentTitle => 'Son çözülenler';

  @override
  String get nonogramDashboardSeeAll => 'Tümünü gör';

  @override
  String get nonogramDashboardRecentEmpty =>
      'Resim koleksiyonunu başlatmak için ilk bulmacanı çöz.';

  @override
  String get nonogramDashboardAllDoneTitle => 'Tüm bulmacalar çözüldü!';

  @override
  String nonogramDashboardAllDoneDesc(int total) {
    return '$total bulmacanın hepsini tamamladın. Koleksiyonuna istediğin zaman göz atabilirsin.';
  }

  @override
  String nonogramDurationHoursMinutes(int hours, int minutes) {
    return '$hours sa $minutes dk';
  }

  @override
  String nonogramHistoryBestTime(String time) {
    return 'En iyi $time';
  }

  @override
  String get nonogramPlayActionDashboard => 'Ana sayfa';

  @override
  String get appThemeTitle => 'Görünüm';

  @override
  String get appThemeLight => 'Açık';

  @override
  String get appThemeDark => 'Koyu';

  @override
  String get nonogramPlayModeFill => 'Doldurma modu';

  @override
  String get nonogramPlayModeMark => 'X modu';

  @override
  String get nonogramSettingsRestart => 'Bu bölümü yeniden başlat';

  @override
  String get nonogramSettingsRestartConfirmTitle =>
      'Bu bölüm yeniden başlatılsın mı?';

  @override
  String get nonogramSettingsRestartConfirmMessage =>
      'Doldurduğun veya işaretlediğin tüm kareler temizlenecek. Yıldızlı kareler (ipucu ya da sihirli değnekle açılanlar) korunur.';

  @override
  String get commonClose => 'Kapat';

  @override
  String get nonogramSettingsRestartConfirm => 'Yeniden başlat';

  @override
  String get nonogramTutorialTitle => 'Nasıl oynanır';

  @override
  String get nonogramTutorialSkip => 'Atla';

  @override
  String get nonogramTutorialWelcomeTitle => 'Nonopix\'e hoş geldin!';

  @override
  String get nonogramTutorialWelcome =>
      'Temel kuralları küçük bir 5×5 bulmacayla öğrenelim.';

  @override
  String get nonogramTutorialStart => 'Başla';

  @override
  String get nonogramTutorialSwitchToFill =>
      'Bulmacalar kareleri doldurarak çözülür. Doldurma moduna geçmek için aşağıdaki düğmeye dokun.';

  @override
  String get nonogramTutorialClueIsCount =>
      'Sayı, satırda kaç karenin dolu olduğunu söyler. Bu satırda 5 var, yani hepsini doldur!';

  @override
  String get nonogramTutorialEdgeCell =>
      'Son kare zaten dolu. 4\'lük blok onu içermek zorunda, yani yerleştirmenin tek bir yolu var: solundaki 3 kareyi doldur.';

  @override
  String get nonogramTutorialMultipleClues =>
      'Birden fazla sayı, aralarında en az bir boş kare olan birden fazla blok demektir. 2 2 bu 5 kareye yalnızca tek bir şekilde sığar.';

  @override
  String get nonogramTutorialClueOrder =>
      'Sıra da önemlidir: 3 1, önce 3\'lük bloğun, sonra 1\'lik bloğun geldiği anlamına gelir.';

  @override
  String get nonogramTutorialColumns =>
      'Sütunların da sayıları vardır ve yukarıdan aşağıya okunur. Boş kalması gereken kareleri işaretlemek için X moduna geç.';

  @override
  String get nonogramTutorialMarkEmpty =>
      '✓ olan sütunların tüm kareleri zaten tamam. Kalan boş karelerini X ile işaretle.';

  @override
  String get nonogramTutorialOneCellLeft =>
      'Son satırdaki 1 için artık tek bir yer kaldı. Doldurma moduna geri dön.';

  @override
  String get nonogramTutorialFinish =>
      'Bulmacayı bitirmek için son kareyi doldur!';

  @override
  String get nonogramTutorialDoneTitle => 'Harika!';

  @override
  String get nonogramTutorialDone =>
      'Her şey hazır! Büyük bulmacalarda tahtayı taşımak için iki parmakla (ya da ızgaranın dışındaki boş alandan) sürükle; ilk büyük bulmacanda uygulama sana hatırlatacak.';

  @override
  String get nonogramTutorialShowTechniques => 'Çözüm tekniklerini gör';

  @override
  String get nonogramTutorialPlay => 'Oynamaya başla';

  @override
  String get nonogramGuideTutorialCardTitle => 'Oynayarak öğren';

  @override
  String get nonogramGuideTutorialCardDesc =>
      'Kuralları ve kontrolleri küçük bir 5×5 bulmacada adım adım öğren.';

  @override
  String get nonogramPlayInfoHide => 'Bölüm bilgisini gizle';

  @override
  String get nonogramPlayWandLabel => 'Sihirli değnek';

  @override
  String get nonogramPlayWandSelectPrompt =>
      'Açmak istediğin satırın veya sütunun ipuçlarına dokun';

  @override
  String get nonogramPlayWandRowSolved =>
      'Bu satır zaten doğru. Başka bir satır veya sütun seç.';

  @override
  String get nonogramPlayWandColSolved =>
      'Bu sütun zaten doğru. Başka bir satır veya sütun seç.';

  @override
  String get nonogramSettingsControlsGuide => 'Kontrol rehberi';

  @override
  String get nonogramCoachSkip => 'Atla';

  @override
  String get nonogramCoachNext => 'İleri';

  @override
  String get nonogramCoachDone => 'Anladım';

  @override
  String nonogramCoachStep(int current, int total) {
    return '$current/$total';
  }

  @override
  String get nonogramCoachHintTitle => 'İpucu';

  @override
  String get nonogramCoachHintBody =>
      'Tahtanın tamamından rastgele seçilen 5 doğru kareyi (dolu olması gerekip henüz doldurulmamış kareler) senin için doldurur. Bunlar yıldız alır: değiştirilemez ve yeniden başlatsan bile korunur. Her bulmacada 3 hakkın var.';

  @override
  String get nonogramCoachWandTitle => 'Sihirli değnek';

  @override
  String get nonogramCoachWandBody =>
      'Değneğe, ardından herhangi bir satır ya da sütunun ipuçlarına dokun: o çizginin tamamının cevabı açılır ve yıldızla işaretlenir, yeniden başlatsan bile korunur. Her bulmacada 1 hakkın var.';

  @override
  String get nonogramCoachModeTitle => 'Doldur veya X';

  @override
  String get nonogramCoachModeBody =>
      'Dokunmanın ne yapacağını seç: kareyi doldurmak ya da boş olduğunu hatırlamak için X ile işaretlemek. Değiştirmek için düğmeye dokun. Birçok kareyi tek seferde doldurmak veya işaretlemek için ızgara üzerinde sürükle.';

  @override
  String get nonogramCoachLongPressTitle => 'Tersi için basılı tut';

  @override
  String get nonogramCoachLongPressBody =>
      'Geçerli modun tersini yapmak için bir kareye basılı tut: doldururken X, işaretlerken doldurma. Kısa bir titreşim işlemin bittiğini ve bırakabileceğini gösterir.';

  @override
  String get nonogramCoachScrollTitle => 'Büyük bulmacalarda gezinme';

  @override
  String get nonogramCoachScrollBody =>
      'Büyük bulmacalar ekrana sığmaz: tahtayı taşımak için iki parmakla ya da ızgaranın dışındaki boş alandan sürükle. Gizli sayıları görmek için ipuçlarının üzerinde sürükle (köşedeki \"+N\" kaç tane olduğunu gösterir).';

  @override
  String get nonogramTutorialRulesDoneTitle => 'Kuralları öğrendin!';

  @override
  String get nonogramTutorialRulesDone =>
      'Şimdi kontrolleri ve yardımcıları başka bir bulmacada deneyelim: hızlı doldurmak için sürükleme, işaretlemek için basılı tutma, ipuçları ve sihirli değnek.';

  @override
  String get nonogramTutorialContinue => 'Devam et';

  @override
  String get nonogramTutorialLater => 'Sonra, sadece oyna';

  @override
  String get nonogramTutorialDragRow =>
      'İpucu: kareleri tek hamlede doldurmak için parmağını üzerlerinde kaydır. Üst satırda 5 var, yani tüm satır boyunca sürükle!';

  @override
  String get nonogramTutorialLongPressMark =>
      '1 1 1 bu 5 kareye tam olarak sığar, yani 2. ve 4. kareler boş olmalı. Mod değiştirmene gerek yok: X ile işaretlemek için her birine basılı tut. Kısa bir titreşim işlemin bittiğini gösterir.';

  @override
  String get nonogramTutorialUseHint =>
      'Takıldın mı? İpucu düğmesine dokun, uygulama rastgele 5 doğru kareyi doldursun. Her bulmacada 3 hakkın var.';

  @override
  String get nonogramTutorialActivateWand =>
      'İpucu yıldızlı 5 kare doldurdu: bunlar kilitlidir ve yeniden başlatsan bile korunur. Seçtiğin bir satırı veya sütunu tamamen açmak için sihirli değneği kullan: değnek düğmesine dokun.';

  @override
  String get nonogramTutorialPickWandLine =>
      'Şimdi en alt satırın ipuçlarına dokunarak o satırı aç. Her bulmacada 1 değnek hakkın var.';

  @override
  String get nonogramTutorialFinishTools =>
      'Bitirmek için kalan kareleri doldur. Daha hızlı doldurmak için bir sütun boyunca aşağı sürükle.';

  @override
  String get nonogramPlayHintNothingToFill =>
      'Dolu olması gereken tüm kareler zaten dolu. Fazladan doldurulmuş kare olup olmadığını kontrol et.';

  @override
  String get settingsLicenses => 'Lisanslar';

  @override
  String get settingsSwitchPlayMode => 'Oyun modunu değiştir';

  @override
  String get licensesTitle => 'Lisanslar';

  @override
  String get licensesLevelArtHeading => 'Bulmacalar';

  @override
  String get licensesLevelArtIntro =>
      'Bulmacalar bu kaynaklardan gelir. Simge setleri küçültüldü, siyah beyaza dönüştürüldü ve her bulmaca çözülebilsin diye düzenlendi; nonogram koleksiyonları olduğu gibi kullanılır.';

  @override
  String get licensesFontHeading => 'Yazı tipi';

  @override
  String get licensesSoftwareButton => 'Açık kaynak yazılım lisansları';

  @override
  String get licensesDeveloperLevelsNote =>
      'Geliştirici modu bulmacaları nonogram.org\'dan alınmıştır ve yalnızca iç testler içindir. Mağaza sürümünde yer almazlar.';

  @override
  String get playModeTitle => 'Bir oyun modu seç';

  @override
  String get playModeSubtitle => 'İlerleme her mod için ayrı kaydedilir.';

  @override
  String get playModeUserTitle => 'Oyuncu modu';

  @override
  String get playModeUserBody =>
      'Mağaza sürümünde bulunan lisanslı bulmacalar.';

  @override
  String get playModeDeveloperTitle => 'Geliştirici modu';

  @override
  String get playModeDeveloperBody =>
      'İç testler için nonogram.org\'daki orijinal bulmacalar. Önceki ilerlemeni korur.';

  @override
  String get playModeLastUsed => 'Son kullanılan';

  @override
  String licensesBy(String author) {
    return 'Hazırlayan: $author';
  }

  @override
  String licensesLevelCount(int count) {
    return '$count bulmaca';
  }

  @override
  String playModeProgress(int solved, int total) {
    return '$solved/$total çözüldü';
  }

  @override
  String get adRewardNotReady =>
      'Reklam henüz hazır değil. İnternet bağlantını kontrol edip tekrar dene.';

  @override
  String get settingsAdPrivacy => 'Reklam gizliliği';

  @override
  String get ratingTitle => 'Nonopix\'i beğendin mi?';

  @override
  String get ratingMessage => 'Oyunu puanlamak için bir yıldıza dokun.';

  @override
  String get ratingLater => 'Sonra';

  @override
  String get ratingSubmit => 'Gönder';

  @override
  String get ratingThanks =>
      'Geri bildirimin için teşekkürler! Oyunu geliştirmeye devam edeceğiz.';

  @override
  String ratingStarLabel(int count) {
    return '$count yıldız';
  }

  @override
  String get settingsLanguage => 'Dil';

  @override
  String get settingsLanguageSystem => 'Cihaz dili';

  @override
  String get premiumTitle => 'Reklamsız oyna';

  @override
  String get premiumBenefitNoAds => 'Seviyeler arasında artık reklam yok';

  @override
  String get premiumBenefitDaily => 'Her gün 2 ipucu ve 1 sihirli değnek';

  @override
  String premiumBuy(String price) {
    return 'Satın al · $price';
  }

  @override
  String get premiumOneTime => 'Google Play üzerinden tek seferlik ödeme';

  @override
  String get premiumActiveTitle => 'Reklamsız paket etkin';

  @override
  String get premiumActiveDaily =>
      'Her gün envanterin 2 ipucu ve 1 sihirli değneğe tamamlanır.';

  @override
  String get premiumPurchased =>
      'Teşekkürler! Seviyeler arasındaki reklamlar kapatıldı.';

  @override
  String get premiumPending =>
      'Ödemen beklemede. Tamamlanınca paket etkinleşecek.';

  @override
  String get premiumFailed => 'Satın alma gerçekleşmedi. Lütfen tekrar dene.';

  @override
  String premiumDailyReward(int hints, int wands) {
    return 'Günlük hediye: artık $hints ipucun ve $wands sihirli değneğin var.';
  }
}
