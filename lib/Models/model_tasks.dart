import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String taskRef;
  String assignedLMName;
  DocumentReference? backupLmRef;
  String billingModel;
  String categoryTag;
  Timestamp createdAt;
  String createdBy;
  bool isCockpitTaskCreated;
  bool isDelayed;
  bool isTaskDisabled;
  DocumentReference? lmRef;
  String patronName; // Fixed Typo
  String patronAddress;
  DocumentReference? patronRef;
  String priority;
  String refImage;
  String remarks;
  String selectedHomeCuratorDepartment;
  DocumentReference? selectedHomeCuratorDepartmentRef;
  Timestamp taskAssignDate;
  String taskCategory;
  Timestamp taskDate;
  String taskDescription;
  Timestamp taskDueDate;
  Timestamp taskEndTime;
  String taskID;
  String taskOwner;
  String taskRecievedTime;
  Timestamp taskStartTime;
  String taskStatusCategory;
  String taskSubCategory;
  String taskSubject;

  // Newly Added Fields
  String curatorTaskStatus;
  String? taskAssignedToCurator;
  String? assignedTimeSlot;
  double taskPriceByAdmin;
  double taskDurationByAdmin;
  Timestamp? taskStartTimeByCurator;
  Timestamp? taskEndTimeByCurator;
  List<String> listOfImagesUploadedByCurator;
  List<String> listOfVideosUploadedByCurator;

  TaskModel({
    required this.taskRef,
    required this.assignedLMName,
    this.backupLmRef,
    required this.billingModel,
    required this.categoryTag,
    required this.createdAt,
    required this.createdBy,
    required this.isCockpitTaskCreated,
    required this.isDelayed,
    required this.isTaskDisabled,
    this.lmRef,
    required this.patronName, // Fixed Typo
    required this.patronAddress,
    this.patronRef,
    required this.priority,
    required this.refImage,
    required this.remarks,
    required this.selectedHomeCuratorDepartment,
    this.selectedHomeCuratorDepartmentRef,
    required this.taskAssignDate,
    required this.taskCategory,
    required this.taskDate,
    required this.taskDescription,
    required this.taskDueDate,
    required this.taskEndTime,
    required this.taskID,
    required this.taskOwner,
    required this.taskRecievedTime,
    required this.taskStartTime,
    required this.taskStatusCategory,
    required this.taskSubCategory,
    required this.taskSubject,

    // Newly Added Fields with Defaults
    this.curatorTaskStatus = "Pending",
    this.taskAssignedToCurator,
    this.assignedTimeSlot,
    this.taskPriceByAdmin = 0.0,
    this.taskDurationByAdmin = 0.0,
    this.taskStartTimeByCurator,
    this.taskEndTimeByCurator,
    this.listOfImagesUploadedByCurator = const [],
    this.listOfVideosUploadedByCurator = const [],
  });

  // Convert Firestore DocumentSnapshot to TaskModel
  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      taskRef: doc.id,
      assignedLMName: data['assignedLMName'] ?? '',
      backupLmRef: data['backupLmRef'] as DocumentReference?,
      billingModel: data['billingModel'] ?? '',
      categoryTag: data['categoryTag'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      createdBy: data['createdBy'] ?? '',
      isCockpitTaskCreated: data['isCockpitTaskCreated'] ?? false,
      isDelayed: data['isDelayed'] ?? false,
      isTaskDisabled: data['isTaskDisabled'] ?? false,
      lmRef: data['lmRef'] as DocumentReference?,
      patronName: data['patronName'] ?? '',
      patronAddress: data['patronAddress'] ?? '',
      patronRef: data['patronRef'] as DocumentReference?,
      priority: data['priority'] ?? '',
      refImage: data['refImage'] ?? '',
      remarks: data['remarks'] ?? '',
      selectedHomeCuratorDepartment:
          data['selectedHomeCuratorDepartment'] ?? '',
      selectedHomeCuratorDepartmentRef:
          data['selectedHomeCuratorDepartmentRef'] as DocumentReference?,
      taskAssignDate: data['taskAssignDate'] ?? Timestamp.now(),
      taskCategory: data['taskCategory'] ?? '',
      taskDate: data['taskDate'] ?? Timestamp.now(),
      taskDescription: data['taskDescription'] ?? '',
      taskDueDate: data['taskDueDate'] ?? Timestamp.now(),
      taskEndTime: data['taskEndTime'] ?? Timestamp.now(),
      taskID: data['taskID'] ?? '',
      taskOwner: data['taskOwner'] ?? '',
      taskRecievedTime: data['taskRecievedTime'] ?? '',
      taskStartTime: data['taskStartTime'] ?? Timestamp.now(),
      taskStatusCategory: data['taskStatusCategory'] ?? '',
      taskSubCategory: data['taskSubCategory'] ?? '',
      taskSubject: data['taskSubject'] ?? '',

      // Newly Added Fields with Null Safety
      curatorTaskStatus:
          data['curatorTaskStatus'] ?? 'Not accepted by any curator',
      taskAssignedToCurator: data['taskAssignedToCurator'] as String?,
      assignedTimeSlot: data['assignedTimeSlot'] as String? ?? "NA",

      taskPriceByAdmin: (data['taskPriceByAdmin'] ?? 0.0).toDouble(),
      taskDurationByAdmin: (data['taskDurationByAdmin'] ?? 0.0).toDouble(),
      taskStartTimeByCurator: data['taskStartTimeByCurator'],
      taskEndTimeByCurator: data['taskEndTimeByCurator'],
      listOfImagesUploadedByCurator: List<String>.from(
        data['listOfImagesUploadedByCurator'] ?? [],
      ),
      listOfVideosUploadedByCurator: List<String>.from(
        data['listOfVideosUploadedByCurator'] ?? [],
      ),
    );
  }

  // Convert TaskModel to Firestore Map
  Map<String, dynamic> toFirestore() {
    return {
      'assignedLMName': assignedLMName,
      'backupLmRef': backupLmRef,
      'billingModel': billingModel,
      'categoryTag': categoryTag,
      'createdAt': createdAt,
      'createdBy': createdBy,
      'isCockpitTaskCreated': isCockpitTaskCreated,
      'isDelayed': isDelayed,
      'isTaskDisabled': isTaskDisabled,
      'lmRef': lmRef,
      'patronName': patronName,
      'patronAddress': patronAddress,
      'patronRef': patronRef,
      'priority': priority,
      'refImage': refImage,
      'remarks': remarks,
      'selectedHomeCuratorDepartment': selectedHomeCuratorDepartment,
      'selectedHomeCuratorDepartmentRef': selectedHomeCuratorDepartmentRef,
      'taskAssignDate': taskAssignDate,
      'taskCategory': taskCategory,
      'taskDate': taskDate,
      'taskDescription': taskDescription,
      'taskDueDate': taskDueDate,
      'taskEndTime': taskEndTime,
      'taskID': taskID,
      'taskOwner': taskOwner,
      'taskRecievedTime': taskRecievedTime,
      'taskStartTime': taskStartTime,
      'taskStatusCategory': taskStatusCategory,
      'taskSubCategory': taskSubCategory,
      'taskSubject': taskSubject,

      // Newly Added Fields
      'curatorTaskStatus': curatorTaskStatus,
      'taskAssignedToCurator': taskAssignedToCurator,

      'taskPriceByAdmin': taskPriceByAdmin,
      'taskDurationByAdmin': taskDurationByAdmin,
      'taskStartTimeByCurator': taskStartTimeByCurator,
      'taskEndTimeByCurator': taskEndTimeByCurator,
      'listOfImagesUploadedByCurator': listOfImagesUploadedByCurator,
      'listOfVideosUploadedByCurator': listOfVideosUploadedByCurator,
    };
  }
}
