class AppUser {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoURL;

  AppUser({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
  });

  factory AppUser.fromFirebaseUser(dynamic data) {
    return AppUser(
      uid: data.uid,
      email: data.email,
      displayName: data.displayName,
      photoURL: data.photoURL,
    );
  }
}