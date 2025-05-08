import 'dart:math';

import 'package:admin_curator/Constants/URls.dart';
import 'package:admin_curator/Constants/app_colors.dart';
import 'package:admin_curator/Constants/firebase_collections.dart';
import 'package:admin_curator/Models/model_tasks.dart';
import 'package:admin_curator/Models/profile.dart';
import 'package:admin_curator/Presentation/Widgets/create_bill_component.dart';
import 'package:admin_curator/Presentation/Widgets/custom_dropDown.dart';
import 'package:admin_curator/Presentation/Widgets/taskUnassignReason.dart';
import 'package:admin_curator/Presentation/Widgets/upload_photos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../Constants/app_styles.dart';
import '../../Models/comment.dart';
import '../../Providers/providers.dart';
import '../../Providers/textproviders.dart';
import '../Widgets/asssign_pric_component.dart';
import '../Widgets/taskDisableDialog.dart';

class TasksDetailsPAge extends ConsumerStatefulWidget {
  final TaskModel model;
  TasksDetailsPAge(this.model, {super.key});

  @override
  ConsumerState<TasksDetailsPAge> createState() => _CuratorProfilesState();
}

class _CuratorProfilesState extends ConsumerState<TasksDetailsPAge> {
  CuratorModel? matchingProfile;
  DocumentReference? taskRef;

  String getRandomString(int length) {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => characters.codeUnitAt(random.nextInt(characters.length)),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      taskRef = FirebaseFirestore.instance
          .collection(FirebaseCollections.createTaskCollection)
          .doc(widget.model.taskRef);
      //   print('id from task: ${widget.model.taskAssignedToCurator!}');
      ref.read(patronProvider.notifier).fetchPatron(widget.model.patronRef!);
      ref.read(taskProvider.notifier).getTaskById(id: widget.model.taskRef);
      if (widget.model.taskAssignedToCurator != null) {
        final referenceProfile = FirebaseFirestore.instance
            .collection('Consultants')
            .doc(widget.model.taskAssignedToCurator);

        ref
            .read(profileProvider.notifier)
            .getCuratorByReference(referenceProfile);
      }
      if (widget.model.patronRef != null) {
        ref.read(patronProvider.notifier).fetchPatron(widget.model.patronRef!);
        ref.read(taskProvider.notifier).listenToComments(widget.model.taskRef);
      }
      ref.read(curatorBillProvider.notifier).fetchBills(taskRef: taskRef!);
    });
  }

  void onAssignedPrice() {
    setState(() {
      ref.watch(profileProvider);
    });
  }

  double _parseToDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final patronState = ref.watch(patronProvider);
    final authState = ref.watch(authNotifierProvider);
    final profileState = ref.watch(profileProvider);
    final comment = ref.watch(commentController);

    final curatorBillState = ref.watch(curatorBillProvider);

    print('Curator Bill State: ${curatorBillState.curatorBills}');

    print('User Profile is empty : ${profileState.singleProfile?.id}');
    final taskState = ref.watch(taskProvider);

    final comments = ref.watch(taskProvider).comments;
    final imageLength =
        taskState.selectedTask?.listOfImagesUploadedByCurator.length ?? 0;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFFAA4400),
                    ),
                    onPressed: () {
                      GoRouter.of(context).replace('/dashboard');
                    },
                  ),
                  const SizedBox(width: 8),
                  Row(
                    children: [
                      Text(
                        'Task',
                        style: AppStyles.style20.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  taskState.selectedTask?.isTaskDisabled == false
                      ? Visibility(
                        visible:
                            taskState.selectedTask?.paymentDueCleared == false,
                        child: ElevatedButton(
                          onPressed: () {
                            final String userEmail =
                                authState.user?.email ?? "Unknown User";
                            showDialog(
                              context: context,
                              builder:
                                  (context) => DisabledDialog(
                                    userEmail: userEmail,
                                    taskID:
                                        taskState.selectedTask?.taskRef ?? '',
                                    ref: ref,
                                    tasksNotifier: ref.read(
                                      taskProvider.notifier,
                                    ),
                                  ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.secondary,
                            elevation: 2,
                          ),
                          child: Text(
                            'Disable Task',
                            style: AppStyles.style20.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      )
                      : Visibility(
                        visible:
                            taskState.selectedTask?.paymentDueCleared == false,
                        child: ElevatedButton(
                          onPressed: () {
                            ref
                                .read(taskProvider.notifier)
                                .updateTaskVisiblity(
                                  isTaskDisabled: false,
                                  taskId: widget.model.taskRef,
                                  reason: "",
                                );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.secondary,
                            elevation: 2,
                          ),
                          child: Text(
                            'Enable Task',
                            style: AppStyles.style20.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                  SizedBox(width: 5),
                  Visibility(
                    visible: taskState.selectedTask?.paymentDueCleared == false,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (taskState.selectedTask?.isTaskDisabled == false) {
                          final curatorRef = FirebaseFirestore.instance
                              .collection(
                                FirebaseCollections.consultantCollection,
                              )
                              .doc(profileState.singleProfile!.id);
                          final taskRef = FirebaseFirestore.instance
                              .collection(
                                FirebaseCollections.createTaskCollection,
                              )
                              .doc(taskState.selectedTask!.taskRef);

                          if (taskState.selectedTask?.isTaskBillCreated ==
                              false) {
                            await ref
                                .read(curatorBillProvider.notifier)
                                .getAdditionalBill(taskRef: taskRef);
                            final taskStateBill = ref.watch(
                              curatorBillProvider,
                            );
                            final additionalBill = taskStateBill.additionalBill;

                            if (additionalBill != null) {
                              final map = additionalBill.toFirestore();
                              // print(map);
                              List<Map<String, dynamic>> item = [];
                              final actualValues = {
                                'task': taskState.selectedTask?.taskSubject,

                                'description':
                                    taskState.selectedTask?.taskDescription,

                                'taskHours':
                                    taskState.selectedTask?.taskDurationByAdmin,

                                'taskPrice':
                                    taskState.selectedTask?.taskPriceByAdmin,

                                'date': DateFormat(
                                  'dd MMM yyyy, hh:mm a',
                                ).format(
                                  taskState.selectedTask?.taskDate.toDate() ??
                                      Timestamp.now().toDate(),
                                ),

                                'totalAmount':
                                    taskState.selectedTask?.taskPriceByAdmin,
                              };
                              print(map['taskHours'].runtimeType);
                              print(map['taskPrice'].runtimeType);
                              final mapping = {
                                'task': taskState.selectedTask?.taskSubject,

                                'description': map['invoiceDescription'],

                                'taskHours': _parseToDouble(map['taskHours']),

                                'taskPrice': _parseToDouble(map['taskPrice']),

                                'date': DateFormat(
                                  'dd MMM yyyy, hh:mm a',
                                ).format(
                                  taskState.selectedTask?.taskDate.toDate() ??
                                      Timestamp.now().toDate(),
                                ),

                                'totalAmount': _parseToDouble(
                                  map['totalAmount'],
                                ),
                              };
                              item.add(mapping);
                              item.add(actualValues);
                              await ref
                                  .read(curatorBillProvider.notifier)
                                  .createTaskBill(
                                    fileName:
                                        '${profileState.singleProfile?.fullName}_${taskState.selectedTask?.taskSubject}_${taskState.selectedTask?.taskRef}',
                                    vendorName: 'Pinch Lifestyle Pvt Ltd.',
                                    invoiceNumber: getRandomString(10),
                                    invoiceDate: DateFormat(
                                      'yyyy-MM-dd',
                                    ).format(DateTime.now()),
                                    soldTo:
                                        profileState.singleProfile?.fullName ??
                                        '',
                                    items: item,

                                    taskRef: taskRef,
                                    curatorRef: curatorRef,
                                    invoiceDescription:
                                        taskState
                                            .selectedTask
                                            ?.taskDescription ??
                                        '',
                                    totalAmount:
                                        (taskState
                                                .selectedTask!
                                                .taskPriceByAdmin +
                                            map['totalAmount']),
                                    taskHours:
                                        taskState
                                            .selectedTask
                                            ?.taskDurationByAdmin ??
                                        0.0,
                                    taskPrice:
                                        taskState
                                            .selectedTask
                                            ?.taskPriceByAdmin ??
                                        0.0,
                                  );

                              await ref
                                  .read(taskProvider.notifier)
                                  .updateTaskBillStatus(
                                    isTaskBillCreated: true,
                                    taskId:
                                        taskState.selectedTask?.taskRef ?? '',
                                  )
                                  .then((val) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Bill created succesfully.',
                                        ),
                                      ),
                                    );
                                  });
                            } else {
                              print('additionalBill is Null');
                              await ref
                                  .read(curatorBillProvider.notifier)
                                  .createTaskBill(
                                    fileName:
                                        '${profileState.singleProfile?.fullName}_${widget.model.taskSubject}_${DateTime.now()}',
                                    vendorName: 'Pinch Lifestyle Pvt Ltd.',
                                    invoiceNumber: getRandomString(10),
                                    invoiceDate: DateFormat(
                                      'yyyy-MM-dd',
                                    ).format(DateTime.now()),
                                    soldTo:
                                        profileState.singleProfile?.fullName ??
                                        '',
                                    items: [
                                      {
                                        'task': widget.model.taskSubject,

                                        'description':
                                            widget.model.taskDescription,

                                        'taskHours':
                                            widget.model.taskDurationByAdmin,

                                        'taskPrice':
                                            widget.model.taskPriceByAdmin,

                                        'date': DateFormat(
                                          'dd MMM yyyy, hh:mm a',
                                        ).format(
                                          widget.model.taskDate.toDate(),
                                        ),

                                        'totalAmount':
                                            widget.model.taskPriceByAdmin,
                                      },
                                    ],
                                    taskRef: widget.model.taskDocRef!,
                                    curatorRef: curatorRef,
                                    invoiceDescription:
                                        widget.model.taskDescription,
                                    totalAmount: widget.model.taskPriceByAdmin,
                                    taskHours:
                                        taskState
                                            .selectedTask
                                            ?.taskDurationByAdmin ??
                                        0.0,
                                    taskPrice:
                                        taskState
                                            .selectedTask
                                            ?.taskPriceByAdmin ??
                                        0.0,
                                  );

                              await ref
                                  .read(taskProvider.notifier)
                                  .updateTaskBillStatus(
                                    isTaskBillCreated: true,
                                    taskId:
                                        taskState.selectedTask?.taskRef ?? '',
                                  )
                                  .then((val) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Bill created succesfully.',
                                        ),
                                      ),
                                    );
                                  });
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Bill is already created, please reject the current bill to make new bill.',
                                ),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Task is disabled, cannot create the bill, Please enable the task to create bill',
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.secondary,
                        elevation: 2,
                      ),
                      child:
                          taskState.isLoading == false
                              ? Text(
                                'Create Task Bill',
                                style: AppStyles.style20.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                  fontSize: 18,
                                ),
                              )
                              : CircularProgressIndicator(
                                color: AppColors.white,
                              ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            CustomDropdown(
              onAssignPressed: onAssignedPrice,
              taskID: widget.model.taskRef,
              header: 'Assign Task to curator',

              selectedItem:
                  profileState.singleProfile?.fullName ?? 'NO Assigned',
              items:
                  profileState.profile
                      .map((curator) => curator.fullName)
                      .toList(),
              hintText: 'Search Curator',
            ),
            SizedBox(height: 5),
            ElevatedButton(
              onPressed: () async {
                final updatedTask = await showDialog<TaskModel>(
                  context: context,
                  builder:
                      (context) => UnassignDialog(
                        userEmail: authState.user!.email,
                        ref: ref,
                        taskID: taskState.selectedTask?.taskRef ?? '',
                        tasksNotifier: ref.watch(taskProvider.notifier),
                      ),
                );

                if (updatedTask != null) {
                  await ref
                      .read(taskProvider.notifier)
                      .notifyAllCurators(
                        title: 'New Task ',
                        body:
                            'A new Task has been added.Click here to checkout',
                        action: 'NEW_TASK_ADDED',
                      )
                      .then(
                        (val) =>
                            context.replace('/crm_tasks', extra: updatedTask),
                      );
                }

                //  context.replace('/dashboard');
              }, // Call the provided function
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Unassign",
                style: AppStyles.style20.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                  fontSize: 18,
                ),
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Task details
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Task Details',
                                        style: AppStyles.style20.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Spacer(),
                                      Visibility(
                                        visible:
                                            taskState
                                                .selectedTask
                                                ?.paymentDueCleared ==
                                            false,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            showAssignPriceDialog(
                                              context,
                                              ref,
                                              taskState.selectedTask?.taskRef ??
                                                  '',
                                              taskState
                                                      .selectedTask
                                                      ?.taskSubject ??
                                                  'No Subject Avialable',
                                              taskState
                                                      .selectedTask
                                                      ?.taskDescription ??
                                                  'No Description Available',
                                              taskState
                                                      .selectedTask
                                                      ?.assignedTimeSlot ??
                                                  'No Time Slot Available',
                                              taskState
                                                      .selectedTask
                                                      ?.locationMode ??
                                                  'NA',
                                              taskState
                                                  .selectedTask!
                                                  .taskPriceByAdmin,
                                              taskState
                                                  .selectedTask
                                                  ?.taskDurationByAdmin,
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.primary,
                                            foregroundColor:
                                                AppColors.secondary,
                                          ),
                                          child: Text(
                                            'Assign Price',
                                            style: AppStyles.style20.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.white,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              taskState
                                                          .selectedTask
                                                          ?.curatorTaskStatus ==
                                                      'Completed'
                                                  ? Colors.green
                                                  : Colors.yellow.shade800,
                                          foregroundColor: AppColors.secondary,
                                        ),
                                        child: Text(
                                          taskState
                                                  .selectedTask
                                                  ?.curatorTaskStatus ??
                                              '',
                                          style: AppStyles.style20.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  // Category pills
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Text(
                                          taskState
                                                  .selectedTask
                                                  ?.selectedHomeCuratorDepartment ??
                                              'Not Available',
                                          style: AppStyles.style20.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  // Subject
                                  DetailRow(
                                    label: 'Subject :',
                                    value:
                                        taskState.selectedTask?.taskSubject ??
                                        'No Subject Avialable',
                                  ),
                                  const SizedBox(height: 8),
                                  // Description
                                  DetailRow(
                                    label: 'Description :',
                                    value:
                                        taskState
                                            .selectedTask
                                            ?.taskDescription ??
                                        'No Description Available',
                                    isMultiLine: true,
                                  ),
                                  const SizedBox(height: 16),
                                  // Dates
                                  DetailRow(
                                    label: 'Start Date :',
                                    value: DateFormat('dd-MM-yy').format(
                                      taskState.selectedTask!.taskStartTime
                                          .toDate(),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  DetailRow(
                                    label: 'End Date :',
                                    value: DateFormat('dd-MM-yy').format(
                                      taskState.selectedTask!.taskEndTime
                                          .toDate(),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  // Mode and Location
                                  DetailRow(
                                    label: 'Location Mode :',
                                    value:
                                        taskState.selectedTask?.locationMode ??
                                        'NA',
                                  ),
                                  DetailRow(
                                    label: 'Task Hours :',
                                    value:
                                        taskState
                                            .selectedTask
                                            ?.taskDurationByAdmin
                                            .toString() ??
                                        'NA',
                                  ),

                                  const SizedBox(height: 16),
                                  // Price
                                  DetailRow(
                                    label: 'Price :',
                                    value:
                                        taskState.selectedTask?.taskPriceByAdmin
                                            .toString() ??
                                        'No price assigned ',
                                  ),
                                  const SizedBox(height: 16),

                                  DetailRow(
                                    label: 'Task Final Price :',
                                    value:
                                        taskState.selectedTask?.taskPriceByAdmin
                                            .toString() ??
                                        'No price assigned ',
                                  ),
                                  const SizedBox(height: 16),

                                  // Slot and Priority
                                  DetailRow(
                                    label: 'Slot :',
                                    value:
                                        taskState
                                            .selectedTask
                                            ?.assignedTimeSlot ??
                                        'NA',
                                  ),
                                  const SizedBox(height: 8),
                                  DetailRow(
                                    label: 'Priority: ',
                                    value: taskState.selectedTask!.priority,
                                    color:
                                        widget.model.priority == 'Low'
                                            ? AppColors.black
                                            : widget.model.priority == 'Medium'
                                            ? AppColors.orange
                                            : AppColors.red,
                                  ),
                                  const SizedBox(height: 16),
                                  // Lifestyle Manager
                                  DetailRow(
                                    label: 'LM:',
                                    value:
                                        taskState.selectedTask!.assignedLMName,
                                  ),
                                  const SizedBox(height: 24),
                                  // Patron Details
                                  Text(
                                    'Patron Details',
                                    style: AppStyles.style20.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                      fontSize: 23,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  // Patron information
                                  DetailRow(
                                    label: 'Name :',
                                    value: widget.model.patronName,
                                  ),
                                  const SizedBox(height: 8),

                                  const SizedBox(height: 16),
                                  // Address
                                  DetailRow(
                                    label: 'Address :',
                                    value: widget.model.patronAddress,
                                    isMultiLine: true,
                                  ),

                                  const SizedBox(height: 8),
                                  DetailRow(
                                    label: 'City :',
                                    value: patronState.patron?.city ?? 'NA',
                                  ),
                                  const SizedBox(height: 8),
                                  DetailRow(
                                    label: 'State :',
                                    value: patronState.patron?.state ?? "NA",
                                  ),
                                  const SizedBox(height: 8),
                                  DetailRow(
                                    label: 'Pincode :',
                                    value:
                                        patronState.patron?.addressLine2 ??
                                        "NA",
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Curator Details',
                                    style: AppStyles.style20.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                      fontSize: 23,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Column(
                                    children: [
                                      DetailRow(
                                        label: 'Curator Name: ',
                                        value:
                                            profileState
                                                .singleProfile
                                                ?.fullName ??
                                            "NA",
                                      ),
                                      const SizedBox(height: 8),
                                      DetailRow(
                                        label: 'Curator Email :',
                                        value:
                                            profileState.singleProfile?.email ??
                                            "NA",
                                      ),
                                      const SizedBox(height: 8),
                                      DetailRow(
                                        label: 'Contact Num :',
                                        value:
                                            profileState
                                                .singleProfile
                                                ?.profile
                                                ?.contactNumber ??
                                            'Not Available',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Task Images',
                              style: AppStyles.style20.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                                fontSize: 23,
                              ),
                            ),
                            Text(
                              ' Uploaded photos highlighting the tasks performed and the progress made will be shown below',
                              style: AppStyles.style20.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 5),
                            Wrap(
                              spacing: 15,
                              runSpacing: 3,
                              children: [
                                for (int i = 0; i < imageLength; i++)
                                  _buildImagePreview(
                                    taskState
                                            .selectedTask
                                            ?.listOfImagesUploadedByCurator[i] ??
                                        '',
                                  ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Transferred Tasks',
                              style: AppStyles.style20.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                                fontSize: 23,
                              ),
                            ),
                            SizedBox(height: 5),
                            taskState.selectedTask?.transferredTasks != null
                                ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount:
                                      taskState
                                          .selectedTask
                                          ?.transferredTasks
                                          ?.length ??
                                      0,
                                  itemBuilder: (context, index) {
                                    final transferredTask =
                                        taskState
                                            .selectedTask!
                                            .transferredTasks![index];

                                    return Card(
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 16,
                                      ),
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              vertical: 12,
                                              horizontal: 16,
                                            ),
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.blue.shade100,
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.blue.shade800,
                                          ),
                                        ),
                                        title: Text(
                                          transferredTask?.name ?? 'NA',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 4),
                                            Text(
                                              "Reason: ${transferredTask?.reason}",
                                              style: TextStyle(
                                                color: Colors.grey.shade700,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "Location: ${taskState.selectedTask?.locationMode}",
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        children: [
                          if (taskState.selectedTask?.paymentDueCleared == true)
                            Text(
                              'Payment is cleared! This task has been closed.',
                              style: AppStyles.style20.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                fontSize: 25,
                              ),
                            ),
                          Container(
                            width: 450,
                            color: Colors.grey,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Comments',
                                              style: AppStyles.style20.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.white,
                                                fontSize: 22,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                comments.length.toString(),
                                                style: AppStyles.subHeading,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(8),
                                        bottomRight: Radius.circular(8),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 300,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const AlwaysScrollableScrollPhysics(),
                                            itemCount: comments.length,
                                            itemBuilder: (context, index) {
                                              final comment = comments[index];
                                              return Column(
                                                children: [
                                                  _buildCommentItem(
                                                    name:
                                                        comment
                                                            .commentOwnerName,
                                                    comment:
                                                        comment.commentText,
                                                    time: formatTime(
                                                      comment.commentDate
                                                          .toDate(),
                                                    ),
                                                    date: formatDate(
                                                      comment.commentDate
                                                          .toDate(),
                                                    ),
                                                    url:
                                                        comment.commentOwnerImg,
                                                    likes:
                                                        comment.likedBy.length,
                                                  ),
                                                  const Divider(),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        // Comment input field
                                        Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey[100],
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: TextFormField(
                                                      controller: comment,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      style: AppStyles
                                                          .subHeadingMobile
                                                          .copyWith(
                                                            color: Colors.black,
                                                          ),
                                                      decoration: InputDecoration(
                                                        hintText:
                                                            "Enter message here",
                                                        hintStyle: AppStyles
                                                            .subHeadingMobile
                                                            .copyWith(
                                                              color:
                                                                  AppColors
                                                                      .grey,
                                                            ),
                                                        counterText: "",
                                                        contentPadding:
                                                            const EdgeInsets.symmetric(
                                                              vertical: 2,
                                                              horizontal: 12,
                                                            ),
                                                        border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                          borderSide:
                                                              const BorderSide(
                                                                color:
                                                                    AppColors
                                                                        .primary,
                                                                width: 1,
                                                              ),
                                                        ),
                                                        enabledBorder: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                          borderSide:
                                                              const BorderSide(
                                                                color:
                                                                    AppColors
                                                                        .primary,
                                                                width: 1,
                                                              ),
                                                        ),
                                                        focusedBorder: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                          borderSide:
                                                              const BorderSide(
                                                                color:
                                                                    AppColors
                                                                        .primary,
                                                                width: 1,
                                                              ),
                                                        ),
                                                        errorBorder: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                          borderSide:
                                                              const BorderSide(
                                                                color:
                                                                    Colors.red,
                                                                width: 1,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    decoration:
                                                        const BoxDecoration(
                                                          color:
                                                              AppColors
                                                                  .secondary,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                    child: IconButton(
                                                      onPressed: () async {
                                                        if (comment
                                                            .text
                                                            .isNotEmpty) {
                                                          print(
                                                            'comment is pressed',
                                                          );
                                                          final Comment
                                                          commentModel = Comment(
                                                            commentText:
                                                                comment.text
                                                                    .trim(),
                                                            timeStamp:
                                                                Timestamp.now(),
                                                            commentOwnerRef:
                                                                authState
                                                                    .user!
                                                                    .documentReference,
                                                            commentOwnerName:
                                                                authState
                                                                    .user!
                                                                    .displayName,
                                                            taskRef:
                                                                taskState
                                                                    .selectedTask!
                                                                    .taskDocRef,
                                                            commentOwnerImg:
                                                                authState
                                                                    .user!
                                                                    .photoUrl,

                                                            commentDate:
                                                                Timestamp.now(),
                                                            likedBy: [],
                                                            likedByRef: [],
                                                            totalLikes: 0,
                                                            taskStatusCategory:
                                                                taskState
                                                                    .selectedTask!
                                                                    .taskStatusCategory,
                                                          );
                                                          final success = await ref
                                                              .read(
                                                                taskProvider
                                                                    .notifier,
                                                              )
                                                              .addCommentToTask(
                                                                taskId:
                                                                    taskState
                                                                        .selectedTask!
                                                                        .taskRef,
                                                                comment:
                                                                    commentModel,
                                                              );
                                                          if (success) {
                                                            comment.clear();
                                                          }
                                                        }

                                                        // ScaffoldMessenger.of(
                                                        //   context,
                                                        // ).showSnackBar(
                                                        //   SnackBar(
                                                        //     content: Text(
                                                        //       'Comment adding feature is coming soon.',
                                                        //     ),
                                                        //   ),
                                                        // );
                                                      },
                                                      icon: const Icon(
                                                        Icons.send,
                                                        color: Colors.black,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              SizedBox(),
                              Text(
                                'Curator Bills',
                                style: AppStyles.style20.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,

                                  fontSize: 24,
                                ),
                              ),
                              SizedBox(width: 30),
                              InkWell(
                                onTap: () {
                                  if (taskState.selectedTask?.isTaskDisabled ==
                                      false) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          child: SizedBox(
                                            height:
                                                MediaQuery.of(
                                                  context,
                                                ).size.height *
                                                0.9,
                                            child: AddBill(
                                              taskState.selectedTask!,
                                              profileState.singleProfile?.id ??
                                                  '',
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Task is disabled, cannot create the bill, Please enable the task to create bill',
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Tooltip(
                                  message: 'Add new addition bill',
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: AppColors.primary,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 400,
                            height: 300,
                            child: ListView.builder(
                              itemCount: curatorBillState.curatorBills.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(40.0),
                                  child: Card(
                                    elevation: 4,
                                    margin: const EdgeInsets.all(8),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        children: [
                                          const SizedBox(width: 16),

                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Invoice Number: ${curatorBillState.curatorBills[index].invoiceNumber}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  'Description: ${curatorBillState.curatorBills[index].invoiceDescription}',
                                                  style: TextStyle(
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  'Total Amount: \₹${curatorBillState.curatorBills[index].totalAmount.toStringAsFixed(2)}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green[700],
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    SizedBox(height: 5),
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        URL().openUrlInNewTab(
                                                          curatorBillState
                                                              .curatorBills[index]
                                                              .docUrl,
                                                          '_name',
                                                        );
                                                      },
                                                      style:
                                                          ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                AppColors
                                                                    .primary,
                                                            foregroundColor:
                                                                AppColors
                                                                    .secondary,
                                                            elevation: 2,
                                                          ),
                                                      child: Text('View Bill'),
                                                    ),
                                                    Row(
                                                      spacing: 5,
                                                      children: [
                                                        !(curatorBillState
                                                                    .curatorBills[index]
                                                                    .isAdminApproved ||
                                                                curatorBillState
                                                                    .curatorBills[index]
                                                                    .isLMApproved)
                                                            ? ElevatedButton(
                                                              onPressed: () {
                                                                ref
                                                                    .read(
                                                                      curatorBillProvider
                                                                          .notifier,
                                                                    )
                                                                    .updateBill(
                                                                      isAdminApproved:
                                                                          true,
                                                                      billId:
                                                                          curatorBillState
                                                                              .curatorBills[index]
                                                                              .billDocRef!,
                                                                      status:
                                                                          'Approved',
                                                                    );
                                                              },
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor:
                                                                    AppColors
                                                                        .primary,
                                                                foregroundColor:
                                                                    AppColors
                                                                        .secondary,
                                                                elevation: 2,
                                                              ),
                                                              child: const Text(
                                                                'Approve Bill',
                                                              ),
                                                            )
                                                            : SizedBox(),
                                                        !(curatorBillState
                                                                    .curatorBills[index]
                                                                    .status ==
                                                                'Rejected')
                                                            ? PopupMenuButton<
                                                              String
                                                            >(
                                                              onSelected: (
                                                                String value,
                                                              ) async {
                                                                if (value ==
                                                                    'Reject') {
                                                                  String?
                                                                  rejectionReason =
                                                                      await showRejectionDialog(
                                                                        context,
                                                                      );
                                                                  if (rejectionReason !=
                                                                      null) {
                                                                    ref
                                                                        .read(
                                                                          curatorBillProvider
                                                                              .notifier,
                                                                        )
                                                                        .updateRejectionBill(
                                                                          isAdminApproved:
                                                                              false,
                                                                          rejectionReason:
                                                                              rejectionReason,
                                                                          billId:
                                                                              curatorBillState.curatorBills[index].billDocRef!,
                                                                        );
                                                                    taskState
                                                                        .selectedTask
                                                                        ?.isTaskBillCreated = false;
                                                                  }
                                                                }
                                                              },
                                                              icon: Icon(
                                                                Icons.more_vert,
                                                                color:
                                                                    AppColors
                                                                        .primary,
                                                              ),
                                                              itemBuilder:
                                                                  (
                                                                    BuildContext
                                                                    context,
                                                                  ) => [
                                                                    PopupMenuItem<
                                                                      String
                                                                    >(
                                                                      value:
                                                                          'Reject',
                                                                      child: Text(
                                                                        'Reject',
                                                                      ),
                                                                    ),
                                                                    // You can add more options here later if needed
                                                                  ],
                                                            )
                                                            : Text(
                                                              'Rejected',
                                                              style: TextStyle(
                                                                color:
                                                                    AppColors
                                                                        .red,
                                                              ),
                                                            ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 10),

                          Visibility(
                            visible:
                                taskState.selectedTask?.isTaskBillCreated ==
                                    true &&
                                taskState.selectedTask?.curatorTaskStatus ==
                                    'Completed' &&
                                taskState.selectedTask?.paymentDueCleared ==
                                    false,
                            child: ElevatedButton(
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: SizedBox(
                                        height: 450,
                                        child: UploadPhotosBills(
                                          taskId:
                                              taskState.selectedTask?.taskRef ??
                                              '',
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.secondary,
                                elevation: 2,
                              ),
                              child:
                                  !(taskState.actionLoaders['cycleUpdate'] ??
                                          false)
                                      ? Text(
                                        'Complete Task Lifecycle',
                                        style: AppStyles.style20.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.white,
                                          fontSize: 18,
                                        ),
                                      )
                                      : CircularProgressIndicator(),
                            ),
                          ),

                          SizedBox(height: 10),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> showRejectionDialog(BuildContext context) async {
    TextEditingController reasonController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Reject Bill"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Please enter the reason for rejection:"),
              SizedBox(height: 10),
              TextField(
                controller: reasonController,
                decoration: InputDecoration(
                  hintText: "Enter reason...",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed:
                  () => Navigator.pop(context, null), // Close without reason
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (reasonController.text.isNotEmpty) {
                  Navigator.pop(context, reasonController.text);
                }
              },
              child: Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  void showAssignPriceDialog(
    BuildContext context,
    WidgetRef ref,
    String taskId,
    String taskSubject,
    String taskDescription,
    String timeSlot,
    String taskMode,
    double taskPrice,
    double? taskHours,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AssignPriceDialog(
            taskId: taskId,
            taskSubject: taskSubject,
            taskDescription: taskDescription,
            timeSlot: timeSlot,
            taskMode: taskMode,
            taskPrice: taskPrice,
            taskHours: taskHours ?? 0,
          ),
    );
  }

  Widget _buildImagePreview(String image) {
    return Container(
      height: 250,
      width: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image(image: NetworkImage(image), fit: BoxFit.cover),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.grey, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}

String formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.year}';
}

String formatFullDate(DateTime date) {
  return DateFormat('EEEE, d MMM yyyy').format(date);
}

String formatTime(DateTime date) {
  return DateFormat('hh:mm a').format(date);
}

Widget _buildCommentItem({
  required String name,
  required String comment,
  required String time,
  required String date,
  required String url,
  required int likes,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.orange[200],
                radius: 16,
                child: Image.network(url, fit: BoxFit.fill),
              ),
              const SizedBox(width: 8),
              Text(
                name,
                style: AppStyles.style20.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
      if (date.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(left: 40.0, top: 2.0),
          child: Text(
            date,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
      Padding(
        padding: const EdgeInsets.only(left: 40.0, top: 4.0),
        child: Text(comment),
      ),
      // Commented out like and reply section
      // Padding(
      //   padding: const EdgeInsets.only(left: 40.0, top: 4.0),
      //   child: Row(
      //     children: [
      //       const Icon(Icons.thumb_up, size: 16, color: Colors.grey),
      //       const SizedBox(width: 4),
      //       if (likes > 0)
      //         Text('$likes', style: const TextStyle(color: Colors.grey)),
      //       const SizedBox(width: 16),
      //       Text('Reply',
      //           style: TextStyle(
      //               color: Colors.deepOrange[700],
      //               fontWeight: FontWeight.w500)),
      //     ],
      //   ),
      // ),
    ],
  );
}

class DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isMultiLine;
  final Color? color;

  const DetailRow({
    this.color = Colors.black87,
    Key? key,
    required this.label,
    required this.value,
    this.isMultiLine = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
          isMultiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 130,
          child: Text(
            label,
            style: AppStyles.style20.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppStyles.style20.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
