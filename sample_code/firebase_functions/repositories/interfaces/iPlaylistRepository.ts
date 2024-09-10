import { MystifyPlaylist } from "../../models/playlist/playlist";

export interface IPlaylistRepository {
  getPlaylist(playlistId: string): Promise<MystifyPlaylist>;

  getPlaylistsForUser(userId: string): Promise<MystifyPlaylist[]>;

  updatePlaylist(playlist: MystifyPlaylist): Promise<void>;
}
