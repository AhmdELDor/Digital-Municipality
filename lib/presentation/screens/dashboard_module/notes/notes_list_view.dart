part of 'notes_list_view_imports.dart';

class NotesListView extends StatefulWidget {
  const NotesListView({super.key});

  @override
  State<NotesListView> createState() => _NotesListViewState();
}

class _NotesListViewState extends State<NotesListView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  NotesListController controller=Get.put(NotesListController());
  @override
  Widget build(BuildContext context) {
    final notesList = GoRouterState.of(context).extra as List;
    //var mobileView = ResponsiveView.isMobile(context);
    return Scaffold(
      key: _scaffoldKey,
      drawer: const SizedBox(width: 270, child: SideDrawerMenu()),
      appBar: CustomAppBar(
        searchController: controller.searchController,
        drawerOnTap: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        showBackIcon: true,

      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                child: CommonText.medium(
                  NotesListStrings.notes,
                  size: 18,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: ResponsiveGridRow(
                  children: List.generate(
                    notesList.length,
                        (index) {
                      final data = notesList[index];
                      return ResponsiveGridCol(
                        lg: 4, // 3 cards = 4 columns each on 12-grid
                        xs: 12,
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: 25,
                            bottom: 25,

                          ),
                          child: CommonNotesView(note: data),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
