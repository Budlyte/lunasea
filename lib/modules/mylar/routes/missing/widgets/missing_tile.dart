import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/extensions/datetime.dart';
import 'package:lunasea/extensions/string/string.dart';
import 'package:lunasea/modules/mylar.dart';
import 'package:lunasea/router/routes/mylar.dart';

class MylarMissingTile extends StatefulWidget {
  static final itemExtent = LunaBlock.calculateItemExtent(3);

  final MylarMissingRecord record;
  final MylarSeries? series;

  const MylarMissingTile({
    Key? key,
    required this.record,
    this.series,
  }) : super(key: key);

  @override
  State<MylarMissingTile> createState() => _State();
}

class _State extends State<MylarMissingTile> {
  @override
  Widget build(BuildContext context) {
    return LunaBlock(
      backgroundUrl:
          context.read<MylarState>().getFanartURL(widget.record.seriesId),
      posterUrl:
          context.read<MylarState>().getPosterURL(widget.record.seriesId),
      posterHeaders: context.read<MylarState>().headers,
      posterPlaceholderIcon: LunaIcons.VIDEO_CAM,
      title: widget.record.series?.title ??
          widget.series?.title ??
          LunaUI.TEXT_EMDASH,
      body: [
        _subtitle1(),
        _subtitle2(),
        _subtitle3(),
      ],
      disabled: !widget.record.monitored!,
      onTap: _onTap,
      onLongPress: _onLongPress,
      trailing: _trailing(),
    );
  }

  Widget _trailing() {
    return LunaIconButton(
      icon: Icons.search_rounded,
      onPressed: _trailingOnTap,
      onLongPress: _trailingOnLongPress,
    );
  }

  TextSpan _subtitle1() {
    return TextSpan(
      children: [
        TextSpan(
            text: widget.record.seasonNumber == 0
                ? 'Specials'
                : 'Season ${widget.record.seasonNumber}'),
        TextSpan(text: LunaUI.TEXT_BULLET.pad()),
        TextSpan(text: 'Episode ${widget.record.episodeNumber}'),
      ],
    );
  }

  TextSpan _subtitle2() {
    return TextSpan(
      style: const TextStyle(
        fontStyle: FontStyle.italic,
      ),
      text: widget.record.title ?? 'lunasea.Unknown'.tr(),
    );
  }

  TextSpan _subtitle3() {
    return TextSpan(
      style: const TextStyle(
        fontSize: LunaUI.FONT_SIZE_H3,
        color: LunaColours.red,
        fontWeight: LunaUI.FONT_WEIGHT_BOLD,
      ),
      children: [
        TextSpan(
            text: widget.record.airDateUtc == null
                ? 'Aired'
                : 'Aired ${widget.record.airDateUtc!.toLocal().asAge()}'),
      ],
    );
  }

  Future<void> _onTap() async {
    MylarRoutes.SERIES_SEASON.go(params: {
      'series': (widget.record.seriesId ?? -1).toString(),
      'season': (widget.record.seasonNumber ?? -1).toString(),
    });
  }

  Future<void> _onLongPress() async {
    MylarRoutes.SERIES.go(params: {
      'series': widget.record.seriesId!.toString(),
    });
  }

  Future<void> _trailingOnTap() async {
    Provider.of<MylarState>(context, listen: false)
        .api!
        .command
        .episodeSearch(episodeIds: [widget.record.id!])
        .then((_) => showLunaSuccessSnackBar(
              title: 'Searching for Episode...',
              message: widget.record.title,
            ))
        .catchError((error, stack) {
          LunaLogger().error(
              'Failed to search for episode: ${widget.record.id}',
              error,
              stack);
          showLunaErrorSnackBar(
            title: 'Failed to Search',
            error: error,
          );
        });
  }

  Future<void> _trailingOnLongPress() async {
    return MylarRoutes.RELEASES.go(queryParams: {
      'episode': widget.record.id!.toString(),
    });
  }
}
