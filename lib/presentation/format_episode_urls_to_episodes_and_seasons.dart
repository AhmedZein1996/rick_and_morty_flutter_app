List<dynamic> formatEpisodeUrlsToEpisodesAndSeasonsList(List<dynamic> episodeUrls) {
  final List<String> episodeList = [];
  for (final episodeUrl in episodeUrls) {
    final int episodeNumber = int.parse(episodeUrl.split('/').last);

    if (episodeNumber < 8 || episodeNumber > 48) continue;

    final int seasonNumber = ((episodeNumber - 1) / 10).floor() + 1;
    final int episodeInSeason = (episodeNumber - 1) % 10 + 1;

    episodeList.add('S${seasonNumber.toString().padLeft(2, '0')}E${episodeInSeason.toString().padLeft(2, '0')}');
  }

  return episodeList;

}
