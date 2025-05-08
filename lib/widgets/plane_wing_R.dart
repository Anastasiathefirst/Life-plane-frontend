import 'package:flutter/material.dart';

class PlaneWing_R extends StatelessWidget {
  final double width;
  final bool isActive;
  final bool isSelected;
  final bool isCompositeMode;

  const PlaneWing_R({
    super.key,
    required this.width,
    required this.isActive,
    required this.isSelected,
    required this.isCompositeMode,
  });

  @override
  Widget build(BuildContext context) {
    final shouldDarken = (isActive || isSelected) && !isCompositeMode;

    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: width,
        child: ColorFiltered(
          colorFilter: shouldDarken
              ? ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.srcATop)
              : const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
          child: Image.asset(
            'assets/images/plane_wing_R.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
