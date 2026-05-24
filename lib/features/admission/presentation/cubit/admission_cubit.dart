// // lib/features/admission/presentation/manager/admission_cubit.dart
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../domain/entities/admission_entity.dart';
// import '../../domain/usecases/get_admission_status_usecase.dart';

// part 'admission_state.dart';

// class AdmissionCubit extends Cubit<AdmissionState> {
//   final GetAdmissionStatusUseCase getAdmissionStatusUseCase;

//   AdmissionCubit({required this.getAdmissionStatusUseCase})
//       : super(AdmissionInitial());

//   Future<void> fetchAdmissionStatus(String nationalId) async {
//     if (nationalId.isEmpty) {
//       emit(AdmissionFailure("يرجى إدخال الرقم القومي"));
//       return;
//     }

//     emit(AdmissionLoading());
//     try {
//       final result = await getAdmissionStatusUseCase(nationalId);
      
//       if (result.isSuccess) {
//         emit(AdmissionSuccess(result));
//       } else {
//         // في حال كان السيرفر أرجع النجاح كـ false مع رسالة خطأ
//         emit(AdmissionFailure(result.message ?? "حدث خطأ في جلب حالة الطلب"));
//       }
//     } catch (e) {
//       // التعامل مع أخطاء الشبكة أو السيرفر
//       emit(AdmissionFailure("تعذر الاتصال بالسيرفر، تأكد من الرقم القومي"));
//     }
//   }
// }