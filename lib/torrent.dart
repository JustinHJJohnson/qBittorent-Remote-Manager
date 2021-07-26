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
  int completionOn;
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
  int numComplete;
  int numIncomplete;
  int numLeechs;
  int numSeeds;
  int priority;
  double progress;
  double ratio;
  double ratioLimit;
  String savePath;
  int seedingTime;
  int seedingTimeLimit;
  int seenComplete;
  bool seqDl;
  int size;
  String state;
  bool superSeeding;
  String tags;
  int timeActive;
  int totalSize;
  String tracker;
  int upLimit;
  int uploaded;
  int uploadedSession;
  int upspeed;

  Torrent(
    this.addedOn,
    this.amountLeft,
    this.autoTmm,
    this.availability,
    this.category,
    this.completed,
    this.completionOn,
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
    this.numComplete,
    this.numIncomplete,
    this.numLeechs,
    this.numSeeds,
    this.priority,
    this.progress,
    this.ratio,
    this.ratioLimit,
    this.savePath,
    this.seedingTime,
    this.seedingTimeLimit,
    this.seenComplete,
    this.seqDl,
    this.size,
    this.state,
    this.superSeeding,
    this.tags,
    this.timeActive,
    this.totalSize,
    this.tracker,
    this.upLimit,
    this.uploaded,
    this.uploadedSession,
    this.upspeed,
  );
 
  Torrent.fromJson(dynamic json):
    this.addedOn = json['added_on'],
    this.amountLeft = json['amount_left'],
    this.autoTmm = json['auto_tmm'],
    this.availability = json['availability'] + 0.0,
    this.category = json['category'],
    this.completed = json['completed'],
    this.completionOn = json['completion_on'],
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
    this.maxRatio = json['max_ratio'] + 0.0,
    this.maxSeedingTime = json['max_seeding_time'],
    this.name = json['name'],
    this.numComplete = json['num_complete'],
    this.numIncomplete = json['num_incomplete'],
    this.numLeechs = json['num_leechs'],
    this.numSeeds = json['num_seeds'],
    this.priority = json['priority'],
    this.progress = json['progress'] + 0.0,
    this.ratio = json['ratio'] + 0.0,
    this.ratioLimit = json['ratio_limit'] + 0.0,
    this.savePath = json['save_path'],
    this.seedingTime = json['seeding_time'],
    this.seedingTimeLimit = json['seeding_time_limit'],
    this.seenComplete = json['seen_complete'],
    this.seqDl = json['seq_dl'],
    this.size = json['size'],
    this.state = json['state'],
    this.superSeeding = json['super_seeding'],
    this.tags = json['tags'],
    this.timeActive = json['time_active'],
    this.totalSize = json['total_size'],
    this.tracker = json['tracker'],
    this.upLimit = json['up_limit'],
    this.uploaded = json['uploaded'],
    this.uploadedSession = json['uploaded_session'],
    this.upspeed = json['upspeed'];
 
  Map<String, dynamic> toJson() => {
    'added_on': this.addedOn,
    'amount_left': this.amountLeft,
    'auto_tmm': this.autoTmm,
    'availability': this.availability,
    'category': this.category,
    'completed': this.completed,
    'completion_on': this.completionOn,
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
    'num_complete': this.numComplete,
    'num_incomplete': this.numIncomplete,
    'num_leechs': this.numLeechs,
    'num_seeds': this.numSeeds,
    'priority': this.priority,
    'progress': this.progress,
    'ratio': this.ratio,
    'ratio_limit': this.ratioLimit,
    'save_path': this.savePath,
    'seeding_time': this.seedingTime,
    'seeding_time_limit': this.seedingTimeLimit,
    'seen_complete': this.seenComplete,
    'seq_dl': this.seqDl,
    'size': this.size,
    'state': this.state,
    'super_seeding': this.superSeeding,
    'tags': this.tags,
    'time_active': this.timeActive,
    'total_size': this.totalSize,
    'tracker': this.tracker,
    'up_limit': this.upLimit,
    'uploaded': this.uploaded,
    'uploaded_session': this.uploadedSession,
    'upspeed': this.upspeed,
  };
}