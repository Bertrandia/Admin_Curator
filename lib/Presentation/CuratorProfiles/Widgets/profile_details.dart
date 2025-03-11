import 'package:admin_curator/Models/profile.dart';
import 'package:admin_curator/Presentation/Widgets/global_btn.dart';
import 'package:admin_curator/Providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileDetailsPage extends ConsumerWidget {
  final CuratorModel curatorModel;
  const ProfileDetailsPage({super.key, required this.curatorModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileNotifier = ref.read(profileProvider.notifier);
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          if (curatorModel.isVerified == false)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 150,
                  child: GlobalButton(
                    text: "Accept",
                    onPressed: () async {
                      await profileNotifier.updateVerificationStatus(
                        consultantId: curatorModel.id,
                        isVerified: true,
                        isRejected: false,
                      );
                      Navigator.pop(context);
                    },
                    height: 35,
                    isOutlined: true,
                  ),
                ),
                const SizedBox(width: 5),
                SizedBox(
                  width: 150,
                  child: GlobalButton(
                    text: "Reject",
                    onPressed: () async {
                      await profileNotifier.updateVerificationStatus(
                        consultantId: curatorModel.id,
                        isVerified: false,
                        isRejected: true,
                      );
                      Navigator.pop(context);
                    },
                    height: 35,
                  ),
                ),
              ],
            ),
          // Personal Information
          sectionHeader("Personal Information"),
          personalInfoRow(
            "Full Name",
            '${curatorModel.profile!.firstName} ${curatorModel.profile!.lastName}',
          ),
          personalInfoRow("Gender", curatorModel.profile!.gender),
          personalInfoRow("Nationality", curatorModel.profile!.nationality),
          personalInfoRow("Date of Birth", curatorModel.profile!.dob),
          personalInfoRow("Email ID", curatorModel.profile!.email),
          personalInfoRow(
            "Contact Number",
            curatorModel.profile!.contactNumber,
          ),

          const SizedBox(height: 20),

          // Location
          sectionHeader("Location"),
          personalInfoRow(
            "Address",
            "${curatorModel.profile!.addressLine1} ${curatorModel.profile!.addressLine2}",
          ),
          personalInfoRow("District", curatorModel.profile!.district),
          personalInfoRow("State", curatorModel.profile!.state),
          personalInfoRow("Pincode", curatorModel.profile!.pincode),
          personalInfoRow("Landline Number", curatorModel.profile!.landline),

          const SizedBox(height: 20),

          // Identification
          sectionHeader("Identification"),
          personalInfoRow("Aadhaar Number", curatorModel.profile!.aadhar),
          personalInfoRow("PAN Number", curatorModel.profile!.pan),
          // infoText("📄 Goibibo Completion Certificate"),
          // infoText("📄 Radhika Dua Resume.pdf"),
          // infoText("📄 Letter of Recommendation - Steven Hick"),

          const SizedBox(height: 20),

          // Higher Education
          sectionHeader("Higher Education"),
          ...curatorModel.profile!.higherEducation.map(
            (edu) => personalInfoRow(edu.institute, edu.degree),
          ),

          const SizedBox(height: 20),

          // Work Experience
          sectionHeader("Work Experience"),
          ...curatorModel.profile!.workExperience.map(
            (work) => personalInfoRow(work.organization, work.role),
          ),

          personalInfoRow(
            "Department of Interest",
            curatorModel.profile!.departmentInterested,
          ),

          const SizedBox(height: 20),

          // Skills
          sectionHeader("Skills"),
          ...curatorModel.profile!.selectedSkills.map(
            (skill) => infoText("• $skill"),
          ),

          const SizedBox(height: 20),

          // Availability
          sectionHeader("Availability"),
          personalInfoRow(
            "Date of Availability",
            curatorModel.profile!.dateOfAvailability,
          ),
        ],
      ),
    );
  }

  /// Widget for section titles
  Widget sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.brown,
      ),
    );
  }

  /// Widget for general information text
  Widget infoText(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Text(
        text,
        style: const TextStyle(fontSize: 17, color: Colors.black87),
      ),
    );
  }

  /// Widget for section headers
  Widget sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.brown,
        ),
      ),
    );
  }

  /// Widget for displaying personal info in two columns
  Widget personalInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
