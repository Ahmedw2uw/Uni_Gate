import 'package:nuigate/features/courses/data/models/course_assignment_model.dart';
import 'package:nuigate/features/courses/data/models/course_content_model.dart';
import 'package:nuigate/features/courses/data/models/course_exam_model.dart';
import 'package:nuigate/features/courses/data/models/department_model.dart';
import 'package:nuigate/features/courses/data/models/instructor_model.dart';
import 'package:nuigate/features/courses/data/models/schedule_slot_model.dart';
import 'package:nuigate/features/courses/data/models/student_course_enrollment_model.dart';
import 'package:nuigate/features/courses/domain/entities/course_entity.dart';

class CourseModel extends CourseEntity {
  final InstructorModel? instructorObj;
  final DepartmentModel? department;
  final List<CourseContentModel> contents;
  final List<CourseAssignmentModel> assignments;
  final List<CourseExamModel> exams;
  final List<ScheduleSlotModel> scheduleSlots;
  final List<StudentCourseEnrollmentModel> studentCourses;

  const CourseModel({
    required super.id,
    required super.name,
    required super.code,
    required super.creditHours,
    required super.price,
    super.instructor,
    super.instructorId,
    super.departmentId,
    super.academicYear,
    super.semester,
    super.content,
    super.title,
    super.description,
    this.instructorObj,
    this.department,
    this.contents = const [],
    this.assignments = const [],
    this.exams = const [],
    this.scheduleSlots = const [],
    this.studentCourses = const [],
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    String instructorName = '';
    InstructorModel? instructorModel;
    if (json['instructor'] is Map) {
      instructorModel = InstructorModel.fromJson(
        json['instructor'] as Map<String, dynamic>,
      );
      instructorName = instructorModel.fullName;
    } else {
      instructorName = "${json['instructorTitle'] ?? ''} ${json['instructorName'] ?? ''}"
          .trim();
    }

    DepartmentModel? deptModel;
    if (json['department'] is Map) {
      deptModel = DepartmentModel.fromJson(
        json['department'] as Map<String, dynamic>,
      );
    }

    List<CourseContentModel> contents = [];
    if (json['contents'] is List) {
      contents = (json['contents'] as List)
          .map((e) => CourseContentModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    List<CourseAssignmentModel> assignments = [];
    if (json['assignments'] is List) {
      assignments = (json['assignments'] as List)
          .map((e) => CourseAssignmentModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    List<CourseExamModel> exams = [];
    if (json['exams'] is List) {
      exams = (json['exams'] as List)
          .map((e) => CourseExamModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    List<ScheduleSlotModel> slots = [];
    if (json['scheduleSlots'] is List) {
      slots = (json['scheduleSlots'] as List)
          .map((e) => ScheduleSlotModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    List<StudentCourseEnrollmentModel> enrollments = [];
    if (json['studentCourses'] is List) {
      enrollments = (json['studentCourses'] as List)
          .map((e) => StudentCourseEnrollmentModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return CourseModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      creditHours: json['creditHours'] is int
          ? json['creditHours']
          : int.tryParse(json['creditHours'].toString()) ?? 0,
      price: json['price'] is num ? (json['price'] as num).toDouble() : 0.0,
      instructor: instructorName,
      instructorId: json['instructorId'] is int ? json['instructorId'] : null,
      departmentId: json['departmentId'] is int ? json['departmentId'] : null,
      academicYear: json['academicYear'] is int ? json['academicYear'] : null,
      semester: json['semester'] is int ? json['semester'] : null,
      content: json['content'],
      title: json['title']?.toString(),
      description: json['description']?.toString(),
      instructorObj: instructorModel,
      department: deptModel,
      contents: contents,
      assignments: assignments,
      exams: exams,
      scheduleSlots: slots,
      studentCourses: enrollments,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'creditHours': creditHours,
      'price': price,
      'instructorName': instructor,
      'instructorId': instructorId,
      'departmentId': departmentId,
      'academicYear': academicYear,
      'semester': semester,
      'title': title,
      'description': description,
      'content': content,
      'instructor': instructorObj?.toJson(),
      'department': department?.toJson(),
      'contents': contents.map((e) => e.toJson()).toList(),
      'assignments': assignments.map((e) => e.toJson()).toList(),
      'exams': exams.map((e) => e.toJson()).toList(),
      'scheduleSlots': scheduleSlots.map((e) => e.toJson()).toList(),
      'studentCourses': studentCourses.map((e) => e.toJson()).toList(),
    };
  }
}
