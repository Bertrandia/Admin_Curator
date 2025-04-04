import 'package:admin_curator/Constants/URls.dart';
import 'package:admin_curator/Constants/app_colors.dart';
import 'package:admin_curator/Models/model_tasks.dart';
import 'package:admin_curator/Models/profile.dart';
import 'package:admin_curator/Presentation/Widgets/custom_dropDown.dart';
import 'package:admin_curator/Presentation/Widgets/global_btn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../Constants/app_styles.dart';
import '../../Models/comment.dart';
import '../../Providers/providers.dart';
import '../../Providers/textproviders.dart';
import '../Widgets/asssign_pric_component.dart';
import 'dart:html' as html;

class TasksDetailsPAge extends ConsumerStatefulWidget {
  final TaskModel model;
  TasksDetailsPAge(this.model, {super.key});

  @override
  ConsumerState<TasksDetailsPAge> createState() => _CuratorProfilesState();
}

class _CuratorProfilesState extends ConsumerState<TasksDetailsPAge> {
  CuratorModel? matchingProfile;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.microtask(() {
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

        // print("Profile by ID : ${profileState.singleProfile?.fullName}");
      }
      if (widget.model.patronRef != null) {
        ref.read(patronProvider.notifier).fetchPatron(widget.model!.patronRef!);
        ref.read(taskProvider.notifier).listenToComments(widget.model.taskRef);
      }
      print('Document Reference of Task${widget.model.taskDocRef}');
      ref
          .read(curatorBillProvider.notifier)
          .fetchBills(taskRef: widget.model.taskDocRef!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final patronState = ref.watch(patronProvider);
    final authState = ref.watch(authNotifierProvider);
    final profileState = ref.watch(profileProvider);
    final comment = ref.watch(commentController);

    final curatorBillState = ref.watch(curatorBillProvider);

    print('Curator Bill State: ${curatorBillState.curatorBills}');

    print('User Profile is empty : ${profileState.singleProfile?.fullName}');
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
                      const Text(
                        'Task',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFAA4400),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  taskState.selectedTask?.isTaskDisabled == false
                      ? ElevatedButton(
                        onPressed: () {
                          ref
                              .read(taskProvider.notifier)
                              .updateTaskVisiblity(
                                isTaskDisabled: true,
                                taskId: widget.model.taskRef,
                              );
                        },
                        child: Text('Disable Task'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.secondary,
                          elevation: 2,
                        ),
                      )
                      : ElevatedButton(
                        onPressed: () {
                          ref
                              .read(taskProvider.notifier)
                              .updateTaskVisiblity(
                                isTaskDisabled: false,
                                taskId: widget.model.taskRef,
                              );
                        },
                        child: Text('Enable Task'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.secondary,
                          elevation: 2,
                        ),
                      ),
                ],
              ),
            ),
            SizedBox(height: 10),
            CustomDropdown(
              taskID: widget.model.taskRef,
              header: 'Assign Task to curator',
              selectedItem: matchingProfile?.fullName ?? 'NO Assigned',
              items:
                  profileState.profile
                      .map((curator) => curator.fullName)
                      .toList(),
              hintText: 'Search Curator',
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
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      Spacer(),
                                      ElevatedButton(
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
                                        child: Text('Assign Price'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                          foregroundColor: AppColors.secondary,
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
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
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
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFAA4400),
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
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFAA4400),
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
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFAA4400),
                              ),
                            ),
                            const Text(
                              ' Uploaded photos highlighting the tasks performed and the progress made will be shown below',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
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
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        children: [
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
                                              style: AppStyles.subHeading
                                                  .copyWith(
                                                    color: AppColors.white,
                                                    fontSize: 18,
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
                                                            "Type comment feature will come soon",
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
                                                                        .taskID,
                                                                comment:
                                                                    commentModel,
                                                              );
                                                          if (success) {
                                                            comment.clear();
                                                          }
                                                        }

                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              'Comment adding feature is coming soon.',
                                                            ),
                                                          ),
                                                        );
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(),
                              Text(
                                'Curator Bills',
                                style: TextStyle(fontSize: 30),
                              ),
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: AppColors.primary,
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
                                                        ? ElevatedButton(
                                                          onPressed: () async {
                                                            String?
                                                            rejectionReason =
                                                                await showRejectionDialog(
                                                                  context,
                                                                );
                                                            ref
                                                                .read(
                                                                  curatorBillProvider
                                                                      .notifier,
                                                                )
                                                                .updateRejectionBill(
                                                                  isAdminApproved:
                                                                      false,
                                                                  rejectionReason:
                                                                      rejectionReason ??
                                                                      '',
                                                                  billId:
                                                                      curatorBillState
                                                                          .curatorBills[index]
                                                                          .billDocRef!,
                                                                );
                                                          },
                                                          child: Text(
                                                            'Reject Bill',
                                                          ),
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                AppColors
                                                                    .primary,
                                                            foregroundColor:
                                                                AppColors
                                                                    .secondary,
                                                            elevation: 2,
                                                          ),
                                                        )
                                                        : Text(
                                                          'Rejected',
                                                          style: TextStyle(
                                                            color:
                                                                AppColors.red,
                                                          ),
                                                        ),
                                                  ],
                                                ),
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
                                                            AppColors.primary,
                                                        foregroundColor:
                                                            AppColors.secondary,
                                                        elevation: 2,
                                                      ),
                                                  child: Text('View Bill'),
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

                          ElevatedButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('createTaskCollection')
                                  .doc(widget.model.taskRef)
                                  .update({
                                    'curatorTaskStatus': 'Completed',
                                    'paymentDueClearedTimeByAdmin':
                                        Timestamp.now(),
                                  })
                                  .then((va) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Task Lifecycle completed',
                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: Text('Complete Task Lifecycle'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.secondary,
                              elevation: 2,
                            ),
                          ),
                        ],
                      ),

                      // Visual verification
                      // Expanded(
                      //   flex: 2,
                      //   child: Container(
                      //     padding: const EdgeInsets.all(16),
                      //     child: Column(
                      //       crossAxisAlignment:
                      //           CrossAxisAlignment.start,
                      //       children: [
                      //         const Text(
                      //           'Verified Images',
                      //           style: TextStyle(
                      //             fontSize: 18,
                      //             fontWeight: FontWeight.bold,
                      //             color: Color(0xFFAA4400),
                      //           ),
                      //         ),
                      //         const SizedBox(height: 16),
                      //         const Text(
                      //           ' Uploaded photos highlighting the tasks performed and the progress made will be shown below',
                      //           style: TextStyle(
                      //             fontSize: 14,
                      //             color: Colors.black87,
                      //           ),
                      //         ),
                      //         const SizedBox(height: 16),
                      //         // Image preview slots
                      //      //   Row(
                      //      //     children: [
                      //             // Expanded(
                      //             //   child: _buildImagePreview(
                      //             //     widget
                      //             //         .model
                      //             //         .listOfImagesUploadedByCurator[0],
                      //             //   ),
                      //             // ),
                      //             // const SizedBox(width: 8),
                      //             // Expanded(
                      //             //   child: _buildImagePreview(
                      //             //     widget
                      //             //         .model
                      //             //         .listOfImagesUploadedByCurator[0],
                      //             //   ),
                      //             // ),
                      //     //      ],
                      //    //     ),
                      //
                      //         // Row(
                      //         //   children: [
                      //         //     Expanded(
                      //         //       child: _buildImagePreview(
                      //         //         widget
                      //         //             .model
                      //         //             .listOfImagesUploadedByCurator[0],
                      //         //       ),
                      //         //     ),
                      //         //     const SizedBox(width: 8),
                      //         //     Expanded(
                      //         //       child: _buildImagePreview(
                      //         //         widget
                      //         //             .model
                      //         //             .listOfImagesUploadedByCurator[1],
                      //         //       ),
                      //         //     ),
                      //         //   ],
                      //         // ),
                      //         SizedBox(height: 20),
                      //         widget.model.curatorTaskStatus ==
                      //                 'Payment Due'
                      //             ? Align(
                      //               alignment: Alignment.center,
                      //               child: ElevatedButton(
                      //                 onPressed: () {
                      //                   FirebaseFirestore.instance
                      //                       .collection(
                      //                         'createTaskCollection',
                      //                       )
                      //                       .doc(widget.model.taskRef)
                      //                       .update({
                      //                         'curatorTaskStatus':
                      //                             'Completed',
                      //                         'paymentDueClearedTimeByAdmin':
                      //                             DateTime.now(),
                      //                       })
                      //                       .then((val) {
                      //                         context.replace(
                      //                           '/dashboard',
                      //                         );
                      //                       });
                      //                 },
                      //                 child: Text(
                      //                   'Complete Task Lifecyle',
                      //                 ),
                      //                 style: ElevatedButton.styleFrom(
                      //                   backgroundColor:
                      //                       AppColors.primary,
                      //                   foregroundColor:
                      //                       AppColors.secondary,
                      //                 ),
                      //               ),
                      //             )
                      //             : SizedBox(),
                      //       ],
                      //     ),
                      //   ),
                      // ),
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange[800],
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
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: label == 'Priority' ? this.color : color,
            ),
          ),
        ),
        Expanded(
          child: Text(value, style: TextStyle(fontSize: 14, color: color)),
        ),
      ],
    );
  }
}
