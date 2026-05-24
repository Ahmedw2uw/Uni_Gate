// import '../../domain/entities/admission_entity.dart';
// import '../../domain/repositories/admission_repository.dart';
// import '../datasources/admission_remote_datasource.dart';

// class AdmissionRepositoryImpl implements AdmissionRepository {
//   final AdmissionRemoteDataSource remoteDataSource;

//   AdmissionRepositoryImpl(this.remoteDataSource);

//   @override
//   Future<AdmissionEntity> getAdmissionStatus(String nationalId) async {
//     final model = await remoteDataSource.getAdmissionStatus(nationalId);
//     return model.toEntity();
//   }
// }
