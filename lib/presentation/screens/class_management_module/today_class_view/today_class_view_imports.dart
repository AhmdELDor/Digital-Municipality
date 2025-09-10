import 'package:education_admin_portal/presentation/common_widgets/widgets/button.dart';
import 'package:education_admin_portal/presentation/common_widgets/widgets/common_divider.dart';
import 'package:education_admin_portal/presentation/screens/class_management_module/today_class_view/widgets/today_class_common_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../utils/extensions/responsive.dart';
import '../../../app/app_route.dart';
import '../../../app/theme_controller.dart';
import '../../../common_widgets/common_text_view/common_header_text.dart';
import '../../../common_widgets/input_field/common_search_field.dart';
import '../../../common_widgets/view_common_widget/common_circle_add_button.dart';
import '../../../common_widgets/view_common_widget/common_dialog_box.dart';
import '../../../common_widgets/view_common_widget/custom_app_bar.dart';
import '../../../common_widgets/widgets/text.dart';
import '../../approvals_module/approvals_course_view/widgets/approvals_common_view.dart' hide courseCategoryDropDown, usersDropDown;
import '../../side_drawer_module/side_drawer_menu/side_drawer_imports.dart';
import 'controller/today_class_controller.dart';

part 'today_class_view.dart';