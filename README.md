<p align="center">
  <img alt="Logo" width=900 src="/resources/Logo with Words.png" />
</p>
&nbsp;
  
<table align=center>
  <tr>
    <td><a href="#overview">Overview</a></td>
    <td><a href="#demo">Demo</a></td>
    <td><a href="#system-architecture">System Architecture</a></td>
    <td><a href="#example-workflow-create-playlist">Example Workflow / Sample Code</a></td>
    <td><a href="#database-design">Database Design</a></td>
  </tr>
</table>

<br>

# Overview

<img width=450 align=right alt="Preview" src="/resources/Preview.gif" />
<img width=0 height=925 align=right border=0 />
<img width=0 height=925 align=right border=0 />
<img width=0 height=925 align=right border=0 />

Mystify is a [Flutter](https://flutter.dev/) app that builds smart [Spotify](https://spotify.com) playlists from custom filters, updating them daily using [Firebase](https://firebase.google.com/) Functions.\
&nbsp;

### Background
My massive collection of Liked Songs (4,500 and counting) ranges across countless genres and moods, so shuffling it has always been messy and unpredictable. I wanted a way to filter those songs down to the perfect match for each setting, whether that's background music at work or a road trip with friends. While Spotify has some solutions for this, none are customizable or comprehensive... so I decided to build my own.\
&nbsp;

### Features
Mystify unlocks the power of your Spotify library. It allows you to create deeply customizable playlists for the right mood and moment based on rules you specify. These playlists automatically update as your library evolves.

Mystify's playlist "recipes" allow you to filter based on a song's sound (e.g. genre, energy, instrumentalness or happiness), its metadata (e.g. release date, title, duration or popularity), and so much more. You can combine any of these filters to create hyper-specific playlists like "Recently Released Popular Danceable Acoustic Songs".\
&nbsp;

### Development
This project was largely born from my desire to learn [Flutter](https://flutter.dev/), and along the way, it's also taught me a ton about [Dart](https://dart.dev/), [Firebase](https://firebase.google.com/), mobile app development, handling async [streams](https://dart.dev/libraries/async/using-streams) and experimenting with countless state management solutions. It's been really fun and rewarding to work on, and although it's not finished yet, I wanted to share what I've built so far. This README includes a video demo, an overview of the system/database design and some code snippets.

<br>

# Demo
[![Mystify Demo](/resources/Demo.png)](https://www.youtube.com/watch?v=khQL0550tmY)

<br>

# System Architecture
Mystify is built with [Flutter](https://flutter.dev/), a [Dart](https://dart.dev/) framework for multi-platform app development, which makes it easy to release on iOS, Android and web.

Because I didn't want the client dealing with long-running API operations, I built out a serverless component with [Firebase Functions](https://firebase.google.com/docs/functions). These functions, written in [Typescript](https://www.typescriptlang.org/) and running on [Node.js](https://nodejs.org/), handle things like updating playlists in Spotify and generating authentication tokens. Mystify also uses Firebase for its NoSQL DB ([Firestore](https://firebase.google.com/docs/firestore)), [Authentication](https://firebase.google.com/docs/auth), [Remote Config](https://firebase.google.com/docs/remote-config) and more.

Mystify connects to Spotify over [OAuth 2](https://oauth.net/2/) and performs operations using both its Web API and the [spotify-dart](https://github.com/rinukkusu/spotify-dart) package, which I've made some [contributions](https://github.com/rinukkusu/spotify-dart/pulls?q=is%3Apr+is%3Aclosed+author%3ALeviHassel) to.

<br>

![Mystify Architecture](/resources/Architecture.png)

<br>

| <h3>Example Workflow: Create Playlist</h3> | <h3>Sample Code</h3> |
| ------------- |-------------|
| <img width=750 alt="Example Workflow" src="/resources/Example Workflow.png" /> | <h3><a href="https://flutter.dev/" target="_blank"><img alt="Flutter" title="Flutter" height=20 src="https://github.com/devicons/devicon/blob/master/icons/flutter/flutter-original.svg"></a> Flutter app</h3><ul><li>`ui/screens`</li><ul><li>`edit_playlist`</li><ul><li>[`edit_playlist_screen.dart`](/sample_code/flutter_app/ui/screens/edit_playlist/edit_playlist_screen.dart)</li><li>[`edit_playlist_vm.dart`](/sample_code/flutter_app/ui/screens/edit_playlist/edit_playlist_vm.dart)</li><li>📂 [`widgets`](/sample_code/flutter_app/ui/screens/edit_playlist/widgets)</li><li>📂 [`view_models`](/sample_code/flutter_app/ui/screens/edit_playlist/view_models)</li></ul></ul></ul><ul><li>`core`</li><ul><li>`services`</li><ul><li>[`playlist_service.dart`](/sample_code/flutter_app/core/services/playlist_service.dart)</li></ul></ul><ul><li>`repositories`</li><ul><li>[`functions_repository.dart`](/sample_code/flutter_app/core/repositories/functions_repository.dart)</li><li>[`playlist_repository.dart`](/sample_code/flutter_app/core/repositories/playlist_repository.dart)</li></ul></ul></ul><ul><li>`data/models`</li><ul><li>`playlists`</li><ul><li>[`playlist.dart`](/sample_code/flutter_app/data/models/playlists/playlist.dart)</li><li>📂 [`filters`](/sample_code/flutter_app/data/models/playlists/filters)</li></ul></ul></ul> &nbsp; <h3><a href="https://firebase.google.com/" target="_blank"><img alt="Firebase" title="Firebase" height=20 src="https://github.com/devicons/devicon/blob/master/icons/firebase/firebase-original.svg"></a> Firebase Functions</h3> <ul><li>[`index.ts`](/sample_code/firebase_functions/index.ts) (Functions)</li><li>`services`</li><ul><li>[`updatePlaylistService.ts`](/sample_code/firebase_functions/services/updatePlaylistService.ts)</li><li>[`filterService.ts`](/sample_code/firebase_functions/services/filterService.ts)</li></ul><li>`repositories`</li><ul><li>[`spotifyRepository.ts`](/sample_code/firebase_functions/repositories/spotifyRepository.ts)</li><li>[`playlistRepository.ts`](/sample_code/firebase_functions/repositories/playlistRepository.ts)</li></ul><li>`models`</li><ul><li>[`playlist.ts`](/sample_code/firebase_functions/models/playlist/playlist.ts)</li><li>[`filter.ts`](/sample_code/firebase_functions/models/playlist/filter.ts)</li></ul></ul> &nbsp; |

<br>

# Database Design
Below are some example [Firestore](https://firebase.google.com/docs/firestore) database entries used in the video demo. They showcase a variety of [Playlists](/sample_code/flutter_app/data/models/playlists/playlist.dart) and [Filters](/sample_code/flutter_app/data/models/playlists/filters).

A `Playlist` "recipe" in Mystify today is comprised of `Filters` that are ANDed together to narrow down your Liked Songs, in order. In the future, I plan to expand `Playlists` to include:
- `Sources` other than Liked Songs (like any playlist, artist or your top played tracks)
- `Tweaks` (like sorting by any song attribute and limiting the song count)
- More flexible options for combining `Filters` (like OR and XOR)\
&nbsp;

<table width="100%">
  <thead>
    <tr>
      <th><h3>New & Undiscovered</h3></th>
      <th><h3>Sad Songs About "You"</h3></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td width="52%"><img width=100% alt="New & Undiscovered" src="/resources/New & Undiscovered.png" /></td>
      <td width="48%"><img width=100% alt="Sad Songs About You" src="/resources/Sad Songs About You.png" /></td>
    </tr>
  </tbody>
</table>

<table width="100%">
  <thead>
    <tr>
      <th><h3>Party Anthems (CLEAN)</h3></th>
      <th><h3>Hidden Gems From the '90s</h3></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td width="48%"><img alt="Party Anthems (CLEAN)" src="/resources/Party Anthems (CLEAN).png" /></td>
      <td width="52%"><img alt="Hidden Gems From the '90s" src="/resources/Hidden Gems From the '90s.png" /></td>
    </tr>
  </tbody>
</table>
