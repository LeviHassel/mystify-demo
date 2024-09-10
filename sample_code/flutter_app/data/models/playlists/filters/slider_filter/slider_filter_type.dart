import 'package:flutter/widgets.dart';
import 'package:mystify/generated/l10n.dart';

enum SliderFilterType {
  energy,
  liveness,
  danceability,
  tempo,
  duration,
  happiness,
  speechiness,
  loudness,
  instrumentalness,
  acousticness,
  trackPopularity,
  artistPopularity,
  artistFollowers,
}

extension SliderFilterTypeExtensions on SliderFilterType {
  String title(BuildContext context) {
    switch (this) {
      case SliderFilterType.energy:
        return MystifyLocalizations.of(context).energy;
      case SliderFilterType.liveness:
        return MystifyLocalizations.of(context).liveness;
      case SliderFilterType.danceability:
        return MystifyLocalizations.of(context).danceability;
      case SliderFilterType.tempo:
        return MystifyLocalizations.of(context).tempo;
      case SliderFilterType.duration:
        return MystifyLocalizations.of(context).duration;
      case SliderFilterType.happiness:
        return MystifyLocalizations.of(context).happiness;
      case SliderFilterType.speechiness:
        return MystifyLocalizations.of(context).speechiness;
      case SliderFilterType.loudness:
        return MystifyLocalizations.of(context).loudness;
      case SliderFilterType.instrumentalness:
        return MystifyLocalizations.of(context).instrumentalness;
      case SliderFilterType.acousticness:
        return MystifyLocalizations.of(context).acousticness;
      case SliderFilterType.trackPopularity:
        return MystifyLocalizations.of(context).trackPopularity;
      case SliderFilterType.artistPopularity:
        return MystifyLocalizations.of(context).artistPopularity;
      case SliderFilterType.artistFollowers:
        return MystifyLocalizations.of(context).artistFollowers;
      default:
        return '';
    }
  }

  String description(BuildContext context) {
    switch (this) {
      case SliderFilterType.energy:
        return MystifyLocalizations.of(context).energyDescription;
      case SliderFilterType.liveness:
        return MystifyLocalizations.of(context).livenessDescription;
      case SliderFilterType.danceability:
        return MystifyLocalizations.of(context).danceabilityDescription;
      case SliderFilterType.tempo:
        return MystifyLocalizations.of(context).tempoDescription;
      case SliderFilterType.duration:
        return MystifyLocalizations.of(context).durationDescription;
      case SliderFilterType.happiness:
        return MystifyLocalizations.of(context).happinessDescription;
      case SliderFilterType.speechiness:
        return MystifyLocalizations.of(context).speechinessDescription;
      case SliderFilterType.loudness:
        return MystifyLocalizations.of(context).loudnessDescription;
      case SliderFilterType.instrumentalness:
        return MystifyLocalizations.of(context).instrumentalnessDescription;
      case SliderFilterType.acousticness:
        return MystifyLocalizations.of(context).acousticnessDescription;
      case SliderFilterType.trackPopularity:
        return MystifyLocalizations.of(context).trackPopularityDescription;
      case SliderFilterType.artistPopularity:
        return MystifyLocalizations.of(context).artistPopularityDescription;
      case SliderFilterType.artistFollowers:
        return MystifyLocalizations.of(context).artistFollowersDescription;
      default:
        return '';
    }
  }
}
