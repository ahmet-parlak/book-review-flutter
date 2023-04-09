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
