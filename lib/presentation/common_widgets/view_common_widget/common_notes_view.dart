import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../screens/dashboard_module/dashboard/model/notes_model.dart';
import '../widgets/common_cache_image.dart';
import '../widgets/text.dart';

class CommonNotesView extends StatefulWidget {
  final NoteModel note;
  const CommonNotesView({super.key, required this.note});

  @override
  State<CommonNotesView> createState() => _CommonNotesViewState();
}

class _CommonNotesViewState extends State<CommonNotesView> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: commonCacheImage(
            widget.note.backgroundImage,
            ImagePlaceHolder.imagePlaceHolderDark,
            height: 174,
            fit: BoxFit.fill,
            width: double.infinity,
          ),
        ),
        Positioned(
          left: 10,
          top: 10,
          right: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CommonText.medium(
                  widget. note.name,
                  size: 16,
                  color: AppColors.white,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              CommonText.medium(widget.note.date, size: 13, color: AppColors.white),
            ],
          ),
        ),
        Positioned(
          top: 50,
          left: 0,
          right: 0,
          child: Divider(color: hexToColor(widget.note.notesColor)),),
        Positioned(
          left: 10,
          bottom: 10,
          right: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Expanded(
              //       child: CommonText.medium(
              //         widget. note.name,
              //         size: 16,
              //         color: AppColors.white,
              //         overflow: TextOverflow.ellipsis,
              //       ),
              //     ),
              //     CommonText.medium(widget.note.date, size: 13, color: AppColors.white),
              //   ],
              // ),
              // Gap(15),
              // Divider(color: hexToColor(widget.note.notesColor)),
              // Gap(15),
              CommonText.medium(
                widget.note.description,
                size: 13,
                color: AppColors.white,
                maxLines: 5,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
