import 'package:admin_curator/Models/profile.dart';
import 'package:admin_curator/Presentation/CuratorProfiles/Widgets/rejectionRandomSheet.dart';
import 'package:admin_curator/Presentation/Widgets/global_btn.dart';
import 'package:admin_curator/Providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileDetailsPage extends ConsumerWidget {
  final CuratorModel curatorModel;
  const ProfileDetailsPage({super.key, required this.curatorModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileNotifier = ref.read(profileProvider.notifier);
    final authState = ref.watch(authNotifierProvider);
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
                    // onPressed: () async {
                    onPressed: () {
                      final String userEmail =
                          authState.user!.email ??
                          "Unknown User"; // Fetch logged-in user's email
                      // showModalBottomSheet(
                      //   context: context,
                      //   isScrollControlled: true,
                      //   builder:
                      //       (context) => RejectionBottomSheet(
                      //         consultantId: curatorModel.id,
                      //         profileNotifier: profileNotifier,
                      //         userEmail: userEmail,
                      //       ),
                      // );
                      showDialog(
                        context: context,
                        builder:
                            (context) => RejectionDialog(
                              consultantId: curatorModel.id,
                              profileNotifier: profileNotifier,
                              userEmail: userEmail,
                            ),
                      );
                    },
                    height: 35,
                  ),
                ),
              ],
            ),
          // Personal Information
          Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back_ios),
              ),
              SizedBox(width: 10),
              sectionHeader("Personal Information", true),
            ],
          ),
          SizedBox(height: 10),
          Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor:
                      Colors.grey[300], // Optional: Background color
                  child: ClipOval(
                    child: Image.network(
                      curatorModel.profile!.profileImage ??
                          'https://via.placeholder.com/150',
                      width: 120,
                      height: 120,
                      fit:
                          BoxFit
                              .cover, // Ensures the image fills the circle without stretching
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.grey[600],
                        );
                      },
                    ),
                  ),
                ),
              ),
              Visibility(
                visible:
                    curatorModel.profile?.curatorAgreementUrl != '' ||
                    curatorModel.profile?.curatorAgreementUrl != null,
                child: GlobalButton(
                  text: 'View Agreement',
                  onPressed: () async {
                    await openUrlInNewTab(
                      curatorModel.profile!.curatorAgreementUrl,
                    );
                  },
                ),
              ),
            ],
          ),

          SizedBox(height: 10),
          personalInfoRow(
            "Full Name",
            '${curatorModel.profile!.firstName} ${curatorModel.profile!.lastName}',
          ),
          personalInfoRow("Nationality:", curatorModel.profile!.nationality),
          personalInfoRow("Date of Birth:", curatorModel.profile!.dob),
          personalInfoRow("Email ID:", curatorModel.profile!.email),
          personalInfoRow(
            "Contact Number:",
            curatorModel.profile!.contactNumber,
          ),
          personalInfoRow("About:", curatorModel.profile!.aboutSelf),

          const SizedBox(height: 20),

          // Location
          sectionHeader('Bank Details', false),
          personalInfoRow(
            'Bank Name:',
            curatorModel.profile?.bankAccountDetails?.bankName ?? 'NA',
          ),
          personalInfoRow(
            'Account Holder Name:',
            curatorModel.profile?.bankAccountDetails?.accountHolderName ?? 'NA',
          ),
          personalInfoRow(
            'Account Number:',
            curatorModel.profile?.bankAccountDetails?.accountNumber ?? 'NA',
          ),
          personalInfoRow(
            'Account Type:',
            curatorModel.profile?.bankAccountDetails?.accountType ?? 'NA',
          ),
          personalInfoRow(
            'IFSC code:',
            curatorModel.profile?.bankAccountDetails?.ifscCode ?? 'NA',
          ),
          SizedBox(height: 20),
          sectionHeader("Location:", false),
          personalInfoRow(
            "Address",
            "${curatorModel.profile!.addressLine1} ${curatorModel.profile!.addressLine2}",
          ),
          personalInfoRow("District:", curatorModel.profile!.district),
          personalInfoRow("State:", curatorModel.profile!.state),
          personalInfoRow("Pincode:", curatorModel.profile!.pincode),

          const SizedBox(height: 20),

          // Identification
          sectionHeader("Identification", false),
          personalInfoRow("Aadhaar Number:", curatorModel.profile!.aadhar),
          personalInfoRow("PAN Number:", curatorModel.profile!.pan),

          // infoText("📄 Goibibo Completion Certificate"),
          // infoText("📄 Radhika Dua Resume.pdf"),
          // infoText("📄 Letter of Recommendation - Steven Hick"),
          const SizedBox(height: 20),

          // Higher Education
          sectionHeader("Higher Education", false),
          ...curatorModel.profile!.higherEducation.map(
            (edu) => personalInfoRow(edu.institute, edu.degree),
          ),

          const SizedBox(height: 20),

          // Work Experience
          sectionHeader("Work Experience", false),
          ...curatorModel.profile!.workExperience.map(
            (work) => personalInfoRow(work.organization, work.role),
          ),

          personalInfoRow(
            "Dept. of Interest:",
            curatorModel.profile!.departmentInterested,
          ),

          const SizedBox(height: 20),

          // Skills
          sectionHeader("Skills", false),
          ...curatorModel.profile!.selectedSkills.map(
            (skill) => infoText("• $skill"),
          ),

          const SizedBox(height: 20),

          // Availability
          sectionHeader("Availability", false),
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
  Widget sectionHeader(String title, bool isMainHeader) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
          ),
        ),
      ],
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

  Future<void> openUrlInNewTab(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
