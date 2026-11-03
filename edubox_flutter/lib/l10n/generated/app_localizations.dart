import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('vi')];

  /// No description provided for @appName.
  ///
  /// In vi, this message translates to:
  /// **'EduBox'**
  String get appName;

  /// No description provided for @appOpening.
  ///
  /// In vi, this message translates to:
  /// **'Đang mở EduBox…'**
  String get appOpening;

  /// No description provided for @appMarkSemantics.
  ///
  /// In vi, this message translates to:
  /// **'EduBox'**
  String get appMarkSemantics;

  /// No description provided for @signInTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get signInTitle;

  /// No description provided for @emailLabel.
  ///
  /// In vi, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu'**
  String get passwordLabel;

  /// No description provided for @signInButton.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get signInButton;

  /// No description provided for @signInSubmitting.
  ///
  /// In vi, this message translates to:
  /// **'Đang đăng nhập…'**
  String get signInSubmitting;

  /// No description provided for @showPassword.
  ///
  /// In vi, this message translates to:
  /// **'Hiện mật khẩu'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In vi, this message translates to:
  /// **'Ẩn mật khẩu'**
  String get hidePassword;

  /// No description provided for @emailRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập email'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In vi, this message translates to:
  /// **'Email chưa đúng định dạng'**
  String get emailInvalid;

  /// No description provided for @passwordRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập mật khẩu'**
  String get passwordRequired;

  /// No description provided for @signInWrongCredentials.
  ///
  /// In vi, this message translates to:
  /// **'Email hoặc mật khẩu không đúng'**
  String get signInWrongCredentials;

  /// No description provided for @backendUnreachable.
  ///
  /// In vi, this message translates to:
  /// **'Không kết nối được với EduBox'**
  String get backendUnreachable;

  /// No description provided for @backendUnreachableHint.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra kết nối mạng rồi thử lại.'**
  String get backendUnreachableHint;

  /// No description provided for @retry.
  ///
  /// In vi, this message translates to:
  /// **'Thử lại'**
  String get retry;

  /// No description provided for @retrying.
  ///
  /// In vi, this message translates to:
  /// **'Đang thử lại…'**
  String get retrying;

  /// No description provided for @signInTooManyAttempts.
  ///
  /// In vi, this message translates to:
  /// **'Đã thử quá nhiều lần. Vui lòng đợi vài phút rồi thử lại.'**
  String get signInTooManyAttempts;

  /// No description provided for @signInAccountDisabled.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản này đang bị tạm khóa. Vui lòng liên hệ nhà trường.'**
  String get signInAccountDisabled;

  /// No description provided for @signInUnknownError.
  ///
  /// In vi, this message translates to:
  /// **'Không đăng nhập được. Vui lòng thử lại.'**
  String get signInUnknownError;

  /// No description provided for @signInHelp.
  ///
  /// In vi, this message translates to:
  /// **'Quên mật khẩu hoặc chưa có tài khoản? Vui lòng liên hệ nhà trường.'**
  String get signInHelp;

  /// No description provided for @accountNotSetUp.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản chưa được thiết lập'**
  String get accountNotSetUp;

  /// No description provided for @accountNotSetUpBody.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã đăng nhập đúng, nhưng tài khoản này chưa được gán vai trò (học sinh, giáo viên hoặc phụ huynh). Việc này do nhà trường thực hiện, không phải lỗi của bạn.'**
  String get accountNotSetUpBody;

  /// No description provided for @accountNotSetUpContact.
  ///
  /// In vi, this message translates to:
  /// **'Hãy nhờ giáo viên hoặc quản trị viên của trường thiết lập giúp, rồi bấm \"Kiểm tra lại\".'**
  String get accountNotSetUpContact;

  /// No description provided for @accountSignedInAs.
  ///
  /// In vi, this message translates to:
  /// **'Đang đăng nhập bằng'**
  String get accountSignedInAs;

  /// No description provided for @accountSignedInAsSemantics.
  ///
  /// In vi, this message translates to:
  /// **'Đang đăng nhập bằng {email}'**
  String accountSignedInAsSemantics(String email);

  /// No description provided for @accountCheckAgain.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra lại'**
  String get accountCheckAgain;

  /// No description provided for @accountChecking.
  ///
  /// In vi, this message translates to:
  /// **'Đang kiểm tra…'**
  String get accountChecking;

  /// No description provided for @accountStillNotSetUp.
  ///
  /// In vi, this message translates to:
  /// **'Vẫn chưa được thiết lập.'**
  String get accountStillNotSetUp;

  /// No description provided for @accountCheckedAt.
  ///
  /// In vi, this message translates to:
  /// **'Đã kiểm tra lúc {time}'**
  String accountCheckedAt(String time);

  /// No description provided for @accountCheckFailedOffline.
  ///
  /// In vi, this message translates to:
  /// **'Chưa kiểm tra được vì không có kết nối mạng.'**
  String get accountCheckFailedOffline;

  /// No description provided for @signOut.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất'**
  String get signOut;

  /// No description provided for @signOutBusy.
  ///
  /// In vi, this message translates to:
  /// **'Đang đăng xuất…'**
  String get signOutBusy;

  /// No description provided for @signOutConfirmTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất khỏi EduBox?'**
  String get signOutConfirmTitle;

  /// No description provided for @signOutConfirmBody.
  ///
  /// In vi, this message translates to:
  /// **'Em sẽ cần nhập lại email và mật khẩu để vào lại.'**
  String get signOutConfirmBody;

  /// No description provided for @signOutOfflineWarning.
  ///
  /// In vi, this message translates to:
  /// **'Đang ngoại tuyến nên em sẽ chưa đăng nhập lại được cho tới khi có mạng.'**
  String get signOutOfflineWarning;

  /// No description provided for @signOutFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không đăng xuất được. Hãy thử lại.'**
  String get signOutFailed;

  /// No description provided for @cancel.
  ///
  /// In vi, this message translates to:
  /// **'Hủy'**
  String get cancel;

  /// No description provided for @navHome.
  ///
  /// In vi, this message translates to:
  /// **'Trang chủ'**
  String get navHome;

  /// No description provided for @navLibrary.
  ///
  /// In vi, this message translates to:
  /// **'Thư viện'**
  String get navLibrary;

  /// No description provided for @navTeacherOverview.
  ///
  /// In vi, this message translates to:
  /// **'Tổng quan'**
  String get navTeacherOverview;

  /// No description provided for @studentHomeGreeting.
  ///
  /// In vi, this message translates to:
  /// **'Chào {name}'**
  String studentHomeGreeting(String name);

  /// No description provided for @studentHomeGreetingNoName.
  ///
  /// In vi, this message translates to:
  /// **'Xin chào'**
  String get studentHomeGreetingNoName;

  /// No description provided for @studentHomeDateLine.
  ///
  /// In vi, this message translates to:
  /// **'{className} · {date}'**
  String studentHomeDateLine(String className, String date);

  /// No description provided for @studentHomeDateOnly.
  ///
  /// In vi, this message translates to:
  /// **'{date}'**
  String studentHomeDateOnly(String date);

  /// No description provided for @studentHomeLibraryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Mới thêm vào thư viện'**
  String get studentHomeLibraryTitle;

  /// No description provided for @studentHomeLibraryCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} tài liệu cho lớp em'**
  String studentHomeLibraryCount(int count);

  /// No description provided for @studentHomeOpenLibrary.
  ///
  /// In vi, this message translates to:
  /// **'Mở thư viện'**
  String get studentHomeOpenLibrary;

  /// No description provided for @studentHomeLoadingLibrary.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải thư viện'**
  String get studentHomeLoadingLibrary;

  /// No description provided for @studentHomeLibraryError.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được thư viện.'**
  String get studentHomeLibraryError;

  /// No description provided for @studentHomeLibraryOfflineNoCache.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được thư viện vì đang ngoại tuyến.'**
  String get studentHomeLibraryOfflineNoCache;

  /// No description provided for @studentHomeProfileError.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được thông tin tài khoản.'**
  String get studentHomeProfileError;

  /// No description provided for @studentNoClass.
  ///
  /// In vi, this message translates to:
  /// **'Em chưa được xếp vào lớp nào.'**
  String get studentNoClass;

  /// No description provided for @studentNoClassHint.
  ///
  /// In vi, this message translates to:
  /// **'Hãy nhờ giáo viên thêm em vào lớp.'**
  String get studentNoClassHint;

  /// No description provided for @libraryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thư viện'**
  String get libraryTitle;

  /// No description provided for @libraryTotal.
  ///
  /// In vi, this message translates to:
  /// **'{count} tài liệu'**
  String libraryTotal(int count);

  /// No description provided for @libraryListSemantics.
  ///
  /// In vi, this message translates to:
  /// **'Danh sách tài liệu'**
  String get libraryListSemantics;

  /// No description provided for @librarySubjectOther.
  ///
  /// In vi, this message translates to:
  /// **'Môn khác'**
  String get librarySubjectOther;

  /// No description provided for @libraryLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải thư viện'**
  String get libraryLoading;

  /// No description provided for @libraryEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Thư viện của lớp chưa có tài liệu nào.'**
  String get libraryEmpty;

  /// No description provided for @libraryEmptyHint.
  ///
  /// In vi, this message translates to:
  /// **'Khi giáo viên duyệt tài liệu, tài liệu sẽ hiện ở đây.'**
  String get libraryEmptyHint;

  /// No description provided for @libraryOfflineNoData.
  ///
  /// In vi, this message translates to:
  /// **'Máy chưa lưu danh sách tài liệu. Kết nối mạng để xem thư viện.'**
  String get libraryOfflineNoData;

  /// No description provided for @libraryLoadError.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được thư viện.'**
  String get libraryLoadError;

  /// No description provided for @libraryLoadErrorWithTime.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được thư viện. Cập nhật lần cuối {time}.'**
  String libraryLoadErrorWithTime(String time);

  /// No description provided for @libraryItemSemantics.
  ///
  /// In vi, this message translates to:
  /// **'{title}, {type}'**
  String libraryItemSemantics(String title, String type);

  /// No description provided for @contentTypeEbook.
  ///
  /// In vi, this message translates to:
  /// **'Sách'**
  String get contentTypeEbook;

  /// No description provided for @contentTypeVideo.
  ///
  /// In vi, this message translates to:
  /// **'Video'**
  String get contentTypeVideo;

  /// No description provided for @contentTypeExercise.
  ///
  /// In vi, this message translates to:
  /// **'Bài tập'**
  String get contentTypeExercise;

  /// No description provided for @contentRowSemantics.
  ///
  /// In vi, this message translates to:
  /// **'{title}, {type}, {subject}'**
  String contentRowSemantics(String title, String type, String subject);

  /// No description provided for @lastUpdatedAt.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật lần cuối {time}.'**
  String lastUpdatedAt(String time);

  /// No description provided for @networkOffline.
  ///
  /// In vi, this message translates to:
  /// **'Đang ngoại tuyến. Dữ liệu đã lưu vẫn hiển thị.'**
  String get networkOffline;

  /// No description provided for @networkOfflineStale.
  ///
  /// In vi, this message translates to:
  /// **'Đang ngoại tuyến. Dữ liệu hiển thị có thể chưa mới nhất.'**
  String get networkOfflineStale;

  /// No description provided for @networkReconnecting.
  ///
  /// In vi, this message translates to:
  /// **'Đã kết nối lại, đang cập nhật…'**
  String get networkReconnecting;

  /// No description provided for @accountMenuTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản'**
  String get accountMenuTooltip;

  /// No description provided for @parentMenuTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Tùy chọn'**
  String get parentMenuTooltip;

  /// No description provided for @teacherClassesTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lớp của tôi'**
  String get teacherClassesTitle;

  /// No description provided for @teacherClassesCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} lớp'**
  String teacherClassesCount(int count);

  /// No description provided for @classColumnName.
  ///
  /// In vi, this message translates to:
  /// **'Lớp'**
  String get classColumnName;

  /// No description provided for @classColumnGrade.
  ///
  /// In vi, this message translates to:
  /// **'Khối'**
  String get classColumnGrade;

  /// No description provided for @classColumnSubjects.
  ///
  /// In vi, this message translates to:
  /// **'Môn học'**
  String get classColumnSubjects;

  /// No description provided for @classColumnStudents.
  ///
  /// In vi, this message translates to:
  /// **'Học sinh'**
  String get classColumnStudents;

  /// No description provided for @classGradeValue.
  ///
  /// In vi, this message translates to:
  /// **'Khối {grade}'**
  String classGradeValue(int grade);

  /// No description provided for @classStudentCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} học sinh'**
  String classStudentCount(int count);

  /// No description provided for @classRowSemantics.
  ///
  /// In vi, this message translates to:
  /// **'{name}, khối {grade}, môn {subjects}, {count} học sinh'**
  String classRowSemantics(String name, int grade, String subjects, int count);

  /// No description provided for @valueMissing.
  ///
  /// In vi, this message translates to:
  /// **'-'**
  String get valueMissing;

  /// No description provided for @teacherRoleLabel.
  ///
  /// In vi, this message translates to:
  /// **'Giáo viên'**
  String get teacherRoleLabel;

  /// No description provided for @teacherClassesLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải danh sách lớp'**
  String get teacherClassesLoading;

  /// No description provided for @teacherClassesLoaded.
  ///
  /// In vi, this message translates to:
  /// **'Đã tải {count} lớp'**
  String teacherClassesLoaded(int count);

  /// No description provided for @teacherClassesEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Bạn chưa được phân công lớp nào. Liên hệ quản trị viên của trường để được thêm vào lớp.'**
  String get teacherClassesEmpty;

  /// No description provided for @teacherClassesOfflineNoData.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có danh sách lớp trên máy này. Danh sách sẽ hiện khi có mạng.'**
  String get teacherClassesOfflineNoData;

  /// No description provided for @teacherClassesError.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được danh sách lớp.'**
  String get teacherClassesError;

  /// No description provided for @teacherClassesStaleError.
  ///
  /// In vi, this message translates to:
  /// **'Không cập nhật được danh sách lớp. Cập nhật lần cuối {time}.'**
  String teacherClassesStaleError(String time);

  /// No description provided for @parentHomeStudentLabel.
  ///
  /// In vi, this message translates to:
  /// **'Học sinh'**
  String get parentHomeStudentLabel;

  /// No description provided for @parentHomeStudentSemantics.
  ///
  /// In vi, this message translates to:
  /// **'Học sinh: {name}'**
  String parentHomeStudentSemantics(String name);

  /// No description provided for @parentHomeNoChild.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản này chưa được liên kết với học sinh nào. Hãy liên hệ nhà trường để được hỗ trợ.'**
  String get parentHomeNoChild;

  /// No description provided for @parentHomeLoadError.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được thông tin học sinh.'**
  String get parentHomeLoadError;

  /// No description provided for @parentHomeOfflineNoData.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có thông tin học sinh trên máy này. Hãy kết nối mạng để tải.'**
  String get parentHomeOfflineNoData;

  /// No description provided for @navAssignments.
  ///
  /// In vi, this message translates to:
  /// **'Bài tập'**
  String get navAssignments;

  /// No description provided for @navTutor.
  ///
  /// In vi, this message translates to:
  /// **'Gia sư AI'**
  String get navTutor;

  /// No description provided for @navTeacherContent.
  ///
  /// In vi, this message translates to:
  /// **'Nội dung'**
  String get navTeacherContent;

  /// No description provided for @navTeacherAssignments.
  ///
  /// In vi, this message translates to:
  /// **'Bài tập'**
  String get navTeacherAssignments;

  /// No description provided for @navTeacherResults.
  ///
  /// In vi, this message translates to:
  /// **'Kết quả'**
  String get navTeacherResults;

  /// No description provided for @navTeacherChats.
  ///
  /// In vi, this message translates to:
  /// **'Trò chuyện AI'**
  String get navTeacherChats;

  /// No description provided for @save.
  ///
  /// In vi, this message translates to:
  /// **'Lưu'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In vi, this message translates to:
  /// **'Xóa'**
  String get delete;

  /// No description provided for @confirm.
  ///
  /// In vi, this message translates to:
  /// **'Đồng ý'**
  String get confirm;

  /// No description provided for @back.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại'**
  String get back;

  /// No description provided for @contentStatusDraft.
  ///
  /// In vi, this message translates to:
  /// **'Bản nháp'**
  String get contentStatusDraft;

  /// No description provided for @contentStatusApproved.
  ///
  /// In vi, this message translates to:
  /// **'Đã duyệt'**
  String get contentStatusApproved;

  /// No description provided for @contentIngestProcessing.
  ///
  /// In vi, this message translates to:
  /// **'Đang xử lý'**
  String get contentIngestProcessing;

  /// No description provided for @contentIngestReady.
  ///
  /// In vi, this message translates to:
  /// **'Chờ duyệt'**
  String get contentIngestReady;

  /// No description provided for @contentIngestRejected.
  ///
  /// In vi, this message translates to:
  /// **'Bị từ chối'**
  String get contentIngestRejected;

  /// No description provided for @teacherContentTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nội dung'**
  String get teacherContentTitle;

  /// No description provided for @teacherContentUpload.
  ///
  /// In vi, this message translates to:
  /// **'Tải lên'**
  String get teacherContentUpload;

  /// No description provided for @teacherContentEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có tài liệu. Tải lên tài liệu đầu tiên.'**
  String get teacherContentEmpty;

  /// No description provided for @teacherContentLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải nội dung'**
  String get teacherContentLoading;

  /// No description provided for @teacherContentError.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được nội dung.'**
  String get teacherContentError;

  /// No description provided for @teacherContentClassLabel.
  ///
  /// In vi, this message translates to:
  /// **'Lớp'**
  String get teacherContentClassLabel;

  /// No description provided for @teacherContentApprove.
  ///
  /// In vi, this message translates to:
  /// **'Duyệt'**
  String get teacherContentApprove;

  /// No description provided for @teacherContentApprovedSnack.
  ///
  /// In vi, this message translates to:
  /// **'Đã duyệt tài liệu.'**
  String get teacherContentApprovedSnack;

  /// No description provided for @teacherContentOfflineNoData.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có danh sách tài liệu trên máy. Kết nối mạng để tải.'**
  String get teacherContentOfflineNoData;

  /// No description provided for @contentUploadTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tải tài liệu lên'**
  String get contentUploadTitle;

  /// No description provided for @contentUploadPickFile.
  ///
  /// In vi, this message translates to:
  /// **'Chọn tệp'**
  String get contentUploadPickFile;

  /// No description provided for @contentUploadNoFile.
  ///
  /// In vi, this message translates to:
  /// **'Chưa chọn tệp'**
  String get contentUploadNoFile;

  /// No description provided for @contentUploadFormTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tên tài liệu'**
  String get contentUploadFormTitle;

  /// No description provided for @contentUploadSubject.
  ///
  /// In vi, this message translates to:
  /// **'Môn học'**
  String get contentUploadSubject;

  /// No description provided for @contentUploadGrade.
  ///
  /// In vi, this message translates to:
  /// **'Khối'**
  String get contentUploadGrade;

  /// No description provided for @contentUploadClass.
  ///
  /// In vi, this message translates to:
  /// **'Lớp'**
  String get contentUploadClass;

  /// No description provided for @contentUploadSubmit.
  ///
  /// In vi, this message translates to:
  /// **'Tải lên'**
  String get contentUploadSubmit;

  /// No description provided for @contentUploading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải lên… {percent}%'**
  String contentUploading(String percent);

  /// No description provided for @contentUploadFailed.
  ///
  /// In vi, this message translates to:
  /// **'Tải lên thất bại'**
  String get contentUploadFailed;

  /// No description provided for @contentUploadSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã tải lên'**
  String get contentUploadSuccess;

  /// No description provided for @contentUploadHint.
  ///
  /// In vi, this message translates to:
  /// **'PDF tối đa 20 MB, MP4 tối đa 120 MB.'**
  String get contentUploadHint;

  /// No description provided for @contentUploadFileRequired.
  ///
  /// In vi, this message translates to:
  /// **'Chọn một tệp PDF hoặc MP4.'**
  String get contentUploadFileRequired;

  /// No description provided for @contentUploadTitleRequired.
  ///
  /// In vi, this message translates to:
  /// **'Nhập tên tài liệu.'**
  String get contentUploadTitleRequired;

  /// No description provided for @contentUploadSubjectRequired.
  ///
  /// In vi, this message translates to:
  /// **'Nhập môn học.'**
  String get contentUploadSubjectRequired;

  /// No description provided for @contentUploadGradeRequired.
  ///
  /// In vi, this message translates to:
  /// **'Chọn khối.'**
  String get contentUploadGradeRequired;

  /// No description provided for @contentUploadClassRequired.
  ///
  /// In vi, this message translates to:
  /// **'Chọn lớp.'**
  String get contentUploadClassRequired;

  /// No description provided for @contentUploadRejected.
  ///
  /// In vi, this message translates to:
  /// **'Tệp bị từ chối: {reason}'**
  String contentUploadRejected(String reason);

  /// No description provided for @contentReplaceFile.
  ///
  /// In vi, this message translates to:
  /// **'Thay tệp khác'**
  String get contentReplaceFile;

  /// No description provided for @contentPreview.
  ///
  /// In vi, this message translates to:
  /// **'Xem trước'**
  String get contentPreview;

  /// No description provided for @contentFileInfo.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin tệp'**
  String get contentFileInfo;

  /// No description provided for @contentPageCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} trang'**
  String contentPageCount(int count);

  /// No description provided for @contentOpen.
  ///
  /// In vi, this message translates to:
  /// **'Mở'**
  String get contentOpen;

  /// No description provided for @contentDownload.
  ///
  /// In vi, this message translates to:
  /// **'Tải về máy'**
  String get contentDownload;

  /// No description provided for @contentDownloading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải về… {percent}%'**
  String contentDownloading(String percent);

  /// No description provided for @contentDownloaded.
  ///
  /// In vi, this message translates to:
  /// **'Đã tải về máy'**
  String get contentDownloaded;

  /// No description provided for @contentAvailableOffline.
  ///
  /// In vi, this message translates to:
  /// **'Đã tải về máy'**
  String get contentAvailableOffline;

  /// No description provided for @contentNeedsInternet.
  ///
  /// In vi, this message translates to:
  /// **'Cần kết nối mạng để mở'**
  String get contentNeedsInternet;

  /// No description provided for @contentDownloadFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không tải về được tài liệu.'**
  String get contentDownloadFailed;

  /// No description provided for @contentFileUnavailable.
  ///
  /// In vi, this message translates to:
  /// **'Tài liệu này chưa có tệp.'**
  String get contentFileUnavailable;

  /// No description provided for @contentDetailLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang mở tài liệu'**
  String get contentDetailLoading;

  /// No description provided for @contentDetailError.
  ///
  /// In vi, this message translates to:
  /// **'Không mở được tài liệu.'**
  String get contentDetailError;

  /// No description provided for @contentDetailOffline.
  ///
  /// In vi, this message translates to:
  /// **'Tài liệu này chưa được tải về máy.'**
  String get contentDetailOffline;

  /// No description provided for @contentNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy tài liệu.'**
  String get contentNotFound;

  /// No description provided for @ebookPageIndicator.
  ///
  /// In vi, this message translates to:
  /// **'Trang {page} / {total}'**
  String ebookPageIndicator(int page, int total);

  /// No description provided for @ebookPrevious.
  ///
  /// In vi, this message translates to:
  /// **'Trang trước'**
  String get ebookPrevious;

  /// No description provided for @ebookNext.
  ///
  /// In vi, this message translates to:
  /// **'Trang sau'**
  String get ebookNext;

  /// No description provided for @ebookLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang mở trang'**
  String get ebookLoading;

  /// No description provided for @ebookError.
  ///
  /// In vi, this message translates to:
  /// **'Không đọc được tệp PDF.'**
  String get ebookError;

  /// No description provided for @videoPlay.
  ///
  /// In vi, this message translates to:
  /// **'Phát'**
  String get videoPlay;

  /// No description provided for @videoPause.
  ///
  /// In vi, this message translates to:
  /// **'Tạm dừng'**
  String get videoPause;

  /// No description provided for @videoLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang mở video'**
  String get videoLoading;

  /// No description provided for @videoError.
  ///
  /// In vi, this message translates to:
  /// **'Không phát được video.'**
  String get videoError;

  /// No description provided for @videoDuration.
  ///
  /// In vi, this message translates to:
  /// **'Thời lượng {time}'**
  String videoDuration(String time);

  /// No description provided for @videoPosition.
  ///
  /// In vi, this message translates to:
  /// **'{position} / {duration}'**
  String videoPosition(String position, String duration);

  /// No description provided for @exerciseEditorTitle.
  ///
  /// In vi, this message translates to:
  /// **'Soạn bài tập'**
  String get exerciseEditorTitle;

  /// No description provided for @exerciseNew.
  ///
  /// In vi, this message translates to:
  /// **'Bài tập mới'**
  String get exerciseNew;

  /// No description provided for @exerciseTitleField.
  ///
  /// In vi, this message translates to:
  /// **'Tên bài tập'**
  String get exerciseTitleField;

  /// No description provided for @exerciseSubjectField.
  ///
  /// In vi, this message translates to:
  /// **'Môn học'**
  String get exerciseSubjectField;

  /// No description provided for @exerciseGradeField.
  ///
  /// In vi, this message translates to:
  /// **'Khối'**
  String get exerciseGradeField;

  /// No description provided for @exerciseClassField.
  ///
  /// In vi, this message translates to:
  /// **'Lớp'**
  String get exerciseClassField;

  /// No description provided for @exerciseLessonField.
  ///
  /// In vi, this message translates to:
  /// **'Bài học liên kết'**
  String get exerciseLessonField;

  /// No description provided for @exerciseQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Câu {number}'**
  String exerciseQuestion(int number);

  /// No description provided for @exerciseStem.
  ///
  /// In vi, this message translates to:
  /// **'Đề bài'**
  String get exerciseStem;

  /// No description provided for @exerciseOption.
  ///
  /// In vi, this message translates to:
  /// **'Lựa chọn {letter}'**
  String exerciseOption(String letter);

  /// No description provided for @exerciseCorrect.
  ///
  /// In vi, this message translates to:
  /// **'Đáp án đúng'**
  String get exerciseCorrect;

  /// No description provided for @exerciseMulti.
  ///
  /// In vi, this message translates to:
  /// **'Cho phép chọn nhiều đáp án'**
  String get exerciseMulti;

  /// No description provided for @exerciseAddQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Thêm câu hỏi'**
  String get exerciseAddQuestion;

  /// No description provided for @exerciseRemoveQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Xóa câu'**
  String get exerciseRemoveQuestion;

  /// No description provided for @exerciseSave.
  ///
  /// In vi, this message translates to:
  /// **'Lưu'**
  String get exerciseSave;

  /// No description provided for @exerciseSaved.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu bài tập.'**
  String get exerciseSaved;

  /// No description provided for @exerciseValidation.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra lại đề bài và đáp án.'**
  String get exerciseValidation;

  /// No description provided for @exerciseEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có bài tập nào.'**
  String get exerciseEmpty;

  /// No description provided for @exerciseLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải bài tập'**
  String get exerciseLoading;

  /// No description provided for @exerciseError.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được bài tập.'**
  String get exerciseError;

  /// No description provided for @exerciseQuestionsCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} câu'**
  String exerciseQuestionsCount(int count);

  /// No description provided for @exercisePick.
  ///
  /// In vi, this message translates to:
  /// **'Chọn bài tập'**
  String get exercisePick;

  /// No description provided for @exerciseEdit.
  ///
  /// In vi, this message translates to:
  /// **'Sửa bài tập'**
  String get exerciseEdit;

  /// No description provided for @exerciseAnswerKeyHint.
  ///
  /// In vi, this message translates to:
  /// **'Chọn vị trí đáp án đúng.'**
  String get exerciseAnswerKeyHint;

  /// No description provided for @exerciseNoneLesson.
  ///
  /// In vi, this message translates to:
  /// **'Không liên kết bài học'**
  String get exerciseNoneLesson;

  /// No description provided for @assignmentEditorTitle.
  ///
  /// In vi, this message translates to:
  /// **'Giao bài'**
  String get assignmentEditorTitle;

  /// No description provided for @assignmentType.
  ///
  /// In vi, this message translates to:
  /// **'Loại bài'**
  String get assignmentType;

  /// No description provided for @assignmentTypePractice.
  ///
  /// In vi, this message translates to:
  /// **'Luyện tập'**
  String get assignmentTypePractice;

  /// No description provided for @assignmentTypeTest.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra'**
  String get assignmentTypeTest;

  /// No description provided for @assignmentDue.
  ///
  /// In vi, this message translates to:
  /// **'Hạn nộp'**
  String get assignmentDue;

  /// No description provided for @assignmentNoDue.
  ///
  /// In vi, this message translates to:
  /// **'Không đặt hạn'**
  String get assignmentNoDue;

  /// No description provided for @assignmentTimeLimit.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian làm bài (phút)'**
  String get assignmentTimeLimit;

  /// No description provided for @assignmentClass.
  ///
  /// In vi, this message translates to:
  /// **'Lớp'**
  String get assignmentClass;

  /// No description provided for @assignmentExercise.
  ///
  /// In vi, this message translates to:
  /// **'Bài tập'**
  String get assignmentExercise;

  /// No description provided for @assignmentAssign.
  ///
  /// In vi, this message translates to:
  /// **'Giao bài'**
  String get assignmentAssign;

  /// No description provided for @assignmentSaved.
  ///
  /// In vi, this message translates to:
  /// **'Đã giao bài.'**
  String get assignmentSaved;

  /// No description provided for @assignmentDelete.
  ///
  /// In vi, this message translates to:
  /// **'Xóa bài giao'**
  String get assignmentDelete;

  /// No description provided for @assignmentDeleted.
  ///
  /// In vi, this message translates to:
  /// **'Đã xóa bài giao.'**
  String get assignmentDeleted;

  /// No description provided for @assignmentDeleteConfirmTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xóa bài giao?'**
  String get assignmentDeleteConfirmTitle;

  /// No description provided for @assignmentDeleteConfirmBody.
  ///
  /// In vi, this message translates to:
  /// **'Kết quả đã nộp của học sinh cũng sẽ bị xóa.'**
  String get assignmentDeleteConfirmBody;

  /// No description provided for @assignmentEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có bài tập nào được giao.'**
  String get assignmentEmpty;

  /// No description provided for @assignmentLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải bài tập'**
  String get assignmentLoading;

  /// No description provided for @assignmentError.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được danh sách bài tập.'**
  String get assignmentError;

  /// No description provided for @assignmentTeacherTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bài đã giao'**
  String get assignmentTeacherTitle;

  /// No description provided for @assignmentNew.
  ///
  /// In vi, this message translates to:
  /// **'Giao bài mới'**
  String get assignmentNew;

  /// No description provided for @assignmentSubmissions.
  ///
  /// In vi, this message translates to:
  /// **'{count} bài nộp'**
  String assignmentSubmissions(int count);

  /// No description provided for @assignmentGradedCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} đã chấm'**
  String assignmentGradedCount(int count);

  /// No description provided for @assignmentDueAt.
  ///
  /// In vi, this message translates to:
  /// **'Hạn {date}'**
  String assignmentDueAt(String date);

  /// No description provided for @assignmentNoDueAt.
  ///
  /// In vi, this message translates to:
  /// **'Không hạn'**
  String get assignmentNoDueAt;

  /// No description provided for @assignmentPickExercise.
  ///
  /// In vi, this message translates to:
  /// **'Chọn bài tập'**
  String get assignmentPickExercise;

  /// No description provided for @assignmentTimeLimitInvalid.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian phải lớn hơn 0.'**
  String get assignmentTimeLimitInvalid;

  /// No description provided for @assignmentTypeRequired.
  ///
  /// In vi, this message translates to:
  /// **'Chọn loại bài.'**
  String get assignmentTypeRequired;

  /// No description provided for @assignmentOfflineNoData.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có danh sách bài giao trên máy. Kết nối mạng để tải.'**
  String get assignmentOfflineNoData;

  /// No description provided for @assignmentsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bài tập'**
  String get assignmentsTitle;

  /// No description provided for @assignmentsNeedsAction.
  ///
  /// In vi, this message translates to:
  /// **'Cần làm'**
  String get assignmentsNeedsAction;

  /// No description provided for @assignmentsDone.
  ///
  /// In vi, this message translates to:
  /// **'Đã nộp'**
  String get assignmentsDone;

  /// No description provided for @assignmentsEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có bài tập nào được giao.'**
  String get assignmentsEmpty;

  /// No description provided for @assignmentsLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải bài tập'**
  String get assignmentsLoading;

  /// No description provided for @assignmentsError.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được danh sách bài tập.'**
  String get assignmentsError;

  /// No description provided for @assignmentsOfflineNoData.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có danh sách bài tập trên máy. Kết nối mạng để tải.'**
  String get assignmentsOfflineNoData;

  /// No description provided for @assignmentsDue.
  ///
  /// In vi, this message translates to:
  /// **'Hạn {date}'**
  String assignmentsDue(String date);

  /// No description provided for @assignmentsNoDue.
  ///
  /// In vi, this message translates to:
  /// **'Không hạn'**
  String get assignmentsNoDue;

  /// No description provided for @assignmentsOpen.
  ///
  /// In vi, this message translates to:
  /// **'Mở bài'**
  String get assignmentsOpen;

  /// No description provided for @assignmentsStart.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu'**
  String get assignmentsStart;

  /// No description provided for @assignmentsContinue.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục'**
  String get assignmentsContinue;

  /// No description provided for @assignmentsScore.
  ///
  /// In vi, this message translates to:
  /// **'Điểm {score}/{max}'**
  String assignmentsScore(String score, String max);

  /// No description provided for @assignmentsPendingSync.
  ///
  /// In vi, this message translates to:
  /// **'Bài nộp đang chờ đồng bộ'**
  String get assignmentsPendingSync;

  /// No description provided for @lessonTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bài học'**
  String get lessonTitle;

  /// No description provided for @lessonCompleted.
  ///
  /// In vi, this message translates to:
  /// **'Đã học xong'**
  String get lessonCompleted;

  /// No description provided for @lessonMarkComplete.
  ///
  /// In vi, this message translates to:
  /// **'Đánh dấu đã học xong'**
  String get lessonMarkComplete;

  /// No description provided for @lessonOpen.
  ///
  /// In vi, this message translates to:
  /// **'Mở bài học'**
  String get lessonOpen;

  /// No description provided for @lessonCompletedSnack.
  ///
  /// In vi, this message translates to:
  /// **'Đã đánh dấu bài học hoàn thành.'**
  String get lessonCompletedSnack;

  /// No description provided for @lessonNeedsInternet.
  ///
  /// In vi, this message translates to:
  /// **'Cần kết nối mạng để mở bài học.'**
  String get lessonNeedsInternet;

  /// No description provided for @lessonLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải bài học'**
  String get lessonLoading;

  /// No description provided for @lessonError.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được bài học.'**
  String get lessonError;

  /// No description provided for @exerciseStart.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu làm bài'**
  String get exerciseStart;

  /// No description provided for @exerciseSubmit.
  ///
  /// In vi, this message translates to:
  /// **'Nộp bài'**
  String get exerciseSubmit;

  /// No description provided for @exerciseSubmitting.
  ///
  /// In vi, this message translates to:
  /// **'Đang nộp…'**
  String get exerciseSubmitting;

  /// No description provided for @exerciseConfirmTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nộp bài?'**
  String get exerciseConfirmTitle;

  /// No description provided for @exerciseConfirmBody.
  ///
  /// In vi, this message translates to:
  /// **'Em còn {count} câu chưa trả lời. Vẫn nộp?'**
  String exerciseConfirmBody(int count);

  /// No description provided for @exerciseConfirmSubmit.
  ///
  /// In vi, this message translates to:
  /// **'Nộp'**
  String get exerciseConfirmSubmit;

  /// No description provided for @exerciseQuestionOf.
  ///
  /// In vi, this message translates to:
  /// **'Câu {current} / {total}'**
  String exerciseQuestionOf(int current, int total);

  /// No description provided for @exerciseUnanswered.
  ///
  /// In vi, this message translates to:
  /// **'Chưa trả lời'**
  String get exerciseUnanswered;

  /// No description provided for @exerciseAnswered.
  ///
  /// In vi, this message translates to:
  /// **'Đã trả lời'**
  String get exerciseAnswered;

  /// No description provided for @exerciseOptionsSemantics.
  ///
  /// In vi, this message translates to:
  /// **'Câu {number}, lựa chọn {letter}'**
  String exerciseOptionsSemantics(int number, String letter);

  /// No description provided for @exerciseSavedOffline.
  ///
  /// In vi, this message translates to:
  /// **'Bài làm đã lưu trên máy.'**
  String get exerciseSavedOffline;

  /// No description provided for @exerciseScreenLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang mở bài tập'**
  String get exerciseScreenLoading;

  /// No description provided for @exerciseScreenError.
  ///
  /// In vi, this message translates to:
  /// **'Không mở được bài tập.'**
  String get exerciseScreenError;

  /// No description provided for @exerciseOfflineNoData.
  ///
  /// In vi, this message translates to:
  /// **'Bài tập này chưa được tải về máy.'**
  String get exerciseOfflineNoData;

  /// No description provided for @exerciseOptionsHint.
  ///
  /// In vi, this message translates to:
  /// **'Chọn một đáp án'**
  String get exerciseOptionsHint;

  /// No description provided for @exerciseQuestionMultiHint.
  ///
  /// In vi, this message translates to:
  /// **'Có thể chọn nhiều đáp án.'**
  String get exerciseQuestionMultiHint;

  /// No description provided for @resultTitle.
  ///
  /// In vi, this message translates to:
  /// **'Kết quả'**
  String get resultTitle;

  /// No description provided for @resultScore.
  ///
  /// In vi, this message translates to:
  /// **'Điểm'**
  String get resultScore;

  /// No description provided for @resultScoreValue.
  ///
  /// In vi, this message translates to:
  /// **'{score}/{max}'**
  String resultScoreValue(String score, String max);

  /// No description provided for @resultPending.
  ///
  /// In vi, this message translates to:
  /// **'Bài nộp đang chờ đồng bộ'**
  String get resultPending;

  /// No description provided for @resultSubmitted.
  ///
  /// In vi, this message translates to:
  /// **'Đã nộp, đang chờ chấm'**
  String get resultSubmitted;

  /// No description provided for @resultGradingFailed.
  ///
  /// In vi, this message translates to:
  /// **'Chưa chấm được'**
  String get resultGradingFailed;

  /// No description provided for @resultBack.
  ///
  /// In vi, this message translates to:
  /// **'Về danh sách bài tập'**
  String get resultBack;

  /// No description provided for @resultCorrectCount.
  ///
  /// In vi, this message translates to:
  /// **'{correct}/{total} câu đúng'**
  String resultCorrectCount(int correct, int total);

  /// No description provided for @resultLate.
  ///
  /// In vi, this message translates to:
  /// **'Nộp muộn'**
  String get resultLate;

  /// No description provided for @resultLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải kết quả'**
  String get resultLoading;

  /// No description provided for @resultError.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được kết quả.'**
  String get resultError;

  /// No description provided for @statusToDo.
  ///
  /// In vi, this message translates to:
  /// **'Chưa làm'**
  String get statusToDo;

  /// No description provided for @statusInProgress.
  ///
  /// In vi, this message translates to:
  /// **'Đang làm bài'**
  String get statusInProgress;

  /// No description provided for @statusSubmittedAwaitingGrade.
  ///
  /// In vi, this message translates to:
  /// **'Đã nộp, đang chờ chấm'**
  String get statusSubmittedAwaitingGrade;

  /// No description provided for @statusPendingSync.
  ///
  /// In vi, this message translates to:
  /// **'Chờ đồng bộ'**
  String get statusPendingSync;

  /// No description provided for @statusGraded.
  ///
  /// In vi, this message translates to:
  /// **'Đã chấm'**
  String get statusGraded;

  /// No description provided for @statusLate.
  ///
  /// In vi, this message translates to:
  /// **'Nộp muộn'**
  String get statusLate;

  /// No description provided for @statusGradingFailed.
  ///
  /// In vi, this message translates to:
  /// **'Chưa chấm được'**
  String get statusGradingFailed;

  /// No description provided for @statusLessonDone.
  ///
  /// In vi, this message translates to:
  /// **'Đã học xong'**
  String get statusLessonDone;

  /// No description provided for @statusDraft.
  ///
  /// In vi, this message translates to:
  /// **'Bản nháp'**
  String get statusDraft;

  /// No description provided for @statusProcessing.
  ///
  /// In vi, this message translates to:
  /// **'Đang xử lý'**
  String get statusProcessing;

  /// No description provided for @statusAwaitingApproval.
  ///
  /// In vi, this message translates to:
  /// **'Chờ duyệt'**
  String get statusAwaitingApproval;

  /// No description provided for @statusApproved.
  ///
  /// In vi, this message translates to:
  /// **'Đã duyệt'**
  String get statusApproved;

  /// No description provided for @statusRejected.
  ///
  /// In vi, this message translates to:
  /// **'Bị từ chối'**
  String get statusRejected;

  /// No description provided for @resultsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Kết quả'**
  String get resultsTitle;

  /// No description provided for @resultsClass.
  ///
  /// In vi, this message translates to:
  /// **'Lớp'**
  String get resultsClass;

  /// No description provided for @resultsEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có bài nộp nào.'**
  String get resultsEmpty;

  /// No description provided for @resultsLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải kết quả'**
  String get resultsLoading;

  /// No description provided for @resultsError.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được kết quả.'**
  String get resultsError;

  /// No description provided for @resultsSummary.
  ///
  /// In vi, this message translates to:
  /// **'{submitted} trên {total} em đã nộp · {late} bài nộp muộn'**
  String resultsSummary(int submitted, int total, int late);

  /// No description provided for @resultsRegrade.
  ///
  /// In vi, this message translates to:
  /// **'Chấm lại'**
  String get resultsRegrade;

  /// No description provided for @resultsRegraded.
  ///
  /// In vi, this message translates to:
  /// **'Đã chấm lại.'**
  String get resultsRegraded;

  /// No description provided for @resultsCellNoSubmission.
  ///
  /// In vi, this message translates to:
  /// **'–'**
  String get resultsCellNoSubmission;

  /// No description provided for @tutorTitle.
  ///
  /// In vi, this message translates to:
  /// **'Gia sư AI'**
  String get tutorTitle;

  /// No description provided for @tutorNewChat.
  ///
  /// In vi, this message translates to:
  /// **'Cuộc trò chuyện mới'**
  String get tutorNewChat;

  /// No description provided for @tutorConversations.
  ///
  /// In vi, this message translates to:
  /// **'Cuộc trò chuyện'**
  String get tutorConversations;

  /// No description provided for @tutorNoConversations.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có cuộc trò chuyện nào.'**
  String get tutorNoConversations;

  /// No description provided for @tutorSubject.
  ///
  /// In vi, this message translates to:
  /// **'Môn học'**
  String get tutorSubject;

  /// No description provided for @tutorMessageHint.
  ///
  /// In vi, this message translates to:
  /// **'Hỏi gia sư về bài học…'**
  String get tutorMessageHint;

  /// No description provided for @tutorSend.
  ///
  /// In vi, this message translates to:
  /// **'Gửi'**
  String get tutorSend;

  /// No description provided for @tutorTutorLabel.
  ///
  /// In vi, this message translates to:
  /// **'Gia sư'**
  String get tutorTutorLabel;

  /// No description provided for @tutorStudentLabel.
  ///
  /// In vi, this message translates to:
  /// **'Em'**
  String get tutorStudentLabel;

  /// No description provided for @tutorThinking.
  ///
  /// In vi, this message translates to:
  /// **'Gia sư đang trả lời…'**
  String get tutorThinking;

  /// No description provided for @tutorNeedsInternet.
  ///
  /// In vi, this message translates to:
  /// **'Gia sư AI cần kết nối mạng'**
  String get tutorNeedsInternet;

  /// No description provided for @tutorDailyLimit.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã dùng hết lượt hỏi hôm nay'**
  String get tutorDailyLimit;

  /// No description provided for @tutorDailyLimitHint.
  ///
  /// In vi, this message translates to:
  /// **'Lượt hỏi mới từ 0:00.'**
  String get tutorDailyLimitHint;

  /// No description provided for @tutorPaused.
  ///
  /// In vi, this message translates to:
  /// **'Gia sư AI tạm dừng trong lúc làm bài kiểm tra'**
  String get tutorPaused;

  /// No description provided for @tutorPausedHint.
  ///
  /// In vi, this message translates to:
  /// **'Sẽ mở lại khi em nộp bài kiểm tra.'**
  String get tutorPausedHint;

  /// No description provided for @tutorError.
  ///
  /// In vi, this message translates to:
  /// **'Gia sư chưa trả lời được. Thử lại nhé.'**
  String get tutorError;

  /// No description provided for @tutorSubjectNotAllowed.
  ///
  /// In vi, this message translates to:
  /// **'Môn này ngoài phạm vi của gia sư.'**
  String get tutorSubjectNotAllowed;

  /// No description provided for @tutorEmptySubject.
  ///
  /// In vi, this message translates to:
  /// **'Chọn môn học trước khi hỏi.'**
  String get tutorEmptySubject;

  /// No description provided for @tutorLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang mở gia sư'**
  String get tutorLoading;

  /// No description provided for @tutorLoadError.
  ///
  /// In vi, this message translates to:
  /// **'Không mở được gia sư.'**
  String get tutorLoadError;

  /// No description provided for @tutorChatLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải cuộc trò chuyện'**
  String get tutorChatLoading;

  /// No description provided for @tutorChatError.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được cuộc trò chuyện.'**
  String get tutorChatError;

  /// No description provided for @tutorOfflineNoData.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có cuộc trò chuyện nào trên máy.'**
  String get tutorOfflineNoData;

  /// No description provided for @tutorReadOnly.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ xem'**
  String get tutorReadOnly;

  /// No description provided for @tutorClassChatsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Trò chuyện AI của học sinh'**
  String get tutorClassChatsTitle;

  /// No description provided for @tutorPickStudent.
  ///
  /// In vi, this message translates to:
  /// **'Chọn học sinh'**
  String get tutorPickStudent;

  /// No description provided for @tutorNoChatsForStudent.
  ///
  /// In vi, this message translates to:
  /// **'Học sinh này chưa trò chuyện với gia sư.'**
  String get tutorNoChatsForStudent;

  /// No description provided for @tutorStudentPicker.
  ///
  /// In vi, this message translates to:
  /// **'Học sinh'**
  String get tutorStudentPicker;

  /// No description provided for @testLobbyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bài kiểm tra'**
  String get testLobbyTitle;

  /// No description provided for @testRules.
  ///
  /// In vi, this message translates to:
  /// **'Quy định'**
  String get testRules;

  /// No description provided for @testRulesBody.
  ///
  /// In vi, this message translates to:
  /// **'Bài kiểm tra bắt đầu tính giờ ngay khi em bấm Bắt đầu. Hết giờ, bài sẽ tự nộp.'**
  String get testRulesBody;

  /// No description provided for @testTimeLimit.
  ///
  /// In vi, this message translates to:
  /// **'{minutes} phút'**
  String testTimeLimit(int minutes);

  /// No description provided for @testStart.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu'**
  String get testStart;

  /// No description provided for @testNeedsInternet.
  ///
  /// In vi, this message translates to:
  /// **'Cần kết nối mạng để bắt đầu bài kiểm tra'**
  String get testNeedsInternet;

  /// No description provided for @testStarting.
  ///
  /// In vi, this message translates to:
  /// **'Đang bắt đầu…'**
  String get testStarting;

  /// No description provided for @testStartFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không bắt đầu được bài kiểm tra.'**
  String get testStartFailed;

  /// No description provided for @testRoomTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đang làm bài'**
  String get testRoomTitle;

  /// No description provided for @testRemaining.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian còn lại'**
  String get testRemaining;

  /// No description provided for @testUnderMinute.
  ///
  /// In vi, this message translates to:
  /// **'Còn dưới 1 phút'**
  String get testUnderMinute;

  /// No description provided for @testAutoSubmitted.
  ///
  /// In vi, this message translates to:
  /// **'Hết giờ, bài đã được nộp.'**
  String get testAutoSubmitted;

  /// No description provided for @testSubmittedTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đã nộp bài'**
  String get testSubmittedTitle;

  /// No description provided for @testSubmittedBody.
  ///
  /// In vi, this message translates to:
  /// **'Bài làm đã được ghi nhận.'**
  String get testSubmittedBody;

  /// No description provided for @testScoreLabel.
  ///
  /// In vi, this message translates to:
  /// **'Điểm'**
  String get testScoreLabel;

  /// No description provided for @testSubmittedGraded.
  ///
  /// In vi, this message translates to:
  /// **'Bài của em đã được chấm.'**
  String get testSubmittedGraded;

  /// No description provided for @testSubmittedPending.
  ///
  /// In vi, this message translates to:
  /// **'Bài của em đang chờ đồng bộ.'**
  String get testSubmittedPending;

  /// No description provided for @testSubmittedLate.
  ///
  /// In vi, this message translates to:
  /// **'Bài nộp muộn'**
  String get testSubmittedLate;

  /// No description provided for @testBackToAssignments.
  ///
  /// In vi, this message translates to:
  /// **'Về danh sách bài tập'**
  String get testBackToAssignments;

  /// No description provided for @testConfirmSubmit.
  ///
  /// In vi, this message translates to:
  /// **'Nộp bài kiểm tra?'**
  String get testConfirmSubmit;

  /// No description provided for @testSubmittedState.
  ///
  /// In vi, this message translates to:
  /// **'Đã nộp'**
  String get testSubmittedState;

  /// No description provided for @parentSummaryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Sổ liên lạc'**
  String get parentSummaryTitle;

  /// No description provided for @parentResults.
  ///
  /// In vi, this message translates to:
  /// **'Kết quả học tập'**
  String get parentResults;

  /// No description provided for @parentNoResults.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có kết quả nào.'**
  String get parentNoResults;

  /// No description provided for @parentAiChats.
  ///
  /// In vi, this message translates to:
  /// **'Trò chuyện với gia sư AI'**
  String get parentAiChats;

  /// No description provided for @parentNoChats.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có cuộc trò chuyện nào.'**
  String get parentNoChats;

  /// No description provided for @parentSummaryLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải sổ liên lạc'**
  String get parentSummaryLoading;

  /// No description provided for @parentSummaryError.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được sổ liên lạc.'**
  String get parentSummaryError;

  /// No description provided for @parentSummaryOfflineNoData.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có sổ liên lạc trên máy. Kết nối mạng để tải.'**
  String get parentSummaryOfflineNoData;

  /// No description provided for @parentReadOnly.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ xem'**
  String get parentReadOnly;

  /// No description provided for @parentChatTitle.
  ///
  /// In vi, this message translates to:
  /// **'Trò chuyện của con'**
  String get parentChatTitle;

  /// No description provided for @teacherChatReviewTitle.
  ///
  /// In vi, this message translates to:
  /// **'Trò chuyện AI'**
  String get teacherChatReviewTitle;

  /// No description provided for @teacherChatReviewEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có học sinh nào trong lớp.'**
  String get teacherChatReviewEmpty;

  /// No description provided for @teacherChatReviewPick.
  ///
  /// In vi, this message translates to:
  /// **'Chọn học sinh để xem trò chuyện.'**
  String get teacherChatReviewPick;

  /// No description provided for @teacherChatReviewLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải trò chuyện'**
  String get teacherChatReviewLoading;

  /// No description provided for @teacherChatReviewError.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được trò chuyện.'**
  String get teacherChatReviewError;

  /// No description provided for @teacherChatReviewHint.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ xem, không thể thay đổi.'**
  String get teacherChatReviewHint;

  /// No description provided for @aiChatMessageCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} tin nhắn'**
  String aiChatMessageCount(int count);

  /// No description provided for @contentUploadingSimple.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải lên…'**
  String get contentUploadingSimple;

  /// No description provided for @statusSemantics.
  ///
  /// In vi, this message translates to:
  /// **'Trạng thái: {word}'**
  String statusSemantics(String word);

  /// No description provided for @contentDownloadingSimple.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải về…'**
  String get contentDownloadingSimple;

  /// No description provided for @exercisesTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bài tập'**
  String get exercisesTitle;

  /// No description provided for @exerciseRowMeta.
  ///
  /// In vi, this message translates to:
  /// **'{subject} · {count}'**
  String exerciseRowMeta(String subject, String count);

  /// No description provided for @assignmentCounts.
  ///
  /// In vi, this message translates to:
  /// **'{submissions} · {graded}'**
  String assignmentCounts(String submissions, String graded);

  /// No description provided for @chatRowMeta.
  ///
  /// In vi, this message translates to:
  /// **'{subject} · {date}'**
  String chatRowMeta(String subject, String date);

  /// No description provided for @assignmentDefaultMinutes.
  ///
  /// In vi, this message translates to:
  /// **'15'**
  String get assignmentDefaultMinutes;

  /// No description provided for @contentPunctuation.
  ///
  /// In vi, this message translates to:
  /// **'·'**
  String get contentPunctuation;

  /// No description provided for @exerciseRetry.
  ///
  /// In vi, this message translates to:
  /// **'Làm lại'**
  String get exerciseRetry;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
