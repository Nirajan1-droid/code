
class _CarouselDemoState extends State<CarouselDemo> {
  int _currentIndex = 2; // Initialize current index to match initialPage
  bool _isOpen = false; // Flag to track bottom sheet visibility
  int _previousIndex = 2; // Store the previous index

  void _toggleBottomSheet() {
    setState(() {
      _isOpen = !_isOpen; // Toggle open/closed state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Your main content here
        _isOpen
            ? GFBottomSheet(
                controller: GFBottomSheetController(),
                maxContentHeight: 800,
                enableExpandableContent: true,
                stickyHeaderHeight: 100,
                stickyHeader: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 75, 156, 199),
                    boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 0)],
                  ),
                  child: const GFListTile(
                    avatar: GFAvatar(
                      backgroundImage: AssetImage('asset image here'),
                    ),
                    titleText: 'Charles Aly',
                  ),
                ),
                contentBody: SingleChildScrollView(
                  controller: ScrollController(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Button 1 functionality
                            },
                            child: Text('Button 1'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Button 2 functionality
                            },
                            child: Text('Button 2'),
                          ),
                        ],
                      ),
                      // Bar chart
                      Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: CarouselSlider(
                          items: [
                            Expanded(child: ChartToggleWidget()),
                            Container(color: Colors.red),
                            Container(color: Colors.blue),
                            Container(color: Colors.green),
                          ],
                          carouselController: CarouselController(),
                          options: CarouselOptions(
                            autoPlay: false,
                            enlargeCenterPage: true,
                            viewportFraction: 0.9,
                            aspectRatio: 4.0,
                            initialPage: 0,
                            onPageChanged: (index, reason) {
                              // Prevent sliding back
                              if (index > _previousIndex) {
                                setState(() {
                                  _currentIndex = index;
                                  _previousIndex = index;
                                });
                                if (widget.onPageChanged != null) {
                                  widget.onPageChanged!(index);
                                }
                              }
                            },
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => CarouselController().nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.linear,
                        ),
                        child: Text('→'),
                      ),
                      _currentIndex == 0 ? ChartToggleWidget() : TimingsChart(),
                    ],
                  ),
                ),
              )
            : Container(), // Empty container when closed
      ],
    );
  }
}
