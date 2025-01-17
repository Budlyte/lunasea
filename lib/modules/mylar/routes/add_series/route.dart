import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/myar.dart';

class AddSeriesRoute extends StatefulWidget {
  final String query;

  const AddSeriesRoute({
    Key? key,
    required this.query,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<AddSeriesRoute> with LunaScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MylarAddSeriesState(
        context,
        widget.query,
      ),
      builder: (context, _) => LunaScaffold(
        scaffoldKey: _scaffoldKey,
        appBar: _appBar() as PreferredSizeWidget?,
        body: _body(),
      ),
    );
  }

  Widget _appBar() {
    return MylarSeriesAddAppBar(
      scrollController: scrollController,
      query: widget.query,
      autofocus: widget.query.isEmpty,
    );
  }

  Widget _body() {
    return MylarAddSeriesSearchPage(scrollController: scrollController);
  }
}
