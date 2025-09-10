part of 'view_quiz_imports.dart';

class ViewQuiz extends StatefulWidget {
  const ViewQuiz({super.key});

  @override
  State<ViewQuiz> createState() => _ViewQuizState();
}

class _ViewQuizState extends State<ViewQuiz> {
  ViewQuizController controller = Get.put(ViewQuizController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var mobileView = ResponsiveView.isMobile(context);
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;


    final data = GoRouterState.of(context).extra;

    // ✅ check type
    if (data is QuizModel) {
      if (kDebugMode) {
        print("Got QuizModel: ${data.name}");
      }
    } else if (data is TestModel) {
      if (kDebugMode) {
        print("Got TestModel: ${data.name}");
      }
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: const SizedBox(width: 270, child: SideDrawerMenu()),
      appBar: CustomAppBar(
        searchController: controller.searchController,
        drawerOnTap: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              mobileView
                  ? Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 20,
                      ),
                      child: CommonSearchField(
                        controller: controller.searchController,
                        hintText: DashboardViewStrings.searchAnything,
                      ),
                    )
                  : SizedBox(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: CommonText.medium(data is QuizModel?ViewQuizStrings.viewQuiz:TestStrings.viewTest, size: 18),
              ),
              CommonDivider(),
              mobileView
                  ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: commonCacheImage(
                                  controller.data.value.image,
                                  ImagePlaceHolder.imagePlaceHolderDark,
                                  height: 85,
                                  width: 128,
                                ),
                              ),
                              Gap(15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CommonText.regular(
                                      controller.data.value.name,
                                      size: 15,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Gap(5),
                                    CommonText.light(
                                      controller.data.value.tag,
                                      size: 15,
                                      color: isDarkMode
                                          ? AppColors.bodyTextDarkColor
                                          : AppColors.bodyTextColor,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Gap(20),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: commonCardDecoration(9),
                                  padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CommonText.regular(
                                        DashboardViewStrings.category,
                                        size: 15,
                                        color: isDarkMode
                                            ? AppColors.bodyTextDarkColor
                                            : AppColors.bodyTextColor,
                                      ),
                                      Gap(7),
                                      CommonText.regular(
                                        controller.data.value.course,
                                        size: 16,
                                        color: isDarkMode
                                            ? AppColors.bodyTextDarkColor
                                            : AppColors.bodyTextColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ), Gap(15),
                              Expanded(
                                child: Container(
                                  decoration: commonCardDecoration(9),
                                  padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CommonText.regular(
                                        'Attendees',
                                        size: 15,
                                        color: isDarkMode
                                            ? AppColors.bodyTextDarkColor
                                            : AppColors.bodyTextColor,
                                      ),
                                      Gap(7),
                                      CommonText.regular(
                                        controller.data.value.totalAttendees.toString(),
                                        size: 16,
                                        color: isDarkMode
                                            ? AppColors.bodyTextDarkColor
                                            : AppColors.bodyTextColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ), Gap(15),
                              Expanded(
                                child: Container(
                                  decoration: commonCardDecoration(9),
                                  padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CommonText.regular(
                                        'Questions',
                                        size: 15,
                                        color: isDarkMode
                                            ? AppColors.bodyTextDarkColor
                                            : AppColors.bodyTextColor,
                                      ),
                                      Gap(7),
                                      CommonText.regular(
                                        controller.data.value.totalAttendees.toString(),
                                        size: 16,
                                        color: isDarkMode
                                            ? AppColors.bodyTextDarkColor
                                            : AppColors.bodyTextColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                  )
                  : SizedBox(),
              Obx(
                      () => ResponsiveGridRow(
                        children: [
                          ResponsiveGridCol(
                            lg: 9,
                            xs: 12,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(

                                vertical: 20,
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: isDarkMode
                                      ? AppColors.mainDarkBgColor
                                      : AppColors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isDarkMode
                                        ? AppColors.grey100Color
                                        : AppColors.lightBorderColor,
                                    width: 1,
                                  ),
                                ),
                                child: Theme(
                                  data: ThemeData(disabledColor: Colors.transparent),
                                  child: ReorderableListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    buildDefaultDragHandles: false,
                                    itemCount: controller.data.value.quizList.length,
                                    onReorder: (oldIndex, newIndex) {
                                      if (newIndex > oldIndex) newIndex--;
                                      final item = controller.data.value.quizList.removeAt(oldIndex);
                                      controller.data.value.quizList.insert(newIndex, item);
                                      controller.update();
                                    },
                                    proxyDecorator: (child, index, animation) => Material(
                                      elevation: 6,
                                      color: Colors.transparent,
                                      shadowColor: Colors.black45,
                                      child: child,
                                    ),
                                    itemBuilder: (context, index) {
                                      final quiz = controller.data.value.quizList[index];

                                      return KeyedSubtree( // ✅ Key for quiz item
                                        key: ValueKey("quiz_${quiz.id}_$index"),
                                        child: Obx(
                                              () => Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 25),
                                                child: Container(
                                                  margin: const EdgeInsets.only(left: 30, bottom: 12),
                                                  decoration: BoxDecoration(
                                                    color: isDarkMode ? AppColors.mainDarkBgColor : AppColors.white,
                                                    borderRadius: BorderRadius.circular(8),
                                                    border: Border.all(
                                                      color: quiz.isExpanded.value
                                                          ? AppColors.primary500
                                                          : (isDarkMode
                                                          ? AppColors.grey100Color
                                                          : AppColors.lightBorderColor),
                                                    ),
                                                  ),
                                                  child: Theme(
                                                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                                    child: ExpansionTile(

                                                      childrenPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),

                                                      showTrailingIcon: false,
                                                      onExpansionChanged: (expanded) => quiz.isExpanded.value = expanded,
                                                      title: Row(
                                                        children: [
                                                          Expanded(
                                                            child: CommonText.regular(
                                                              quiz.question,
                                                              size: 16,
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                          ),
                                                          const Gap(15),
                                                          ReorderableDragStartListener(
                                                            index: index,
                                                            child: Row(
                                                              children: [
                                                                SvgImageFromAsset(
                                                                  AppCommonIcon.menuIcon,
                                                                  colorFilter: ColorFilter.mode(
                                                                    isDarkMode ? AppColors.white : AppColors.headingsColor,
                                                                    BlendMode.srcIn,
                                                                  ),
                                                                ),
                                                                const Gap(8),
                                                                Icon(
                                                                  quiz.isExpanded.value
                                                                      ? Icons.keyboard_arrow_up
                                                                      : Icons.keyboard_arrow_down,
                                                                  color: isDarkMode
                                                                      ? AppColors.white
                                                                      : AppColors.headingsColor,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),

                                                      // ✅ Inner options list
                                                      children: [
                                                        SizedBox(
                                                          height: quiz.options.any((e) => e.isImage) ? 160 : null,
                                                          child: ReorderableListView.builder(
                                                            shrinkWrap: true,
                                                            physics: const NeverScrollableScrollPhysics(),
                                                            scrollDirection: quiz.options.any((e) => e.isImage)
                                                                ? Axis.horizontal
                                                                : Axis.vertical,
                                                            buildDefaultDragHandles: false,
                                                            itemCount: quiz.options.length,
                                                            onReorder: (oldIndex, newIndex) {
                                                              if (newIndex > oldIndex) newIndex--;
                                                              final item = quiz.options.removeAt(oldIndex);
                                                              quiz.options.insert(newIndex, item);
                                                              controller.update();
                                                            },
                                                            itemBuilder: (context, i) {
                                                              final option = quiz.options[i];
                                                              return KeyedSubtree( // ✅ Key for option
                                                                key: ValueKey("quiz_${quiz.id}_opt_${option.id}_$i"),
                                                                child: ReorderableDragStartListener(
                                                                  index: i,
                                                                  child: option.isImage
                                                                      ? Container(
                                                                    margin: const EdgeInsets.symmetric(horizontal: 8),
                                                                    child: ClipRRect(
                                                                      borderRadius: BorderRadius.circular(8),
                                                                      child: commonCacheImage(
                                                                        option.value,
                                                                        ImagePlaceHolder.imagePlaceHolderDark,
                                                                        width: 125,
                                                                        height: 154,
                                                                        fit: BoxFit.cover,
                                                                      ),
                                                                    ),
                                                                  )
                                                                      : Container(
                                                                    margin: const EdgeInsets.only(bottom: 12),
                                                                    child: Row(
                                                                      children: [
                                                                        Container(
                                                                          height: 32,
                                                                          width: 32,
                                                                          decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(6),
                                                                            color: AppColors.cardBgColor,
                                                                          ),
                                                                          child: Center(
                                                                            child: CommonText.regular(
                                                                              (i + 1).toString().padLeft(2, '0'),
                                                                              size: 14,
                                                                              color: AppColors.primary500,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const Gap(12),
                                                                        Expanded(
                                                                          child: CommonText.medium(
                                                                            option.value,
                                                                            size: 16,
                                                                            color: isDarkMode
                                                                                ? AppColors.bodyTextDarkColor
                                                                                : AppColors.bodyTextColor,
                                                                            maxLines: 1,
                                                                            overflow: TextOverflow.ellipsis,
                                                                          ),
                                                                        ),
                                                                        SvgImageFromAsset(
                                                                          AppCommonIcon.menuIcon,
                                                                          colorFilter: ColorFilter.mode(
                                                                            isDarkMode
                                                                                ? AppColors.white
                                                                                : AppColors.headingsColor,
                                                                            BlendMode.srcIn,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              // Index badge outside border
                                              Positioned(
                                                left: 0,
                                                top: 3,
                                                child: Container(
                                                  height: mobileView ? 34 : 47,
                                                  width: mobileView ? 34 : 47,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(6),
                                                    color: AppColors.primary500,
                                                  ),
                                                  child: Center(
                                                    child: CommonText.regular(
                                                      quiz.id.toString().padLeft(2, '0'),
                                                      size: 17,
                                                      color: AppColors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )



        //                               Theme(
        //                                 data: ThemeData(
        //                                   disabledColor: Colors.transparent,
        //                                 ),
        //                                 child: ReorderableListView.builder(
        //                                   shrinkWrap: true,
        //                                   physics: const NeverScrollableScrollPhysics(),
        //                                   buildDefaultDragHandles:
        //                                       false, // ✅ custom drag icon
        //                                   itemCount:
        //                                       controller.data.value.quizList.length,
        //                                   onReorder: (oldIndex, newIndex) {
        //                                     if (newIndex > oldIndex) newIndex--;
        //                                     final item = controller.data.value.quizList
        //                                         .removeAt(oldIndex);
        //                                     controller.data.value.quizList.insert(
        //                                       newIndex,
        //                                       item,
        //                                     );
        //                                     controller.update();
        //                                   },
        //                                   proxyDecorator:
        //                                       (
        //                                         Widget child,
        //                                         int index,
        //                                         Animation<double> animation,
        //                                       ) {
        //                                         return Material(
        //                                           elevation: 6,
        //                                           color: Colors.transparent,
        //                                           shadowColor: Colors.black45,
        //                                           child:
        //                                               child, // 🔑 show the actual widget instead of white
        //                                         );
        //                                       },
        //                                   itemBuilder: (context, index) {
        //                                     final data =
        //                                         controller.data.value.quizList[index];
        //
        //                                     return Container(
        //                                       key: ValueKey(
        //                                         data.id,
        //                                       ), // ✅ Unique key for quiz
        //                                       child: Theme(
        //                                         data: Theme.of(context).copyWith(
        //                                           dividerColor: Colors.transparent,
        //                                         ),
        //                                         child: Obx(
        //                                           () => ExpansionTile(
        //                                             tilePadding: EdgeInsets.zero,
        //                                             childrenPadding:
        //                                                 const EdgeInsets.only(
        //                                                   left: 56,
        //                                                   right: 16,
        //                                                 ),
        //                                             showTrailingIcon: false,
        //                                             onExpansionChanged: (expanded) {
        //                                               data.isExpanded.value = expanded;
        //                                             },
        //
        //                                             /// ✅ Question row
        //                                             title: Row(
        //                                               children: [
        //                                                 // Number box
        //                                                 Container(
        //                                                   height: mobileView?34:44,
        //                                                   width:  mobileView?34:44,
        //                                                   decoration: BoxDecoration(
        //                                                     borderRadius:
        //                                                         BorderRadius.circular(
        //                                                           6,
        //                                                         ),
        //                                                     color: AppColors.primary500,
        //                                                   ),
        //                                                   child: Center(
        //                                                     child: CommonText.regular(
        //                                                       data.id
        //                                                           .toString()
        //                                                           .padLeft(2, '0'),
        //                                                       size: 17,
        //                                                       color: AppColors.white,
        //                                                     ),
        //                                                   ),
        //                                                 ),
        //                                                 const Gap(12),
        //
        //                                                 // Question container
        //                                                 Expanded(
        //                                                   child: Container(
        //                                                     padding:
        //                                                         const EdgeInsets.symmetric(
        //                                                           horizontal: 15,
        //                                                           vertical: 15,
        //                                                         ),
        //                                                     decoration: BoxDecoration(
        //                                                       color: isDarkMode
        //                                                           ? AppColors
        //                                                                 .mainDarkBgColor
        //                                                           : AppColors.white,
        //                                                       borderRadius:
        //                                                           BorderRadius.circular(
        //                                                             8,
        //                                                           ),
        //                                                       border: Border.all(
        //                                                         color: isDarkMode
        //                                                             ? AppColors
        //                                                                   .grey100Color
        //                                                             : AppColors
        //                                                                   .lightBorderColor,
        //                                                       ),
        //                                                     ),
        //                                                     child: Row(
        //                                                       mainAxisAlignment:
        //                                                           MainAxisAlignment
        //                                                               .spaceBetween,
        //                                                       children: [
        //                                                         Expanded(
        //                                                           child:
        //                                                               CommonText.regular(
        //                                                                 data.question,
        //                                                                 size: 16,
        //                                                                 maxLines: 1,
        //                                                                 overflow: TextOverflow.ellipsis,
        //                                                               ),
        //                                                         ),
        // Gap(15),
        //                                                         // Custom drag handle + expand icon
        //                                                         ReorderableDragStartListener(
        //                                                           index: index,
        //                                                           child: Row(
        //                                                             children: [
        //                                                               SvgImageFromAsset(
        //                                                                 AppCommonIcon
        //                                                                     .menuIcon,
        //                                                                 colorFilter: ColorFilter.mode(
        //                                                                   isDarkMode
        //                                                                       ? AppColors
        //                                                                             .white
        //                                                                       : AppColors
        //                                                                             .headingsColor,
        //                                                                   BlendMode
        //                                                                       .srcIn,
        //                                                                 ),
        //                                                               ),
        //                                                               const Gap(8),
        //                                                               Icon(
        //                                                                 data
        //                                                                         .isExpanded
        //                                                                         .value
        //                                                                     ? Icons
        //                                                                           .keyboard_arrow_up
        //                                                                     : Icons
        //                                                                           .keyboard_arrow_down,
        //                                                                 color:
        //                                                                     isDarkMode
        //                                                                     ? AppColors
        //                                                                           .white
        //                                                                     : AppColors
        //                                                                           .headingsColor,
        //                                                               ),
        //                                                             ],
        //                                                           ),
        //                                                         ),
        //                                                       ],
        //                                                     ),
        //                                                   ),
        //                                                 ),
        //                                               ],
        //                                             ),
        //
        //                                             children: [
        //                                               SizedBox(
        //                                                 height:
        //                                                     data.options.any(
        //                                                       (e) => e.isImage,
        //                                                     )
        //                                                     ? 160
        //                                                     : null,
        //                                                 child: ReorderableListView.builder(
        //                                                   scrollDirection:
        //                                                       data.options.any(
        //                                                         (e) => e.isImage,
        //                                                       )
        //                                                       ? Axis.horizontal
        //                                                       : Axis.vertical,
        //                                                   buildDefaultDragHandles:
        //                                                       false,
        //                                                   shrinkWrap: true,
        //                                                   physics:
        //                                                       const NeverScrollableScrollPhysics(),
        //                                                   itemCount:
        //                                                       data.options.length,
        //                                                   onReorder: (oldIndex, newIndex) {
        //                                                     if (newIndex > oldIndex) {
        //                                                       newIndex--;
        //                                                     }
        //                                                     final item = data.options
        //                                                         .removeAt(oldIndex);
        //                                                     data.options.insert(
        //                                                       newIndex,
        //                                                       item,
        //                                                     );
        //                                                     controller
        //                                                         .update(); // 🔑 force GetX to rebuild
        //                                                   },
        //                                                   itemBuilder: (context, i) {
        //                                                     final option =
        //                                                         data.options[i];
        //                                                     return ReorderableDragStartListener(
        //                                                       key: ValueKey(
        //                                                         "quiz_${data.id}_opt_${option.id}_$i",
        //                                                       ), // 🔑 unique key
        //                                                       index: i,
        //                                                       child: option.isImage
        //                                                           ? Container(
        //                                                               margin:
        //                                                                   const EdgeInsets.symmetric(
        //                                                                     horizontal:
        //                                                                         8,
        //                                                                   ),
        //                                                               child: ClipRRect(
        //                                                                 borderRadius:
        //                                                                     BorderRadius.circular(
        //                                                                       8,
        //                                                                     ),
        //                                                                 child: commonCacheImage(
        //                                                                   option.value,
        //                                                                   ImagePlaceHolder
        //                                                                       .imagePlaceHolderDark,
        //                                                                   width: 125,
        //                                                                   height: 154,
        //                                                                   fit: BoxFit
        //                                                                       .cover,
        //                                                                 ),
        //                                                               ),
        //                                                             )
        //                                                           : Container(
        //                                                               margin:
        //                                                                   const EdgeInsets.only(
        //                                                                     bottom: 12,
        //                                                                   ),
        //                                                               child: Row(
        //                                                                 children: [
        //                                                                   Container(
        //                                                                     height: 32,
        //                                                                     width: 32,
        //                                                                     decoration: BoxDecoration(
        //                                                                       borderRadius:
        //                                                                           BorderRadius.circular(
        //                                                                             6,
        //                                                                           ),
        //                                                                       color: AppColors
        //                                                                           .cardBgColor,
        //                                                                     ),
        //                                                                     child: Center(
        //                                                                       child: CommonText.regular(
        //                                                                         (i + 1)
        //                                                                             .toString()
        //                                                                             .padLeft(
        //                                                                               2,
        //                                                                               '0',
        //                                                                             ),
        //                                                                         size:
        //                                                                             14,
        //                                                                         color: AppColors
        //                                                                             .primary500,
        //                                                                       ),
        //                                                                     ),
        //                                                                   ),
        //                                                                   const Gap(12),
        //                                                                   Expanded(
        //                                                                     child: CommonText.medium(
        //                                                                       option
        //                                                                           .value,
        //                                                                       size: 16,
        //                                                                       color: isDarkMode?AppColors.bodyTextDarkColor:AppColors
        //                                                                           .bodyTextColor,
        //                                                                       maxLines: 1,
        //                                                                       overflow: TextOverflow.ellipsis,
        //                                                                     ),
        //                                                                   ),
        //                                                                   SvgImageFromAsset(
        //                                                                     AppCommonIcon
        //                                                                         .menuIcon,
        //                                                                     colorFilter: ColorFilter.mode(
        //                                                                       isDarkMode
        //                                                                           ? AppColors.white
        //                                                                           : AppColors.headingsColor,
        //                                                                       BlendMode
        //                                                                           .srcIn,
        //                                                                     ),
        //                                                                   ),
        //                                                                 ],
        //                                                               ),
        //                                                             ),
        //                                                     );
        //                                                   },
        //                                                 ),
        //                                               ),
        //                                             ],
        //                                           ),
        //                                         ),
        //                                       ),
        //                                     );
        //                                   },
        //                                 ),
        //                               ),
                              ),
                            ),
                          ),
                          ResponsiveGridCol(
                            lg: 3,
                            xs: 0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                              child: quizDetail(),
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget quizDetail() {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.mainDarkBgColor : AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode
              ? AppColors.grey100Color
              : AppColors.lightBorderColor,
          width: 1,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: commonCacheImage(
              controller.data.value.image,
              ImagePlaceHolder.imagePlaceHolderDark,
              height: 250,
              width: double.infinity,
            ),
          ),
          Gap(12),
          CommonText.medium(controller.data.value.name, size: 18),
          Gap(12),
          CommonDivider(),

          Gap(12),
          CommonText.medium(
            controller.data.value.tag,
            size: 16,
            color: isDarkMode
                ? AppColors.bodyTextDarkColor
                : AppColors.bodyTextColor,
          ),
          Gap(12),
          CommonDivider(),
          Gap(12),
          CommonText.medium(
            controller.data.value.course,
            size: 16,
            color: isDarkMode
                ? AppColors.bodyTextDarkColor
                : AppColors.bodyTextColor,
          ),
          Gap(12),
          CommonDivider(),
          Gap(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText.medium(
                '${controller.data.value.totalAttendees.toString()} Attendees',
                size: 16,
                color: isDarkMode
                    ? AppColors.bodyTextDarkColor
                    : AppColors.bodyTextColor,
              ),
              CommonText.medium(
                '${controller.data.value.totalQuestions.toString()} Questions',
                size: 16,
                color: isDarkMode
                    ? AppColors.bodyTextDarkColor
                    : AppColors.bodyTextColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
