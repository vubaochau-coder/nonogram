// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'Pixel Nonogram';

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
      'ถ้าเชื่อมสองส่วนที่ระบายแล้วจะได้บล็อกยาวกว่าตัวเลขที่มากที่สุด ช่องระหว่างกลางต้องว่าง กากบาทเพื่อแยกมันออกจากกัน';

  @override
  String get nonogramGuideMethodDivisionTitle => '5. การแบ่งแยก';

  @override
  String get nonogramGuideMethodDoublePositioningDesc =>
      'บางครั้งช่องที่ระบายแล้วเป็นของตัวเลขได้แค่หนึ่งหรือสองตัว ลองทุกความเป็นไปได้ ช่องที่ว่างในทุกกรณีให้กากบาท';

  @override
  String get nonogramGuideMethodDoublePositioningTitle =>
      '6. การวางตำแหน่งซ้อน';

  @override
  String get nonogramGuideMethodInaccessibilityDesc =>
      'ช่องที่ไม่มีบล็อกใดเอื้อมถึงต้องว่าง ลองวางแต่ละบล็อกในตำแหน่งไกลสุดรอบช่องที่ระบายแล้ว ช่องที่อยู่นอกระยะนั้นให้กากบาท';

  @override
  String get nonogramGuideMethodInaccessibilityTitle => '3. เข้าถึงไม่ได้';

  @override
  String get nonogramGuideMethodNotFitDesc =>
      'ช่องว่างระหว่างกากบาท (หรือระหว่างกากบาทกับขอบ) ที่สั้นกว่าทุกตัวเลขที่อาจวางตรงนั้นได้ ใส่บล็อกไม่ได้: กากบาทให้หมด';

  @override
  String get nonogramGuideMethodNotFitTitle => '4. ใส่ไม่พอดี';

  @override
  String get nonogramGuideMethodSuperpositionMultiDesc =>
      'ถ้ามีหลายตัวเลข ให้ดันทั้งกลุ่มไปชิดซ้าย (เว้นช่องว่าง 1 ช่องระหว่างบล็อก) แล้วดันไปชิดขวา ช่องที่บล็อกเดียวกันทับทั้งสองตำแหน่งต้องระบาย วิธีคิดเร็ว: บวกตัวเลขกับช่องว่างคั่น ส่วนที่เหลือคือระยะที่แต่ละบล็อกเลื่อนได้';

  @override
  String get nonogramGuideMethodSuperpositionMultiTitle =>
      'การซ้อนทับ (ตัวเลขหลายตัว)';

  @override
  String get nonogramGuideMethodSuperpositionSimpleDesc =>
      'ถ้าตัวเลขยาวเกินครึ่งเส้น บางส่วนจะถูกระบายเสมอ ลองนึกภาพดันบล็อกไปชิดซ้ายสุด แล้วดันไปชิดขวาสุด ช่องที่ถูกทับทั้งสองครั้งระบายได้แน่นอน ตัวอย่าง: 7 ใน 10 ช่อง จะระบาย 4 ช่องตรงกลางเสมอ';

  @override
  String get nonogramGuideMethodSuperpositionSimpleTitle =>
      'การซ้อนทับ (ตัวเลขตัวเดียว)';

  @override
  String get nonogramGuideMethodWallPushingDesc =>
      'ช่องที่ระบายแล้วซึ่งอยู่ใกล้ขอบจะจำกัดตำแหน่งของบล็อก บล็อกล้นขอบไม่ได้ จึงต้องยื่นออกไปอีกฝั่ง ตัวอย่าง: เลข 5 ที่ช่องที่ 4 ระบายแล้ว ต่อให้ดันชิดขอบซ้าย บล็อกก็ยังทับช่องที่ 5';

  @override
  String get nonogramGuideMethodWallPushingTitle => '2. ดันออกจากขอบ';

  @override
  String get nonogramGuideRuleDesc =>
      'ตัวเลขแต่ละตัวแทนบล็อกของช่องที่ระบายต่อเนื่องกันหนึ่งบล็อกในแถวหรือคอลัมน์นั้น ถ้ามีหลายตัวเลข แต่ละตัวคือบล็อกแยกกัน และแต่ละบล็อกต้องคั่นด้วยช่องว่างอย่างน้อยหนึ่งช่อง เช่น 3 1 หมายถึงบล็อกที่ระบาย 3 ช่อง ตามด้วยช่องว่างอย่างน้อย 1 ช่อง แล้วจึงเป็นบล็อกที่ระบาย 1 ช่อง';

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
  String get nonogramTutorialWelcomeTitle => 'ยินดีต้อนรับสู่ Pixel Nonogram!';

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
      'เรียนรู้กติกา การควบคุม และเทคนิคการแก้หลัก ๆ ทีละขั้นด้วยการลงมือเล่น';

  @override
  String get nonogramGuideRoutineTitle => 'เริ่มจากตรงไหน';

  @override
  String get nonogramGuideRoutineTip1 =>
      'เริ่มจากตัวเลขใหญ่ ถ้าตัวเลขยาวเกินครึ่งเส้น บางส่วนของมันระบายได้แน่นอนแล้ว (ดูเทคนิคที่ 1 ด้านล่าง)';

  @override
  String get nonogramGuideRoutineTip2 =>
      'แก้แถวง่าย ๆ ก่อน: 0 หมายถึงทั้งแถวว่าง และถ้าผลรวมของตัวเลขบวกช่องว่างคั่น 1 ช่องระหว่างแต่ละตัวเท่ากับความยาวแถวพอดี จะวางได้แบบเดียว';

  @override
  String get nonogramGuideRoutineTip3 =>
      'กากบาทช่องที่รู้แน่ว่าว่าง กากบาทมีประโยชน์พอ ๆ กับช่องที่ระบายแล้ว';

  @override
  String get nonogramGuideRoutineTip4 =>
      'สลับดูแถวกับคอลัมน์ไปมา ทุกช่องที่แก้ได้คือเบาะแสใหม่ของเส้นที่ตัดผ่านช่องนั้น';

  @override
  String get nonogramGuideRoutineTip5 =>
      'อย่าเดา ถ้าติด ให้หาเส้นที่เหลือช่องที่ยังไม่รู้น้อยที่สุด หรือใช้คำใบ้';

  @override
  String get nonogramGuideMethodLineDoneTitle => 'เส้นที่ครบแล้ว';

  @override
  String get nonogramGuideMethodLineDoneDesc =>
      'เมื่อบล็อกทั้งหมดของเส้นหนึ่งเข้าที่แล้ว ช่องที่เหลือในเส้นนั้นว่างทั้งหมด: กากบาทให้หมด เส้นที่มีเลข 0 ว่างตั้งแต่แรก';

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
  String get nonogramTutorialToolsDoneTitle => 'ใช้ปุ่มควบคุมเป็นแล้ว!';

  @override
  String get nonogramTutorialToolsDone =>
      'ปริศนาจริงใหญ่กว่านี้ และแถวส่วนใหญ่ไม่สามารถแก้ได้ในแวบเดียว ต่อไปมาเรียนเทคนิคการแก้บนปริศนาขนาด 8×8 กัน';

  @override
  String get nonogramTutorialOverlapSingle =>
      'มองหาตัวเลขใหญ่ก่อน แถบสีฟ้าสองแถบคือบล็อก 6 ที่ชิดซ้ายสุดและชิดขวาสุด ส่วนที่ซ้อนกันจะถูกระบายเสมอไม่ว่าบล็อกอยู่ตรงไหน ระบาย 4 ช่องนั้นเลย';

  @override
  String get nonogramTutorialOverlapMulti =>
      'หลายตัวเลขก็เหมือนกัน: 3 3 ต้องใช้อย่างน้อย 7 ช่อง (3 + ช่องว่าง + 3) ทั้งกลุ่มจึงเลื่อนได้แค่ 1 ช่อง แถบบนคือชิดซ้าย แถบล่างคือชิดขวา ระบายช่องที่ทั้งสองแถบทับ';

  @override
  String get nonogramTutorialFullRow =>
      '8 ใน 8 ช่อง: ทั้งแถวถูกระบาย ลากผ่านทั้งแถวเลย';

  @override
  String get nonogramTutorialZeroRow =>
      '0 หมายความว่าแถวนั้นไม่มีช่องที่ถูกระบายเลย สลับไปโหมด X';

  @override
  String get nonogramTutorialMarkZeroRow =>
      'กากบาทแถวล่างสุดทั้งแถว กากบาทมีประโยชน์ เพราะบอกคอลัมน์ว่าบล็อกอยู่ตรงไหนไม่ได้';

  @override
  String get nonogramTutorialOutOfReach =>
      'ต่อไปดูคอลัมน์ คอลัมน์ที่ 2 เป็นบล็อก 3 ช่องที่ต้องครอบ 2 ช่องที่ระบายแล้ว แถบสีฟ้าสองแถบคือตำแหน่งไกลสุดของมัน ช่องที่อยู่นอกทั้งสองแถบเอื้อมไม่ถึง กากบาทให้หมด และทำแบบเดียวกันในคอลัมน์ที่ 7';

  @override
  String get nonogramTutorialBackToFill =>
      'ดูคอลัมน์ที่ 3 ต้องการ 7 ช่อง สลับกลับไปโหมดระบาย';

  @override
  String get nonogramTutorialExactSpace =>
      'กากบาทด้านล่างเหลือที่ไว้ให้เลข 7 พอดี 7 ช่อง ระบายให้หมดเลย คอลัมน์ที่ 6 ก็เหมือนกัน';

  @override
  String get nonogramTutorialFinishTechniques =>
      'นี่คือวิธีแก้: ทำเท่าที่ทำได้ในแถว แล้วไปทำในคอลัมน์ แล้วทำซ้ำ ลองทำเห็ดให้เสร็จด้วยตัวเองเลย!';

  @override
  String get nonogramPlayHintNothingToFill =>
      'ช่องที่ควรระบายถูกระบายครบแล้ว ลองตรวจดูว่ามีช่องที่ระบายเกินหรือไม่';

  @override
  String get settingsSound => 'เสียง';

  @override
  String get settingsLicenses => 'สัญญาอนุญาต';

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
  String licensesBy(String author) {
    return 'โดย $author';
  }

  @override
  String licensesLevelCount(int count) {
    return '$count ปริศนา';
  }

  @override
  String get adRewardNotReady =>
      'โฆษณายังไม่พร้อม ตรวจสอบการเชื่อมต่ออินเทอร์เน็ตแล้วลองอีกครั้ง';

  @override
  String get settingsAdPrivacy => 'ความเป็นส่วนตัวด้านโฆษณา';

  @override
  String get ratingTitle => 'ชอบ Pixel Nonogram ไหม';

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

  @override
  String get premiumTitle => 'เล่นแบบไม่มีโฆษณา';

  @override
  String get premiumBenefitNoAds => 'ไม่มีโฆษณาระหว่างด่านอีกต่อไป';

  @override
  String get premiumBenefitDaily =>
      'คำใบ้ 2 ครั้งและไม้กายสิทธิ์ 1 ครั้งทุกวันที่เช็กอิน';

  @override
  String premiumBuy(String price) {
    return 'ซื้อ · $price';
  }

  @override
  String get premiumOneTime => 'ชำระครั้งเดียวผ่าน Google Play';

  @override
  String get premiumActiveTitle => 'แพ็กไม่มีโฆษณาเปิดใช้งานแล้ว';

  @override
  String get premiumActiveDaily =>
      'เช็กอินทุกวันเพื่อรับคำใบ้ 2 ครั้งและไม้กายสิทธิ์ 1 ครั้งสำหรับวันนั้น';

  @override
  String get premiumPurchased => 'ขอบคุณ! ปิดโฆษณาระหว่างด่านแล้ว';

  @override
  String get premiumPending =>
      'การชำระเงินกำลังรอดำเนินการ แพ็กจะเปิดใช้งานเมื่อชำระเสร็จ';

  @override
  String get premiumFailed => 'ซื้อไม่สำเร็จ โปรดลองอีกครั้ง';

  @override
  String get checkInTitle => 'เช็กอินรายวัน';

  @override
  String get checkInAction => 'เช็กอิน';

  @override
  String get checkInDoneToday => 'วันนี้เช็กอินแล้ว';

  @override
  String checkInNextGift(int count) {
    return 'อีก $count ครั้งจะได้ของขวัญถัดไป';
  }

  @override
  String get checkInCheckedIn => 'เช็กอินแล้ว!';

  @override
  String checkInReceived(String rewards) {
    return 'คุณได้รับ $rewards';
  }

  @override
  String rewardHints(int count) {
    return 'คำใบ้ $count ครั้ง';
  }

  @override
  String rewardWands(int count) {
    return 'ไม้กายสิทธิ์ $count ครั้ง';
  }

  @override
  String rewardTodayOnly(String reward) {
    return '$reward (เฉพาะวันนี้)';
  }

  @override
  String get checkInMonthGifts => 'ของขวัญเดือนนี้';

  @override
  String get navHome => 'หน้าหลัก';

  @override
  String get navMe => 'ฉัน';

  @override
  String get meHelp => 'ช่วยเหลือ';

  @override
  String get meMore => 'อื่น ๆ';

  @override
  String get checkInNotYetToday => 'วันนี้ยังไม่ได้เช็กอิน';

  @override
  String get checkInTodayButton => 'เช็กอินวันนี้';

  @override
  String checkInGiftsLeftShort(int count) {
    return 'อีก $count ครั้งได้ของขวัญ';
  }

  @override
  String get checkInGiftToday => 'วันนี้มีของขวัญ!';

  @override
  String checkInGiftMilestone(int count) {
    return 'ของขวัญเช็กอินครบ $count ครั้ง';
  }

  @override
  String get checkInGiftCollect => 'รับ';

  @override
  String get checkInTotalHints => 'คำใบ้';

  @override
  String get checkInTotalWands => 'ไม้กายสิทธิ์';

  @override
  String get checkInTotalDailyHints => 'คำใบ้ (เฉพาะวันนี้)';

  @override
  String get checkInTotalDailyWands => 'ไม้กายสิทธิ์ (เฉพาะวันนี้)';

  @override
  String get checkInPremiumNotYet =>
      'เช็กอินเพื่อรับคำใบ้ 2 ครั้งและไม้กายสิทธิ์ 1 ครั้งสำหรับวันนี้';

  @override
  String dashboardDailyReminder(String rewards, String time) {
    return 'คุณยังมี$rewardsที่จะหมดอายุใน $time ใช้เลยเพื่อไม่ให้เสียเปล่า';
  }

  @override
  String get premiumViewBenefits => 'ดูสิทธิประโยชน์';

  @override
  String get premiumBenefitsTitle => 'สิทธิประโยชน์ของแพ็ก';

  @override
  String get premiumBenefitsTagline =>
      'ซื้อครั้งเดียวเพื่อลบโฆษณาระหว่างด่านและรับรางวัลตัวช่วยทุกวัน ตลอดไปบนบัญชีของคุณ';

  @override
  String get premiumBenefitsOneTime => 'จ่ายครั้งเดียว';

  @override
  String get premiumWhatYouGet => 'สิ่งที่คุณได้รับ';

  @override
  String get premiumPerkNoAdsTitle => 'ไม่มีโฆษณาระหว่างด่าน';

  @override
  String get premiumPerkNoAdsBody =>
      'ไม่มีโฆษณาเต็มจอระหว่างปริศนาอีกต่อไป เล่นต่อจากด่านหนึ่งไปอีกด่านได้โดยไม่สะดุด';

  @override
  String get premiumPerkDailyTitle => 'รางวัลเช็กอินรายวัน';

  @override
  String get premiumPerkDailyBody =>
      'การเช็กอินแต่ละครั้งให้คำใบ้เพิ่ม 2 ครั้งและไม้กายสิทธิ์ 1 ครั้งสำหรับวันนั้น นอกเหนือจากรางวัลหมุดหมายตามปกติ';

  @override
  String get premiumItemsTitle => 'ตัวช่วยทำอะไรได้บ้าง';

  @override
  String get powerUpHintName => 'คำใบ้';

  @override
  String get powerUpHintTagline => 'เผยช่องที่ถูกต้องหนึ่งช่องที่คุณเลือก';

  @override
  String get powerUpHintDesc =>
      'แตะหลอดไฟ แล้วเลือกตำแหน่งที่ยังไม่แน่ใจ แอปจะเติมช่องที่ถูกต้องหนึ่งช่อง (ระบายหรือทำเครื่องหมายว่าว่าง) เพื่อช่วยให้คุณไปต่อได้';

  @override
  String get powerUpWandName => 'ไม้กายสิทธิ์';

  @override
  String get powerUpWandTagline => 'แก้ทั้งแถวหรือทั้งคอลัมน์';

  @override
  String get powerUpWandDesc =>
      'แตะไม้กายสิทธิ์เพื่อเปิดโหมดเลือก แล้วแตะตัวเลขใบ้ของแถวหรือคอลัมน์ แอปจะเผยทั้งแถวหรือคอลัมน์นั้น ทรงพลังกว่าคำใบ้แบบช่องเดียว';

  @override
  String get powerUpStatesTitle => 'ไอคอนบอกประเภทของสิทธิ์';

  @override
  String get powerUpStatesLead =>
      'ตัวเลขที่มุมคือจำนวนครั้งที่เหลือทั้งหมด สิทธิ์แบบมีกำหนดเวลาจะทำให้ไอคอนเป็นสีทองพร้อมนาฬิกาเล็ก ๆ';

  @override
  String get powerUpTimeLimited => 'มีกำหนดเวลา';

  @override
  String get powerUpTimeLimitedDesc =>
      'ไอคอนสีทองมีนาฬิกา มาจากรางวัลเช็กอินรายวันของแพ็ก หมดอายุเมื่อสิ้นวัน';

  @override
  String get powerUpPermanent => 'ไม่มีกำหนด';

  @override
  String get powerUpPermanentDesc =>
      'ไอคอนปกติมีป้ายสีน้ำเงิน เป็นสิทธิ์จากหมุดหมายและของเริ่มต้น ไม่มีวันหมดอายุ';

  @override
  String get powerUpSpendOrderTitle => 'สิทธิ์ไหนถูกใช้ก่อน?';

  @override
  String get powerUpSpendOrderHeading => 'สิทธิ์แบบมีกำหนดเวลาจะถูกใช้ก่อน';

  @override
  String get powerUpSpendOrderBody =>
      'สิทธิ์รายวันหมดอายุเมื่อสิ้นวัน ดังนั้นคำใบ้หรือไม้กายสิทธิ์จะใช้สิทธิ์รายวันก่อน และจะใช้สิทธิ์ถาวรก็ต่อเมื่อสิทธิ์รายวันหมดแล้ว จึงไม่มีอะไรสูญเปล่า';

  @override
  String get powerUpSpendDaily => 'สิทธิ์รายวัน';

  @override
  String get powerUpSpendPermanent => 'สิทธิ์ถาวร';

  @override
  String get premiumBenefitsFootnote =>
      'สิทธิ์รายวันไม่ยกยอดไปวันถัดไป รางวัลหมุดหมายเป็นสิทธิ์ถาวรและสะสมได้ตามปกติ';

  @override
  String dashboardDailyReminderBoth(String hints, String wands) {
    return '$hintsและ$wands';
  }

  @override
  String checkInLegendMilestone(int count) {
    return 'ของขวัญทุก $count ครั้งที่เช็กอิน';
  }

  @override
  String get checkInLegendPremium => 'รางวัลแพ็กไม่มีโฆษณา';
}
