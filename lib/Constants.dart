class Constants {
  static const int DefaultPageSize = 100;
  static const String BaseRequestUrl = 'http://192.168.2.108:8000/';
  static const String MosaicUrl = 'https://javzoo.com/cn/';
  static const String NoMosaicUrl = 'https://avme.pw/cn/';
  static const String BaseUrl = MosaicUrl;

  static const String SearchMovie =
      'http://api.rekonquer.com/psvs/search.php?kw=';
  static const String ReleasedPage = BaseUrl + 'released';
  static const String HotPage = BaseUrl + 'popular';
  static const String Genre = BaseUrl + 'genre';
  static const String Actress = BaseUrl + 'actresses';
}
