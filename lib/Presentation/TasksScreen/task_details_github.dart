import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../Constants/app_colors.dart';
import '../../Constants/app_styles.dart';
import '../../Models/model_tasks.dart';
import '../../Providers/providers.dart';
import '../../Providers/textproviders.dart';
import '../LoadingScreen/loading_screen.dart';
import '../Widgets/global_btn.dart';

class TaskDetailsScreen extends ConsumerStatefulWidget {
  final String taskId;
  const TaskDetailsScreen({super.key, required this.taskId});

  @override
  ConsumerState<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends ConsumerState<TaskDetailsScreen> {
  TaskModel? task;
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final taskState = ref.read(taskProvider);
      task = taskState.listOfTasks.firstWhere(
        (task) => task.taskRef == widget.taskId,
      );

      if (task?.patronRef != null) {
        ref.read(patronProvider.notifier).fetchPatron(task!.patronRef!);
        ref.read(taskProvider.notifier).listenToComments(widget.taskId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final comment = ref.watch(commentController);
    final tasksNotifier = ref.read(taskProvider.notifier);
    if (authState.user == null) {
      return const LoadingScreen();
    }
    final profile = ref.watch(profileProvider);
    final taskState = ref.watch(taskProvider);
    task = taskState.listOfTasks.firstWhere(
      (task) => task.taskRef == widget.taskId,
    );

    if (task == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Task Details")),
        body: Center(child: Text("Task not found or still loading...")),
      );
    }

    final patronState = ref.watch(patronProvider);
    final comments = ref.watch(taskProvider).comments;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        context.pushReplacement("/tasks/onGoingTasks");
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Task Details Section
                          _buildSectionCard(
                            title: 'Task Details',
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildCategoryPill(
                                  task?.selectedHomeCuratorDepartment ??
                                      "Not Provided",
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  task?.taskSubject ?? "Not Provided",
                                  style: AppStyles.subHeadingMobile,
                                ),
                                const SizedBox(height: 12),
                                _buildDetailRow(
                                  'Subject :',
                                  task?.taskSubject ?? "Not Provided",
                                ),
                                const SizedBox(height: 8),
                                _buildDetailRow(
                                  'Description :',
                                  task?.taskDescription ?? "Not Provided",
                                  isMultiLine: true,
                                ),
                                const SizedBox(height: 8),
                                _buildDetailRow(
                                  'Start Date :',
                                  formatDate(task!.taskStartTime.toDate()),
                                ),
                                _buildDetailRow(
                                  'End Date :',
                                  formatDate(task!.taskEndTime.toDate()),
                                ),
                                const SizedBox(height: 8),
                                _buildDetailRow(
                                  'Mode :',
                                  task?.locationMode ?? "Not Provided",
                                ),
                                _buildDetailRow(
                                  'Location :',
                                  task?.patronAddress ?? "Not Provided",
                                ),
                                const SizedBox(height: 8),
                                _buildDetailRow(
                                  'Price :',
                                  task!.taskPriceByAdmin == 0.0
                                      ? "Price Reveal Soon"
                                      : '₹ ${task!.taskPriceByAdmin.toString()}',
                                ),
                                const SizedBox(height: 8),
                                _buildDetailRow(
                                  'Slot :',
                                  task?.assignedTimeSlot ?? "Not Provided",
                                ),
                                const SizedBox(height: 4),
                                // PriorityBadge(
                                //   priority: task?.priority ?? "Low",
                                // ),
                                const SizedBox(height: 8),
                                _buildDetailRow(
                                  'Lifestyle Manager :',
                                  task?.assignedLMName ?? "Not Provided",
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (patronState.isLoading)
                            const Center(child: CircularProgressIndicator())
                          else if (patronState.errorMessage != null)
                            Text(
                              "Error: ${patronState.errorMessage}",
                              style: const TextStyle(
                                color: Colors.red,
                                fontFamily: 'Begum',
                              ),
                            )
                          else if (patronState.patron != null)
                            _buildSectionCard(
                              title: 'Patron Details',
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildDetailRow(
                                    'Name :',
                                    patronState.patron!.patronName,
                                  ),
                                  _buildDetailRow(
                                    'Phone Number :',
                                    patronState.patron!.mobileNumber1,
                                  ),
                                  _buildDetailRow(
                                    'Address :',
                                    '${patronState.patron!.addressLine1} ${patronState.patron!.addressLine2} '
                                        '${patronState.patron!.landmark} ${patronState.patron!.city} '
                                        '${patronState.patron!.pinCode}',
                                    isMultiLine: true,
                                  ),
                                  _buildDetailRow(
                                    'Landmark :',
                                    patronState.patron!.landmark,
                                  ),
                                  _buildDetailRow(
                                    'City :',
                                    patronState.patron!.city,
                                  ),
                                  _buildDetailRow(
                                    'State :',
                                    patronState.patron!.state,
                                  ),
                                  _buildDetailRow(
                                    'Pincode :',
                                    patronState.patron!.pinCode.toString(),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Visibility(
                              //   visible: task?.curatorTaskStatus == "Pending",
                              //   child: Padding(
                              //     padding: const EdgeInsets.symmetric(
                              //       horizontal: 20,
                              //     ),
                              //     child: Row(
                              //       children: [
                              //         Expanded(
                              //           child: GlobalButton(
                              //             text: "Begin Task",
                              //             onPressed: () async {
                              //               await tasksNotifier
                              //                   .taskBeginByCurator(
                              //                     taskId: task!.taskRef,
                              //                   );
                              //             },
                              //             height: 40,
                              //             width: 200,
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              // Visibility(
                              //   visible:
                              //       task?.curatorTaskStatus == "In Progress",
                              //   child: VisualVerificationWidget(task: task!),
                              // ),
                              // const SizedBox(height: 10),
                              // StatusUpdateWidget(task: task!),
                            ],
                          ),
                          Container(
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
                                            padding: const EdgeInsets.symmetric(
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
                                                      comment.commentOwnerName,
                                                  comment: comment.commentText,
                                                  time: formatTime(
                                                    comment.commentDate
                                                        .toDate(),
                                                  ),
                                                  date: formatDate(
                                                    comment.commentDate
                                                        .toDate(),
                                                  ),
                                                  url: comment.commentOwnerImg,
                                                  likes: comment.likedBy.length,
                                                ),
                                                const Divider(),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      // Comment input field
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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
                                                  hintText: "Type a Text",
                                                  hintStyle: AppStyles
                                                      .subHeadingMobile
                                                      .copyWith(
                                                        color: AppColors.grey,
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
                                                              AppColors.primary,
                                                          width: 1,
                                                        ),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
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
                                                  focusedBorder:
                                                      OutlineInputBorder(
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
                                                          color: Colors.red,
                                                          width: 1,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: const BoxDecoration(
                                                color: AppColors.secondary,
                                                shape: BoxShape.circle,
                                              ),
                                              // child: IconButton(
                                              //   onPressed: () async {
                                              //     if (comment.text.isNotEmpty) {
                                              //       final Comment
                                              //       commentModel = Comment(
                                              //         commentText:
                                              //             comment.text.trim(),
                                              //         timeStamp:
                                              //             Timestamp.now(),
                                              //         commentOwnerRef:
                                              //             authState
                                              //                 .user!
                                              //                 .userRef!,
                                              //         commentOwnerName:
                                              //             authState
                                              //                 .user!
                                              //                 .fullName,
                                              //         taskRef:
                                              //             task!.taskRef!!!,
                                              //         commentOwnerImg:
                                              //             profile
                                              //                 .profile!
                                              //                 .profileImage,
                                              //         commentDate:
                                              //             Timestamp.now(),
                                              //         likedBy: [],
                                              //         likedByRef: [],
                                              //         totalLikes: 0,
                                              //         taskStatusCategory:
                                              //             task!
                                              //                 .curatorTaskStatus,
                                              //       );
                                              //       final success =
                                              //           await tasksNotifier
                                              //               .addCommentToTask(
                                              //                 taskId:
                                              //                     task!.taskRef,
                                              //                 comment:
                                              //                     commentModel,
                                              //               );
                                              //       if (success) {
                                              //         comment.clear();
                                              //       }
                                              //     }
                                              //   },
                                              //   icon: const Icon(
                                              //     Icons.send,
                                              //     color: Colors.black,
                                              //     size: 20,
                                              //   ),
                                              // ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget content}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppStyles.subHeadingMobile),
            const SizedBox(height: 16),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: AppStyles.subHeadingMobile.copyWith(color: AppColors.white),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isMultiLine = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment:
            isMultiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Text(label, style: AppStyles.subHeadingMobile.copyWith(fontSize: 16)),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              style: AppStyles.text14.copyWith(
                color: Colors.black,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
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
            Text(
              time,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
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
}
