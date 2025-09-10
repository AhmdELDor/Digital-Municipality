import 'package:education_admin_portal/presentation/common_widgets/view_common_widget/common_card_decoration.dart';
import 'package:education_admin_portal/presentation/common_widgets/widgets/common_cache_image.dart';
import 'package:education_admin_portal/presentation/common_widgets/widgets/common_divider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../utils/extensions/responsive.dart';
import '../../../app/theme_controller.dart';
import '../../../common_widgets/input_field/common_date_picker.dart';
import '../../../common_widgets/input_field/common_search_field.dart';
import '../../../common_widgets/view_common_widget/common_dialog_box.dart';
import '../../../common_widgets/view_common_widget/custom_app_bar.dart';
import '../../../common_widgets/view_common_widget/custom_dropdown_button.dart';
import '../../../common_widgets/widgets/button.dart';
import '../../../common_widgets/widgets/image.dart';
import '../../../common_widgets/widgets/text.dart';
import '../../approvals_module/approvals_course_view/widgets/approvals_common_view.dart';
import '../../side_drawer_module/side_drawer_menu/side_drawer_imports.dart';
import 'controller/leader_board_controller.dart';
import 'model/leader_board_model.dart';

part 'leader_board_view.dart';