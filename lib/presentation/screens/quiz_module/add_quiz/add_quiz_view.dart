part of 'add_quiz_imports.dart';

class AddQuizView extends StatefulWidget {
  final QuizModel? quizData;
  final TestModel? testData;
  final String? title;
  const AddQuizView({super.key, this.quizData, this.testData, this.title});

  @override
  State<AddQuizView> createState() => _AddQuizViewState();
}

class _AddQuizViewState extends State<AddQuizView> {
  @override
  void initState() {
    super.initState();
    // print("=====title======");
    // print(widget.title);
    // print(widget.quizData);
    // print(widget.testData);
  }
  AddQuizController controller = Get.put((AddQuizController()));
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    var mobileView = ResponsiveView.isMobile(context);
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;

    if (widget.quizData != null) {
      controller.fillData(widget.quizData);
    } else {
      () {
        controller.fillData(widget.testData);
      };
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: const SizedBox(width: 270, child: SideDrawerMenu()),
      appBar: CustomAppBar(
        showBackIcon: true,
        searchController: controller.searchController,
        drawerOnTap: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
      body: SafeArea(
        child: mobileView
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: controller.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
                              ),
                              child: CommonText.medium(
                                widget.testData != null
                                    ? TestStrings.addTest
                                    : widget.quizData != null
                                    ? AddQuizStrings.addQuiz
                                    : widget.title == 'Test'
                                    ? TestStrings.addTest
                                    : AddQuizStrings.addQuiz,
                                size: 18,
                              ),
                            ),
                            CommonDivider(),
                            Gap(20),
                            deviceView(isDarkMode),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                    child: Obx(() {
                      return controller.selectedType.value ==
                              "Multiple Choice Question"
                          ? Row(
                              children: [
                                Expanded(
                                  child: PrimaryButton(
                                    height: 42,
                                    onPressed: () {
                                      controller.questionIndex.value--;
                                    },
                                    label: AddCoursesStrings.previous,
                                    textSize: 16,
                                    textWeight: FontWeight.w500,
                                    backgroundColor: isDarkMode
                                        ? AppColors.mainDarkBgColor
                                        : AppColors.lightBgColor,
                                    borderSide: BorderSide(
                                      color: AppColors.primary500,
                                      width: 1,
                                    ),
                                    textColor: AppColors.primary500,
                                  ),
                                ),
                                Gap(25),
                                Expanded(
                                  child: PrimaryButton(
                                    height: 42,
                                    onPressed: () {
                                      controller.submit(context);
                                    },
                                    label: AddCoursesStrings.saveAndNext,
                                    textSize: 16,
                                    textWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: PrimaryButton(
                                    height: 42,
                                    onPressed: () {},
                                    label: AddCoursesStrings.previous,
                                    textSize: 16,
                                    textWeight: FontWeight.w500,
                                    backgroundColor: isDarkMode
                                        ? AppColors.mainDarkBgColor
                                        : AppColors.lightBgColor,
                                    borderSide: BorderSide(
                                      color: AppColors.primary500,
                                      width: 1,
                                    ),
                                    textColor: AppColors.primary500,
                                  ),
                                ),
                                Gap(25),
                                Expanded(
                                  child: PrimaryButton(
                                    height: 42,
                                    onPressed: () {
                                      controller.submit(context);
                                    },
                                    label: widget.testData != null
                                        ? TestStrings.createTest
                                        : widget.quizData != null
                                        ? QuizStrings.createQuiz
                                        : widget.title == 'Test'
                                        ? TestStrings.createTest
                                        : QuizStrings.createQuiz,
                                    textSize: 16,
                                    textWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            );
                    }),
                  ),
                ],
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: CommonText.medium(
                        widget.testData != null
                            ? TestStrings.addTest
                            : widget.quizData != null
                            ? AddQuizStrings.addQuiz
                            : widget.title == 'Test'
                            ? TestStrings.addTest
                            : AddQuizStrings.addQuiz,
                        size: 18,
                      ),
                    ),
                    CommonDivider(),
                    Gap(20),
                    desktopView(isDarkMode),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: ResponsiveGridRow(
                        children: [
                          ResponsiveGridCol(
                            lg: 9,
                            child: Container(
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isDarkMode
                                          ? AppColors.cardDarkBg2Color
                                          : AppColors.lightBgColor,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        topLeft: Radius.circular(20),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Obx(
                                          () => CommonText.regular(
                                            "Question ${controller.questionIndex.value}",
                                            size: 16,
                                          ),
                                        ),

                                        Gap(30),

                                        SizedBox(
                                          width: 250,

                                          child: Obx(
                                            () => AlwaysDownDropdown<String>(
                                              color: Colors.transparent,
                                              borderRadius: 6,
                                              hintText: "Select",
                                              items:
                                                  controller.selectedTypeList,
                                              value:
                                                  controller
                                                      .selectedType
                                                      .value
                                                      .isEmpty
                                                  ? null
                                                  : controller
                                                        .selectedType
                                                        .value,
                                              onChanged: (val) {
                                                controller.selectedType.value =
                                                    val ?? "";
                                              },
                                              // validator: (val) => val == null || val.isEmpty
                                              //     ? "Please select"
                                              //     : null,
                                            ),
                                          ),
                                        ),

                                        Spacer(),

                                        CommonDeleteView()
                                      ],
                                    ),
                                  ),
                                  CommonDivider(),

                                  Obx(() {
                                    if (controller.selectedType.value ==
                                        "Multiple Choice Question") {
                                      return multipleQuestionsView();
                                    } else if (controller.selectedType.value ==
                                        "A/B Answer") {
                                      return singleOptionsView();
                                    } else {
                                      return SizedBox(); // Empty initially
                                    }
                                  }),
                                ],
                              ),
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

  Widget desktopView(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ResponsiveGridRow(
        children: [
          ResponsiveGridCol(
            lg: 9,

            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        courseCategory(),
                        Gap(20),
                        courseNameView(),
                        Gap(20),
                        selectCourse(),
                      ],
                    ),
                  ),
                  Gap(25),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        languageView(),
                        Gap(20),
                        imageView(),
                        Gap(20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  commonRequiredHeaderText(
                                    QuizStrings.question,
                                  ),
                                  Gap(10),
                                  CommonTextField(
                                    hintText: QuizStrings.question,
                                    controller: controller.questionsController,
                                    textInputAction: TextInputAction.next,
                                    validator: (value) {
                                      return validateEmptyValue(
                                        value,
                                        'lectures is Required',
                                      );
                                    },
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              int current =
                                                  int.tryParse(
                                                    controller
                                                        .questionsController
                                                        .text,
                                                  ) ??
                                                  0;
                                              current++;
                                              controller
                                                  .questionsController
                                                  .text = current
                                                  .toString();
                                            },
                                            child: const Icon(
                                              Icons.keyboard_arrow_up,
                                              color: AppColors.bodyTextColor,
                                              size: 20,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              int current =
                                                  int.tryParse(
                                                    controller
                                                        .questionsController
                                                        .text,
                                                  ) ??
                                                  0;
                                              if (current > 0) {
                                                current--; // don’t go below 0
                                              }
                                              controller
                                                  .questionsController
                                                  .text = current
                                                  .toString();
                                            },
                                            child: const Icon(
                                              Icons.keyboard_arrow_down,
                                              color: AppColors.bodyTextColor,
                                              size: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Gap(25),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  commonRequiredHeaderText(
                                    QuizStrings.answerChangeable,
                                  ),
                                  Gap(15),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Obx(
                                          () => InkWell(
                                            onTap: () {
                                              controller.selectionOfRadio(0);
                                            },
                                            child: Container(
                                              height: 24,
                                              width: 24,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: AppColors.greyColor,
                                                  width: 1.25,
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Container(
                                                  height: 12,
                                                  width: 12,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        controller
                                                                .selectedRadioIndex
                                                                .value ==
                                                            0
                                                        ? AppColors.primary500
                                                        : Colors.transparent,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Gap(10),
                                        CommonText.medium(
                                          AddQuizStrings.yes,
                                          size: 16,
                                          color: isDarkMode
                                              ? AppColors.bodyTextDarkColor
                                              : AppColors.bodyTextColor,
                                        ),

                                        Gap(30),
                                        Obx(
                                          () => InkWell(
                                            onTap: () {
                                              controller.selectionOfRadio(1);
                                            },
                                            child: Container(
                                              height: 24,
                                              width: 24,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: AppColors.greyColor,
                                                  width: 1.25,
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Container(
                                                  height: 12,
                                                  width: 12,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        controller
                                                                .selectedRadioIndex
                                                                .value ==
                                                            1
                                                        ? AppColors.primary500
                                                        : Colors.transparent,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Gap(10),
                                        CommonText.medium(
                                          AddQuizStrings.no,
                                          size: 16,
                                          color: isDarkMode
                                              ? AppColors.bodyTextDarkColor
                                              : AppColors.bodyTextColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget multipleQuestionsView() {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          commonRequiredHeaderText(QuizStrings.question),
          Gap(10),
          CommonTextField(
            hintText: AddQuizStrings.enterQuestions,
            controller: controller.enterQuestionsController,
            textInputAction: TextInputAction.next,
            maxLines: 2,
            // validator: (value) {
            //   return validateEmptyValue(value, 'Quiz name is Required');
            // },
          ),
          Gap(15),
          CommonText.medium(
            AddQuizStrings.option,
            size: 17,
            color: isDarkMode
                ? AppColors.bodyTextDarkColor
                : AppColors.bodyTextColor,
          ),

          Gap(20),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    optionTile(0, AddQuizStrings.optionOne,TextInputAction.next),
                    Gap(20),
                    optionTile(2, AddQuizStrings.optionThree,TextInputAction.next),
                  ],
                ),
              ),
              Gap(25),
              Expanded(
                child: Column(
                  children: [
                    optionTile(1, AddQuizStrings.optionTwo,TextInputAction.done),
                    Gap(20),
                    optionTile(3, AddQuizStrings.optionFour,TextInputAction.done),
                  ],
                ),
              ),
            ],
          ),
          Gap(30),
          Row(
            children: [
              SizedBox(
                width: 160,
                child: PrimaryButton(
                  height: 42,
                  onPressed: () {
                    controller.questionIndex.value--;
                  },
                  label: AddCoursesStrings.previous,
                  textSize: 16,
                  textWeight: FontWeight.w500,
                  backgroundColor: isDarkMode
                      ? AppColors.mainDarkBgColor
                      : AppColors.lightBgColor,
                  borderSide: BorderSide(color: AppColors.primary500, width: 1),
                  textColor: AppColors.primary500,
                ),
              ),
              Gap(25),
              SizedBox(
                width: 160,
                child: PrimaryButton(
                  height: 42,
                  onPressed: () {
                    controller.submit(context);
                  },
                  label: AddCoursesStrings.saveAndNext,
                  textSize: 16,
                  textWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget singleOptionsView() {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          commonRequiredHeaderText(QuizStrings.question),
          Gap(10),
          CommonTextField(
            hintText: AddQuizStrings.enterQuestions,
            controller: controller.enterQuestionsController,
            textInputAction: TextInputAction.next,
            maxLines: 2,
            // validator: (value) {
            //   return validateEmptyValue(value, 'Quiz name is Required');
            // },
          ),
          Gap(15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,

                  children: [
                    imageAView(),
                    Gap(20),
                    CommonText.medium(
                      AddQuizStrings.option,
                      size: 17,
                      color: isDarkMode
                          ? AppColors.bodyTextDarkColor
                          : AppColors.bodyTextColor,
                    ),
                    Gap(15),
                    commonOptionsView(
                      title: AddQuizStrings.optionOne,
                      hintText: AddQuizStrings.enterOptionOne,
                      textController: controller.singleQuestionOneController,
                      showDeleteIcon: false,
                    ),
                  ],
                ),
              ),
              Gap(20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    imageBView(),

                    Gap(20),
                    CommonText.medium(
                      '',
                      size: 17,
                      color: isDarkMode
                          ? AppColors.bodyTextDarkColor
                          : AppColors.bodyTextColor,
                    ),
                    Gap(15),
                    commonOptionsView(
                      title: AddQuizStrings.optionTwo,
                      hintText: AddQuizStrings.enterOptionTwo,
                      textController: controller.singleQuestionTwoController,
                      showDeleteIcon: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(30),
          Row(
            children: [
              SizedBox(
                width: 160,
                child: PrimaryButton(
                  height: 42,
                  onPressed: () {},
                  label: AddCoursesStrings.previous,
                  textSize: 16,
                  textWeight: FontWeight.w500,
                  backgroundColor: isDarkMode
                      ? AppColors.mainDarkBgColor
                      : AppColors.lightBgColor,
                  borderSide: BorderSide(color: AppColors.primary500, width: 1),
                  textColor: AppColors.primary500,
                ),
              ),
              Gap(25),
              SizedBox(
                width: 160,
                child: PrimaryButton(
                  height: 42,
                  onPressed: () {
                    controller.submit(context);
                  },

                  label: widget.testData != null
                      ? TestStrings.createTest
                      : widget.quizData != null
                      ? QuizStrings.createQuiz
                      : widget.title == 'Test'
                      ? TestStrings.createTest
                      : QuizStrings.createQuiz,

                  textSize: 16,
                  textWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget optionTile(int index, String label,TextInputAction? textInputAction) {
    return commonOptionsView(
      title: label,
      hintText: "Enter $label",
      textController: controller.options[index],
      textInputAction: textInputAction
    );
  }

  Widget optionWithArrows({
    required Widget child,
    required VoidCallback onMoveUp,
    required VoidCallback onMoveDown,
  }) {
    return Row(
      children: [
        Expanded(child: child),
        Column(
          children: [
            IconButton(icon: Icon(Icons.arrow_upward), onPressed: onMoveUp),
            IconButton(icon: Icon(Icons.arrow_downward), onPressed: onMoveDown),
          ],
        ),
      ],
    );
  }

  Widget courseCategory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonRequiredHeaderText(AddCoursesStrings.category),
        Gap(10),
        Obx(
          () => AlwaysDownDropdown<String>(
            color: Colors.transparent,
            hintText: "Select",
            items: controller.categoryList,
            value: controller.selectedCategory.value.isEmpty
                ? null
                : controller.selectedCategory.value,
            onChanged: (val) {
              controller.selectedCategory.value = val ?? '';
            },
            //validator: (val) => val == null || val.isEmpty ? "Select" : null,
          ),
        ),
      ],
    );
  }

  Widget languageView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonRequiredHeaderText(AddCoursesStrings.language),
        Gap(10),
        Obx(
          () => AlwaysDownDropdown<String>(
            color: Colors.transparent,
            hintText: "Select",
            items: controller.languageList,
            value: controller.selectedLanguage.value.isEmpty
                ? null
                : controller.selectedLanguage.value,
            onChanged: (val) {
              controller.selectedLanguage.value = val ?? '';
            },
            //validator: (val) => val == null || val.isEmpty ? "Select" : null,
          ),
        ),
      ],
    );
  }

  Widget courseNameView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonRequiredHeaderText(AddCoursesStrings.name),
        Gap(10),
        CommonTextField(
          hintText: AddQuizStrings.enterQuizName,
          controller: controller.quizNameController,
          textInputAction: TextInputAction.next,
          validator: (value) {
            return validateEmptyValue(value, 'Quiz name is Required');
          },
        ),
      ],
    );
  }

  Widget imageView() {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonRequiredHeaderText(AddCoursesStrings.imageVideo),
        Gap(10),
        CommonTextField(
          hintText: AddCoursesStrings.select,
          controller: controller.imageVideoController,
          textInputAction: TextInputAction.next,
          validator: (value) {
            return validateEmptyValue(value, 'This Field is Required');
          },
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: () {
                controller.pickFileCommon(controller.imageVideoController);
              },
              child: Container(
                width: 73,
                height: 25,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppColors.greyDarkColor
                      : AppColors.lightBorderColor.withValues(alpha: 0.40),
                  border: Border.all(
                    color: isDarkMode
                        ? AppColors.grey100Color
                        : AppColors.lightBorderColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: CommonText.medium(
                    AddCoursesStrings.chooseFile,
                    size: 12,
                    color: isDarkMode
                        ? AppColors.bodyTextDarkColor
                        : AppColors.bodyTextColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget selectCourse() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonRequiredHeaderText(AddQuizStrings.course),
        Gap(10),
        Obx(
          () => AlwaysDownDropdown<String>(
            color: Colors.transparent,
            hintText: "Select",
            items: controller.coursesList,
            value: controller.selectedCourses.value.isEmpty
                ? null
                : controller.selectedCourses.value,
            onChanged: (val) {
              controller.selectedCourses.value = val ?? '';
            },
            //validator: (val) => val == null || val.isEmpty ? "Select" : null,
          ),
        ),
      ],
    );
  }

  Widget arrowIconView(void Function()? onTap, String image) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppColors.mainDarkBgColor
              : AppColors.lightBgColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isDarkMode
                ? AppColors.grey100Color
                : AppColors.lightBorderColor,
          ),
        ),
        child: Center(child: SvgImageFromAsset(image)),
      ),
    );
  }

  Widget commonOptionsView({
    required String title,
    required String hintText,
    required TextEditingController textController,
    // required void Function() downOnTap,
    // required void Function() upOnTap,
    bool showDeleteIcon = true,
    TextInputAction? textInputAction
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: commonRequiredHeaderText(title)),

            showDeleteIcon == false
                ? SizedBox()
                : CommonDeleteView(),
          ],
        ),
        Gap(10),
        CommonTextField(
          hintText: hintText,
          controller: textController,
          textInputAction:textInputAction?? TextInputAction.next,
        ),
      ],
    );
  }

  Widget imageAView() {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonRequiredHeaderText(AddQuizStrings.imageA),
        Gap(10),
        CommonTextField(
          hintText: AddCoursesStrings.select,
          controller: controller.imageAController,
          textInputAction: TextInputAction.next,
          validator: (value) {
            return validateEmptyValue(value, 'This Field is Required');
          },
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: () {
                controller.pickFileCommon(controller.imageAController);
              },
              child: Container(
                width: 73,
                height: 25,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppColors.greyDarkColor
                      : AppColors.lightBorderColor.withValues(alpha: 0.40),
                  border: Border.all(
                    color: isDarkMode
                        ? AppColors.grey100Color
                        : AppColors.lightBorderColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: CommonText.medium(
                    AddCoursesStrings.chooseFile,
                    size: 12,
                    color: isDarkMode
                        ? AppColors.bodyTextDarkColor
                        : AppColors.bodyTextColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget imageBView() {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonRequiredHeaderText(AddQuizStrings.imageB),
        Gap(10),
        CommonTextField(
          hintText: AddCoursesStrings.select,
          controller: controller.imageBController,
          textInputAction: TextInputAction.next,
          validator: (value) {
            return validateEmptyValue(value, 'This Field is Required');
          },
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: () {
                controller.pickFileCommon(controller.imageBController);
              },
              child: Container(
                width: 73,
                height: 25,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppColors.greyDarkColor
                      : AppColors.lightBorderColor.withValues(alpha: 0.40),
                  border: Border.all(
                    color: isDarkMode
                        ? AppColors.grey100Color
                        : AppColors.lightBorderColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: CommonText.medium(
                    AddCoursesStrings.chooseFile,
                    size: 12,
                    color: isDarkMode
                        ? AppColors.bodyTextDarkColor
                        : AppColors.bodyTextColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget deviceView(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                courseCategory(),
                Gap(15),
                languageView(),
                Gap(15),
                courseNameView(),
                Gap(15),
                imageView(),
                Gap(15),
                selectCourse(),
                Gap(15),
                commonRequiredHeaderText(QuizStrings.question),
                Gap(10),
                CommonTextField(
                  hintText: QuizStrings.question,
                  controller: controller.questionsController,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    return validateEmptyValue(value, 'lectures is Required');
                  },
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            int current =
                                int.tryParse(
                                  controller.questionsController.text,
                                ) ??
                                0;
                            current++;
                            controller.questionsController.text = current
                                .toString();
                          },
                          child: const Icon(
                            Icons.keyboard_arrow_up,
                            color: AppColors.bodyTextColor,
                            size: 20,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            int current =
                                int.tryParse(
                                  controller.questionsController.text,
                                ) ??
                                0;
                            if (current > 0) {
                              current--; // don’t go below 0
                            }
                            controller.questionsController.text = current
                                .toString();
                          },
                          child: const Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.bodyTextColor,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Gap(15),
                commonRequiredHeaderText(QuizStrings.answerChangeable),
                Gap(15),
                Row(
                  children: [
                    Obx(
                      () => InkWell(
                        onTap: () {
                          controller.selectionOfRadio(0);
                        },
                        child: Container(
                          height: 24,
                          width: 24,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.greyColor,
                              width: 1.25,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Container(
                              height: 12,
                              width: 12,
                              decoration: BoxDecoration(
                                color: controller.selectedRadioIndex.value == 0
                                    ? AppColors.primary500
                                    : Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Gap(10),
                    CommonText.medium(
                      AddQuizStrings.yes,
                      size: 16,
                      color: isDarkMode
                          ? AppColors.bodyTextDarkColor
                          : AppColors.bodyTextColor,
                    ),

                    Gap(30),
                    Obx(
                      () => InkWell(
                        onTap: () {
                          controller.selectionOfRadio(1);
                        },
                        child: Container(
                          height: 24,
                          width: 24,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.greyColor,
                              width: 1.25,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Container(
                              height: 12,
                              width: 12,
                              decoration: BoxDecoration(
                                color: controller.selectedRadioIndex.value == 1
                                    ? AppColors.primary500
                                    : Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Gap(10),
                    CommonText.medium(
                      AddQuizStrings.no,
                      size: 16,
                      color: isDarkMode
                          ? AppColors.bodyTextDarkColor
                          : AppColors.bodyTextColor,
                    ),
                  ],
                ),
                Gap(15),

                Container(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          // color: isDarkMode
                          //     ? AppColors.cardDarkBg2Color
                          //     : AppColors.lightBgColor,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          children: [
                            Obx(
                              () => CommonText.regular(
                                "Question ${controller.questionIndex.value}",
                                size: 16,
                              ),
                            ),

                            Gap(30),

                            Spacer(),

                            Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? AppColors.error500
                                    : AppColors.error100,
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Center(
                                child: SvgImageFromAsset(
                                  AppCommonIcon.quizDeleteIcon,
                                  height: 20,
                                  width: 20,
                                  colorFilter: ColorFilter.mode(
                                    isDarkMode
                                        ? AppColors.white
                                        : AppColors.error500,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Gap(15),
                      CommonDivider(),
                      Gap(15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: commonRequiredHeaderText('Question Type'),
                      ),
                      Gap(15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Obx(
                          () => AlwaysDownDropdown<String>(
                            color: isDarkMode
                                ? AppColors.greyDarkColor
                                : AppColors.lightBorderColor,
                            borderRadius: 6,
                            hintText: "Select",
                            items: controller.selectedTypeList,
                            value: controller.selectedType.value.isEmpty
                                ? null
                                : controller.selectedType.value,
                            onChanged: (val) {
                              controller.selectedType.value = val ?? "";
                            },
                          ),
                        ),
                      ),
                      Gap(15),
                      Obx(() {
                        if (controller.selectedType.value ==
                            "Multiple Choice Question") {
                          return deviceMultipleQuestionsView(isDarkMode);
                        } else if (controller.selectedType.value ==
                            "A/B Answer") {
                          return deviceSingleQuestionsView(isDarkMode);
                        } else {
                          return SizedBox(); // Empty initially
                        }
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget deviceMultipleQuestionsView(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          commonRequiredHeaderText(QuizStrings.question),
          Gap(10),
          CommonTextField(
            hintText: AddQuizStrings.enterQuestions,
            controller: controller.enterQuestionsController,
            textInputAction: TextInputAction.next,
            maxLines: 2,
            validator: (value) {
              return validateEmptyValue(value, 'This Filed is Required');
            },
          ),
          Gap(15),
          CommonText.medium(
            AddQuizStrings.option,
            size: 17,
            color: isDarkMode
                ? AppColors.bodyTextDarkColor
                : AppColors.bodyTextColor,
          ),
          Gap(15),
          optionTile(0, AddQuizStrings.optionOne,TextInputAction.next),
          Gap(20),
          optionTile(1, AddQuizStrings.optionTwo,TextInputAction.next),
          Gap(20),
          optionTile(2, AddQuizStrings.optionThree,TextInputAction.next),
          Gap(20),
          optionTile(3, AddQuizStrings.optionFour,TextInputAction.done),
          Gap(15),
        ],
      ),
    );
  }

  Widget deviceSingleQuestionsView(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          commonRequiredHeaderText(QuizStrings.question),
          Gap(10),
          CommonTextField(
            hintText: AddQuizStrings.enterQuestions,
            controller: controller.enterQuestionsController,
            textInputAction: TextInputAction.next,
            maxLines: 2,
            // validator: (value) {
            //   return validateEmptyValue(value, 'Quiz name is Required');
            // },
          ),
          Gap(15),
          imageAView(),
          Gap(20),
          imageBView(),
          Gap(20),
          CommonText.medium(
            AddQuizStrings.option,
            size: 17,
            color: isDarkMode
                ? AppColors.bodyTextDarkColor
                : AppColors.bodyTextColor,
          ),
          Gap(15),
          commonOptionsView(
            title: AddQuizStrings.optionOne,
            hintText: AddQuizStrings.enterOptionOne,
            textController: controller.singleQuestionOneController,
            showDeleteIcon: false,
            textInputAction: TextInputAction.next
          ),
          CommonText.medium(
            '',
            size: 17,
            color: isDarkMode
                ? AppColors.bodyTextDarkColor
                : AppColors.bodyTextColor,
          ),
          //Gap(15),
          commonOptionsView(
            title: AddQuizStrings.optionTwo,
            hintText: AddQuizStrings.enterOptionTwo,
            textController: controller.singleQuestionTwoController,
            showDeleteIcon: false,
            textInputAction: TextInputAction.done
          ),
          Gap(15),
        ],
      ),
    );
  }
}
