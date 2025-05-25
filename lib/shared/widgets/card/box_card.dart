import 'package:dongi/modules/box/domain/di/box_controller_di.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/constants/font_config.dart';
import '../../utilities/helpers/snackbar_helper.dart';
import '../../../modules/box/domain/models/box_model.dart';
import '../../../modules/group/domain/models/group_model.dart';
import '../../../core/router/router_names.dart';
import '../image/image_widget.dart';
import '../long_press_menu/long_press_menu.dart';
import 'card.dart';
import '../../../core/constants/color_config.dart';

class BoxCardWidget extends ConsumerWidget {
  final BoxModel boxModel;
  final GroupModel groupModel;

  const BoxCardWidget({
    super.key,
    required this.boxModel,
    required this.groupModel,
  });

  ///* Popup menu
  //_popupButton(BoxModel boxModel) {
  //  List<String> items = ["Edit", "Delete"];

  //  return Consumer(
  //    builder: (context, ref, child) {
  //      return PopupMenuButton<String>(
  //        padding: EdgeInsets.zero,
  //        child: const Icon(Icons.more_vert_outlined),
  //        itemBuilder: (BuildContext context) {
  //          return items
  //              .map(
  //                (val) => PopupMenuItem<String>(
  //                  child: Text(val),
  //                  onTap: () {
  //                    if (val == items[0]) {
  //                      //  Edit dropdown action
  //                    } else {
  //                      //  Delete dropdown action
  //                    }
  //                  },
  //                ),
  //              )
  //              .toList();
  //        },
  //      );
  //    },
  //  );
  //}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    deleteBox() async {
      await ref
          .read(boxNotifierProvider(groupModel.id!).notifier)
          .deleteBox(boxModel: boxModel, groupModel: groupModel);
      if (context.mounted) {
        showSnackBar(context, content: "box deleted successfully");
      }
    }

    // List<CupertinoContextMenuAction> menuItems = [
    //  CupertinoContextMenuAction(
    //    child: const Text('Edit'),
    //    onPressed: () => context.push(RouteName.updateBox, extra: box),
    //  ),
    //  CupertinoContextMenuAction(
    //    onPressed: deleteBox,
    //    child: const Text('Delete'),
    //  ),
    //];

    List<PopupMenuEntry> menuItems = [
      PopupMenuItem(
        child: const Text('Edit'),
        onTap: () => context.push(
          RouteName.updateBox,
          extra: {"boxModel": boxModel},
        ),
      ),
      PopupMenuItem(
        onTap: deleteBox,
        child: const Text('Delete'),
      ),
    ];

    return LongPressMenuWidget(
      onTap: () => context.push(
        RouteName.boxDetail(boxModel.id),
        extra: {"boxModel": boxModel, "groupModel": groupModel},
      ),
      items: menuItems,
      child: CardWidget(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        padding: EdgeInsets.zero,
        backColor: ColorConfig.white,
        borderColor: ColorConfig.primarySwatch.withOpacity(0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with image and title
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ColorConfig.primarySwatch.withOpacity(0.05),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: ColorConfig.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: ColorConfig.primarySwatch.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: ImageWidget(imageUrl: boxModel.image),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          boxModel.title,
                          style: FontConfig.body1().copyWith(
                            fontWeight: FontWeight.w600,
                            color: ColorConfig.midnight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${boxModel.boxUsers.length} members',
                          style: FontConfig.caption().copyWith(
                            color: ColorConfig.primarySwatch50,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Stats section
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Total bill
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: ColorConfig.secondary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                Icons.account_balance_wallet,
                                size: 14,
                                color: ColorConfig.secondary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Total Bill",
                              style: FontConfig.caption().copyWith(
                                color: ColorConfig.primarySwatch50,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${boxModel.total.toStringAsFixed(2)}',
                          style: FontConfig.h6().copyWith(
                            fontWeight: FontWeight.w600,
                            color: ColorConfig.midnight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Divider
                  Container(
                    width: 1,
                    height: 40,
                    color: ColorConfig.primarySwatch.withOpacity(0.1),
                  ),
                  // Expenses count
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF845EC2).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.receipt_long,
                                  size: 14,
                                  color: Color(0xFF845EC2),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Expenses",
                                style: FontConfig.caption().copyWith(
                                  color: ColorConfig.primarySwatch50,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${boxModel.expenseIds.length}',
                            style: FontConfig.h6().copyWith(
                              fontWeight: FontWeight.w600,
                              color: ColorConfig.midnight,
                            ),
                          ),
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
    );
  }
}
