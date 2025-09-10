import 'package:education_admin_portal/core/constants/app_colors.dart';
import 'package:education_admin_portal/presentation/common_widgets/widgets/common_divider.dart';
import 'package:education_admin_portal/presentation/common_widgets/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';


import '../../../../core/constants/app_strings.dart';
import '../../../../utils/extensions/responsive.dart';
import '../../../app/app_route.dart';
import '../../../app/theme_controller.dart';
import '../../../common_widgets/common_text_view/common_header_text.dart';
import '../../../common_widgets/input_field/common_search_field.dart';
import '../../../common_widgets/view_common_widget/common_circle_add_button.dart';
import '../../../common_widgets/view_common_widget/custom_app_bar.dart';
import '../../side_drawer_module/side_drawer_menu/side_drawer_imports.dart';
import 'controller/class_management_controller.dart';
import 'model/class_model.dart';

part 'class_management_view.dart';