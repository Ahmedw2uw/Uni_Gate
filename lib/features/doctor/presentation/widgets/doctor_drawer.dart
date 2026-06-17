import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return Drawer(
      width: MediaQuery.sizeOf(context).width * 0.78,
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
                    const SizedBox(height: 8),
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
                      padding: const EdgeInsets.all(10),
                      child: Material(
                        color: const Color(0xFFFFE8E8),
                        borderRadius: BorderRadius.circular(6),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            context.read<AuthCubit>().logout();
                          },
                          borderRadius: BorderRadius.circular(6),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 13,
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.logout, color: Colors.red, size: 20),
                                SizedBox(width: 10),
                                CustomText(
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: const Row(
        children: [
          CircleAvatar(
            backgroundColor: Color(0xFFECEFF5),
            child: Icon(Icons.person_outline, color: AppColors.primary),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  'بوابة أعضاء هيئة التدريس',
                  color: AppColors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: 4),
                CustomText(
                  'Instructor Dashboard',
                  color: Colors.black54,
                  fontSize: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
