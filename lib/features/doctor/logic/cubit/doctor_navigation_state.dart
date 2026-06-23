import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nuigate/features/doctor/domain/entities/doctor_course_entity.dart';

enum DoctorTab {
  dashboard(
    label: 'لوحة التحكم',
    icon: Icons.home_outlined,
    title: 'لوحة الدكتور',
  ),
  assignments(
    label: 'الواجبات',
    icon: Icons.assignment_outlined,
    title: 'الواجبات',
  ),
  lectures(
    label: 'المحاضرات',
    icon: Icons.menu_book_outlined,
    title: 'المحاضرات',
  ),
  exams(label: 'الامتحانات', icon: Icons.quiz_outlined, title: 'الامتحانات'),
  submissions(
    label: 'التقديمات',
    icon: Icons.check_circle_outline,
    title: 'التقديمات',
  );

  final String label;
  final IconData icon;
  final String title;

  const DoctorTab({
    required this.label,
    required this.icon,
    required this.title,
  });
}

class DoctorNavigationState extends Equatable {
  final DoctorTab selectedTab;
  final DoctorCourseEntity? selectedCourse;

  const DoctorNavigationState({
    this.selectedTab = DoctorTab.dashboard,
    this.selectedCourse,
  });

  DoctorNavigationState copyWith({
    DoctorTab? selectedTab,
    DoctorCourseEntity? selectedCourse,
  }) {
    return DoctorNavigationState(
      selectedTab: selectedTab ?? this.selectedTab,
      selectedCourse: selectedCourse ?? this.selectedCourse,
    );
  }

  @override
  List<Object?> get props => [selectedTab, selectedCourse];
}
