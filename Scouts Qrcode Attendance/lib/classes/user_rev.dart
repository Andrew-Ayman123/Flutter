class AppUserReview {
  String email, eventId, excuse;
  bool isCostume, isChurch, isSharing;
  AppUserReview(
      {required this.email,
      required this.eventId,
      this.isCostume = false,
      this.isChurch = false,
      this.isSharing = false,
      this.excuse = ''});
  @override
  AppUserReview.fromJson(Map<String, dynamic> values)
      : email = values['email'],
        eventId = values['event_id'],
        excuse = values['excuse'],
        isCostume = values['is_costume'],
        isChurch = values['is_church'],
        isSharing = values['is_sharing'];

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'event_id': eventId,
      'is_costume': isCostume,
      'is_church': isChurch,
      'is_sharing': isSharing,
      'excuse': excuse
    };
  }
}
