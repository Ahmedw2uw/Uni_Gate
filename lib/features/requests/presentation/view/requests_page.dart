import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuigate/features/requests/data/model/request_type_model.dart';
import 'package:nuigate/features/requests/data/model/student_request_model.dart';
import 'package:nuigate/features/requests/logic/cubit/requests_cubit.dart';
import 'package:nuigate/features/requests/logic/requests_state.dart';
import 'package:nuigate/shared/widgets/app_scaffold.dart';

class RequestsPage extends StatefulWidget {
  const RequestsPage({super.key});

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  int? selectedTypeId;
  final TextEditingController detailsController = TextEditingController();
  String? selectedFilePath;
  String? selectedFileName;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<RequestsCubit>().fetchRequestsPageData();
    });
  }

  @override
  void dispose() {
    detailsController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
    );

    if (!mounted || result == null) return;

    setState(() {
      selectedFilePath = result.files.single.path;
      selectedFileName = result.files.single.name;
    });
  }

  void _submit() {
    if (selectedTypeId == null) {
      _showSnackBar('برجاء اختيار نوع الطلب', Colors.orange);
      return;
    }

    context.read<RequestsCubit>().submitNewRequest(
      requestType: selectedTypeId!,
      details: detailsController.text,
      filePath: selectedFilePath,
    );
  }

  void _resetForm() {
    setState(() {
      selectedTypeId = null;
      detailsController.clear();
      selectedFilePath = null;
      selectedFileName = null;
    });
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'طلبات شؤون الطلاب',
      child: BlocConsumer<RequestsCubit, RequestsState>(
        listener: (context, state) {
          if (state is SubmitRequestSuccess) {
            _showSnackBar(state.message, Colors.green);
            _resetForm();
          } else if (state is RequestsFailure) {
            _showSnackBar(state.errorMessage, Colors.red);
          }
        },
        buildWhen: (previous, current) =>
            current is RequestsLoading ||
            current is RequestsLoaded ||
            current is SubmitRequestLoading,
        builder: (context, state) {
          final cubit = context.read<RequestsCubit>();
          final isSubmitting = state is SubmitRequestLoading;

          if (state is RequestsLoading && cubit.currentTypes.isEmpty) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          return RefreshIndicator(
            onRefresh: () => cubit.fetchRequestsPageData(force: true),
            child: CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.all(16.r),
                  sliver: SliverToBoxAdapter(
                    child: _RequestFormCard(
                      selectedTypeId: selectedTypeId,
                      detailsController: detailsController,
                      selectedFileName: selectedFileName,
                      requestTypes: cubit.currentTypes,
                      isSubmitting: isSubmitting,
                      onTypeChanged: (value) =>
                          setState(() => selectedTypeId = value),
                      onPickFile: _pickFile,
                      onSubmit: _submit,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.h, bottom: 12.h),
                    child: Text(
                      'متابعة الطلبات',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                if (cubit.currentRequests.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: Text('لا توجد طلبات حتى الآن')),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
                    sliver: SliverList.separated(
                      itemCount: cubit.currentRequests.length,
                      separatorBuilder: (_, _) => SizedBox(height: 10.h),
                      itemBuilder: (context, index) {
                        return _RequestListTile(
                          request: cubit.currentRequests[index],
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _RequestFormCard extends StatelessWidget {
  final int? selectedTypeId;
  final TextEditingController detailsController;
  final String? selectedFileName;
  final List<RequestTypeModel> requestTypes;
  final bool isSubmitting;
  final ValueChanged<int?> onTypeChanged;
  final VoidCallback onPickFile;
  final VoidCallback onSubmit;

  const _RequestFormCard({
    required this.selectedTypeId,
    required this.detailsController,
    required this.selectedFileName,
    required this.requestTypes,
    required this.isSubmitting,
    required this.onTypeChanged,
    required this.onPickFile,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تقديم طلب جديد',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            DropdownButtonFormField<int>(
              isExpanded: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              hint: const Text('نوع الطلب'),
              initialValue: selectedTypeId,
              items: requestTypes.map((type) {
                return DropdownMenuItem<int>(
                  value: type.id,
                  child: Text(
                    type.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: isSubmitting ? null : onTypeChanged,
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: detailsController,
              enabled: !isSubmitting,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'التفاصيل',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 330;
                final fileName = Text(
                  selectedFileName ?? 'مسموح فقط ملفات PDF, PNG, JPG',
                  style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                );
                final button = ElevatedButton.icon(
                  onPressed: isSubmitting ? null : onPickFile,
                  icon: const Icon(Icons.attach_file),
                  label: const Text('رفع الملف'),
                );

                if (compact) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      button,
                      SizedBox(height: 10.h),
                      fileName,
                    ],
                  );
                }

                return Row(
                  children: [
                    button,
                    SizedBox(width: 10.w),
                    Expanded(child: fileName),
                  ],
                );
              },
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                onPressed: isSubmitting ? null : onSubmit,
                child: isSubmitting
                    ? SizedBox.square(
                        dimension: 22.r,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'إرسال الطلب',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RequestListTile extends StatelessWidget {
  final StudentRequestModel request;

  const _RequestListTile({required this.request});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        title: Text(
          request.typeName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text('${request.date}\n${request.status}'),
        isThreeLine: true,
        leading: CircleAvatar(radius: 18.r, child: Text(request.id.toString())),
        trailing: TextButton(onPressed: () {}, child: const Text('مراجعة')),
      ),
    );
  }
}
