class UserModel {
  final String userId; // Unique identifier for the user
  final String username; // Display name
  final String phoneNumber; // User's phone number
  final String profilePhoto; // URL or path to the profile photo
  final bool isOnline; // Online status
  final String lastSeen; // Last seen timestamp
  final String statusMessage; // User's status or about info
  final bool isVerified; // Whether the user's number is verified

  UserModel({
    required this.userId,
    required this.username,
    required this.phoneNumber,
    required this.profilePhoto,
    required this.isOnline,
    required this.lastSeen,
    required this.statusMessage,
    required this.isVerified,
  });
}
