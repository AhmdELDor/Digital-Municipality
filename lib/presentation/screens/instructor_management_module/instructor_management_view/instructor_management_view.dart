part of 'instructor_management_view_imports.dart';

class InstructorManagementView extends StatefulWidget {
  const InstructorManagementView({super.key});

  @override
  State<InstructorManagementView> createState() =>
      _InstructorManagementViewState();
}

class _InstructorManagementViewState extends State<InstructorManagementView> {
  InstructorManagementController controller = Get.put(
    InstructorManagementController(),
  );
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var mobileView = ResponsiveView.isMobile(context);
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    commonHeaderText(
                      title: DashboardViewStrings.instructorManagement,
                    ),
                    CommonCircleAddButton(
                      onTap: () {
                        commonDialogBox(
                          context: context,
                          child: SizedBox(
                            width: 560,
                            child: AddDetailView(
                              title: AddInstructorStrings.addInstructor,
                              nameController: controller.nameController,
                              emailController: controller.emailController,
                              formKey: controller.formKey,
                              onPressed: () {
                                final isValid = controller.formKey.currentState!
                                    .validate();
                                FocusScope.of(
                                  context,
                                ).unfocus(); // ✅ safer than Get.focusScope

                                if (!isValid) return;

                                controller.formKey.currentState!.save();
                                // ✅ Close previous dialog safely
                                Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).pop();

                                commonDialogBox(
                                  context: context,
                                  child: SizedBox(
                                    width: 560,
                                    child: CommonDialogView(
                                      image: CommonImageAssets.inviteSent,
                                      title: InviteSendStrings.inviteSent,
                                      subtitle: InviteSendStrings.inviteSentDes,
                                      buttonBackgroundColor:
                                          AppColors.primary500,
                                      buttonName:
                                          InviteSendStrings.backToDashboard,
                                      onPressed: () {
                                        Navigator.of(
                                          context,
                                          rootNavigator: true,
                                        ).pop();

                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              CommonDivider(),
              Gap(20),
              Obx(
                () =>  controller.instructorManagementList.isEmpty
                    ? Center(child: CommonNoResultFound())
                    : Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: ResponsiveGridRow(
                    children: List.generate(
                      controller.instructorManagementList.length,
                      (index) {
                        final data = controller.instructorManagementList[index];
                        return ResponsiveGridCol(
                          lg: 3,
                          xs: 12,
                          child: InkWell(
                            //splashColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            onTap: () {
                              context.go(
                                '${AppRouteName.instructorManagementView}/${AppRouteName.instructorManagementDetailView}',
                                extra: data,
                              );
                            },
                            child: InstructorManagementDetailView(
                              data: data,
                              deleteOnTap: () {
                                commonDialogBox(
                                  context: context,
                                  child: SizedBox(
                                    width: 560,
                                    child: CommonDeleteDialogBox(
                                      tittle: CourseApproveDialogStrings
                                          .deleteInstructor,
                                      subtitle: CourseApproveDialogStrings
                                          .deleteInstructorDes,
                                      doneOnPressed: () {
                                        //Navigator.pop(context); // close dialog

                                        if (index <
                                            controller
                                                .instructorManagementList
                                                .length) {
                                          controller
                                              .instructorManagementList
                                              .removeAt(index);
                                          controller.instructorManagementList
                                              .refresh(); // ✅ refresh reactive state
                                        }
                                        Navigator.of(
                                          context,
                                          rootNavigator: true,
                                        ).pop();


                                        showSuccessMessage(
                                          context: context,
                                          title:
                                          'Instructor Deleted Successfully',
                                          content: '',
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
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
