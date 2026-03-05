/// Model representing the logged-in user's profile data.
class UserProfile {
  final String displayName;
  final String username;
  final String avatarUrl;
  final String coverUrl;
  final String bio;
  final String postCount;
  final String followerCount;
  final String followingCount;
  final bool isVerified;

  const UserProfile({
    required this.displayName,
    required this.username,
    required this.avatarUrl,
    required this.coverUrl,
    required this.bio,
    required this.postCount,
    required this.followerCount,
    required this.followingCount,
    this.isVerified = false,
  });

  /// Demo profile shown in the Profile tab.
  static const UserProfile demo = UserProfile(
    displayName: 'JM Java',
    username: '@jm_java',
    avatarUrl: 'https://picsum.photos/300/300?random=400',
    coverUrl: 'https://picsum.photos/900/420?random=300',
    bio: '✈️ Travel • 🍳 Food • 📸 Photography',
    postCount: '156',
    followerCount: '12.5k',
    followingCount: '843',
    isVerified: true,
  );
}