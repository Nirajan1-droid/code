import 'package:flutter/material.dart';
import 'package:taskes/kaamkocodes/5dartkocopy.dart';
import 'package:taskes/kaamkocodes/5dartkothirdgraph.dart';
import 'package:taskes/kaamkocodes/5file.dart';

class TrafficPage extends StatefulWidget {
  const TrafficPage({Key? key}) : super(key: key);

  @override
  _TrafficPageState createState() => _TrafficPageState();
}

class _TrafficPageState extends State<TrafficPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Traffic Page'),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        children: [
           ChartToggleWidget(),
                          ChartToggleWidget_second(),
                          ChartToggleWidget_third(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: (int page) {
          _pageController.jumpToPage(page);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Page 1',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Page 2',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Page 3',
          ),
        ],
      ),
    );
  }
}

class PageContent extends StatelessWidget {
  final int pageNumber;

  const PageContent({required this.pageNumber, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Page $pageNumber',
        style: TextStyle(fontSize: 24.0),
      ),
    );
  }
}
 