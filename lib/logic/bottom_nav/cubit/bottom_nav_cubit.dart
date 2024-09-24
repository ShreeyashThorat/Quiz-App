import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class BottomNavCubit extends Cubit<BottomNavState> {
  BottomNavCubit() : super(const BottomNavState(NavbarItem.dashboard, 0));
  void getNavBarItem(NavbarItem navbarItem) {
    switch (navbarItem) {
      case NavbarItem.dashboard:
        emit(const BottomNavState(NavbarItem.dashboard, 0));
        break;
      case NavbarItem.stats:
        emit(const BottomNavState(NavbarItem.stats, 1));
        break;
      case NavbarItem.profile:
        emit(const BottomNavState(NavbarItem.profile, 2));
        break;
    }
  }
}

class BottomNavState extends Equatable {
  final NavbarItem navbarItem;
  final int index;
  const BottomNavState(this.navbarItem, this.index);

  @override
  List<Object> get props => [navbarItem, index];
}

enum NavbarItem { dashboard, stats, profile }
