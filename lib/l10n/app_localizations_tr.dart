// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Pixel Nonogram';

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
      'İki dolu parçayı birleştirmek en büyük sayıdan uzun bir blok oluşturacaksa, aradaki kare boş olmalıdır. Onları ayırmak için X koy.';

  @override
  String get nonogramGuideMethodDivisionTitle => '5. Ayırma';

  @override
  String get nonogramGuideMethodDoublePositioningDesc =>
      'Bazen dolu bir kare sayılardan yalnızca birine ya da ikisine ait olabilir. Her olasılığı dene: hepsinde boş kalan karelere X koy.';

  @override
  String get nonogramGuideMethodDoublePositioningTitle =>
      '6. Çift konumlandırma';

  @override
  String get nonogramGuideMethodInaccessibilityDesc =>
      'Hiçbir bloğun ulaşamadığı kareler boştur. Her bloğu dolu karelerin çevresindeki en uç konumlarında dene; bu aralığın dışında kalan her kareye X koy.';

  @override
  String get nonogramGuideMethodInaccessibilityTitle => '3. Erişilemezlik';

  @override
  String get nonogramGuideMethodNotFitDesc =>
      'X\'ler arasındaki (veya X ile kenar arasındaki) boşluk, oraya girebilecek her sayıdan kısaysa hiçbir blok sığmaz: X ile işaretle.';

  @override
  String get nonogramGuideMethodNotFitTitle => '4. Sığmıyor';

  @override
  String get nonogramGuideMethodSuperpositionMultiDesc =>
      'Birden çok sayı varsa tüm grubu sola (bloklar arasında birer boş kare bırakarak), sonra sağa it. Aynı blok bir kareyi iki konumda da kaplıyorsa o kare doludur. Hızlı yol: sayıları ve boşlukları topla; artan kısım her bloğun ne kadar kayabileceğidir.';

  @override
  String get nonogramGuideMethodSuperpositionMultiTitle =>
      'Üst üste koyma (birden fazla ipucu)';

  @override
  String get nonogramGuideMethodSuperpositionSimpleDesc =>
      'Bir sayı çizgisinin yarısından büyükse bir kısmı her zaman doludur. Bloğu önce tamamen sola, sonra tamamen sağa ittiğini düşün: iki seferde de kapladığı kareler kesin doludur. Örnek: 10 karede 7, ortadaki 4 kareyi her zaman doldurur.';

  @override
  String get nonogramGuideMethodSuperpositionSimpleTitle =>
      'Üst üste koyma (tek ipucu)';

  @override
  String get nonogramGuideMethodWallPushingDesc =>
      'Kenara yakın dolu bir kare, bloğunun nerede olabileceğini sınırlar. Blok kenarı aşamaz, bu yüzden kenardan uzağa doğru uzanmalıdır. Örnek: 4. karesi dolu bir 5: sol kenara dayansa bile blok 5. kareyi kaplar.';

  @override
  String get nonogramGuideMethodWallPushingTitle => '2. Kenardan itme';

  @override
  String get nonogramGuideRuleDesc =>
      'Her sayı, o satır ya da sütundaki kesintisiz bir dolu kare bloğunu gösterir. Birden fazla sayı varsa bunlar ayrı bloklardır ve her blok bir sonrakinden en az bir boş kareyle ayrılmalıdır. Örneğin 3 1, 3 dolu karelik bir blok, ardından en az 1 boş kare, ardından 1 dolu karelik bir blok demektir.';

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
  String get nonogramTutorialWelcomeTitle => 'Pixel Nonogram\'a hoş geldin!';

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
      'Kuralları, kontrolleri ve temel çözüm tekniklerini oynayarak adım adım öğren.';

  @override
  String get nonogramGuideRoutineTitle => 'Nereden başlamalı';

  @override
  String get nonogramGuideRoutineTip1 =>
      'Büyük sayılarla başla. Bir sayı çizgisinin yarısından büyükse bir kısmı zaten kesindir (aşağıdaki 1. tekniğe bak).';

  @override
  String get nonogramGuideRoutineTip2 =>
      'Önce kolay satırları çöz: 0 satırın tamamen boş olduğu anlamına gelir; sayıların toplamı ve aralarındaki birer boşluk satırın uzunluğuna eşitse tek bir yerleşim vardır.';

  @override
  String get nonogramGuideRoutineTip3 =>
      'Boş olduğunu bildiğin kareleri X ile işaretle. Bir X, dolu bir kare kadar işe yarar.';

  @override
  String get nonogramGuideRoutineTip4 =>
      'Satırlarla sütunlar arasında gidip gel. Çözdüğün her kare, onu kesen çizgi için yeni bir ipucudur.';

  @override
  String get nonogramGuideRoutineTip5 =>
      'Asla tahmin etme. Takılırsan en az bilinmeyen karesi olan çizgiyi ara ya da ipucu kullan.';

  @override
  String get nonogramGuideMethodLineDoneTitle => 'Tamamlanan çizgiler';

  @override
  String get nonogramGuideMethodLineDoneDesc =>
      'Bir çizginin tüm blokları yerleştiğinde diğer bütün kareleri boştur: onları X ile işaretle. 0 sayılı bir çizgi baştan boştur.';

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
  String get nonogramTutorialToolsDoneTitle => 'Kontroller tamam!';

  @override
  String get nonogramTutorialToolsDone =>
      'Gerçek bulmacalar daha büyüktür ve çoğu satır bir bakışta çözülmez. Şimdi çözüm tekniklerini 8×8 bir bulmacada öğren.';

  @override
  String get nonogramTutorialOverlapSingle =>
      'Önce büyük sayılara bak. 6 bu 8 kareye 3 şekilde sığar ve her biri sırayla yanıp söner. Her şekilde yanan kareler kesin doludur: sarı çerçevedeki 4 kareyi doldur.';

  @override
  String get nonogramTutorialOverlapMulti =>
      'Birden çok sayıda da aynı: 3 3 en az 7 kare ister (3 + boşluk + 3), yani yalnızca 3 şekilde sığar. Üçünde de yanan kareleri doldur.';

  @override
  String get nonogramTutorialFullRow =>
      '8 karede 8: satırın tamamı dolu. Parmağını boydan boya sürükle.';

  @override
  String get nonogramTutorialZeroRow =>
      '0, satırda hiç dolu kare olmadığı anlamına gelir. X moduna geç.';

  @override
  String get nonogramTutorialMarkZeroRow =>
      'En alt satırın tamamını X ile işaretle. X\'ler önemlidir: sütunlara blokların nereye gelemeyeceğini gösterir.';

  @override
  String get nonogramTutorialOutOfReach =>
      'Şimdi sütunlar. 2. sütun, 2 dolu karesini kaplaması gereken tek bir 3\'lük blok; yalnızca 2 şekilde sığar. Hiç yanmayan karelere ulaşılamaz: onları X ile işaretle, 7. sütunda da aynısını yap.';

  @override
  String get nonogramTutorialBackToFill =>
      '3. sütuna bak: 7 kare istiyor. Doldurma moduna geri dön.';

  @override
  String get nonogramTutorialExactSpace =>
      'Alttaki X, 7 için tam 7 kare bırakıyor; hepsini doldur. 6. sütun da aynı şekilde.';

  @override
  String get nonogramTutorialFinishTechniques =>
      'Yöntem bu: satırlarda çözebildiğini çöz, sonra sütunlarda, ve tekrarla. Mantarı kendin tamamla!';

  @override
  String get nonogramPlayHintNothingToFill =>
      'Dolu olması gereken tüm kareler zaten dolu. Fazladan doldurulmuş kare olup olmadığını kontrol et.';

  @override
  String get settingsSound => 'Ses';

  @override
  String get settingsLicenses => 'Lisanslar';

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
  String licensesBy(String author) {
    return 'Hazırlayan: $author';
  }

  @override
  String licensesLevelCount(int count) {
    return '$count bulmaca';
  }

  @override
  String get adRewardNotReady =>
      'Reklam henüz hazır değil. İnternet bağlantını kontrol edip tekrar dene.';

  @override
  String get settingsAdPrivacy => 'Reklam gizliliği';

  @override
  String get ratingTitle => 'Pixel Nonogram\'ı beğendin mi?';

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
  String get premiumBenefitDaily =>
      'Giriş yaptığın her gün 2 ipucu ve 1 sihirli değnek';

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
      'O gün için 2 ipucu ve 1 sihirli değnek almak üzere her gün giriş yap.';

  @override
  String get premiumPurchased =>
      'Teşekkürler! Seviyeler arasındaki reklamlar kapatıldı.';

  @override
  String get premiumPending =>
      'Ödemen beklemede. Tamamlanınca paket etkinleşecek.';

  @override
  String get premiumFailed => 'Satın alma gerçekleşmedi. Lütfen tekrar dene.';

  @override
  String get checkInTitle => 'Günlük giriş';

  @override
  String get checkInAction => 'Giriş yap';

  @override
  String get checkInDoneToday => 'Bugün giriş yapıldı';

  @override
  String checkInNextGift(int count) {
    return 'Sonraki hediyeye $count giriş kaldı';
  }

  @override
  String get checkInCheckedIn => 'Giriş yapıldı!';

  @override
  String checkInReceived(String rewards) {
    return '$rewards kazandın.';
  }

  @override
  String rewardHints(int count) {
    return '$count ipucu';
  }

  @override
  String rewardWands(int count) {
    return '$count sihirli değnek';
  }

  @override
  String rewardTodayOnly(String reward) {
    return '$reward (yalnızca bugün)';
  }

  @override
  String get checkInMonthGifts => 'Bu ayın hediyeleri';

  @override
  String get navHome => 'Ana sayfa';

  @override
  String get navMe => 'Ben';

  @override
  String get meHelp => 'Yardım';

  @override
  String get meMore => 'Diğer';

  @override
  String get checkInNotYetToday => 'Bugün henüz giriş yapılmadı';

  @override
  String get checkInTodayButton => 'Bugün giriş yap';

  @override
  String checkInGiftsLeftShort(int count) {
    return 'Hediyeye $count giriş kaldı';
  }

  @override
  String get checkInGiftToday => 'Bugün hediye var!';

  @override
  String checkInGiftMilestone(int count) {
    return '$count giriş hediyesi';
  }

  @override
  String get checkInGiftCollect => 'Al';

  @override
  String get checkInTotalHints => 'İpuçları';

  @override
  String get checkInTotalWands => 'Sihirli değnekler';

  @override
  String get checkInTotalDailyHints => 'İpuçları (yalnızca bugün)';

  @override
  String get checkInTotalDailyWands => 'Sihirli değnekler (yalnızca bugün)';

  @override
  String get checkInPremiumNotYet =>
      'Bugün için 2 ipucu ve 1 sihirli değnek almak için giriş yap.';

  @override
  String dashboardDailyReminder(String rewards, String time) {
    return '$time içinde sona erecek $rewards hakkın var. Boşa gitmemesi için hemen kullan.';
  }

  @override
  String get premiumViewBenefits => 'Avantajları gör';

  @override
  String get premiumBenefitsTitle => 'Paket avantajları';

  @override
  String get premiumBenefitsTagline =>
      'Bir kez satın al; seviyeler arası reklamları kaldır ve her gün yardım ödülleri kazan, hesabında kalıcı olarak.';

  @override
  String get premiumBenefitsOneTime => 'tek seferlik';

  @override
  String get premiumWhatYouGet => 'Neler kazanırsın';

  @override
  String get premiumPerkNoAdsTitle => 'Seviyeler arasında reklam yok';

  @override
  String get premiumPerkNoAdsBody =>
      'Bulmacalar arasında artık tam ekran reklam yok. Bir seviyeden diğerine aralıksız geç.';

  @override
  String get premiumPerkDailyTitle => 'Günlük giriş ödülleri';

  @override
  String get premiumPerkDailyBody =>
      'Her giriş, her zamanki kilometre taşı ödüllerine ek olarak o gün için sana 2 ipucu ve 1 sihirli değnek daha verir.';

  @override
  String get premiumItemsTitle => 'Yardımcılar ne işe yarar';

  @override
  String get powerUpHintName => 'İpucu';

  @override
  String get powerUpHintTagline => 'Seçtiğin bir doğru hücreyi gösterir';

  @override
  String get powerUpHintDesc =>
      'Ampule dokun, sonra emin olmadığın yeri seç. Uygulama doğru bir hücreyi (dolu ya da boş işaretli) doldurarak takıldığın yeri açar.';

  @override
  String get powerUpWandName => 'Sihirli değnek';

  @override
  String get powerUpWandTagline => 'Bir satırın ya da sütunun tamamını çözer';

  @override
  String get powerUpWandDesc =>
      'Seçim modunu açmak için değneğe dokun, sonra bir satırın ya da sütunun ipucu sayılarına dokun. Uygulama o satırın ya da sütunun tamamını gösterir. Tek hücrelik ipucundan daha güçlü.';

  @override
  String get powerUpStatesTitle => 'Simge kullanım türünü gösterir';

  @override
  String get powerUpStatesLead =>
      'Köşedeki sayı kalan toplam kullanım hakkındır. Süreli bir hak, simgeyi küçük bir saatle birlikte altın rengine çevirir:';

  @override
  String get powerUpTimeLimited => 'Süreli';

  @override
  String get powerUpTimeLimitedDesc =>
      'Saatli altın simge. Paketin günlük giriş ödülünden gelir. Günün sonunda sona erer.';

  @override
  String get powerUpPermanent => 'Kalıcı';

  @override
  String get powerUpPermanentDesc =>
      'Mavi rozetli normal simge. Kilometre taşı ve başlangıç hakları. Asla sona ermez.';

  @override
  String get powerUpSpendOrderTitle => 'Hangi haklar önce harcanır?';

  @override
  String get powerUpSpendOrderHeading => 'Önce süreli haklar harcanır';

  @override
  String get powerUpSpendOrderBody =>
      'Günlük haklar günün sonunda sona erer; bu yüzden bir ipucu ya da değnek önce günlük haklarını harcar ve ancak günlükler bitince kalıcı haklarını kullanır. Hiçbir şey boşa gitmez.';

  @override
  String get powerUpSpendDaily => 'Günlük haklar';

  @override
  String get powerUpSpendPermanent => 'Kalıcı haklar';

  @override
  String get premiumBenefitsFootnote =>
      'Günlük haklar ertesi güne devredilmez. Kilometre taşı ödülleri kalıcı haklardır ve her zamanki gibi birikir.';

  @override
  String dashboardDailyReminderBoth(String hints, String wands) {
    return '$hints ve $wands';
  }

  @override
  String checkInLegendMilestone(int count) {
    return 'Her $count girişte hediye';
  }

  @override
  String get checkInLegendPremium => 'Reklamsız paket ödülü';
}
