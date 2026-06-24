import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/features/auth/logic/cubit/auth_cubit.dart';
import 'package:nuigate/features/doctor/logic/cubit/doctor_navigation_cubit.dart';
import 'package:nuigate/features/doctor/logic/cubit/doctor_navigation_state.dart';
import 'package:nuigate/features/doctor/presentation/widgets/doctor_drawer_item.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class DoctorDrawer extends StatelessWidget {
  const DoctorDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final drawerWidth = screenWidth >= 700 ? 340.0 : screenWidth * 0.82;

    return Drawer(
      width: drawerWidth,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          color: AppColors.primary,
          child: SafeArea(
            child: BlocBuilder<DoctorNavigationCubit, DoctorNavigationState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _DoctorDrawerHeader(),
                    SizedBox(height: 8.h),
                    ...DoctorTab.values.map(
                      (tab) => DoctorDrawerItem(
                        label: tab.label,
                        icon: tab.icon,
                        selected: state.selectedTab == tab,
                        onTap: () {
                          context.read<DoctorNavigationCubit>().selectTab(tab);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.all(10.r),
                      child: Material(
                        color: const Color(0xFFFFE8E8),
                        borderRadius: BorderRadius.circular(6.r),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            context.read<AuthCubit>().logout();
                          },
                          borderRadius: BorderRadius.circular(6.r),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 13.h,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.logout,
                                  color: Colors.red,
                                  size: 20.r,
                                ),
                                SizedBox(width: 10.w),
                                const CustomText(
                                  'تسجيل الخروج',
                                  color: Colors.red,
                                  fontWeight: FontWeight.w700,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _DoctorDrawerHeader extends StatelessWidget {
  const _DoctorDrawerHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundColor: const Color(0xFFECEFF5),
            child: Icon(
              Icons.person_outline,
              color: AppColors.primary,
              size: 22.r,
            ),
          ),
          SizedBox(width: 12.w),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  'بوابة أعضاء هيئة التدريس',
                  color: AppColors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                CustomText(
                  'Instructor Dashboard',
                  color: Colors.black54,
                  fontSize: 12,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
