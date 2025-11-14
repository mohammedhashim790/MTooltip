import 'package:flutter/material.dart';

/// A compact, tappable card widget intended to be used as rich content inside
/// an [MTooltip].
///
/// The card displays a title on the left and a navigation icon with a simple
/// pagination indicator on the right. Tapping the icon invokes [onTap] with
/// the provided [index].
///
@Deprecated("Not Supported anymore.")
class MTooltipCard extends StatelessWidget {
  /// The main text shown on the left side of the card.
  final String title;

  /// Color applied to the [title] text.
  final Color titleColor;

  /// Maximum number of pages available (used for the pagination indicator).
  final int paginationLimit;

  /// The current page number shown in the pagination indicator.
  final int pagination;

  /// The index passed to [onTap] when the action icon is pressed.
  final int index;

  /// Callback invoked when the action icon is tapped. Receives [index].
  final Function(int) onTap;

  /// Creates an [MTooltipCard].
  ///
  /// All parameters are required to ensure predictable rendering and behavior.
  const MTooltipCard({
    super.key,
    required this.title,
    required this.titleColor,
    required this.paginationLimit,
    required this.pagination,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // The outer padding provides breathing room inside a tooltip overlay.
    // Width is constrained to 80% of the screen to avoid overflow in narrow
    // containers or when displayed as an overlay.
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        top: 16.0,
        bottom: 16.0,
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title area: expands to take most of the horizontal space.
              Expanded(
                flex: 8,
                child: Text(
                  title,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 16,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),

              // Action column: navigation icon (tap target) + pagination text.
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Navigation icon (tap target). Calls onTap(index).
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            onTap.call(index);
                          },
                          child: const Icon(
                            Icons.navigate_next,
                            size: 30.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    // Pagination indicator (e.g. "1/3").
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "$pagination/$paginationLimit",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              decoration: TextDecoration.none,
                            ),
                          ),
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
}
