// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'Nonopix';

  @override
  String get commonCancel => 'ยกเลิก';

  @override
  String get commonRetry => 'ลองอีกครั้ง';

  @override
  String get commonSave => 'บันทึก';

  @override
  String nonogramDashboardContinueLevel(int level) {
    return 'ด่าน $level';
  }

  @override
  String get nonogramDashboardProgressSectionTitle => 'ความคืบหน้าของคุณ';

  @override
  String get nonogramDashboardStatCompleted => 'ผ่านแล้ว';

  @override
  String get nonogramGuideIntro =>
      'โนโนแกรมคือปริศนาตรรกะที่มีกติกาง่าย แต่หาคำตอบได้ท้าทาย เป้าหมายคือเผยภาพที่ซ่อนอยู่ด้วยการระบายช่องตามตัวเลขที่อยู่ข้างตาราง';

  @override
  String get nonogramGuideMethodDivisionDesc =>
      'ถ้าการเชื่อมสองบล็อกที่มีอยู่จะทำให้เกิดรูปที่ยาวกว่าตัวเลขใบ้ทุกตัว ช่องว่างระหว่างสองบล็อกนั้นต้องเป็น X';

  @override
  String get nonogramGuideMethodDivisionTitle => '5. การแบ่งแยก';

  @override
  String get nonogramGuideMethodDoublePositioningDesc =>
      'ถ้าช่องที่ระบายแล้วเป็นส่วนหนึ่งของบล็อกได้เพียงไม่กี่แบบ ช่องใดที่ไม่ถูกระบายในทุกแบบเหล่านั้นต้องทำเครื่องหมาย X';

  @override
  String get nonogramGuideMethodDoublePositioningTitle =>
      '6. การวางตำแหน่งซ้อน';

  @override
  String get nonogramGuideMethodInaccessibilityDesc =>
      'ทำเครื่องหมายกากบาท (X) ที่ช่องซึ่งไม่มีทางเป็นส่วนหนึ่งของรูปที่เหลืออยู่ได้เลย';

  @override
  String get nonogramGuideMethodInaccessibilityTitle => '3. เข้าถึงไม่ได้';

  @override
  String get nonogramGuideMethodNotFitDesc =>
      'ถ้าช่องว่างระหว่างกากบาทสั้นกว่าตัวเลขใบ้ทุกตัวของแถวนั้น ช่องว่างนั้นต้องทำเครื่องหมาย X';

  @override
  String get nonogramGuideMethodNotFitTitle => '4. ใส่ไม่พอดี';

  @override
  String get nonogramGuideMethodSuperpositionMultiDesc =>
      'เมื่อมีตัวเลขหลายตัว ให้ซ้อนตำแหน่งชิดซ้ายสุดและชิดขวาสุดของทั้งกลุ่ม โดยนับช่องว่างขั้นต่ำหนึ่งช่องที่ต้องมีระหว่างบล็อกสีเดียวกันด้วย ช่องที่บล็อกเดียวกันทับกันในทั้งสองแบบให้ระบาย';

  @override
  String get nonogramGuideMethodSuperpositionMultiTitle =>
      'การซ้อนทับ (ตัวเลขหลายตัว)';

  @override
  String get nonogramGuideMethodSuperpositionSimpleDesc =>
      'ถ้าตัวเลขยาวกว่าครึ่งหนึ่งของแถว ช่องตรงกลางบางช่องต้องถูกระบายแน่นอน ให้ซ้อนตำแหน่งชิดซ้ายสุดกับชิดขวาสุด ช่องที่ทับกันให้ระบาย';

  @override
  String get nonogramGuideMethodSuperpositionSimpleTitle =>
      'การซ้อนทับ (ตัวเลขตัวเดียว)';

  @override
  String get nonogramGuideMethodWallPushingDesc =>
      'ถ้าช่องที่รู้ว่าระบายแล้วอยู่ใกล้ขอบมากกว่าความยาวของตัวเลขตัวแรก รูปที่ช่องนั้นเป็นส่วนหนึ่งต้องยืดออกไปทางที่ห่างจากขอบ';

  @override
  String get nonogramGuideMethodWallPushingTitle => '2. ดันออกจากขอบ';

  @override
  String get nonogramGuideRuleDesc =>
      'ตัวเลขแต่ละตัวแทนบล็อกของช่องที่ระบายต่อเนื่องกันหนึ่งบล็อกในแถวหรือคอลัมน์นั้น ถ้ามีหลายตัวเลข แต่ละตัวคือบล็อกแยกกัน และแต่ละบล็อกต้องคั่นด้วยช่องว่างอย่างน้อยหนึ่งช่อง เช่น `3 1` หมายถึงบล็อกที่ระบาย 3 ช่อง ตามด้วยช่องว่างอย่างน้อย 1 ช่อง แล้วจึงเป็นบล็อกที่ระบาย 1 ช่อง';

  @override
  String get nonogramGuideRuleTitle => 'กติกาหลัก: ตัวเลขหมายถึงอะไร';

  @override
  String get nonogramGuideTitle => 'วิธีแก้ปริศนา';

  @override
  String nonogramHistoryCompletedOn(String date) {
    return 'ผ่านเมื่อ $date';
  }

  @override
  String get nonogramHistoryDetailNotFound => 'ไม่พบรายละเอียดของด่าน';

  @override
  String get nonogramHistoryEmpty => 'ยังไม่มีด่านที่ผ่าน';

  @override
  String nonogramHistoryLevel(int n) {
    return 'ด่าน $n';
  }

  @override
  String get nonogramHistoryTitle => 'ผลลัพธ์';

  @override
  String get nonogramPlayActionNextLevelFixed => 'ด่านถัดไป';

  @override
  String get nonogramPlayActionShowClues => 'แสดงตัวเลขใบ้';

  @override
  String nonogramPlayCompletionMessage(int level) {
    return 'ยินดีด้วย! คุณผ่านด่าน $level แล้ว';
  }

  @override
  String get nonogramPlayCompletionTitle => 'ไขปริศนาสำเร็จ!';

  @override
  String nonogramPlayDurationFormat(int minutes, int seconds) {
    return '$minutes นาที $seconds วินาที';
  }

  @override
  String nonogramPlayHintLabel(int count) {
    return 'คำใบ้ ($count)';
  }

  @override
  String get nonogramPlayNoNextLevelToast => 'ยังไม่มีด่านถัดไป';

  @override
  String get nonogramPlayPageTitle => 'โนโนแกรม';

  @override
  String get nonogramSettingsTitle => 'การตั้งค่า';

  @override
  String get nonogramDashboardContinueNext => 'ความท้าทายถัดไป';

  @override
  String get nonogramDashboardPlay => 'เล่น';

  @override
  String get nonogramDashboardResumeAction => 'เล่นต่อ';

  @override
  String get nonogramDashboardInProgressBadge => 'กำลังเล่น';

  @override
  String nonogramDashboardDifficulty(String value) {
    return 'ความยาก $value';
  }

  @override
  String nonogramDashboardSolvedOfTotal(int completed, int total) {
    return 'ไขแล้ว $completed จาก $total ปริศนา';
  }

  @override
  String get nonogramDashboardStatFastest => 'เร็วที่สุด';

  @override
  String get nonogramDashboardStatTotalTime => 'เวลารวม';

  @override
  String get nonogramDashboardRecentTitle => 'ไขล่าสุด';

  @override
  String get nonogramDashboardSeeAll => 'ดูทั้งหมด';

  @override
  String get nonogramDashboardRecentEmpty =>
      'ไขปริศนาแรกเพื่อเริ่มสะสมภาพของคุณ';

  @override
  String get nonogramDashboardAllDoneTitle => 'ไขปริศนาครบทุกข้อแล้ว!';

  @override
  String nonogramDashboardAllDoneDesc(int total) {
    return 'คุณไขปริศนาครบทั้ง $total ข้อแล้ว กลับมาดูคอลเลกชันของคุณได้ทุกเมื่อ';
  }

  @override
  String nonogramDurationHoursMinutes(int hours, int minutes) {
    return '$hours ชม. $minutes นาที';
  }

  @override
  String nonogramHistoryBestTime(String time) {
    return 'ดีที่สุด $time';
  }

  @override
  String get nonogramPlayActionDashboard => 'หน้าหลัก';

  @override
  String get appThemeTitle => 'ธีม';

  @override
  String get appThemeLight => 'สว่าง';

  @override
  String get appThemeDark => 'มืด';

  @override
  String get nonogramPlayModeFill => 'โหมดระบาย';

  @override
  String get nonogramPlayModeMark => 'โหมดกากบาท X';

  @override
  String get nonogramSettingsRestart => 'เริ่มด่านนี้ใหม่';

  @override
  String get nonogramSettingsRestartConfirmTitle => 'เริ่มด่านนี้ใหม่ไหม';

  @override
  String get nonogramSettingsRestartConfirmMessage =>
      'ช่องทั้งหมดที่คุณระบายหรือทำเครื่องหมายไว้จะถูกล้าง ช่องที่มีดาว (เปิดด้วยคำใบ้หรือไม้กายสิทธิ์) จะยังคงอยู่';

  @override
  String get commonClose => 'ปิด';

  @override
  String get nonogramSettingsRestartConfirm => 'เริ่มใหม่';

  @override
  String get nonogramTutorialTitle => 'วิธีเล่น';

  @override
  String get nonogramTutorialSkip => 'ข้าม';

  @override
  String get nonogramTutorialWelcomeTitle => 'ยินดีต้อนรับสู่ Nonopix!';

  @override
  String get nonogramTutorialWelcome =>
      'มาเรียนรู้กติกาพื้นฐานกับปริศนาขนาด 5×5 กัน';

  @override
  String get nonogramTutorialStart => 'เริ่ม';

  @override
  String get nonogramTutorialSwitchToFill =>
      'ปริศนาไขได้ด้วยการระบายช่อง แตะปุ่มด้านล่างเพื่อเปลี่ยนเป็นโหมดระบาย';

  @override
  String get nonogramTutorialClueIsCount =>
      'ตัวเลขบอกว่าแถวนั้นมีช่องที่ระบายกี่ช่อง แถวนี้มี 5 จึงระบายทุกช่องเลย!';

  @override
  String get nonogramTutorialEdgeCell =>
      'ช่องสุดท้ายถูกระบายแล้ว บล็อก 4 ช่องต้องรวมช่องนี้ด้วย จึงวางได้แบบเดียว: ระบาย 3 ช่องทางซ้ายของมัน';

  @override
  String get nonogramTutorialMultipleClues =>
      'มีตัวเลขมากกว่าหนึ่งตัวหมายถึงมีหลายบล็อก โดยมีช่องว่างคั่นอย่างน้อยหนึ่งช่อง 2 2 วางใน 5 ช่องนี้ได้แบบเดียวเท่านั้น';

  @override
  String get nonogramTutorialClueOrder =>
      'ลำดับก็สำคัญ: 3 1 หมายถึงบล็อก 3 ช่องมาก่อน แล้วจึงเป็นบล็อก 1 ช่อง';

  @override
  String get nonogramTutorialColumns =>
      'คอลัมน์ก็มีตัวเลข อ่านจากบนลงล่าง เปลี่ยนเป็นโหมด X เพื่อทำเครื่องหมายช่องที่ต้องว่าง';

  @override
  String get nonogramTutorialMarkEmpty =>
      'คอลัมน์ที่มี ✓ ระบายครบแล้ว ทำเครื่องหมาย X ที่ช่องว่างที่เหลือของคอลัมน์นั้น';

  @override
  String get nonogramTutorialOneCellLeft =>
      'เลข 1 ในแถวสุดท้ายเหลือที่ว่างให้วางได้ที่เดียวแล้ว เปลี่ยนกลับเป็นโหมดระบาย';

  @override
  String get nonogramTutorialFinish =>
      'ระบายช่องสุดท้ายเพื่อไขปริศนาให้สำเร็จ!';

  @override
  String get nonogramTutorialDoneTitle => 'เก่งมาก!';

  @override
  String get nonogramTutorialDone =>
      'พร้อมแล้ว! ในปริศนาขนาดใหญ่ ใช้สองนิ้วลาก (หรือลากจากพื้นที่ว่างนอกตาราง) เพื่อเลื่อนกระดาน แอปจะเตือนคุณอีกครั้งในปริศนาขนาดใหญ่ข้อแรก';

  @override
  String get nonogramTutorialShowTechniques => 'ดูเทคนิคการไขปริศนา';

  @override
  String get nonogramTutorialPlay => 'เริ่มเล่น';

  @override
  String get nonogramGuideTutorialCardTitle => 'เรียนรู้ด้วยการเล่น';

  @override
  String get nonogramGuideTutorialCardDesc =>
      'เรียนรู้กติกาและการควบคุมทีละขั้นกับปริศนาขนาด 5×5';

  @override
  String get nonogramPlayInfoHide => 'ซ่อนข้อมูลด่าน';

  @override
  String get nonogramPlayWandLabel => 'ไม้กายสิทธิ์';

  @override
  String get nonogramPlayWandSelectPrompt =>
      'แตะตัวเลขของแถวหรือคอลัมน์ที่ต้องการเปิด';

  @override
  String get nonogramPlayWandRowSolved =>
      'แถวนี้ถูกต้องแล้ว เลือกแถวหรือคอลัมน์อื่น';

  @override
  String get nonogramPlayWandColSolved =>
      'คอลัมน์นี้ถูกต้องแล้ว เลือกแถวหรือคอลัมน์อื่น';

  @override
  String get nonogramSettingsControlsGuide => 'คู่มือการควบคุม';

  @override
  String get nonogramCoachSkip => 'ข้าม';

  @override
  String get nonogramCoachNext => 'ถัดไป';

  @override
  String get nonogramCoachDone => 'เข้าใจแล้ว';

  @override
  String nonogramCoachStep(int current, int total) {
    return '$current/$total';
  }

  @override
  String get nonogramCoachHintTitle => 'คำใบ้';

  @override
  String get nonogramCoachHintBody =>
      'ระบายช่องที่ถูกต้องให้ 5 ช่อง (ช่องที่ควรระบายแต่ยังไม่ได้ระบาย) โดยสุ่มจากทั้งกระดาน ช่องเหล่านี้มีดาว: แก้ไขไม่ได้และยังคงอยู่แม้จะเริ่มใหม่ ได้ 3 ครั้งต่อปริศนา';

  @override
  String get nonogramCoachWandTitle => 'ไม้กายสิทธิ์';

  @override
  String get nonogramCoachWandBody =>
      'แตะไม้กายสิทธิ์ แล้วแตะตัวเลขของแถวหรือคอลัมน์ใดก็ได้ คำตอบของทั้งแถวนั้นจะถูกเปิดและมีดาวกำกับ ยังคงอยู่แม้จะเริ่มใหม่ ได้ 1 ครั้งต่อปริศนา';

  @override
  String get nonogramCoachModeTitle => 'ระบายหรือ X';

  @override
  String get nonogramCoachModeBody =>
      'เลือกว่าการแตะจะทำอะไร: ระบายช่อง หรือทำเครื่องหมาย X เพื่อจำว่าช่องนั้นว่าง แตะปุ่มเพื่อสลับ ลากบนตารางเพื่อระบายหรือทำเครื่องหมายหลายช่องพร้อมกัน';

  @override
  String get nonogramCoachLongPressTitle => 'กดค้างเพื่อทำสิ่งตรงข้าม';

  @override
  String get nonogramCoachLongPressBody =>
      'กดค้างที่ช่องเพื่อทำสิ่งตรงข้ามกับโหมดปัจจุบัน: ใส่ X ขณะอยู่ในโหมดระบาย หรือระบายขณะอยู่ในโหมด X การสั่นสั้น ๆ หมายความว่าเสร็จแล้วและปล่อยนิ้วได้';

  @override
  String get nonogramCoachScrollTitle => 'การเลื่อนดูปริศนาขนาดใหญ่';

  @override
  String get nonogramCoachScrollBody =>
      'ปริศนาขนาดใหญ่แสดงไม่พอในหน้าจอ: ใช้สองนิ้วลาก หรือลากจากพื้นที่ว่างนอกตารางเพื่อเลื่อนกระดาน ลากบนตัวเลขใบ้เพื่อดูตัวเลขที่ซ่อนอยู่ (\"+N\" ที่มุมบอกว่ามีกี่ตัว)';

  @override
  String get nonogramTutorialRulesDoneTitle => 'คุณรู้กติกาแล้ว!';

  @override
  String get nonogramTutorialRulesDone =>
      'ต่อไปมาฝึกการควบคุมและตัวช่วยกับปริศนาอีกข้อ: ลากเพื่อระบายเร็ว ๆ กดค้างเพื่อทำเครื่องหมาย คำใบ้ และไม้กายสิทธิ์';

  @override
  String get nonogramTutorialContinue => 'ต่อไป';

  @override
  String get nonogramTutorialLater => 'ไว้ทีหลัง เล่นเลย';

  @override
  String get nonogramTutorialDragRow =>
      'เคล็ดลับ: ลากนิ้วผ่านช่องต่าง ๆ เพื่อระบายในครั้งเดียว แถวบนสุดมี 5 จึงลากผ่านทั้งแถวเลย!';

  @override
  String get nonogramTutorialLongPressMark =>
      '1 1 1 พอดีกับ 5 ช่องนี้ ดังนั้นช่องที่ 2 และ 4 ต้องว่าง ไม่ต้องเปลี่ยนโหมด: กดค้างแต่ละช่องเพื่อใส่ X การสั่นสั้น ๆ หมายความว่าเสร็จแล้ว';

  @override
  String get nonogramTutorialUseHint =>
      'ติดอยู่ใช่ไหม แตะปุ่มคำใบ้ แล้วแอปจะสุ่มระบายช่องที่ถูกต้องให้ 5 ช่อง ได้ 3 ครั้งต่อปริศนา';

  @override
  String get nonogramTutorialActivateWand =>
      'คำใบ้ระบาย 5 ช่องที่มีดาวกำกับ: ช่องเหล่านี้ถูกล็อกและยังคงอยู่แม้จะเริ่มใหม่ ถ้าต้องการเปิดทั้งแถวหรือคอลัมน์ที่เลือกเอง ให้ใช้ไม้กายสิทธิ์: แตะปุ่มไม้กายสิทธิ์';

  @override
  String get nonogramTutorialPickWandLine =>
      'ตอนนี้แตะตัวเลขของแถวล่างสุดเพื่อเปิดแถวนั้น ได้ไม้กายสิทธิ์ 1 ครั้งต่อปริศนา';

  @override
  String get nonogramTutorialFinishTools =>
      'ระบายช่องที่เหลือให้ครบ ลากลงตามคอลัมน์เพื่อระบายได้เร็วขึ้น';

  @override
  String get nonogramPlayHintNothingToFill =>
      'ช่องที่ควรระบายถูกระบายครบแล้ว ลองตรวจดูว่ามีช่องที่ระบายเกินหรือไม่';

  @override
  String get settingsLicenses => 'สัญญาอนุญาต';

  @override
  String get settingsSwitchPlayMode => 'เปลี่ยนโหมดการเล่น';

  @override
  String get licensesTitle => 'สัญญาอนุญาต';

  @override
  String get licensesLevelArtHeading => 'ปริศนา';

  @override
  String get licensesLevelArtIntro =>
      'ปริศนามาจากแหล่งเหล่านี้ ชุดไอคอนถูกย่อขนาด แปลงเป็นขาวดำ และแก้ไขเพื่อให้ทุกปริศนาไขได้ ส่วนคอลเลกชันโนโนแกรมใช้ตามต้นฉบับ';

  @override
  String get licensesFontHeading => 'ฟอนต์';

  @override
  String get licensesSoftwareButton => 'สัญญาอนุญาตซอฟต์แวร์โอเพนซอร์ส';

  @override
  String get licensesDeveloperLevelsNote =>
      'ปริศนาในโหมดนักพัฒนามาจาก nonogram.org และใช้สำหรับทดสอบภายในเท่านั้น ไม่มีอยู่ในเวอร์ชันบนสโตร์';

  @override
  String get playModeTitle => 'เลือกโหมดการเล่น';

  @override
  String get playModeSubtitle => 'ความคืบหน้าของแต่ละโหมดบันทึกแยกกัน';

  @override
  String get playModeUserTitle => 'โหมดผู้เล่น';

  @override
  String get playModeUserBody =>
      'ปริศนาที่มีสัญญาอนุญาตซึ่งอยู่ในเวอร์ชันบนสโตร์';

  @override
  String get playModeDeveloperTitle => 'โหมดนักพัฒนา';

  @override
  String get playModeDeveloperBody =>
      'ปริศนาต้นฉบับจาก nonogram.org สำหรับทดสอบภายใน เก็บความคืบหน้าเดิมของคุณไว้';

  @override
  String get playModeLastUsed => 'ใช้ล่าสุด';

  @override
  String licensesBy(String author) {
    return 'โดย $author';
  }

  @override
  String licensesLevelCount(int count) {
    return '$count ปริศนา';
  }

  @override
  String playModeProgress(int solved, int total) {
    return 'ไขแล้ว $solved/$total';
  }

  @override
  String get adRewardNotReady =>
      'โฆษณายังไม่พร้อม ตรวจสอบการเชื่อมต่ออินเทอร์เน็ตแล้วลองอีกครั้ง';

  @override
  String get settingsAdPrivacy => 'ความเป็นส่วนตัวด้านโฆษณา';

  @override
  String get ratingTitle => 'ชอบ Nonopix ไหม';

  @override
  String get ratingMessage => 'แตะดาวเพื่อให้คะแนนเกม';

  @override
  String get ratingLater => 'ไว้ทีหลัง';

  @override
  String get ratingSubmit => 'ส่ง';

  @override
  String get ratingThanks =>
      'ขอบคุณสำหรับความคิดเห็น! เราจะพัฒนาเกมให้ดียิ่งขึ้นต่อไป';

  @override
  String ratingStarLabel(int count) {
    return '$count ดาว';
  }

  @override
  String get settingsLanguage => 'ภาษา';

  @override
  String get settingsLanguageSystem => 'ภาษาของอุปกรณ์';
}
