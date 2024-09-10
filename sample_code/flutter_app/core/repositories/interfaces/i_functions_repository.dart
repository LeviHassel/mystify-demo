abstract class IFunctionsRepository {
  /// Returns a custom Firebase Auth token generated from a [spotifyUserId].
  Future<String> generateAuthToken(String spotifyUserId);

  /// Updates the Spotify playlist based on the sources, filters and tweaks for
  /// the provided [playlistId].
  void syncPlaylist(String playlistId, String userId);
}
