import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuigate/features/requests/data/model/request_type_model.dart';
import 'package:nuigate/features/requests/data/model/student_request_model.dart';
import 'package:nuigate/features/requests/logic/cubit/requests_cubit.dart';
import 'package:nuigate/features/requests/logic/requests_state.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('طلبات شؤون الطلاب'),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocConsumer<RequestsCubit, RequestsState>(
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
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () => cubit.fetchRequestsPageData(force: true),
            child: CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16),
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
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 12),
                    child: Text(
                      'متابعة الطلبات',
                      style: TextStyle(
                        fontSize: 18,
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
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    sliver: SliverList.separated(
                      itemCount: cubit.currentRequests.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'تقديم طلب جديد',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(border: OutlineInputBorder()),
              hint: const Text('نوع الطلب'),
              initialValue: selectedTypeId,
              items: requestTypes.map((type) {
                return DropdownMenuItem<int>(
                  value: type.id,
                  child: Text(type.name),
                );
              }).toList(),
              onChanged: isSubmitting ? null : onTypeChanged,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: detailsController,
              enabled: !isSubmitting,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'التفاصيل',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: isSubmitting ? null : onPickFile,
                  icon: const Icon(Icons.attach_file),
                  label: const Text('رفع الملف'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    selectedFileName ?? 'مسموح فقط ملفات PDF, PNG, JPG',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                ),
                onPressed: isSubmitting ? null : onSubmit,
                child: isSubmitting
                    ? const SizedBox.square(
                        dimension: 22,
                        child: CircularProgressIndicator(
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
      child: ListTile(
        title: Text(request.typeName),
        subtitle: Text('${request.date}\n${request.status}'),
        isThreeLine: true,
        leading: CircleAvatar(child: Text(request.id.toString())),
        trailing: TextButton(onPressed: () {}, child: const Text('مراجعة')),
      ),
    );
  }
}
