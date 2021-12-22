import 'package:flutter_flavor/flutter_flavor.dart';

import 'constants.dart';

String? getDomain = FlavorConfig.instance.variables["domain"];
String? getReference =  FlavorConfig.instance.variables["reference"];
String mainUrl = "$getDomain$getReference";

// Domain API && Web
String $domainAPI = "${getDomain}ucodeapis.com";
String $domainWeb = "https://$mainUrl.vn";

// Url fanpage
const String $urlFanpageUCode = "https://www.facebook.com/ucode.vn";
const String $urlYoutubeChanel = "https://www.youtube.com/c/uCodevn";

// client ID
const $clientID = '112036722412-7uuq92ri29vivdi680baubmi8ilb2hla.apps.googleusercontent.com';

// web view
const $uToken = "u-token";

// transaction
const Map<String, String> $transaction = {
  "name": "Công ty Cổ Phần Công Nghệ Giáo Dục Tri Thức Số Việt Nam",
  "STK": "1006198888",
  "bank": "Ngân hàng TMCP Á Châu (ACB)",
  "branch": "Chi nhánh Hoàng Cầu",
};
const $phoneNumberSupport = "024.32.025.024";
const $phoneNumberSupportCopy = "02432025024";

const List<Map<String, String>> $teacherInfo = [
  {
    "name": "Cô Phạm Thị Huệ",
    "major": "Thạc sỹ Ngôn ngữ học",
    "description":
        "Tốt nghiệp xuất sắc tại ĐH Bách khoa Tomsk, Liên Bang Nga, có kinh nghiệm huấn luyện trực tiếp cho hơn 2000 giáo viên và hơn 300.000 học sinh THCS, THPT tại 16 tỉnh thành phố.",
    "img": $assetsImageTeacher,
  },
  {
    "name": "Thầy Trần Mạnh Nam",
    "major": "Tiến sỹ CNTT",
    "description":
        "Thầy có nhiều năm dưới vai trò chuyên gia cũng như giảng viên CNTT tại ĐH Bách Khoa Hà Nội, có nhiều năm kinh nghiệm trong quản lý giáo dục với vị trị PGĐ Genetic Bách Khoa và Hiệu trưởng Cao đẳng nghề Dịch vụ Hàng không.",
    "img": $assetsImageTeacher4,
  },
  {
    "name": "Thầy Nguyễn Chí Thức",
    "major": "Thạc sỹ CNTT",
    "description":
        "Là chuyên gia CNTT từ LB Nga, với hơn 10 năm hoạt động trong các công ty công nghệ hàng đầu Việt Nam, nhiều năm giảng dạy, bồi dưỡng học sinh giỏi Tin học các cấp.",
    "img": $assetsImageTeacher3,
  },
  {
    "name": "Thầy Phạm Trọng Tiến",
    "major": "PGS. TS Toán",
    "description":
        "Giảng viên Toán tại ĐH Khoa học Tự Nhiên, ĐHQGHN với nhiều năm kinh nghiệm giảng dạy Toán các cấp, Toán Online cho du học sinh Việt tại Mỹ và Canada.",
    "img": $assetsImageTeacher2,
  },
];

const List<Map<String, String>> $talkAboutUs = [
  {
    "title": "Cách học thú vị",
    "parent": "Chị Lê Thị Nga",
    "place": "Bắc Giang",
    "description":
        '"Chị rất tán thành về cách thức theo dõi tiến trình học tập và tiến bộ của các con. Con tự kiểm tra được bản thân còn mẹ thì nắm được phần kiến thức nào con đang còn yếu để kịp thời giúp con bổ sung kiến thức. Con rất vui vì có mẹ đồng hành cùng con học tập và lúc nào cũng háo hức đợi mẹ cho xem email kết quả học tập trên StudyLand ạ."',
  },
  {
    "title": "Kho đề ấn tượng",
    "parent": "Chị Nguyễn Hải Hà",
    "place": "TT Huế",
    "description":
        '"Bố cháu lo “hơi xa” nên tuy cháu còn nhỏ mà bố cháu đã kì công tìm kiếm, gom đề thi các kì thi toán quốc tế theo từng năm cho cháu. Cơ duyên nào đưa mẹ cháu đến với StudyLand và bây giờ bố cháu không cần vất vả đi thu thập đề nữa rồi ạ!"',
  },
  {
    "title": "Đề cao chất lượng",
    "parent": "Chị Phạm Thị Ngân",
    "place": "Hưng Yên",
    "description":
        '"Mẹ cháu cũng mê tít bài giảng tương tác được hỗ trợ bằng hình ảnh, biểu đồ, lại có câu hỏi tương tác ở cuối mỗi video. Việc nhắc nhở con ngồi vào bàn học chưa bao giờ nhẹ nhàng và hạnh phúc đến thế."',
  },
];
