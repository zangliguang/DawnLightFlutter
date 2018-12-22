class MovieInfo {
  String coverUrl;
  List<SearchFactor> header;
  List<SearchFactor> genre;
  List<SearchFactor> actress;
  List<SearchFactor> sampleImages;

  MovieInfo(this.coverUrl, this.header, this.genre, this.actress,
      this.sampleImages);

  @override
  String toString() {
    return 'MovieInfo{coverUrl: $coverUrl, header: $header, genre: $genre, actress: $actress, sampleImages: $sampleImages}';
  }


}

class SearchFactor {
  String factorLabel;
  String factorName;
  String factorUrl;

  SearchFactor(this.factorLabel, this.factorName, this.factorUrl);

  @override
  String toString() {
    return 'SearchFactor{factorLabel: $factorLabel, factorName: $factorName, factorUrl: $factorUrl}';
  }
}

