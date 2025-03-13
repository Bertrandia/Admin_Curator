import 'package:admin_curator/Constants/app_colors.dart';
import 'package:admin_curator/Models/model_tasks.dart';
import 'package:admin_curator/Models/task_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../Providers/providers.dart';
//
// class TasksDetailsPage extends StatelessWidget {
//   final String id;
//   const TasksDetailsPage({Key? key, required this.id}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Pinch App',
//       theme: ThemeData(primarySwatch: Colors.orange, fontFamily: 'Roboto'),
//       home: const TaskDetailsPage(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

class TasksDetailsPAge extends ConsumerStatefulWidget {
  final TaskModel model;
  TasksDetailsPAge(this.model, {super.key});

  @override
  ConsumerState<TasksDetailsPAge> createState() => _CuratorProfilesState();
}

class _CuratorProfilesState extends ConsumerState<TasksDetailsPAge> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.microtask(() {
      ref.read(patronProvider.notifier).fetchPatron(widget.model.patronRef!);
      ref.read(profileProvider.notifier).fetchCurators();
      ref
          .read(profileProvider.notifier)
          .getCuratorById(widget.model.taskAssignedToCurator!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final patronState = ref.watch(patronProvider);
    final profileState = ref.watch(profileProvider);
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            // Side navigation
            // Container(
            //   width: 230,
            //   color: AppColors.secondary,
            //   child: Column(
            //     children: [
            //       const SizedBox(height: 20),
            //       // Logo
            //       Row(
            //         children: [
            //           const SizedBox(width: 20),
            //           // Image.network(
            //           //   widget.model.patronAddress,
            //           //   width: 24,
            //           //   height: 24,
            //           // ),
            //         ],
            //       ),
            //       const SizedBox(height: 30),
            //       // Profile section
            //       Container(
            //         padding: const EdgeInsets.all(16),
            //         child: Column(
            //           children: [
            //             // const CircleAvatar(
            //             //   radius: 60,
            //             //   backgroundImage: AssetImage('assets/profile.jpg'),
            //             //   backgroundColor: Colors.amber,
            //             // ),
            //             const SizedBox(height: 15),
            //             Text(
            //               profileState.singleProfile?.fullName ?? "NA",
            //               style: TextStyle(
            //                 fontSize: 22,
            //                 fontWeight: FontWeight.bold,
            //                 color: Color(0xFFAA4400),
            //               ),
            //             ),
            //             const SizedBox(height: 5),
            //             Text(
            //               profileState.singleProfile?.email ?? 'NA',
            //               style: TextStyle(fontSize: 14, color: Colors.brown),
            //             ),
            //           ],
            //         ),
            //       ),
            //       const SizedBox(height: 20),
            //       // Navigation sections
            //       NavigationSection(
            //         title: 'Skills',
            //         items:
            //             profileState.singleProfile?.profile?.selectedSkills ??
            //             [],
            //       ),
            //       const Divider(
            //         color: Colors.brown,
            //         height: 1,
            //         indent: 40,
            //         endIndent: 40,
            //       ),
            //       NavigationSection(title: 'Payments', items: []),
            //       const Divider(
            //         color: Colors.brown,
            //         height: 1,
            //         indent: 40,
            //         endIndent: 40,
            //       ),
            //       NavigationSection(title: 'Reviews', items: []),
            //       const Divider(
            //         color: Colors.brown,
            //         height: 1,
            //         indent: 40,
            //         endIndent: 40,
            //       ),
            //       NavigationSection(title: 'Skills', items: []),
            //     ],
            //   ),
            // ),
            // Main content
            Expanded(
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
                              flex: 3,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Task Details',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
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
                                            widget
                                                .model
                                                .selectedHomeCuratorDepartment,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    // Subject
                                    DetailRow(
                                      label: 'Subject :',
                                      value: widget.model.taskSubject,
                                    ),
                                    const SizedBox(height: 8),
                                    // Description
                                    DetailRow(
                                      label: 'Description :',
                                      value: widget.model.taskDescription,
                                      isMultiLine: true,
                                    ),
                                    const SizedBox(height: 16),
                                    // Dates
                                    DetailRow(
                                      label: 'Start Date :',
                                      value: DateFormat('dd-MM-yy').format(
                                        widget.model.taskStartTime.toDate(),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    DetailRow(
                                      label: 'End Date :',
                                      value: DateFormat('dd-MM-yy').format(
                                        widget.model.taskEndTime.toDate(),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    // Mode and Location
                                    DetailRow(
                                      label: 'Location Mode :',
                                      value: widget.model.locationMode ?? 'NA',
                                    ),

                                    const SizedBox(height: 16),
                                    // Price
                                    DetailRow(
                                      label: 'Price :',
                                      value:
                                          widget.model.taskPriceByAdmin
                                              .toString(),
                                    ),
                                    const SizedBox(height: 16),
                                    // Slot and Priority
                                    DetailRow(
                                      label: 'Slot :',
                                      value:
                                          widget.model.assignedTimeSlot ?? 'NA',
                                    ),
                                    const SizedBox(height: 8),
                                    DetailRow(
                                      label: 'Priority: ',
                                      value: widget.model.priority,
                                      color:
                                          widget.model.priority == 'Low'
                                              ? AppColors.black
                                              : widget.model.priority ==
                                                  'Medium'
                                              ? AppColors.orange
                                              : AppColors.red,
                                    ),
                                    const SizedBox(height: 16),
                                    // Lifestyle Manager
                                    DetailRow(
                                      label: 'LM:',
                                      value: widget.model.assignedLMName,
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
                                          patronState.patron?.clientCode ??
                                          "NA",
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Visual verification
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Verified Images',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFAA4400),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      ' Uploaded photos highlighting the tasks performed and the progress made will be shown below',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    // Image preview slots
                                    Row(
                                      children: [
                                        // Expanded(
                                        //   child: _buildImagePreview(
                                        //     widget
                                        //         .model
                                        //         .listOfImagesUploadedByCurator[0],
                                        //   ),
                                        // ),
                                        // const SizedBox(width: 8),
                                        Expanded(
                                          child: _buildImagePreview(
                                            widget
                                                .model
                                                .listOfImagesUploadedByCurator[0],
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Row(
                                    //   children: [
                                    //     Expanded(
                                    //       child: _buildImagePreview(
                                    //         widget
                                    //             .model
                                    //             .listOfImagesUploadedByCurator[0],
                                    //       ),
                                    //     ),
                                    //     const SizedBox(width: 8),
                                    //     Expanded(
                                    //       child: _buildImagePreview(
                                    //         widget
                                    //             .model
                                    //             .listOfImagesUploadedByCurator[1],
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    SizedBox(height: 20),
                                    widget.model.curatorTaskStatus ==
                                            'Payment Due'
                                        ? Align(
                                          alignment: Alignment.center,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              FirebaseFirestore.instance
                                                  .collection(
                                                    'createTaskCollection',
                                                  )
                                                  .doc(widget.model.taskRef)
                                                  .update({
                                                    'curatorTaskStatus':
                                                        'Completed',
                                                    'paymentDueClearedTimeByAdmin':
                                                        DateTime.now(),
                                                  })
                                                  .then((val) {
                                                    context.replace(
                                                      '/dashboard',
                                                    );
                                                  });
                                            },
                                            child: Text(
                                              'Complete Task Lifecyle',
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.primary,
                                              foregroundColor:
                                                  AppColors.secondary,
                                            ),
                                          ),
                                        )
                                        : SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(String Image) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(Icons.image, color: Colors.grey, size: 36),
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

class NavigationSection extends StatelessWidget {
  final String title;
  final List<String> items;

  const NavigationSection({Key? key, required this.title, required this.items})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFFAA4400),
            ),
          ),
        ),
        if (items.isNotEmpty)
          Column(children: items.map((item) => _buildNavItem(item)).toList()),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildNavItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, color: Colors.brown),
      ),
    );
  }
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
