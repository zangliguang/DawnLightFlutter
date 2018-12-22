class MovieItemEntity {
  String title;
  String detailUrl;
  String coverUrl;
  String licences;
  String publicDate;
  bool hot;

  MovieItemEntity(this.title, this.detailUrl, this.coverUrl, this.licences,
      this.publicDate, this.hot);

  @override
  String toString() {
    return 'MovieItemEntity{title: $title, detailUrl: $detailUrl, coverUrl: $coverUrl, licences: $licences, publicDate: $publicDate, hot: $hot}';
  }
}
