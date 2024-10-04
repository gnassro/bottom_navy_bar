library bottom_navy_bar;

import 'package:flutter/material.dart';

typedef BottomNavyBarItemWidgetBuilder = Widget Function(BuildContext context, bool isActive);

/// A beautiful and animated bottom navigation that paints a rounded shape
/// around its [items] to provide a wonderful look.
///
/// Update [selectedIndex] to change the selected item.
/// [selectedIndex] is required and must not be null.
class BottomNavyBar extends StatelessWidget {
  BottomNavyBar({
    Key? key,
    this.selectedIndex = 0,
    this.showElevation = true,
    this.iconSize = 24,
    this.backgroundColor,
    this.shadowColor = Colors.black12,
    this.itemCornerRadius = 50,
    this.containerHeight = 56,
    this.blurRadius = 2,
    this.spreadRadius = 0,
    this.borderRadius,
    this.shadowOffset = Offset.zero,
    this.itemPadding = const EdgeInsets.symmetric(horizontal: 4),
    this.animationDuration = const Duration(milliseconds: 270),
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.showInactiveTitle = false,
    required this.items,
    required this.onItemSelected,
    this.curve = Curves.linear,
  })  : assert(items.length >= 2 && items.length <= 5),
        super(key: key);

  /// The selected item is index. Changing this property will change and animate
  /// the item being selected. Defaults to zero.
  final int selectedIndex;

  /// The icon size of all items. Defaults to 24.
  final double iconSize;

  /// The background color of the navigation bar. It defaults to
  /// [ThemeData.BottomAppBarTheme.color] if not provided.
  final Color? backgroundColor;

  /// Defines the shadow color of the navigation bar. Defaults to [Colors.black12].
  final Color shadowColor;

  /// Whether this navigation bar should show a elevation. Defaults to true.
  final bool showElevation;

  /// Use this to change the item's animation duration. Defaults to 270ms.
  final Duration animationDuration;

  /// Defines the appearance of the buttons that are displayed in the bottom
  /// navigation bar. This should have at least two items and five at most.
  final List<BottomNavyBarItem> items;

  /// A callback that will be called when a item is pressed.
  final ValueChanged<int> onItemSelected;

  /// Defines the alignment of the items.
  /// Defaults to [MainAxisAlignment.spaceBetween].
  final MainAxisAlignment mainAxisAlignment;

  /// The [items] corner radius, if not set, it defaults to 50.
  final double itemCornerRadius;

  /// Defines the bottom navigation bar height. Defaults to 56.
  final double containerHeight;

  /// Used to configure the blurRadius of the [BoxShadow]. Defaults to 2.
  final double blurRadius;

  /// Used to configure the spreadRadius of the [BoxShadow]. Defaults to 0.
  final double spreadRadius;

  /// Used to configure the offset of the [BoxShadow]. Defaults to null.
  final Offset shadowOffset;

  /// Used to configure the borderRadius of the [BottomNavyBar]. Defaults to null.
  final BorderRadiusGeometry? borderRadius;

  /// Used to configure the padding of the [BottomNavyBarItem] [items].
  /// Defaults to EdgeInsets.symmetric(horizontal: 4).
  final EdgeInsetsGeometry itemPadding;

  /// Used to configure the animation curve. Defaults to [Curves.linear].
  final Curve curve;

  /// Whether this navigation bar should show a Inactive titles. Defaults to false.
  final bool showInactiveTitle;

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ??
        (Theme.of(context).bottomAppBarTheme.color ?? Colors.white);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: [
          if (showElevation)
            BoxShadow(
              color: shadowColor,
              blurRadius: blurRadius,
              spreadRadius: spreadRadius,
              offset: shadowOffset,
            ),
        ],
        borderRadius: borderRadius,
      ),
      child: SafeArea(
        child: Container(
          width: double.infinity,
          height: containerHeight,
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: Row(
            mainAxisAlignment: mainAxisAlignment,
            children: items.map((item) {
              var index = items.indexOf(item);
              return _ItemWidget(
                item: item,
                iconSize: iconSize,
                isSelected: index == selectedIndex,
                backgroundColor: bgColor,
                itemCornerRadius: itemCornerRadius,
                animationDuration: animationDuration,
                onItemSelected: onItemSelected,
                itemPadding: itemPadding,
                itemIndex: index,
                curve: curve,
                itemsCount: items.length,
                showInactiveTitle: showInactiveTitle,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  final double iconSize;
  final bool isSelected;
  final BottomNavyBarItem item;
  final Color backgroundColor;
  final double itemCornerRadius;
  final Duration animationDuration;
  final EdgeInsetsGeometry itemPadding;
  final Curve curve;
  final bool showInactiveTitle;
  final int itemsCount;
  final int itemIndex;
  final ValueChanged<int> onItemSelected;

  const _ItemWidget({
    Key? key,
    required this.iconSize,
    required this.isSelected,
    required this.item,
    required this.itemIndex,
    required this.backgroundColor,
    required this.itemCornerRadius,
    required this.animationDuration,
    required this.itemPadding,
    required this.showInactiveTitle,
    required this.itemsCount,
    required this.onItemSelected,
    this.curve = Curves.linear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget semantic = LayoutBuilder(
        builder: (context, constraint) {
        return GestureDetector(
          onTap: () => onItemSelected(itemIndex),
          child: Semantics(
            container: true,
            selected: isSelected,
            child: AnimatedContainer(
              duration: animationDuration,
              curve: curve,
              width: isSelected ? null : constraint.maxWidth,
              decoration: BoxDecoration(
                color: isSelected
                    ? (item.activeBackgroundColor ??
                    item.activeColor.withOpacity(0.2))
                    : backgroundColor,
                borderRadius: BorderRadius.circular(itemCornerRadius),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: NeverScrollableScrollPhysics(),
                child: Container(
                  width: isSelected ? null : constraint.maxWidth,
                  padding: itemPadding,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      item.icon(context, isSelected),
                      if (showInactiveTitle)
                        SizedBox(
                          child: DefaultTextStyle.merge(
                            style: TextStyle(
                              color: item.activeTextColor ?? item.activeColor,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            textAlign: item.textAlign,
                            overflow: TextOverflow.ellipsis,
                            child: item.title(context, isSelected),
                          ),
                        )
                      else if (isSelected)
                        SizedBox(
                          child: DefaultTextStyle.merge(
                            style: TextStyle(
                              color: item.activeColor,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            textAlign: item.textAlign,
                            overflow: TextOverflow.ellipsis,
                            child: item.title(context, isSelected),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    );
    final Widget itemWidget = item.tooltipText == null
        ? semantic
        : Tooltip(
      message: item.tooltipText!,
      child: semantic,
    );
    return isSelected ? ConstrainedBox(
        child: itemWidget,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width * 0.5
      ),
    ) : Expanded(
        child: itemWidget
    );
  }
}

/// The [BottomNavyBar.items] definition.
class BottomNavyBarItem {
  BottomNavyBarItem({
    required this.icon,
    required this.title,
    this.activeColor = Colors.blue,
    this.textAlign,
    this.inactiveColor,
    this.activeTextColor,
    this.activeBackgroundColor,
    this.tooltipText,
  });

  /// Defines this item's icon which is placed in the right side of the [title].
  final BottomNavyBarItemWidgetBuilder icon;

  /// Defines this item's title which placed in the left side of the [icon].
  final BottomNavyBarItemWidgetBuilder title;

  /// The [icon] and [title] color defined when this item is selected. Defaults
  /// to [Colors.blue].
  final Color activeColor;

  /// The [icon] and [title] color defined when this item is not selected.
  final Color? inactiveColor;

  /// The alignment for the [title].
  ///
  /// This will take effect only if [title] it a [Text] widget.
  final TextAlign? textAlign;

  /// The [title] color with higher priority than [activeColor]
  ///
  /// Will fallback to [activeColor] when null
  final Color? activeTextColor;

  /// The [BottomNavyBarItem] background color when active.
  ///
  /// Will fallback to [activeColor] with opacity 0.2 when null
  final Color? activeBackgroundColor;
  /// Will show a tooltip for the item if provided.
  final String? tooltipText;
}
