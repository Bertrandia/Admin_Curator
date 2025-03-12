class CuratorModel {
  final String id;
  final String fullName;
  final String email;
  final String password;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool status;

  final bool isProfileCompleted;
  final bool isVerified;
  final ProfileData? profile;

  CuratorModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.password,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.isVerified,
    this.profile,
    required this.isProfileCompleted,
  });

  /// Convert Model to Firestore Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'password': password,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'status': status,

      'isVerified': isVerified,
      'profile': profile?.toMap(), // Ensure proper serialization
      'isProfileCompleted': isProfileCompleted,
    };
  }

  /// Convert Firestore Map to Model
  factory CuratorModel.fromJson(Map<String, dynamic> json) {
    return CuratorModel(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      status: json['status'] as bool,
      isVerified: json['isVerified'] as bool,
      isProfileCompleted: json['isProfileCompleted'] as bool,
      profile:
          json['profile'] != null ? ProfileData.fromMap(json['profile']) : null,
    );
  }

  /// CopyWith Method for Immutability
  CuratorModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? password,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? status,
    bool? isRejected,
    bool? isVerified,
    bool? isProfileCompleted,
    ProfileData? profile,
  }) {
    return CuratorModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,

      isVerified: isVerified ?? this.isVerified,
      isProfileCompleted: isProfileCompleted ?? this.isProfileCompleted,
      profile: profile ?? this.profile,
    );
  }
}

class ProfileData {
  final String profileImage;
  final String firstName;
  final String lastName;
  final String email;
  final String contactNumber;
  final String dob;
  final String gender;
  final String nationality;
  final String addressLine1;
  final String addressLine2;
  final String state;
  final String district;
  final String pincode;
  final String landline;
  final String aadhar;
  final String pan;
  final List<String> listOfDocs;
  final List<Education> higherEducation;
  final List<WorkExp> workExperience;
  final List<ImagesWithTitle> imagesWithTitle;
  final String departmentInterested;
  final List<String> selectedSkills;
  final String dateOfAvailability;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProfileData({
    required this.profileImage,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.contactNumber,
    required this.dob,
    required this.gender,
    required this.nationality,
    required this.addressLine1,
    required this.addressLine2,
    required this.state,
    required this.district,
    required this.pincode,
    required this.landline,
    required this.aadhar,
    required this.pan,
    required this.listOfDocs,
    required this.higherEducation,
    required this.workExperience,
    required this.departmentInterested,
    required this.selectedSkills,
    required this.dateOfAvailability,
    required this.imagesWithTitle,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convert Model to Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'profileImage': profileImage,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'contactNumber': contactNumber,
      'dob': dob,
      'gender': gender,
      'nationality': nationality,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'state': state,
      'district': district,
      'pincode': pincode,
      'landline': landline,
      'aadhar': aadhar,
      'pan': pan,
      'listOfDocs': listOfDocs,
      'higherEducation': higherEducation.map((e) => e.toMap()).toList(),
      'workExperience': workExperience.map((e) => e.toMap()).toList(),
      'imagesWithTitle': imagesWithTitle.map((e) => e.toMap()).toList(),
      'departmentInterested': departmentInterested,
      'selectedSkills': selectedSkills,
      'dateOfAvailability': dateOfAvailability,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Convert Firestore Map to Model
  factory ProfileData.fromMap(Map<String, dynamic> map) {
    return ProfileData(
      profileImage: map['profileImage'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      contactNumber: map['contactNumber'] ?? '',
      dob: map['dob'] ?? '',
      gender: map['gender'] ?? '',
      nationality: map['nationality'] ?? '',
      addressLine1: map['addressLine1'] ?? '',
      addressLine2: map['addressLine2'] ?? '',
      state: map['state'] ?? '',
      district: map['district'] ?? '',
      pincode: map['pincode'] ?? '',
      landline: map['landline'] ?? '',
      aadhar: map['aadhar'] ?? '',
      pan: map['pan'] ?? '',
      listOfDocs: List<String>.from(map['listOfDocs'] ?? []),
      imagesWithTitle:
          (map['imagesWithTitle'] as List<dynamic>?)
              ?.map((e) => ImagesWithTitle.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      higherEducation:
          (map['higherEducation'] as List<dynamic>?)
              ?.map((e) => Education.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      workExperience:
          (map['workExperience'] as List<dynamic>?)
              ?.map((e) => WorkExp.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      departmentInterested: map['departmentInterested'] ?? '',
      selectedSkills: List<String>.from(map['selectedSkills'] ?? []),
      dateOfAvailability: map['dateOfAvailability'] ?? '',
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }
}

class Education {
  final String institute;
  final String degree;

  Education({required this.institute, required this.degree});

  Map<String, dynamic> toMap() {
    return {'institute': institute, 'degree': degree};
  }

  factory Education.fromMap(Map<String, dynamic> map) {
    return Education(
      institute: map['institute'] ?? '',
      degree: map['degree'] ?? '',
    );
  }
}

class WorkExp {
  final String organization;
  final String role;

  WorkExp({required this.organization, required this.role});

  Map<String, dynamic> toMap() {
    return {'organization': organization, 'role': role};
  }

  factory WorkExp.fromMap(Map<String, dynamic> map) {
    return WorkExp(
      organization: map['organization'] ?? '',
      role: map['role'] ?? '',
    );
  }
}

class ImagesWithTitle {
  final String imageUrl;
  final String imageTitle;

  ImagesWithTitle({required this.imageUrl, required this.imageTitle});

  Map<String, dynamic> toMap() {
    return {'imageUrl': imageUrl, 'imageTitle': imageTitle};
  }

  factory ImagesWithTitle.fromMap(Map<String, dynamic> map) {
    return ImagesWithTitle(
      imageUrl: map['imageUrl'] ?? "",
      imageTitle: map['imageTitle'] ?? "",
    );
  }
}
