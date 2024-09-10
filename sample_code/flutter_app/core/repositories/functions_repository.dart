import 'package:cloud_functions/cloud_functions.dart';
import 'package:mystify/core/locator.dart';
import 'package:mystify/core/repositories/interfaces/i_functions_repository.dart';
import 'package:mystify/core/services/interfaces/i_logging_service.dart';
import 'package:mystify/data/constants/config/functions_config.dart';

class FunctionsRepository implements IFunctionsRepository {
  final ILoggingService _log = Locator.get<ILoggingService>();
  final CloudFunctions _cloudFunctions = Locator.get<CloudFunctions>();

  @override
  Future<String> generateAuthToken(String spotifyUserId) async {
    var function = _cloudFunctions.getHttpsCallable(
        functionName: FunctionsConfig.generateAuthToken);

    var result = await function.call(<String, String>{
      FunctionsConfig.spotifyUserId: spotifyUserId,
    });

    return result.data[FunctionsConfig.firebaseAuthToken];
  }

  @override
  void syncPlaylist(String playlistId, String userId) {
    var function = _cloudFunctions.getHttpsCallable(
        functionName: FunctionsConfig.updatePlaylist);

    try {
      function.call(<String, String>{
        FunctionsConfig.playlistId: playlistId,
        FunctionsConfig.userId: userId,
      });
    } catch (e) {
      _log.error(e, StackTrace.current);
    }
  }
}
