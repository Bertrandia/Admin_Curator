import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String city;
  // final DateTime createdTime;
  final String currentStatus;
  final List<String> department;
  final String designation;
  final String displayName;
  //  final DateTime dob;
  final String email;
  // final DateTime hiringDate;
  final bool isCRMAdmin;
  final bool isDev;
  final bool isHomeDecorEnabled;
  final bool isLM;
  final bool isLeaveQuotaOn;
  final bool isNonUser;
  final bool isVolopayDetailsAdded;
  final String leaveStatus;
  final String level;
  final String newDepartment;
  final String password;
  final String phoneNumber;
  final String photoUrl;
  final String position;
  final String reportingManager;
  final String role;
  final int serialNo;
  final String uid;
  final String volopayCardHolderName;
  final String volopayCardNumber;

  UserModel({
    required this.city,
    //   required this.createdTime,
    required this.currentStatus,
    required this.department,
    required this.designation,
    required this.displayName,
    //  required this.dob,
    required this.email,
    //  required this.hiringDate,
    required this.isCRMAdmin,
    required this.isDev,
    required this.isHomeDecorEnabled,
    required this.isLM,
    required this.isLeaveQuotaOn,
    required this.isNonUser,
    required this.isVolopayDetailsAdded,
    required this.leaveStatus,
    required this.level,
    required this.newDepartment,
    required this.password,
    required this.phoneNumber,
    required this.photoUrl,
    required this.position,
    required this.reportingManager,
    required this.role,
    required this.serialNo,
    required this.uid,
    required this.volopayCardHolderName,
    required this.volopayCardNumber,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      city: map['city'] ?? '',
      //  createdTime:
      //      (map['created_time'] as Timestamp).toDate() ?? DateTime.now(),
      currentStatus: map['currentStatus'] ?? '',
      department: List<String>.from(map['department'] ?? []),
      designation: map['designation'] ?? '',
      displayName: map['display_name'] ?? '',
      //    dob: (map['dob'] as Timestamp).toDate() ?? DateTime.now(),
      email: map['email'] ?? '',
      //    hiringDate: (map['hiringDate'] as Timestamp).toDate() ?? DateTime.now(),
      isCRMAdmin: map['isCRMAdmin'] ?? false,
      isDev: map['isDev'] ?? false,
      isHomeDecorEnabled: map['isHomeDecorEnabled'] ?? false,
      isLM: map['isLM'] ?? false,
      isLeaveQuotaOn: map['isLeaveQuotaOn'] ?? false,
      isNonUser: map['isNonUser'] ?? false,
      isVolopayDetailsAdded: map['isVolopayDetailsAdded'] ?? false,
      leaveStatus: map['leaveStatus'] ?? '',
      level: map['level'] ?? '',
      newDepartment: map['newDepartment'] ?? '',
      password: map['password'] ?? '',
      phoneNumber: map['phone_number'] ?? '',
      photoUrl: map['photo_url'] ?? '',
      position: map['position'] ?? '',
      reportingManager: map['reportingManager'] ?? '',
      role: map['role'] ?? '',
      serialNo: map['serialNo'] ?? 0,
      uid: map['uid'] ?? '',
      volopayCardHolderName: map['volopayCardHolderName'] ?? '',
      volopayCardNumber: map['volopayCardNumber'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'city': city,
      // 'created_time': Timestamp.fromDate(createdTime),
      'currentStatus': currentStatus,
      'department': department,
      'designation': designation,
      'display_name': displayName,
      //  'dob': Timestamp.fromDate(dob),
      'email': email,
      //   'hiringDate': Timestamp.fromDate(hiringDate),
      'isCRMAdmin': isCRMAdmin,
      'isDev': isDev,
      'isHomeDecorEnabled': isHomeDecorEnabled,
      'isLM': isLM,
      'isLeaveQuotaOn': isLeaveQuotaOn,
      'isNonUser': isNonUser,
      'isVolopayDetailsAdded': isVolopayDetailsAdded,
      'leaveStatus': leaveStatus,
      'level': level,
      'newDepartment': newDepartment,
      'password': password,
      'phone_number': phoneNumber,
      'photo_url': photoUrl,
      'position': position,
      'reportingManager': reportingManager,
      'role': role,
      'serialNo': serialNo,
      'uid': uid,
      'volopayCardHolderName': volopayCardHolderName,
      'volopayCardNumber': volopayCardNumber,
    };
  }
}
