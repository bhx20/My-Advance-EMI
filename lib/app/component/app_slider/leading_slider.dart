import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/app_colors.dart';

class CarouselSliderWidget extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext, int, int) itemBuilder;
  final Function(int, CarouselPageChangedReason) onPageChanged;
  final double? carouselHeight;
  final bool padEnds;
  final bool enableInfiniteScroll;
  final int currentIndex;
  final double? viewportFraction;
  final double? aspectRatio;
  final double? enlargeFactor;
  final bool autoPlay;
  final bool disableCenter;
  final bool enlargeCenterPage;
  final bool reverse;
  final bool animateToClosest;
  final Axis? scrollDirection;
  final ScrollPhysics? scrollPhysics;
  final Duration? autoPlayAnimationDuration;

  const CarouselSliderWidget({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.onPageChanged,
    this.carouselHeight,
    this.padEnds = true,
    this.enableInfiniteScroll = true,
    this.animateToClosest = true,
    required this.currentIndex,
    this.viewportFraction,
    this.aspectRatio,
    this.enlargeFactor,
    this.autoPlayAnimationDuration,
    this.autoPlay = false,
    this.reverse = false,
    this.scrollPhysics,
    this.disableCenter = false,
    this.enlargeCenterPage = false,
    this.scrollDirection,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: itemCount,
          itemBuilder: itemBuilder,
          options: CarouselOptions(
              height: carouselHeight ?? 100.h,
              padEnds: padEnds,
              enableInfiniteScroll: enableInfiniteScroll,
              onPageChanged: onPageChanged,
              aspectRatio: aspectRatio ?? 16 / 9,
              disableCenter: disableCenter,
              enlargeCenterPage: enlargeCenterPage,
              enlargeFactor: enlargeFactor ?? 0.3,
              reverse: reverse,
              animateToClosest: animateToClosest,
              scrollPhysics: scrollPhysics,
              autoPlayInterval: const Duration(seconds: 5),
              autoPlayAnimationDuration:
                  autoPlayAnimationDuration ?? const Duration(seconds: 1),
              scrollDirection: scrollDirection ?? Axis.horizontal,
              autoPlay: autoPlay),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(itemCount, (index) {
            return Container(
              width: index == currentIndex ? 20.w : 5.w,
              height: 4.h,
              margin: EdgeInsets.symmetric(horizontal: 3.w).copyWith(top: 10.h),
              decoration: BoxDecoration(
                  shape: index == currentIndex
                      ? BoxShape.rectangle
                      : BoxShape.circle,
                  borderRadius:
                      index == currentIndex ? BorderRadius.circular(10) : null,
                  color: index == currentIndex
                      ? AppColors.appColor
                      : AppColors.orchid),
            );
          }),
        )
      ],
    );
  }
}
