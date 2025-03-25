import 'package:cloud_firestore/cloud_firestore.dart';

class PatronModel {
  final String addressLine1;
  final String addressLine2;
  final String assignedLM;
  final String backupLmName;
  final DocumentReference? backupLmRef;
  final String bannerImage;
  final String billingAddress;
  final String billingName;
  final String carryOnAccessories;
  final String city;
  final String clientCode;
  final List<String> communicationMode;
  final String country;
  final Timestamp createdAt;
  final List<String> culturalChoices;
  final List<String> dietaryConditions;
  final String email1;
  final String email2;
  final List<String> fastingPref;
  final String favCousine;
  final String gadgetsndTech;
  final String gender;
  final String hobbies;
  final String interests;
  final String landmark;
  final DocumentReference? lmRef;
  final String maritalStatus;
  final String mealFreq;
  final List<String> meatPref;
  final String mobileNumber1;
  final String mobileNumber2;
  final String occupation;
  final Timestamp onBoardingDate;
  final String opBillingAddress;
  final String operationCity;
  final String patronBusinessID;
  final String patronFirstName;
  final Timestamp patronJoiningDate;
  final String patronLastName;
  final String patronMiddleName;
  final String patronName;
  final String patronStatus;
  final String patronType;
  final int pinCode;
  final String prefAirlines;
  final String prefBrands;
  final String prefTravelComp;
  final String profileImage;
  final String serviceType;
  final String shortDescription;
  final String state;
  final List<String> styleChoice;
  final String travelStyle;
  final List<String> vacationDestinations;
  final String wearableAccessories;
  final String whatsAppNumber;

  PatronModel({
    required this.addressLine1,
    required this.addressLine2,
    required this.assignedLM,
    required this.backupLmName,
    required this.backupLmRef,
    required this.bannerImage,
    required this.billingAddress,
    required this.billingName,
    required this.carryOnAccessories,
    required this.city,
    required this.clientCode,
    required this.communicationMode,
    required this.country,
    required this.createdAt,
    required this.culturalChoices,
    required this.dietaryConditions,
    required this.email1,
    required this.email2,
    required this.fastingPref,
    required this.favCousine,
    required this.gadgetsndTech,
    required this.gender,
    required this.hobbies,
    required this.interests,
    required this.landmark,
    required this.lmRef,
    required this.maritalStatus,
    required this.mealFreq,
    required this.meatPref,
    required this.mobileNumber1,
    required this.mobileNumber2,
    required this.occupation,
    required this.onBoardingDate,
    required this.opBillingAddress,
    required this.operationCity,
    required this.patronBusinessID,
    required this.patronFirstName,
    required this.patronJoiningDate,
    required this.patronLastName,
    required this.patronMiddleName,
    required this.patronName,
    required this.patronStatus,
    required this.patronType,
    required this.pinCode,
    required this.prefAirlines,
    required this.prefBrands,
    required this.prefTravelComp,
    required this.profileImage,
    required this.serviceType,
    required this.shortDescription,
    required this.state,
    required this.styleChoice,
    required this.travelStyle,
    required this.vacationDestinations,
    required this.wearableAccessories,
    required this.whatsAppNumber,
  });

  factory PatronModel.fromJson(Map<String, dynamic> json) {
    return PatronModel(
      addressLine1: json['addressLine1'] ?? '',
      addressLine2: json['addressLine2'] ?? '',
      assignedLM: json['assignedLM'] ?? '',
      backupLmName: json['backupLmName'] ?? '',
      backupLmRef: json['backupLmRef'],
      bannerImage: json['bannerImage'] ?? '',
      billingAddress: json['billingAddress'] ?? '',
      billingName: json['billingName'] ?? '',
      carryOnAccessories: json['carryOnAccessories'] ?? '',
      city: json['city'] ?? '',
      clientCode: json['clientCode'] ?? '',
      communicationMode: List<String>.from(json['communicationMode'] ?? []),
      country: json['country'] ?? '',
      createdAt: json['createdAt'] ?? Timestamp.now(),
      culturalChoices: List<String>.from(json['culturalChoices'] ?? []),
      dietaryConditions: List<String>.from(json['dietaryConditions'] ?? []),
      email1: json['email1'] ?? '',
      email2: json['email2'] ?? '',
      fastingPref: List<String>.from(json['fastingPref'] ?? []),
      favCousine: json['favCousine'] ?? '',
      gadgetsndTech: json['gadgetsndTech'] ?? '',
      gender: json['gender'] ?? '',
      hobbies: json['hobbies'] ?? '',
      interests: json['interests'] ?? '',
      landmark: json['landmark'] ?? '',
      lmRef: json['lmRef'],
      maritalStatus: json['maritalStatus'] ?? '',
      mealFreq: json['mealFreq'] ?? '',
      meatPref: List<String>.from(json['meatPref'] ?? []),
      mobileNumber1: json['mobile_number1'] ?? '',
      mobileNumber2: json['mobile_number2'] ?? '',
      occupation: json['occupation'] ?? '',
      onBoardingDate: json['onBoardingDate'] ?? Timestamp.now(),
      opBillingAddress: json['opBillingAddress'] ?? '',
      operationCity: json['operationCity'] ?? '',
      patronBusinessID: json['patronBusinessID'] ?? '',
      patronFirstName: json['patronFirstName'] ?? '',
      patronJoiningDate: json['patronJoiningDate'] ?? Timestamp.now(),
      patronLastName: json['patronLastName'] ?? '',
      patronMiddleName: json['patronMiddleName'] ?? '',
      patronName: json['patronName'] ?? '',
      patronStatus: json['patronStatus'] ?? '',
      patronType: json['patronType'] ?? '',
      pinCode: json['pinCode'] ?? 0,
      prefAirlines: json['prefAirlines'] ?? '',
      prefBrands: json['prefBrands'] ?? '',
      prefTravelComp: json['prefTravelComp'] ?? '',
      profileImage: json['profileImage'] ?? '',
      serviceType: json['serviceType'] ?? '',
      shortDescription: json['shortDescription'] ?? '',
      state: json['state'] ?? '',
      styleChoice: List<String>.from(json['styleChoice'] ?? []),
      travelStyle: json['travelStyle'] ?? '',
      vacationDestinations: List<String>.from(
        json['vacationDestinations'] ?? [],
      ),
      wearableAccessories: json['wearableAccessories'] ?? '',
      whatsAppNumber: json['whatsAppNumber'] ?? '',
    );
  }
}
