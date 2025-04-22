import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  DocumentReference? taskDocRef;
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
  List<TransferredTaskModel?>? transferredTasks;
  String? locationMode;
  bool isAdminApproved;
  bool? isTaskBillCreated;

  TaskModel({
    this.taskDocRef,
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
    this.locationMode,
    this.isAdminApproved = false,
    this.transferredTasks,
    this.isTaskBillCreated,
  });

  // Convert Firestore DocumentSnapshot to TaskModel
  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      taskDocRef: doc.reference,
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
      patronName: data['partonName'] ?? '',
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
      locationMode: data['locationMode'] ?? 'Not available',
      isAdminApproved: data['isAdminApproved'] ?? false,
      transferredTasks:
          (data['listOfTaskTransferred'] as List<dynamic>? ?? [])
              .map(
                (item) => TransferredTaskModel.fromMap(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList(),
      isTaskBillCreated: data['isTaskBillCreated'] ?? false,
    );
  }

  // Convert TaskModel to Firestore Map
  Map<String, dynamic> toFirestore() {
    return {
      'taskDocRef': taskDocRef,
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
      'locationMode': locationMode,
      'listOfTaskTransferred':
          transferredTasks?.map((e) => e?.toMap()).toList(),
    };
  }

  Map<String, dynamic> toJson() => {
    'taskRef': taskRef,
    'assignedLMName': assignedLMName,
    'billingModel': billingModel,
    'categoryTag': categoryTag,
    'createdAt': createdAt.millisecondsSinceEpoch,
    'createdBy': createdBy,
    'isCockpitTaskCreated': isCockpitTaskCreated,
    'isDelayed': isDelayed,
    'isTaskDisabled': isTaskDisabled,
    'patronName': patronName,
    'patronAddress': patronAddress,
    'priority': priority,
    'refImage': refImage,
    'remarks': remarks,
    'selectedHomeCuratorDepartment': selectedHomeCuratorDepartment,
    'taskAssignDate': taskAssignDate.millisecondsSinceEpoch,
    'taskCategory': taskCategory,
    'taskDate': taskDate.millisecondsSinceEpoch,
    'taskDescription': taskDescription,
    'taskDueDate': taskDueDate.millisecondsSinceEpoch,
    'taskEndTime': taskEndTime.millisecondsSinceEpoch,
    'taskID': taskID,
    'taskOwner': taskOwner,
    'taskRecievedTime': taskRecievedTime,
    'taskStartTime': taskStartTime.millisecondsSinceEpoch,
    'taskStatusCategory': taskStatusCategory,
    'taskSubCategory': taskSubCategory,
    'taskSubject': taskSubject,
    'curatorTaskStatus': curatorTaskStatus,
    'taskAssignedToCurator': taskAssignedToCurator,
    'assignedTimeSlot': assignedTimeSlot,
    'taskPriceByAdmin': taskPriceByAdmin,
    'taskDurationByAdmin': taskDurationByAdmin,
    'taskStartTimeByCurator': taskStartTimeByCurator?.millisecondsSinceEpoch,
    'taskEndTimeByCurator': taskEndTimeByCurator?.millisecondsSinceEpoch,
    'listOfImagesUploadedByCurator': listOfImagesUploadedByCurator,
    'listOfVideosUploadedByCurator': listOfVideosUploadedByCurator,
    'locationMode': locationMode,
    'isAdminApproved': isAdminApproved,
    'transferredTasks': transferredTasks?.map((e) => e?.toJson()).toList(),
  };

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      taskRef: json['taskRef'],
      assignedLMName: json['assignedLMName'],
      billingModel: json['billingModel'],
      categoryTag: json['categoryTag'],
      createdAt: Timestamp.fromMillisecondsSinceEpoch(json['createdAt']),
      createdBy: json['createdBy'],
      isCockpitTaskCreated: json['isCockpitTaskCreated'],
      isDelayed: json['isDelayed'],
      isTaskDisabled: json['isTaskDisabled'],
      patronName: json['patronName'],
      patronAddress: json['patronAddress'],
      priority: json['priority'],
      refImage: json['refImage'],
      remarks: json['remarks'],
      selectedHomeCuratorDepartment: json['selectedHomeCuratorDepartment'],
      taskAssignDate: Timestamp.fromMillisecondsSinceEpoch(
        json['taskAssignDate'],
      ),
      taskCategory: json['taskCategory'],
      taskDate: Timestamp.fromMillisecondsSinceEpoch(json['taskDate']),
      taskDescription: json['taskDescription'],
      taskDueDate: Timestamp.fromMillisecondsSinceEpoch(json['taskDueDate']),
      taskEndTime: Timestamp.fromMillisecondsSinceEpoch(json['taskEndTime']),
      taskID: json['taskID'],
      taskOwner: json['taskOwner'],
      taskRecievedTime: json['taskRecievedTime'],
      taskStartTime: Timestamp.fromMillisecondsSinceEpoch(
        json['taskStartTime'],
      ),
      taskStatusCategory: json['taskStatusCategory'],
      taskSubCategory: json['taskSubCategory'],
      taskSubject: json['taskSubject'],
      curatorTaskStatus: json['curatorTaskStatus'],
      taskAssignedToCurator: json['taskAssignedToCurator'],
      assignedTimeSlot: json['assignedTimeSlot'],
      taskPriceByAdmin: (json['taskPriceByAdmin'] ?? 0.0).toDouble(),
      taskDurationByAdmin: (json['taskDurationByAdmin'] ?? 0.0).toDouble(),
      taskStartTimeByCurator:
          json['taskStartTimeByCurator'] != null
              ? Timestamp.fromMillisecondsSinceEpoch(
                json['taskStartTimeByCurator'],
              )
              : null,
      taskEndTimeByCurator:
          json['taskEndTimeByCurator'] != null
              ? Timestamp.fromMillisecondsSinceEpoch(
                json['taskEndTimeByCurator'],
              )
              : null,
      listOfImagesUploadedByCurator: List<String>.from(
        json['listOfImagesUploadedByCurator'] ?? [],
      ),
      listOfVideosUploadedByCurator: List<String>.from(
        json['listOfVideosUploadedByCurator'] ?? [],
      ),
      locationMode: json['locationMode'],
      isAdminApproved: json['isAdminApproved'] ?? false,
      transferredTasks:
          (json['transferredTasks'] as List<dynamic>?)
              ?.map((item) => TransferredTaskModel.fromJson(item))
              .toList(),
    );
  }
}

class TransferredTaskModel {
  final String docID;
  final String name;
  final String reason;
  final DocumentReference ref;
  final Timestamp rejectedAt;

  TransferredTaskModel({
    required this.docID,
    required this.name,
    required this.reason,
    required this.ref,
    required this.rejectedAt,
  });

  factory TransferredTaskModel.fromMap(Map<String, dynamic> data) {
    return TransferredTaskModel(
      docID: data['docID'] ?? '',
      name: data['name'] ?? '',
      reason: data['reason'] ?? '',
      ref: data['ref'] as DocumentReference,
      rejectedAt: data['rejectedAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'docID': docID,
      'name': name,
      'reason': reason,
      'ref': ref,
      'rejectedAt': rejectedAt,
    };
  }

  Map<String, dynamic> toJson() => {
    'docID': docID,
    'name': name,
    'reason': reason,
    'rejectedAt': rejectedAt.millisecondsSinceEpoch,
    'refPath': ref.path, // serialize path instead of DocumentReference
  };

  factory TransferredTaskModel.fromJson(Map<String, dynamic> json) {
    return TransferredTaskModel(
      docID: json['docID'],
      name: json['name'],
      reason: json['reason'],
      ref: FirebaseFirestore.instance.doc(json['refPath']),
      rejectedAt: Timestamp.fromMillisecondsSinceEpoch(json['rejectedAt']),
    );
  }
}
