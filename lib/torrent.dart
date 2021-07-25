/*class User {
  final String firstName, lastName, website;
  const User(this.firstName, this.lastName, this.website);
 
  User.fromJson(Map<String, dynamic> json):
    this.firstName = json['first_name'],
    this.lastName = json['last_name'],
    this.website = json['website'];
 
  Map<String, dynamic> toJson() => {
    "first_name": this.firstName,
    "last_name": this.lastName,
    "website": this.website
  };
}*/

class Torrent {
  /// Unix Epoch timestamp of when the torrent was added to the server
  final int addedOn;
  /// Amount of data left to download in bytes
  int amountLeft;
  /// If the torrent is being managed by auto torrent management
  final bool autoTmm;
  double availability;
  // The category of the torrent
  final String category;
  /// Amount of transfer data completed in bytes
  int completed;
  /// Unix Epoch timestamp of when the torrent was completed
  int completedOn;
  /// The absolute path of the torrent contents
  final String contentPath;
  /// The download speed limit on the torrent
  final int dlLimit;
  /// The download speed of the torrent in bytes/s
  int dlspeed;
  /// Amount of data downloaded in bytes
  int downloaded;
  // Amount of data downloaded this session
  int downloadedSession;
  /// Estimated Time for Accomplishment of the torrent in seconds
  int eta;
  /// True if first last piece are prioritized
  final bool fLPiecePrio;
  bool forceStart;
  final String hash;
  int lastActivity;
  final String magnetURI;
  double maxRatio;
  int maxSeedingTime;
  final String name;

  Torrent(
    this.addedOn,
    this.amountLeft,
    this.autoTmm,
    this.availability,
    this.category,
    this.completed,
    this.completedOn,
    this.contentPath,
    this.dlLimit,
    this.dlspeed,
    this.downloaded,
    this.downloadedSession,
    this.eta,
    this.fLPiecePrio,
    this.forceStart,
    this.hash,
    this.lastActivity,
    this.magnetURI,
    this.maxRatio,
    this.maxSeedingTime,
    this.name,
  );
 
  Torrent.fromJson(Map<String, dynamic> json):
    this.addedOn = json['added_on'],
    this.amountLeft = json['amount_left'],
    this.autoTmm = json['auto_tmm'],
    this.availability = json['availability'],
    this.category = json['category'],
    this.completed = json['completed'],
    this.completedOn = json['completed_on'],
    this.contentPath = json['content_path'],
    this.dlLimit = json['dl_limit'],
    this.dlspeed = json['dlspeed'],
    this.downloaded = json['downloaded'],
    this.downloadedSession = json['downloaded_session'],
    this.eta = json['eta'],
    this.fLPiecePrio = json['f_l_piece_prio'],
    this.forceStart = json['force_start'],
    this.hash = json['hash'],
    this.lastActivity = json['last_activity'],
    this.magnetURI = json['magnet_uri'],
    this.maxRatio = json['max_ratio'],
    this.maxSeedingTime = json['max_seeding_time'],
    this.name = json['name'];
 
  Map<String, dynamic> toJson() => {
    'added_on': this.addedOn,
    'amount_left': this.amountLeft,
    'auto_tmm': this.autoTmm,
    'availability': this.availability,
    'category': this.category,
    'completed': this.completed,
    'completed_on': this.completedOn,
    'content_path': this.contentPath,
    'dl_limit': this.dlLimit,
    'dlspeed': this.dlspeed,
    'downloaded': this.downloaded,
    'downloaded_session': this.downloadedSession,
    'eta': this.eta,
    'f_l_piece_prio': this.fLPiecePrio,
    'force_start': this.forceStart,
    'hash': this.hash,
    'last_activity': this.lastActivity,
    'magnet_uri': this.magnetURI,
    'max_ratio': this.maxRatio,
    'max_seeding_time': this.maxSeedingTime,
    'name': this.name,
  };
}