class MoviePlayDirectly {
  String title;
  String keyword;
  double duration;
  String previewUrl;
  String vid;

  MoviePlayDirectly(
      this.title, this.keyword, this.duration, this.previewUrl, this.vid);

  @override
  String toString() {
    return 'MoviePlayDirectly{title: $title, keyword: $keyword, duration: $duration, previewUrl: $previewUrl, vid: $vid}';
  }
}
