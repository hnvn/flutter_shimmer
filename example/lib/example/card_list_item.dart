import 'package:flutter/material.dart';
import 'package:shimmer_example/example/circle_list_item.dart';

class CardListItem extends StatelessWidget {
  const CardListItem({
    Key key,
    this.isLoading = true,
  }) : super(key: key);

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const CircleListItem(size: 70,),
          const SizedBox(
            width: 10,
          ),
          _buildText(),
          const CircleListItem(size: 20,),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildText(width: 60, height: 20),
              const SizedBox(height: 5,),
              _buildText(width: 80, height: 20),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildText({double width = 100, double height = 24}) {
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
    );
  }
}
