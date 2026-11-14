// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Nonopix';

  @override
  String get commonCancel => 'Batal';

  @override
  String get commonRetry => 'Coba lagi';

  @override
  String get commonSave => 'Simpan';

  @override
  String nonogramDashboardContinueLevel(int level) {
    return 'Level $level';
  }

  @override
  String get nonogramDashboardProgressSectionTitle => 'Progres Kamu';

  @override
  String get nonogramDashboardStatCompleted => 'Selesai';

  @override
  String get nonogramGuideIntro =>
      'Nonogram adalah teka-teki logika dengan aturan sederhana dan solusi yang menantang. Tujuannya adalah memunculkan gambar tersembunyi dengan mengisi kotak berdasarkan angka di tepi kisi.';

  @override
  String get nonogramGuideMethodDivisionDesc =>
      'Jika menggabungkan dua blok yang sudah ada akan membentuk figur yang lebih besar dari petunjuk mana pun, celah di antaranya harus berupa X.';

  @override
  String get nonogramGuideMethodDivisionTitle => '5. Pemisahan';

  @override
  String get nonogramGuideMethodDoublePositioningDesc =>
      'Jika kotak yang terisi hanya bisa menjadi bagian dari beberapa varian blok tertentu, setiap kotak yang tidak pernah terisi di varian mana pun harus ditandai X.';

  @override
  String get nonogramGuideMethodDoublePositioningTitle => '6. Posisi ganda';

  @override
  String get nonogramGuideMethodInaccessibilityDesc =>
      'Tandai dengan silang (X) kotak yang tidak mungkin menjadi bagian dari figur mana pun yang tersisa.';

  @override
  String get nonogramGuideMethodInaccessibilityTitle => '3. Tak terjangkau';

  @override
  String get nonogramGuideMethodNotFitDesc =>
      'Jika ruang kosong di antara tanda silang lebih kecil dari petunjuk mana pun di baris itu, ruang itu harus ditandai X.';

  @override
  String get nonogramGuideMethodNotFitTitle => '4. Tidak muat';

  @override
  String get nonogramGuideMethodSuperpositionMultiDesc =>
      'Jika ada beberapa angka, tumpuk posisi paling kiri dan paling kanan dari seluruh kelompok, dengan memperhitungkan celah wajib minimal satu kotak di antara blok berwarna sama. Kotak tempat sebuah blok bertumpuk dengan dirinya sendiri di kedua varian harus diisi.';

  @override
  String get nonogramGuideMethodSuperpositionMultiTitle =>
      'Penumpukan (beberapa petunjuk)';

  @override
  String get nonogramGuideMethodSuperpositionSimpleDesc =>
      'Jika sebuah angka lebih dari setengah panjang baris, beberapa kotak di tengah pasti terisi. Tumpuk posisi paling kiri dan paling kanan; di bagian yang bertumpuk, kotaknya diisi.';

  @override
  String get nonogramGuideMethodSuperpositionSimpleTitle =>
      'Penumpukan (satu petunjuk)';

  @override
  String get nonogramGuideMethodWallPushingDesc =>
      'Jika kotak terisi yang sudah diketahui lebih dekat ke tepi daripada panjang petunjuk pertama, figur tempat kotak itu berada harus memanjang menjauhi tepi tersebut.';

  @override
  String get nonogramGuideMethodWallPushingTitle => '2. Mendorong dari dinding';

  @override
  String get nonogramGuideRuleDesc =>
      'Setiap angka mewakili satu blok kotak terisi yang bersambung di baris atau kolom itu. Jika ada beberapa angka, masing-masing mewakili blok terpisah, dan setiap blok harus dipisahkan dari blok berikutnya oleh minimal satu kotak kosong. Contohnya, `3 1` berarti blok 3 kotak terisi, lalu minimal 1 kotak kosong, lalu blok 1 kotak terisi.';

  @override
  String get nonogramGuideRuleTitle => 'Aturan inti: arti angka-angka';

  @override
  String get nonogramGuideTitle => 'Cara Menyelesaikan';

  @override
  String nonogramHistoryCompletedOn(String date) {
    return 'Selesai pada $date';
  }

  @override
  String get nonogramHistoryDetailNotFound => 'Detail level tidak ditemukan.';

  @override
  String get nonogramHistoryEmpty => 'Belum ada level yang selesai.';

  @override
  String nonogramHistoryLevel(int n) {
    return 'Level $n';
  }

  @override
  String get nonogramHistoryTitle => 'Hasil';

  @override
  String get nonogramPlayActionNextLevelFixed => 'Level Berikutnya';

  @override
  String get nonogramPlayActionShowClues => 'Tampilkan petunjuk';

  @override
  String nonogramPlayCompletionMessage(int level) {
    return 'Selamat! Kamu telah menyelesaikan Level $level.';
  }

  @override
  String get nonogramPlayCompletionTitle => 'Teka-teki Selesai!';

  @override
  String nonogramPlayDurationFormat(int minutes, int seconds) {
    return '$minutes mnt $seconds dtk';
  }

  @override
  String nonogramPlayHintLabel(int count) {
    return 'Bantuan ($count)';
  }

  @override
  String get nonogramPlayNoNextLevelToast => 'Belum ada level berikutnya.';

  @override
  String get nonogramPlayPageTitle => 'Nonogram';

  @override
  String get nonogramSettingsTitle => 'Pengaturan';

  @override
  String get nonogramDashboardContinueNext => 'Tantangan berikutnya';

  @override
  String get nonogramDashboardPlay => 'Main';

  @override
  String get nonogramDashboardResumeAction => 'Lanjutkan';

  @override
  String get nonogramDashboardInProgressBadge => 'Sedang dimainkan';

  @override
  String nonogramDashboardDifficulty(String value) {
    return 'Kesulitan $value';
  }

  @override
  String nonogramDashboardSolvedOfTotal(int completed, int total) {
    return '$completed dari $total teka-teki selesai';
  }

  @override
  String get nonogramDashboardStatFastest => 'Tercepat';

  @override
  String get nonogramDashboardStatTotalTime => 'Total waktu';

  @override
  String get nonogramDashboardRecentTitle => 'Baru diselesaikan';

  @override
  String get nonogramDashboardSeeAll => 'Lihat semua';

  @override
  String get nonogramDashboardRecentEmpty =>
      'Selesaikan teka-teki pertamamu untuk memulai koleksi gambarmu.';

  @override
  String get nonogramDashboardAllDoneTitle => 'Semua teka-teki selesai!';

  @override
  String nonogramDashboardAllDoneDesc(int total) {
    return 'Kamu telah menyelesaikan semua $total teka-teki. Lihat lagi koleksimu kapan saja.';
  }

  @override
  String nonogramDurationHoursMinutes(int hours, int minutes) {
    return '$hours j $minutes mnt';
  }

  @override
  String nonogramHistoryBestTime(String time) {
    return 'Terbaik $time';
  }

  @override
  String get nonogramPlayActionDashboard => 'Beranda';

  @override
  String get appThemeTitle => 'Tampilan';

  @override
  String get appThemeLight => 'Terang';

  @override
  String get appThemeDark => 'Gelap';

  @override
  String get nonogramPlayModeFill => 'Mode isi';

  @override
  String get nonogramPlayModeMark => 'Mode tanda X';

  @override
  String get nonogramSettingsRestart => 'Ulangi level ini';

  @override
  String get nonogramSettingsRestartConfirmTitle => 'Ulangi level ini?';

  @override
  String get nonogramSettingsRestartConfirmMessage =>
      'Semua kotak yang sudah kamu isi atau tandai akan dihapus. Kotak berbintang (dibuka dengan bantuan atau tongkat ajaib) tetap disimpan.';

  @override
  String get commonClose => 'Tutup';

  @override
  String get nonogramSettingsRestartConfirm => 'Ulangi';

  @override
  String get nonogramTutorialTitle => 'Cara bermain';

  @override
  String get nonogramTutorialSkip => 'Lewati';

  @override
  String get nonogramTutorialWelcomeTitle => 'Selamat datang di Nonopix!';

  @override
  String get nonogramTutorialWelcome =>
      'Ayo pelajari aturan dasarnya dengan teka-teki kecil 5×5.';

  @override
  String get nonogramTutorialStart => 'Mulai';

  @override
  String get nonogramTutorialSwitchToFill =>
      'Teka-teki diselesaikan dengan mengisi kotak. Ketuk tombol di bawah untuk beralih ke mode isi.';

  @override
  String get nonogramTutorialClueIsCount =>
      'Angka menunjukkan berapa kotak di baris itu yang terisi. Baris ini punya 5, jadi isi semuanya!';

  @override
  String get nonogramTutorialEdgeCell =>
      'Kotak terakhir sudah terisi. Blok 4 harus mencakupnya, jadi hanya ada satu cara menempatkannya: isi 3 kotak di sebelah kirinya.';

  @override
  String get nonogramTutorialMultipleClues =>
      'Lebih dari satu angka berarti lebih dari satu blok, dengan minimal satu kotak kosong di antaranya. 2 2 hanya muat di 5 kotak ini dengan satu cara.';

  @override
  String get nonogramTutorialClueOrder =>
      'Urutan juga penting: 3 1 berarti blok 3 ada lebih dulu, lalu blok 1.';

  @override
  String get nonogramTutorialColumns =>
      'Kolom juga punya angka, dibaca dari atas ke bawah. Beralihlah ke mode X untuk menandai kotak yang harus tetap kosong.';

  @override
  String get nonogramTutorialMarkEmpty =>
      'Kolom bertanda ✓ sudah lengkap. Tandai kotak kosong yang tersisa di kolom itu dengan X.';

  @override
  String get nonogramTutorialOneCellLeft =>
      'Angka 1 di baris terakhir sekarang hanya punya satu tempat tersisa. Kembali ke mode isi.';

  @override
  String get nonogramTutorialFinish =>
      'Isi kotak terakhir untuk menyelesaikan teka-teki!';

  @override
  String get nonogramTutorialDoneTitle => 'Bagus sekali!';

  @override
  String get nonogramTutorialDone =>
      'Kamu siap! Di teka-teki besar, geser dengan dua jari (atau dari ruang kosong di luar kisi) untuk memindahkan papan; aplikasi akan mengingatkanmu di teka-teki besar pertamamu.';

  @override
  String get nonogramTutorialShowTechniques => 'Lihat teknik penyelesaian';

  @override
  String get nonogramTutorialPlay => 'Mulai bermain';

  @override
  String get nonogramGuideTutorialCardTitle => 'Belajar sambil bermain';

  @override
  String get nonogramGuideTutorialCardDesc =>
      'Pelajari aturan dan kontrol langkah demi langkah di teka-teki kecil 5×5.';

  @override
  String get nonogramPlayInfoHide => 'Sembunyikan info level';

  @override
  String get nonogramPlayWandLabel => 'Tongkat ajaib';

  @override
  String get nonogramPlayWandSelectPrompt =>
      'Ketuk petunjuk baris atau kolom yang ingin dibuka';

  @override
  String get nonogramPlayWandRowSolved =>
      'Baris ini sudah benar. Pilih baris atau kolom lain.';

  @override
  String get nonogramPlayWandColSolved =>
      'Kolom ini sudah benar. Pilih baris atau kolom lain.';

  @override
  String get nonogramSettingsControlsGuide => 'Panduan kontrol';

  @override
  String get nonogramCoachSkip => 'Lewati';

  @override
  String get nonogramCoachNext => 'Berikutnya';

  @override
  String get nonogramCoachDone => 'Mengerti';

  @override
  String nonogramCoachStep(int current, int total) {
    return '$current/$total';
  }

  @override
  String get nonogramCoachHintTitle => 'Bantuan';

  @override
  String get nonogramCoachHintBody =>
      'Mengisikan 5 kotak yang benar untukmu (kotak yang seharusnya terisi tapi belum), dipilih acak di seluruh papan. Kotak ini diberi bintang: tidak bisa diubah dan tetap disimpan meskipun kamu mengulang. Kamu punya 3 per teka-teki.';

  @override
  String get nonogramCoachWandTitle => 'Tongkat ajaib';

  @override
  String get nonogramCoachWandBody =>
      'Ketuk tongkat, lalu ketuk petunjuk baris atau kolom mana saja: jawaban untuk seluruh garis itu dibuka dan ditandai bintang, tetap disimpan meskipun kamu mengulang. Kamu punya 1 per teka-teki.';

  @override
  String get nonogramCoachModeTitle => 'Isi atau X';

  @override
  String get nonogramCoachModeBody =>
      'Pilih apa yang dilakukan ketukan: mengisi kotak, atau menandainya dengan X untuk mengingat bahwa kotak itu kosong. Ketuk tombol untuk beralih. Geser di atas kisi untuk mengisi atau menandai banyak kotak sekaligus.';

  @override
  String get nonogramCoachLongPressTitle => 'Tekan lama untuk kebalikannya';

  @override
  String get nonogramCoachLongPressBody =>
      'Tekan lama sebuah kotak untuk melakukan kebalikan dari mode saat ini: X saat mengisi, mengisi saat menandai. Getaran singkat berarti sudah selesai dan kamu bisa melepas jari.';

  @override
  String get nonogramCoachScrollTitle => 'Menjelajah teka-teki besar';

  @override
  String get nonogramCoachScrollBody =>
      'Teka-teki besar tidak muat di layar: geser dengan dua jari, atau geser dari ruang kosong di luar kisi untuk memindahkan papan. Geser di atas petunjuk untuk melihat angka yang tersembunyi (\"+N\" di sudut menunjukkan jumlahnya).';

  @override
  String get nonogramTutorialRulesDoneTitle => 'Kamu sudah tahu aturannya!';

  @override
  String get nonogramTutorialRulesDone =>
      'Sekarang, ayo latih kontrol dan alat bantu di teka-teki lain: geser untuk mengisi cepat, tekan lama untuk menandai, bantuan, dan tongkat ajaib.';

  @override
  String get nonogramTutorialContinue => 'Lanjutkan';

  @override
  String get nonogramTutorialLater => 'Nanti saja, langsung main';

  @override
  String get nonogramTutorialDragRow =>
      'Tips: geser jarimu melintasi kotak untuk mengisinya sekaligus. Baris paling atas punya 5, jadi geser di sepanjang baris!';

  @override
  String get nonogramTutorialLongPressMark =>
      '1 1 1 pas mengisi 5 kotak ini, jadi kotak ke-2 dan ke-4 harus kosong. Tidak perlu ganti mode: tekan lama masing-masing untuk menandainya dengan X. Getaran singkat berarti sudah selesai.';

  @override
  String get nonogramTutorialUseHint =>
      'Buntu? Ketuk tombol Bantuan dan aplikasi akan mengisi 5 kotak yang benar secara acak. Kamu punya 3 per teka-teki.';

  @override
  String get nonogramTutorialActivateWand =>
      'Bantuan telah mengisi 5 kotak bertanda bintang: kotak itu terkunci dan tetap disimpan meskipun kamu mengulang. Untuk membuka seluruh baris atau kolom pilihanmu, gunakan tongkat ajaib: ketuk tombol tongkat.';

  @override
  String get nonogramTutorialPickWandLine =>
      'Sekarang ketuk petunjuk baris paling bawah untuk membuka baris itu. Kamu punya 1 tongkat per teka-teki.';

  @override
  String get nonogramTutorialFinishTools =>
      'Isi kotak yang tersisa untuk menyelesaikan. Geser ke bawah di sepanjang kolom agar lebih cepat.';

  @override
  String get nonogramPlayHintNothingToFill =>
      'Semua kotak yang seharusnya terisi sudah terisi. Periksa apakah ada kotak yang terisi berlebih.';

  @override
  String get settingsSound => 'Suara';

  @override
  String get settingsLicenses => 'Lisensi';

  @override
  String get settingsSwitchPlayMode => 'Ganti mode bermain';

  @override
  String get licensesTitle => 'Lisensi';

  @override
  String get licensesLevelArtHeading => 'Teka-teki';

  @override
  String get licensesLevelArtIntro =>
      'Teka-teki berasal dari sumber-sumber ini. Kumpulan ikon diperkecil, diubah menjadi hitam putih, dan disunting agar setiap teka-teki bisa diselesaikan; koleksi nonogram digunakan apa adanya.';

  @override
  String get licensesFontHeading => 'Font';

  @override
  String get licensesSoftwareButton => 'Lisensi perangkat lunak sumber terbuka';

  @override
  String get licensesDeveloperLevelsNote =>
      'Teka-teki mode pengembang berasal dari nonogram.org dan hanya untuk pengujian internal. Teka-teki ini tidak disertakan di versi toko.';

  @override
  String get playModeTitle => 'Pilih mode bermain';

  @override
  String get playModeSubtitle => 'Progres disimpan terpisah untuk setiap mode.';

  @override
  String get playModeUserTitle => 'Mode pemain';

  @override
  String get playModeUserBody => 'Teka-teki berlisensi yang ada di versi toko.';

  @override
  String get playModeDeveloperTitle => 'Mode pengembang';

  @override
  String get playModeDeveloperBody =>
      'Teka-teki asli dari nonogram.org, untuk pengujian internal. Progres lamamu tetap tersimpan.';

  @override
  String get playModeLastUsed => 'Terakhir dipakai';

  @override
  String licensesBy(String author) {
    return 'Oleh $author';
  }

  @override
  String licensesLevelCount(int count) {
    return '$count teka-teki';
  }

  @override
  String playModeProgress(int solved, int total) {
    return '$solved/$total selesai';
  }

  @override
  String get adRewardNotReady =>
      'Iklan belum siap. Periksa koneksi internetmu lalu coba lagi.';

  @override
  String get settingsAdPrivacy => 'Privasi iklan';

  @override
  String get ratingTitle => 'Suka Nonopix?';

  @override
  String get ratingMessage => 'Ketuk bintang untuk menilai game ini.';

  @override
  String get ratingLater => 'Nanti';

  @override
  String get ratingSubmit => 'Kirim';

  @override
  String get ratingThanks =>
      'Terima kasih atas masukanmu! Kami akan terus membuat game ini lebih baik.';

  @override
  String ratingStarLabel(int count) {
    return '$count bintang';
  }

  @override
  String get settingsLanguage => 'Bahasa';

  @override
  String get settingsLanguageSystem => 'Bahasa perangkat';

  @override
  String get premiumTitle => 'Main tanpa iklan';

  @override
  String get premiumBenefitNoAds => 'Tidak ada lagi iklan di antara level';

  @override
  String get premiumBenefitDaily =>
      '2 petunjuk dan 1 tongkat ajaib setiap hari kamu absen';

  @override
  String premiumBuy(String price) {
    return 'Beli · $price';
  }

  @override
  String get premiumOneTime => 'Pembayaran sekali melalui Google Play';

  @override
  String get premiumActiveTitle => 'Paket bebas iklan aktif';

  @override
  String get premiumActiveDaily =>
      'Absen setiap hari untuk mendapat 2 petunjuk dan 1 tongkat ajaib untuk hari itu.';

  @override
  String get premiumPurchased =>
      'Terima kasih! Iklan di antara level sudah dimatikan.';

  @override
  String get premiumPending =>
      'Pembayaranmu masih tertunda. Paket akan aktif begitu pembayaran selesai.';

  @override
  String get premiumFailed => 'Pembelian gagal. Silakan coba lagi.';

  @override
  String get checkInTitle => 'Absen harian';

  @override
  String get checkInAction => 'Absen';

  @override
  String get checkInDoneToday => 'Sudah absen hari ini';

  @override
  String checkInNextGift(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hadiah berikutnya dalam $count kali absen',
      one: 'Hadiah berikutnya di absen berikutnya',
    );
    return '$_temp0';
  }

  @override
  String get checkInCheckedIn => 'Berhasil absen!';

  @override
  String checkInReceived(String rewards) {
    return 'Kamu mendapat $rewards.';
  }

  @override
  String rewardHints(int count) {
    return '$count petunjuk';
  }

  @override
  String rewardWands(int count) {
    return '$count tongkat ajaib';
  }

  @override
  String rewardTodayOnly(String reward) {
    return '$reward (hanya hari ini)';
  }

  @override
  String get checkInMonthGifts => 'Hadiah bulan ini';

  @override
  String get navHome => 'Beranda';

  @override
  String get navMe => 'Saya';

  @override
  String get meHelp => 'Bantuan';

  @override
  String get meMore => 'Lainnya';

  @override
  String get checkInNotYetToday => 'Belum absen hari ini';

  @override
  String get checkInTodayButton => 'Absen hari ini';

  @override
  String checkInGiftsLeftShort(int count) {
    return '$count kali lagi dapat hadiah';
  }

  @override
  String get checkInGiftToday => 'Hari ini ada hadiah!';

  @override
  String checkInGiftMilestone(int count) {
    return 'Hadiah $count kali absen';
  }

  @override
  String get checkInGiftCollect => 'Ambil';

  @override
  String get checkInTotalHints => 'Petunjuk';

  @override
  String get checkInTotalWands => 'Tongkat ajaib';

  @override
  String get checkInTotalDailyHints => 'Petunjuk (hanya hari ini)';

  @override
  String get checkInTotalDailyWands => 'Tongkat ajaib (hanya hari ini)';

  @override
  String get checkInPremiumToday => 'Hari ini dari paket bebas iklan';

  @override
  String get checkInPremiumNotYet =>
      'Absen untuk mendapat 2 petunjuk dan 1 tongkat ajaib hari ini.';

  @override
  String get checkInPremiumUsedUp =>
      'Semua sudah dipakai hari ini. Sampai besok!';

  @override
  String checkInExpiresIn(String time) {
    return 'Berakhir dalam $time';
  }

  @override
  String dashboardDailyReminder(String rewards, String time) {
    return 'Kamu masih punya $rewards untuk hari ini. Berakhir dalam $time, main sekarang supaya tidak terbuang!';
  }

  @override
  String get dashboardDailyReminderTitle => 'Bantuan hari ini menunggumu';

  @override
  String get dashboardDailyReminderPlay => 'Main sekarang';

  @override
  String get premiumViewBenefits => 'Lihat manfaat';

  @override
  String get premiumBenefitsTitle => 'Manfaat paket';

  @override
  String get premiumBenefitsTagline =>
      'Beli sekali untuk menghilangkan iklan di antara level dan dapatkan hadiah bantuan setiap hari, selamanya di akunmu.';

  @override
  String get premiumBenefitsOneTime => 'sekali bayar';

  @override
  String get premiumWhatYouGet => 'Yang kamu dapatkan';

  @override
  String get premiumPerkNoAdsTitle => 'Tanpa iklan di antara level';

  @override
  String get premiumPerkNoAdsBody =>
      'Tidak ada lagi iklan layar penuh di antara puzzle. Lanjut dari satu level ke level berikutnya tanpa jeda.';

  @override
  String get premiumPerkDailyTitle => 'Hadiah absen harian';

  @override
  String get premiumPerkDailyBody =>
      'Setiap absen memberimu 2 petunjuk tambahan dan 1 tongkat ajaib untuk hari itu, di luar hadiah tonggak biasa.';

  @override
  String get premiumItemsTitle => 'Fungsi alat bantu';

  @override
  String get powerUpHintName => 'Petunjuk';

  @override
  String get powerUpHintTagline => 'Membuka satu sel benar yang kamu pilih';

  @override
  String get powerUpHintDesc =>
      'Ketuk bola lampu, lalu pilih bagian yang kamu ragukan. Aplikasi mengisi satu sel yang benar (terisi atau ditandai kosong) agar kamu bisa lanjut.';

  @override
  String get powerUpWandName => 'Tongkat ajaib';

  @override
  String get powerUpWandTagline => 'Menyelesaikan satu baris atau kolom penuh';

  @override
  String get powerUpWandDesc =>
      'Ketuk tongkat untuk mengaktifkan mode pilih, lalu ketuk angka petunjuk pada sebuah baris atau kolom. Aplikasi membuka seluruh baris atau kolom itu. Lebih kuat daripada petunjuk satu sel.';

  @override
  String get powerUpStatesTitle => 'Ikon menunjukkan jenis penggunaan';

  @override
  String get powerUpStatesLead =>
      'Angka di sudut adalah total sisa penggunaanmu. Penggunaan berbatas waktu membuat ikon menjadi emas dengan jam kecil:';

  @override
  String get powerUpTimeLimited => 'Berbatas waktu';

  @override
  String get powerUpTimeLimitedDesc =>
      'Ikon emas dengan jam. Dari hadiah absen harian paket. Kedaluwarsa di akhir hari.';

  @override
  String get powerUpPermanent => 'Permanen';

  @override
  String get powerUpPermanentDesc =>
      'Ikon biasa dengan lencana biru. Penggunaan tonggak dan awal. Tidak pernah kedaluwarsa.';

  @override
  String get powerUpSpendOrderTitle => 'Penggunaan mana yang dipakai dulu?';

  @override
  String get powerUpSpendOrderHeading =>
      'Penggunaan berbatas waktu dipakai lebih dulu';

  @override
  String get powerUpSpendOrderBody =>
      'Penggunaan harian kedaluwarsa di akhir hari, jadi petunjuk atau tongkat memakai penggunaan harianmu dulu dan baru memakai yang permanen setelah yang harian habis. Tidak ada yang terbuang.';

  @override
  String get powerUpSpendDaily => 'Penggunaan harian';

  @override
  String get powerUpSpendPermanent => 'Penggunaan permanen';

  @override
  String get premiumBenefitsFootnote =>
      'Penggunaan harian tidak dibawa ke hari berikutnya. Hadiah tonggak adalah penggunaan permanen dan terkumpul seperti biasa.';
}
