import 'package:admin_curator/Core/Notifiers/user_task_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Constants/app_colors.dart';
import '../../Constants/app_styles.dart';
import '../../Core/storage/firebase_storage_helper.dart' as upload;
import '../../Models/model_tasks.dart';
import '../../Providers/providers.dart';
import 'global_btn.dart';

class UploadPhotosBills extends ConsumerStatefulWidget {
  final String taskId;
  const UploadPhotosBills({super.key, required this.taskId});

  @override
  ConsumerState<UploadPhotosBills> createState() => _UploadPhotosBillsState();
}

class _UploadPhotosBillsState extends ConsumerState<UploadPhotosBills> {
  TaskModel? task;
  bool isSaving = false;
  bool isDocSaving = false;
  bool isImage = false;
  List<String> files = [];
  List<DocumentReference<Object?>> billRefs = [];
  List<PlatformFile> selectedFiles = [];
  String? actualTime;
  @override
  Widget build(BuildContext context) {
    final tasksNotifier = ref.read(taskProvider.notifier);
    final taskState = ref.watch(taskProvider);
    task = taskState.listOfTasks.firstWhere(
      (task) => task.taskRef == widget.taskId,
    );
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: ListView(
          children: [
            Text(
              'Upload Reference File',
              style: AppStyles.style20.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please upload reference file showcasing the lifecycle has been completed, ensuring they clearly highlight the tasks performed and the progress made.',
              style: AppStyles.text14.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 8),
            _buildImageUploadSection(
              context: context,
              tasksNotifier: tasksNotifier,
              isPhoto: true,
            ),
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 200,
                child: GlobalButton(
                  text: 'Complete Task',
                  onPressed: () async {
                    if (task?.curatorTaskStatus == "Pending") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Task is not Started yet',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 18,
                              fontFamily: 'Begum',
                            ),
                          ),
                          backgroundColor: AppColors.secondary,
                          duration: Duration(seconds: 1),
                        ),
                      );
                    } else if (task?.curatorTaskStatus == "Completed") {
                      if (files.isNotEmpty) {
                        final tasksNotifier = ref.read(taskProvider.notifier);
                        await tasksNotifier
                            .updateTaskLifecycle(
                              taskRef: taskState.selectedTask!.taskDocRef!,
                            )
                            .then((val) {
                              tasksNotifier.updateSelectedTaskPaymentStatus(
                                true,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Task Lifecyle has been completed',
                                  ),
                                ),
                              );
                              Navigator.pop(context);
                            });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Add an image',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 18,
                                fontFamily: 'Begum',
                              ),
                            ),
                            backgroundColor: AppColors.secondary,
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }
                    } else if (task?.curatorTaskStatus ==
                            "Under Verification" ||
                        task?.curatorTaskStatus == "Payment Due") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Task is already in Progress',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 18,
                              fontFamily: 'Begum',
                            ),
                          ),
                          backgroundColor: AppColors.secondary,
                          duration: Duration(seconds: 1),
                        ),
                      );
                    }
                  },
                  height: 30,
                  isOutlined: task?.curatorTaskStatus != "In Progress",
                ),
              ),
            ),
            Visibility(
              visible: taskState.actionLoaders['cycleUpdate'] == true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CircularProgressIndicator(color: AppColors.primary)],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageUploadSection({
    required BuildContext context,
    required CuratorTaskNotifier tasksNotifier,
    required bool isPhoto,
  }) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        ...List.generate(
          files.length,
          (index) => _buildImageItem(
            context: context,
            index: index,
            tasksNotifier: tasksNotifier,
          ),
        ),
        _buildAddButton(
          context: context,
          tasksNotifier: tasksNotifier,
          isPhoto: isPhoto,
        ),
      ],
    );
  }

  Widget _buildImageItem({
    required BuildContext context,
    required int index,
    required CuratorTaskNotifier tasksNotifier,
  }) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              files[index],
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.secondary,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: AppColors.primary,
                  size: 16,
                ),
                onPressed: () {
                  _showConfirmationDialog(
                    action: 'image',
                    context: context,
                    index: index,
                    tasksNotifier: tasksNotifier,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog({
    required BuildContext context,
    required String action,
    required CuratorTaskNotifier tasksNotifier,
    required int index,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Remove $action',
            style: AppStyles.title22.copyWith(fontWeight: FontWeight.bold),
          ),
          backgroundColor: AppColors.secondary,
          content: Text(
            'Are you sure you want to remove this $action?',
            style: AppStyles.style20.copyWith(fontWeight: FontWeight.normal),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel', style: AppStyles.style18),
            ),
            TextButton(
              onPressed: () async {
                if (action == 'image') {
                  _removeImage(tasksNotifier, index);
                }
                // if (action == 'bill') {
                //   _removeBill(tasksNotifier, index);
                // }
                Navigator.of(context).pop();
              },
              child: const Text('Remove', style: AppStyles.style18),
            ),
          ],
        );
      },
    );
  }

  void _removeImage(CuratorTaskNotifier tasksNotifier, int index) async {
    String imageUrl = files[index];
    await upload.FirebaseStorageHelper.deleteImageFromFirebase(imageUrl);
    final updatedImages = List<String>.from(files)..removeAt(index);
    tasksNotifier.taskAdminReferenceUpdate(
      files: updatedImages,
      taskId: widget.taskId,
    );
    setState(() {
      files.removeAt(index);
    });
    setState(() {});
  }

  Widget _buildAddButton({
    required BuildContext context,
    required CuratorTaskNotifier tasksNotifier,
    required bool isPhoto,
  }) {
    return GestureDetector(
      onTap: () {
        if (isPhoto && !isSaving) {
          selectDocuments(tasksNotifier);
        }
      },
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
        ),
        child:
            isPhoto && isSaving || !isPhoto && isDocSaving
                ? const Center(
                  child: CircularProgressIndicator(color: AppColors.white),
                )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add, size: 50, color: AppColors.white),
                    const SizedBox(height: 10),
                    Text(
                      "Add a File",
                      style: AppStyles.subHeadingMobile.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }

  Future<void> selectDocuments(CuratorTaskNotifier taskNotifier) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );
    if (result != null) {
      setState(() {
        selectedFiles = result.files;
        isSaving = true;
      });
      List<String> uploadedDocumentUrls = [];
      for (PlatformFile file in selectedFiles) {
        String? url = await upload.FirebaseStorageHelper.uploadImageToFirebase(
          context,
          file,
        );
        if (url != null) {
          uploadedDocumentUrls.add(url);
        }
      }
      setState(() {
        files.addAll(uploadedDocumentUrls);
      });
      taskNotifier.taskAdminReferenceUpdate(
        files: files,
        taskId: widget.taskId,
      );
      setState(() {
        isSaving = false;
      });
    }
  }
}
