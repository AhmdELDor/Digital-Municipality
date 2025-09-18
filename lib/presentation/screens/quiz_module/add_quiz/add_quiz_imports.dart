import 'package:education_admin_portal/core/constants/app_assets.dart';
import 'package:education_admin_portal/core/constants/app_colors.dart';
import 'package:education_admin_portal/presentation/common_widgets/widgets/common_divider.dart';
import 'package:education_admin_portal/presentation/common_widgets/widgets/widgets.dart';
import 'package:education_admin_portal/presentation/screens/test_module/main_test_view/model/test_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../utils/extensions/responsive.dart';
import '../../../app/theme_controller.dart';
import '../../../common_widgets/input_field/common_text_field.dart';
import '../../../common_widgets/view_common_widget/common_delete_view.dart';
import '../../../common_widgets/view_common_widget/custom_app_bar.dart';
import '../../../common_widgets/view_common_widget/custom_dropdown_button.dart';
import '../../../common_widgets/widgets/validations.dart';
import '../../add_course_module/widgets/basic_information_view.dart';
import '../../side_drawer_module/side_drawer_menu/side_drawer_imports.dart';
import '../quiz_main_view/model/quiz_model.dart';
import 'controller/add_quiz_controller.dart';

part 'add_quiz_view.dart';