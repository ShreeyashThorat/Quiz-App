// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quiz_app/utils/constant_data.dart';
import 'package:quiz_app/views/home/home_screen.dart';

import '../../logic/bottom_nav/cubit/bottom_nav_cubit.dart';
import '../../utils/color_theme.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BottomNavCubit, BottomNavState>(
        builder: (context, state) {
          if (state.navbarItem == NavbarItem.dashboard) {
            return const HomeScreen();
          } else if (state.navbarItem == NavbarItem.stats) {
            return const Center(
              child: Text("Stats"),
            );
          } else if (state.navbarItem == NavbarItem.profile) {
            return const Center(
              child: Text("Profile"),
            );
          }
          return Container();
        },
      ),
      bottomNavigationBar: BlocBuilder<BottomNavCubit, BottomNavState>(
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ...List.generate(ConstantData.bottomNavItems.length, (index) {
                return InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    if (index == 0) {
                      BlocProvider.of<BottomNavCubit>(context)
                          .getNavBarItem(NavbarItem.dashboard);
                    } else if (index == 1) {
                      BlocProvider.of<BottomNavCubit>(context)
                          .getNavBarItem(NavbarItem.stats);
                    } else if (index == 2) {
                      BlocProvider.of<BottomNavCubit>(context)
                          .getNavBarItem(NavbarItem.profile);
                    }
                  },
                  child: AnimatedContainer(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    duration: const Duration(seconds: 1),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          width: 22,
                          height: 22,
                          color: index == state.index
                              ? ColorTheme.primaryColor
                              : Colors.grey.shade400,
                          ConstantData.bottomNavItems[index]["icon"],
                        ),
                        AnimatedContainer(
                          margin: const EdgeInsets.only(top: 4),
                          duration: const Duration(milliseconds: 500),
                          width: index == state.index ? 8 : 0,
                          height: index == state.index ? 8 : 0,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorTheme.primaryColor),
                        )
                      ],
                    ),
                  ),
                );
              })
            ],
          );
        },
      ),
    );
  }
}
