class SearchResult {
  /// Link to the file description
  final String descrLink;
  /// The name fo the file
  final String fileName;
  /// Size of the file in bytes
  final int fileSize;
  /// Link to the file
  final String fileUrl;
  /// Number of leechers
  final int numLeechers;
  /// Number of seeders
  final int numSeeders;
  /// Link to the torrent site this result came from
  final String siteUrl;

  SearchResult(
    this.descrLink,
    this.fileName,
    this.fileSize,
    this.fileUrl,
    this.numLeechers,
    this.numSeeders,
    this.siteUrl
  );

  SearchResult.fromJson(dynamic json):
    this.descrLink = json['descrLink'],
    this.fileName = json['fileName'],
    this.fileSize = json['fileSize'],
    this.fileUrl = json['fileUrl'],
    this.numLeechers = json['nbLeechers'],
    this.numSeeders = json['nbSeeders'],
    this.siteUrl = json['siteUrl'];
}