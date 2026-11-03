// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appName => 'EduBox';

  @override
  String get appOpening => 'Đang mở EduBox…';

  @override
  String get appMarkSemantics => 'EduBox';

  @override
  String get signInTitle => 'Đăng nhập';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Mật khẩu';

  @override
  String get signInButton => 'Đăng nhập';

  @override
  String get signInSubmitting => 'Đang đăng nhập…';

  @override
  String get showPassword => 'Hiện mật khẩu';

  @override
  String get hidePassword => 'Ẩn mật khẩu';

  @override
  String get emailRequired => 'Vui lòng nhập email';

  @override
  String get emailInvalid => 'Email chưa đúng định dạng';

  @override
  String get passwordRequired => 'Vui lòng nhập mật khẩu';

  @override
  String get signInWrongCredentials => 'Email hoặc mật khẩu không đúng';

  @override
  String get backendUnreachable => 'Không kết nối được với EduBox';

  @override
  String get backendUnreachableHint => 'Kiểm tra kết nối mạng rồi thử lại.';

  @override
  String get retry => 'Thử lại';

  @override
  String get retrying => 'Đang thử lại…';

  @override
  String get signInTooManyAttempts =>
      'Đã thử quá nhiều lần. Vui lòng đợi vài phút rồi thử lại.';

  @override
  String get signInAccountDisabled =>
      'Tài khoản này đang bị tạm khóa. Vui lòng liên hệ nhà trường.';

  @override
  String get signInUnknownError => 'Không đăng nhập được. Vui lòng thử lại.';

  @override
  String get signInHelp =>
      'Quên mật khẩu hoặc chưa có tài khoản? Vui lòng liên hệ nhà trường.';

  @override
  String get accountNotSetUp => 'Tài khoản chưa được thiết lập';

  @override
  String get accountNotSetUpBody =>
      'Bạn đã đăng nhập đúng, nhưng tài khoản này chưa được gán vai trò (học sinh, giáo viên hoặc phụ huynh). Việc này do nhà trường thực hiện, không phải lỗi của bạn.';

  @override
  String get accountNotSetUpContact =>
      'Hãy nhờ giáo viên hoặc quản trị viên của trường thiết lập giúp, rồi bấm \"Kiểm tra lại\".';

  @override
  String get accountSignedInAs => 'Đang đăng nhập bằng';

  @override
  String accountSignedInAsSemantics(String email) {
    return 'Đang đăng nhập bằng $email';
  }

  @override
  String get accountCheckAgain => 'Kiểm tra lại';

  @override
  String get accountChecking => 'Đang kiểm tra…';

  @override
  String get accountStillNotSetUp => 'Vẫn chưa được thiết lập.';

  @override
  String accountCheckedAt(String time) {
    return 'Đã kiểm tra lúc $time';
  }

  @override
  String get accountCheckFailedOffline =>
      'Chưa kiểm tra được vì không có kết nối mạng.';

  @override
  String get signOut => 'Đăng xuất';

  @override
  String get signOutBusy => 'Đang đăng xuất…';

  @override
  String get signOutConfirmTitle => 'Đăng xuất khỏi EduBox?';

  @override
  String get signOutConfirmBody =>
      'Em sẽ cần nhập lại email và mật khẩu để vào lại.';

  @override
  String get signOutOfflineWarning =>
      'Đang ngoại tuyến nên em sẽ chưa đăng nhập lại được cho tới khi có mạng.';

  @override
  String get signOutFailed => 'Không đăng xuất được. Hãy thử lại.';

  @override
  String get cancel => 'Hủy';

  @override
  String get navHome => 'Trang chủ';

  @override
  String get navLibrary => 'Thư viện';

  @override
  String get navTeacherOverview => 'Tổng quan';

  @override
  String studentHomeGreeting(String name) {
    return 'Chào $name';
  }

  @override
  String get studentHomeGreetingNoName => 'Xin chào';

  @override
  String studentHomeDateLine(String className, String date) {
    return '$className · $date';
  }

  @override
  String studentHomeDateOnly(String date) {
    return '$date';
  }

  @override
  String get studentHomeLibraryTitle => 'Mới thêm vào thư viện';

  @override
  String studentHomeLibraryCount(int count) {
    return '$count tài liệu cho lớp em';
  }

  @override
  String get studentHomeOpenLibrary => 'Mở thư viện';

  @override
  String get studentHomeLoadingLibrary => 'Đang tải thư viện';

  @override
  String get studentHomeLibraryError => 'Không tải được thư viện.';

  @override
  String get studentHomeLibraryOfflineNoCache =>
      'Không tải được thư viện vì đang ngoại tuyến.';

  @override
  String get studentHomeProfileError => 'Không tải được thông tin tài khoản.';

  @override
  String get studentNoClass => 'Em chưa được xếp vào lớp nào.';

  @override
  String get studentNoClassHint => 'Hãy nhờ giáo viên thêm em vào lớp.';

  @override
  String get libraryTitle => 'Thư viện';

  @override
  String libraryTotal(int count) {
    return '$count tài liệu';
  }

  @override
  String get libraryListSemantics => 'Danh sách tài liệu';

  @override
  String get librarySubjectOther => 'Môn khác';

  @override
  String get libraryLoading => 'Đang tải thư viện';

  @override
  String get libraryEmpty => 'Thư viện của lớp chưa có tài liệu nào.';

  @override
  String get libraryEmptyHint =>
      'Khi giáo viên duyệt tài liệu, tài liệu sẽ hiện ở đây.';

  @override
  String get libraryOfflineNoData =>
      'Máy chưa lưu danh sách tài liệu. Kết nối mạng để xem thư viện.';

  @override
  String get libraryLoadError => 'Không tải được thư viện.';

  @override
  String libraryLoadErrorWithTime(String time) {
    return 'Không tải được thư viện. Cập nhật lần cuối $time.';
  }

  @override
  String libraryItemSemantics(String title, String type) {
    return '$title, $type';
  }

  @override
  String get contentTypeEbook => 'Sách';

  @override
  String get contentTypeVideo => 'Video';

  @override
  String get contentTypeExercise => 'Bài tập';

  @override
  String contentRowSemantics(String title, String type, String subject) {
    return '$title, $type, $subject';
  }

  @override
  String lastUpdatedAt(String time) {
    return 'Cập nhật lần cuối $time.';
  }

  @override
  String get networkOffline => 'Đang ngoại tuyến. Dữ liệu đã lưu vẫn hiển thị.';

  @override
  String get networkOfflineStale =>
      'Đang ngoại tuyến. Dữ liệu hiển thị có thể chưa mới nhất.';

  @override
  String get networkReconnecting => 'Đã kết nối lại, đang cập nhật…';

  @override
  String get accountMenuTooltip => 'Tài khoản';

  @override
  String get parentMenuTooltip => 'Tùy chọn';

  @override
  String get teacherClassesTitle => 'Lớp của tôi';

  @override
  String teacherClassesCount(int count) {
    return '$count lớp';
  }

  @override
  String get classColumnName => 'Lớp';

  @override
  String get classColumnGrade => 'Khối';

  @override
  String get classColumnSubjects => 'Môn học';

  @override
  String get classColumnStudents => 'Học sinh';

  @override
  String classGradeValue(int grade) {
    return 'Khối $grade';
  }

  @override
  String classStudentCount(int count) {
    return '$count học sinh';
  }

  @override
  String classRowSemantics(String name, int grade, String subjects, int count) {
    return '$name, khối $grade, môn $subjects, $count học sinh';
  }

  @override
  String get valueMissing => '-';

  @override
  String get teacherRoleLabel => 'Giáo viên';

  @override
  String get teacherClassesLoading => 'Đang tải danh sách lớp';

  @override
  String teacherClassesLoaded(int count) {
    return 'Đã tải $count lớp';
  }

  @override
  String get teacherClassesEmpty =>
      'Bạn chưa được phân công lớp nào. Liên hệ quản trị viên của trường để được thêm vào lớp.';

  @override
  String get teacherClassesOfflineNoData =>
      'Chưa có danh sách lớp trên máy này. Danh sách sẽ hiện khi có mạng.';

  @override
  String get teacherClassesError => 'Không tải được danh sách lớp.';

  @override
  String teacherClassesStaleError(String time) {
    return 'Không cập nhật được danh sách lớp. Cập nhật lần cuối $time.';
  }

  @override
  String get parentHomeStudentLabel => 'Học sinh';

  @override
  String parentHomeStudentSemantics(String name) {
    return 'Học sinh: $name';
  }

  @override
  String get parentHomeNoChild =>
      'Tài khoản này chưa được liên kết với học sinh nào. Hãy liên hệ nhà trường để được hỗ trợ.';

  @override
  String get parentHomeLoadError => 'Không tải được thông tin học sinh.';

  @override
  String get parentHomeOfflineNoData =>
      'Chưa có thông tin học sinh trên máy này. Hãy kết nối mạng để tải.';

  @override
  String get navAssignments => 'Bài tập';

  @override
  String get navTutor => 'Gia sư AI';

  @override
  String get navTeacherContent => 'Nội dung';

  @override
  String get navTeacherAssignments => 'Bài tập';

  @override
  String get navTeacherResults => 'Kết quả';

  @override
  String get navTeacherChats => 'Trò chuyện AI';

  @override
  String get save => 'Lưu';

  @override
  String get delete => 'Xóa';

  @override
  String get confirm => 'Đồng ý';

  @override
  String get back => 'Quay lại';

  @override
  String get contentStatusDraft => 'Bản nháp';

  @override
  String get contentStatusApproved => 'Đã duyệt';

  @override
  String get contentIngestProcessing => 'Đang xử lý';

  @override
  String get contentIngestReady => 'Chờ duyệt';

  @override
  String get contentIngestRejected => 'Bị từ chối';

  @override
  String get teacherContentTitle => 'Nội dung';

  @override
  String get teacherContentUpload => 'Tải lên';

  @override
  String get teacherContentEmpty =>
      'Chưa có tài liệu. Tải lên tài liệu đầu tiên.';

  @override
  String get teacherContentLoading => 'Đang tải nội dung';

  @override
  String get teacherContentError => 'Không tải được nội dung.';

  @override
  String get teacherContentClassLabel => 'Lớp';

  @override
  String get teacherContentApprove => 'Duyệt';

  @override
  String get teacherContentApprovedSnack => 'Đã duyệt tài liệu.';

  @override
  String get teacherContentOfflineNoData =>
      'Chưa có danh sách tài liệu trên máy. Kết nối mạng để tải.';

  @override
  String get contentUploadTitle => 'Tải tài liệu lên';

  @override
  String get contentUploadPickFile => 'Chọn tệp';

  @override
  String get contentUploadNoFile => 'Chưa chọn tệp';

  @override
  String get contentUploadFormTitle => 'Tên tài liệu';

  @override
  String get contentUploadSubject => 'Môn học';

  @override
  String get contentUploadGrade => 'Khối';

  @override
  String get contentUploadClass => 'Lớp';

  @override
  String get contentUploadSubmit => 'Tải lên';

  @override
  String contentUploading(String percent) {
    return 'Đang tải lên… $percent%';
  }

  @override
  String get contentUploadFailed => 'Tải lên thất bại';

  @override
  String get contentUploadSuccess => 'Đã tải lên';

  @override
  String get contentUploadHint => 'PDF tối đa 20 MB, MP4 tối đa 120 MB.';

  @override
  String get contentUploadFileRequired => 'Chọn một tệp PDF hoặc MP4.';

  @override
  String get contentUploadTitleRequired => 'Nhập tên tài liệu.';

  @override
  String get contentUploadSubjectRequired => 'Nhập môn học.';

  @override
  String get contentUploadGradeRequired => 'Chọn khối.';

  @override
  String get contentUploadClassRequired => 'Chọn lớp.';

  @override
  String contentUploadRejected(String reason) {
    return 'Tệp bị từ chối: $reason';
  }

  @override
  String get contentReplaceFile => 'Thay tệp khác';

  @override
  String get contentPreview => 'Xem trước';

  @override
  String get contentFileInfo => 'Thông tin tệp';

  @override
  String contentPageCount(int count) {
    return '$count trang';
  }

  @override
  String get contentOpen => 'Mở';

  @override
  String get contentDownload => 'Tải về máy';

  @override
  String contentDownloading(String percent) {
    return 'Đang tải về… $percent%';
  }

  @override
  String get contentDownloaded => 'Đã tải về máy';

  @override
  String get contentAvailableOffline => 'Đã tải về máy';

  @override
  String get contentNeedsInternet => 'Cần kết nối mạng để mở';

  @override
  String get contentDownloadFailed => 'Không tải về được tài liệu.';

  @override
  String get contentFileUnavailable => 'Tài liệu này chưa có tệp.';

  @override
  String get contentDetailLoading => 'Đang mở tài liệu';

  @override
  String get contentDetailError => 'Không mở được tài liệu.';

  @override
  String get contentDetailOffline => 'Tài liệu này chưa được tải về máy.';

  @override
  String get contentNotFound => 'Không tìm thấy tài liệu.';

  @override
  String ebookPageIndicator(int page, int total) {
    return 'Trang $page / $total';
  }

  @override
  String get ebookPrevious => 'Trang trước';

  @override
  String get ebookNext => 'Trang sau';

  @override
  String get ebookLoading => 'Đang mở trang';

  @override
  String get ebookError => 'Không đọc được tệp PDF.';

  @override
  String get videoPlay => 'Phát';

  @override
  String get videoPause => 'Tạm dừng';

  @override
  String get videoLoading => 'Đang mở video';

  @override
  String get videoError => 'Không phát được video.';

  @override
  String videoDuration(String time) {
    return 'Thời lượng $time';
  }

  @override
  String videoPosition(String position, String duration) {
    return '$position / $duration';
  }

  @override
  String get exerciseEditorTitle => 'Soạn bài tập';

  @override
  String get exerciseNew => 'Bài tập mới';

  @override
  String get exerciseTitleField => 'Tên bài tập';

  @override
  String get exerciseSubjectField => 'Môn học';

  @override
  String get exerciseGradeField => 'Khối';

  @override
  String get exerciseClassField => 'Lớp';

  @override
  String get exerciseLessonField => 'Bài học liên kết';

  @override
  String exerciseQuestion(int number) {
    return 'Câu $number';
  }

  @override
  String get exerciseStem => 'Đề bài';

  @override
  String exerciseOption(String letter) {
    return 'Lựa chọn $letter';
  }

  @override
  String get exerciseCorrect => 'Đáp án đúng';

  @override
  String get exerciseMulti => 'Cho phép chọn nhiều đáp án';

  @override
  String get exerciseAddQuestion => 'Thêm câu hỏi';

  @override
  String get exerciseRemoveQuestion => 'Xóa câu';

  @override
  String get exerciseSave => 'Lưu';

  @override
  String get exerciseSaved => 'Đã lưu bài tập.';

  @override
  String get exerciseValidation => 'Kiểm tra lại đề bài và đáp án.';

  @override
  String get exerciseEmpty => 'Chưa có bài tập nào.';

  @override
  String get exerciseLoading => 'Đang tải bài tập';

  @override
  String get exerciseError => 'Không tải được bài tập.';

  @override
  String exerciseQuestionsCount(int count) {
    return '$count câu';
  }

  @override
  String get exercisePick => 'Chọn bài tập';

  @override
  String get exerciseEdit => 'Sửa bài tập';

  @override
  String get exerciseAnswerKeyHint => 'Chọn vị trí đáp án đúng.';

  @override
  String get exerciseNoneLesson => 'Không liên kết bài học';

  @override
  String get assignmentEditorTitle => 'Giao bài';

  @override
  String get assignmentType => 'Loại bài';

  @override
  String get assignmentTypePractice => 'Luyện tập';

  @override
  String get assignmentTypeTest => 'Kiểm tra';

  @override
  String get assignmentDue => 'Hạn nộp';

  @override
  String get assignmentNoDue => 'Không đặt hạn';

  @override
  String get assignmentTimeLimit => 'Thời gian làm bài (phút)';

  @override
  String get assignmentClass => 'Lớp';

  @override
  String get assignmentExercise => 'Bài tập';

  @override
  String get assignmentAssign => 'Giao bài';

  @override
  String get assignmentSaved => 'Đã giao bài.';

  @override
  String get assignmentDelete => 'Xóa bài giao';

  @override
  String get assignmentDeleted => 'Đã xóa bài giao.';

  @override
  String get assignmentDeleteConfirmTitle => 'Xóa bài giao?';

  @override
  String get assignmentDeleteConfirmBody =>
      'Kết quả đã nộp của học sinh cũng sẽ bị xóa.';

  @override
  String get assignmentEmpty => 'Chưa có bài tập nào được giao.';

  @override
  String get assignmentLoading => 'Đang tải bài tập';

  @override
  String get assignmentError => 'Không tải được danh sách bài tập.';

  @override
  String get assignmentTeacherTitle => 'Bài đã giao';

  @override
  String get assignmentNew => 'Giao bài mới';

  @override
  String assignmentSubmissions(int count) {
    return '$count bài nộp';
  }

  @override
  String assignmentGradedCount(int count) {
    return '$count đã chấm';
  }

  @override
  String assignmentDueAt(String date) {
    return 'Hạn $date';
  }

  @override
  String get assignmentNoDueAt => 'Không hạn';

  @override
  String get assignmentPickExercise => 'Chọn bài tập';

  @override
  String get assignmentTimeLimitInvalid => 'Thời gian phải lớn hơn 0.';

  @override
  String get assignmentTypeRequired => 'Chọn loại bài.';

  @override
  String get assignmentOfflineNoData =>
      'Chưa có danh sách bài giao trên máy. Kết nối mạng để tải.';

  @override
  String get assignmentsTitle => 'Bài tập';

  @override
  String get assignmentsNeedsAction => 'Cần làm';

  @override
  String get assignmentsDone => 'Đã nộp';

  @override
  String get assignmentsEmpty => 'Chưa có bài tập nào được giao.';

  @override
  String get assignmentsLoading => 'Đang tải bài tập';

  @override
  String get assignmentsError => 'Không tải được danh sách bài tập.';

  @override
  String get assignmentsOfflineNoData =>
      'Chưa có danh sách bài tập trên máy. Kết nối mạng để tải.';

  @override
  String assignmentsDue(String date) {
    return 'Hạn $date';
  }

  @override
  String get assignmentsNoDue => 'Không hạn';

  @override
  String get assignmentsOpen => 'Mở bài';

  @override
  String get assignmentsStart => 'Bắt đầu';

  @override
  String get assignmentsContinue => 'Tiếp tục';

  @override
  String assignmentsScore(String score, String max) {
    return 'Điểm $score/$max';
  }

  @override
  String get assignmentsPendingSync => 'Bài nộp đang chờ đồng bộ';

  @override
  String get lessonTitle => 'Bài học';

  @override
  String get lessonCompleted => 'Đã học xong';

  @override
  String get lessonMarkComplete => 'Đánh dấu đã học xong';

  @override
  String get lessonOpen => 'Mở bài học';

  @override
  String get lessonCompletedSnack => 'Đã đánh dấu bài học hoàn thành.';

  @override
  String get lessonNeedsInternet => 'Cần kết nối mạng để mở bài học.';

  @override
  String get lessonLoading => 'Đang tải bài học';

  @override
  String get lessonError => 'Không tải được bài học.';

  @override
  String get exerciseStart => 'Bắt đầu làm bài';

  @override
  String get exerciseSubmit => 'Nộp bài';

  @override
  String get exerciseSubmitting => 'Đang nộp…';

  @override
  String get exerciseConfirmTitle => 'Nộp bài?';

  @override
  String exerciseConfirmBody(int count) {
    return 'Em còn $count câu chưa trả lời. Vẫn nộp?';
  }

  @override
  String get exerciseConfirmSubmit => 'Nộp';

  @override
  String exerciseQuestionOf(int current, int total) {
    return 'Câu $current / $total';
  }

  @override
  String get exerciseUnanswered => 'Chưa trả lời';

  @override
  String get exerciseAnswered => 'Đã trả lời';

  @override
  String exerciseOptionsSemantics(int number, String letter) {
    return 'Câu $number, lựa chọn $letter';
  }

  @override
  String get exerciseSavedOffline => 'Bài làm đã lưu trên máy.';

  @override
  String get exerciseScreenLoading => 'Đang mở bài tập';

  @override
  String get exerciseScreenError => 'Không mở được bài tập.';

  @override
  String get exerciseOfflineNoData => 'Bài tập này chưa được tải về máy.';

  @override
  String get exerciseOptionsHint => 'Chọn một đáp án';

  @override
  String get exerciseQuestionMultiHint => 'Có thể chọn nhiều đáp án.';

  @override
  String get resultTitle => 'Kết quả';

  @override
  String get resultScore => 'Điểm';

  @override
  String resultScoreValue(String score, String max) {
    return '$score/$max';
  }

  @override
  String get resultPending => 'Bài nộp đang chờ đồng bộ';

  @override
  String get resultSubmitted => 'Đã nộp, đang chờ chấm';

  @override
  String get resultGradingFailed => 'Chưa chấm được';

  @override
  String get resultBack => 'Về danh sách bài tập';

  @override
  String resultCorrectCount(int correct, int total) {
    return '$correct/$total câu đúng';
  }

  @override
  String get resultLate => 'Nộp muộn';

  @override
  String get resultLoading => 'Đang tải kết quả';

  @override
  String get resultError => 'Không tải được kết quả.';

  @override
  String get statusToDo => 'Chưa làm';

  @override
  String get statusInProgress => 'Đang làm bài';

  @override
  String get statusSubmittedAwaitingGrade => 'Đã nộp, đang chờ chấm';

  @override
  String get statusPendingSync => 'Chờ đồng bộ';

  @override
  String get statusGraded => 'Đã chấm';

  @override
  String get statusLate => 'Nộp muộn';

  @override
  String get statusGradingFailed => 'Chưa chấm được';

  @override
  String get statusLessonDone => 'Đã học xong';

  @override
  String get statusDraft => 'Bản nháp';

  @override
  String get statusProcessing => 'Đang xử lý';

  @override
  String get statusAwaitingApproval => 'Chờ duyệt';

  @override
  String get statusApproved => 'Đã duyệt';

  @override
  String get statusRejected => 'Bị từ chối';

  @override
  String get resultsTitle => 'Kết quả';

  @override
  String get resultsClass => 'Lớp';

  @override
  String get resultsEmpty => 'Chưa có bài nộp nào.';

  @override
  String get resultsLoading => 'Đang tải kết quả';

  @override
  String get resultsError => 'Không tải được kết quả.';

  @override
  String resultsSummary(int submitted, int total, int late) {
    return '$submitted trên $total em đã nộp · $late bài nộp muộn';
  }

  @override
  String get resultsRegrade => 'Chấm lại';

  @override
  String get resultsRegraded => 'Đã chấm lại.';

  @override
  String get resultsCellNoSubmission => '–';

  @override
  String get tutorTitle => 'Gia sư AI';

  @override
  String get tutorNewChat => 'Cuộc trò chuyện mới';

  @override
  String get tutorConversations => 'Cuộc trò chuyện';

  @override
  String get tutorNoConversations => 'Chưa có cuộc trò chuyện nào.';

  @override
  String get tutorSubject => 'Môn học';

  @override
  String get tutorMessageHint => 'Hỏi gia sư về bài học…';

  @override
  String get tutorSend => 'Gửi';

  @override
  String get tutorTutorLabel => 'Gia sư';

  @override
  String get tutorStudentLabel => 'Em';

  @override
  String get tutorThinking => 'Gia sư đang trả lời…';

  @override
  String get tutorNeedsInternet => 'Gia sư AI cần kết nối mạng';

  @override
  String get tutorDailyLimit => 'Bạn đã dùng hết lượt hỏi hôm nay';

  @override
  String get tutorDailyLimitHint => 'Lượt hỏi mới từ 0:00.';

  @override
  String get tutorPaused => 'Gia sư AI tạm dừng trong lúc làm bài kiểm tra';

  @override
  String get tutorPausedHint => 'Sẽ mở lại khi em nộp bài kiểm tra.';

  @override
  String get tutorError => 'Gia sư chưa trả lời được. Thử lại nhé.';

  @override
  String get tutorSubjectNotAllowed => 'Môn này ngoài phạm vi của gia sư.';

  @override
  String get tutorEmptySubject => 'Chọn môn học trước khi hỏi.';

  @override
  String get tutorLoading => 'Đang mở gia sư';

  @override
  String get tutorLoadError => 'Không mở được gia sư.';

  @override
  String get tutorChatLoading => 'Đang tải cuộc trò chuyện';

  @override
  String get tutorChatError => 'Không tải được cuộc trò chuyện.';

  @override
  String get tutorOfflineNoData => 'Chưa có cuộc trò chuyện nào trên máy.';

  @override
  String get tutorReadOnly => 'Chỉ xem';

  @override
  String get tutorClassChatsTitle => 'Trò chuyện AI của học sinh';

  @override
  String get tutorPickStudent => 'Chọn học sinh';

  @override
  String get tutorNoChatsForStudent =>
      'Học sinh này chưa trò chuyện với gia sư.';

  @override
  String get tutorStudentPicker => 'Học sinh';

  @override
  String get testLobbyTitle => 'Bài kiểm tra';

  @override
  String get testRules => 'Quy định';

  @override
  String get testRulesBody =>
      'Bài kiểm tra bắt đầu tính giờ ngay khi em bấm Bắt đầu. Hết giờ, bài sẽ tự nộp.';

  @override
  String testTimeLimit(int minutes) {
    return '$minutes phút';
  }

  @override
  String get testStart => 'Bắt đầu';

  @override
  String get testNeedsInternet => 'Cần kết nối mạng để bắt đầu bài kiểm tra';

  @override
  String get testStarting => 'Đang bắt đầu…';

  @override
  String get testStartFailed => 'Không bắt đầu được bài kiểm tra.';

  @override
  String get testRoomTitle => 'Đang làm bài';

  @override
  String get testRemaining => 'Thời gian còn lại';

  @override
  String get testUnderMinute => 'Còn dưới 1 phút';

  @override
  String get testAutoSubmitted => 'Hết giờ, bài đã được nộp.';

  @override
  String get testSubmittedTitle => 'Đã nộp bài';

  @override
  String get testSubmittedBody => 'Bài làm đã được ghi nhận.';

  @override
  String get testScoreLabel => 'Điểm';

  @override
  String get testSubmittedGraded => 'Bài của em đã được chấm.';

  @override
  String get testSubmittedPending => 'Bài của em đang chờ đồng bộ.';

  @override
  String get testSubmittedLate => 'Bài nộp muộn';

  @override
  String get testBackToAssignments => 'Về danh sách bài tập';

  @override
  String get testConfirmSubmit => 'Nộp bài kiểm tra?';

  @override
  String get testSubmittedState => 'Đã nộp';

  @override
  String get parentSummaryTitle => 'Sổ liên lạc';

  @override
  String get parentResults => 'Kết quả học tập';

  @override
  String get parentNoResults => 'Chưa có kết quả nào.';

  @override
  String get parentAiChats => 'Trò chuyện với gia sư AI';

  @override
  String get parentNoChats => 'Chưa có cuộc trò chuyện nào.';

  @override
  String get parentSummaryLoading => 'Đang tải sổ liên lạc';

  @override
  String get parentSummaryError => 'Không tải được sổ liên lạc.';

  @override
  String get parentSummaryOfflineNoData =>
      'Chưa có sổ liên lạc trên máy. Kết nối mạng để tải.';

  @override
  String get parentReadOnly => 'Chỉ xem';

  @override
  String get parentChatTitle => 'Trò chuyện của con';

  @override
  String get teacherChatReviewTitle => 'Trò chuyện AI';

  @override
  String get teacherChatReviewEmpty => 'Chưa có học sinh nào trong lớp.';

  @override
  String get teacherChatReviewPick => 'Chọn học sinh để xem trò chuyện.';

  @override
  String get teacherChatReviewLoading => 'Đang tải trò chuyện';

  @override
  String get teacherChatReviewError => 'Không tải được trò chuyện.';

  @override
  String get teacherChatReviewHint => 'Chỉ xem, không thể thay đổi.';

  @override
  String aiChatMessageCount(int count) {
    return '$count tin nhắn';
  }

  @override
  String get contentUploadingSimple => 'Đang tải lên…';

  @override
  String statusSemantics(String word) {
    return 'Trạng thái: $word';
  }

  @override
  String get contentDownloadingSimple => 'Đang tải về…';

  @override
  String get exercisesTitle => 'Bài tập';

  @override
  String exerciseRowMeta(String subject, String count) {
    return '$subject · $count';
  }

  @override
  String assignmentCounts(String submissions, String graded) {
    return '$submissions · $graded';
  }

  @override
  String chatRowMeta(String subject, String date) {
    return '$subject · $date';
  }

  @override
  String get assignmentDefaultMinutes => '15';

  @override
  String get contentPunctuation => '·';

  @override
  String get exerciseRetry => 'Làm lại';
}
