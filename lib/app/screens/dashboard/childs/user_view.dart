import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class UserView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
                color: Colors.black12, blurRadius: 15.0, spreadRadius: 15.0)
          ],
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.325,
        child: Padding(
          padding: EdgeInsets.only(top: 56),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  HLTrello(context),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.5),
                  TrelloUser(context)
                ],
              ),
              SizedBox(height: 8.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: UserMessage(context),
              ),
              SizedBox(height: 8.0),
              SearchBar(context),
              BoardTab(context),
              SizedBox(height: 4.0),
            ],
          ),
        ));
  }

  Widget HLTrello(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5.0, spreadRadius: 2.0)
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(2),
        child: Icon(
          MaterialIcons.dashboard,
          size: 32,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget TrelloUser(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5.0, spreadRadius: 2.0)
        ],
      ),
      child: Icon(
        Icons.account_circle,
        size: 40,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget UserMessage(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Hi, Hardik",
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black87)),
        Text("Welcome back to your board",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 15, color: Colors.black87))
      ],
    );
  }

  Widget SearchBar(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(25),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
            padding: EdgeInsets.all(0),
            child: TextField(
              cursorColor: Theme.of(context).primaryColor,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  hintText: 'Search card, board or task here',
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  )),
            )),
      ),
    );
  }

  Widget BoardTab(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: TabBar(
        labelPadding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: CircleTabIndicator(color: Theme.of(context).primaryColor, radius: 4),
        isScrollable: true,
        unselectedLabelColor: Colors.grey,
        labelColor: Theme.of(context).primaryColor,
        tabs: <Widget>[
          Tab(text: 'All Board'),
          Tab(text: 'Boards'),
          Tab(text: 'Personal'),
        ],
      ),
    );
  }
}

class CircleTabIndicator extends Decoration {
  final BoxPainter _painter;

  CircleTabIndicator({@required Color color, @required double radius}) : _painter = _CirclePainter(color, radius);

  @override
  BoxPainter createBoxPainter([onChanged]) => _painter;
}

class _CirclePainter extends BoxPainter {
  final Paint _paint;
  final double radius;

  _CirclePainter(Color color, this.radius)
      : _paint = Paint()
    ..color = color
    ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Offset circleOffset = offset + Offset(cfg.size.width / 2, cfg.size.height - radius);
    canvas.drawCircle(circleOffset, radius, _paint);
  }
}