//Network
const String localhostDomain = 'localhost:8000';
//for device: 192.168.0.10:8000  -- for emulator: 10.0.2.2:8000
const String baseUrlDomain = '192.168.0.10:8000';
const String apiBaseUrl = 'http://192.168.0.10:8000/api';
const String apiAuth = '/auth'; //get token
const String apiRegister = '/register';
const String apiAuthUser = '/auth/user'; //get user credentials with token
const String apiUpdateUserProfile = '/auth/user';
const String apiResetUserPassword = '/auth/user/password'; //[put]
const String apiSearch = '/search'; //[get]
const String apiGetBook = '/book';
const String apiGetLists = '/mylists'; //[get]
const String apiCreateBookList = '/mylists'; //[post]
String apiDeleteBookList(id) => "/mylists/$id"; //[delete][id]
String apiUpdateBookList(id) => '/mylists/$id'; //[post]
String apiShowBookList(id) => '/mylists/$id'; //[get]
String apiListAddBook({required id, required book}) =>
    '/mylists/$id/add/$book'; //[get]
String apiListRemoveBook({required id, required book}) =>
    '/mylists/$id/remove/$book'; //[get]
const String apiGetMyReviews = '/myreviews';
String apiRemoveReview({required bookId}) => '/myreviews/$bookId'; //[delete]
const String apiBookRequest = '/bookrequest'; //[post]
String apiUserDetail(userId) => '/user/$userId'; //[get]
String apiUserDetailList({required userId, required listId}) =>
    '/user/$userId/list/$listId'; //[get]
String apiUserDetailReviews({required userId}) => '/user/$userId/reviews';
const String homeData = '/home'; //[get]

//RegisterForm
const int minPasswordLength = 6;

//ProfilePhotoFileSize
const int maxPhotoFileSize = 1048576; //1024 KB

//Search
const int minSearchCharLength = 3;
const String searchTextHint = 'Kitap, Yazar, ISBN, Yayınevi,...';

//Images
const String logoBanner = 'assets/images/logos/BookReview-Banner.png';
const String bookCoverNotAvailable =
    'assets/images/book_cover_not_available.jpg';

//Language
const Map<String, String> bookLanguage = {
  "tr": "Türkçe",
  "en": "İngilizce",
  "de": "Almanca",
  "es": "İspanyolca",
  "fr": "Fransızca",
  "it": "İtalyanca",
  "fi": "Fince",
  "hi": "Hintçe"
};

//BookLists
const String defaultBookListStatus = 'public';
const Map<String, String> defaultBookLists = {
  "read": "Okundu",
  "to read": "Okunacak",
  "currently reading": "Şu anda okunuyor"
};
const Map<String, String> bookListsStatus = {
  "public": "Herkese Açık",
  "private": "Özel"
};
const int minListNameLength = 3;
