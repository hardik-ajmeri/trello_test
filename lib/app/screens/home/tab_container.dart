import 'package:flutter/material.dart';
import 'package:trellotest/app/navigation/routes.dart';
import 'package:trellotest/app/screens/dashboard/dashboard_screen.dart';
import 'package:trellotest/app/screens/new_board/new_board_screen.dart';

class TabContainer extends StatefulWidget {
  TabContainer({Key key}) : super(key: key);

  @override
  _TabContainerState createState() => _TabContainerState();
}

class _TabContainerState extends State<TabContainer> {
  List<Widget> listScreens;
  int tabIndex = 0;
  Color tabColor = Colors.grey;
  Color selectedTabColor = Color.fromRGBO(17, 73, 182, 1);

  @override
  void initState() {
    super.initState();

    listScreens = [
      DashboardScreen(),
      DashboardScreen(),
      NewBoardScreen(),
      DashboardScreen(),
      DashboardScreen()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: tabIndex, children: listScreens),
      bottomNavigationBar: _buildTabBar(),
      backgroundColor: Colors.white,
    );
  }


  void _selectedTab(int index) {
    setState(() {
      tabIndex = index;
    });
  }

  Widget _buildTabBar() {
    var listItems = [
      BottomAppBarItem(iconData: Icons.assignment, text: 'Home'),
      BottomAppBarItem(iconData: Icons.chat_bubble, text: 'Message'),
      BottomAppBarItem(iconData: Icons.add_circle_outline, text: 'Add'),
      BottomAppBarItem(iconData: Icons.notifications, text: 'Notification'),
      BottomAppBarItem(iconData: Icons.folder, text: 'More'),
    ];

    var items = List.generate(listItems.length, (int index) {
      return _buildTabItem(
        item: listItems[index],
        index: index,
        onPressed: _selectedTab,
      );
    });

    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
      color: Colors.white,
    );
  }

  Widget _buildTabItem({
    BottomAppBarItem item,
    int index,
    ValueChanged<int> onPressed,
  }) {
    var color = tabIndex == index ? selectedTabColor : tabColor;
    return Expanded(
      child: SizedBox(
        height: 60,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => onPressed(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(item.iconData, color: color, size: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BottomAppBarItem {
  BottomAppBarItem({this.iconData, this.text});
  IconData iconData;
  String text;
}