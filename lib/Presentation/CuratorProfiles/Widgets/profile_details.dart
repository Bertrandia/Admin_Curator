import 'package:admin_curator/Constants/URls.dart';
import 'package:admin_curator/Constants/app_styles.dart';
import 'package:admin_curator/Models/profile.dart';
import 'package:admin_curator/Presentation/CuratorProfiles/Widgets/rejectionRandomSheet.dart';
import 'package:admin_curator/Presentation/Widgets/global_btn.dart';
import 'package:admin_curator/Providers/providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../Constants/app_colors.dart';

class ProfileDetailsPage extends ConsumerStatefulWidget {
  final CuratorModel curatorModel;
  const ProfileDetailsPage({super.key, required this.curatorModel});

  @override
  _ProfileDetailsPageState createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends ConsumerState<ProfileDetailsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      final referenceProfile = FirebaseFirestore.instance
          .collection('Consultants')
          .doc(widget.curatorModel.id);

      ref
          .read(profileProvider.notifier)
          .getCuratorByReference(referenceProfile);
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileNotifier = ref.read(profileProvider.notifier);
    final authState = ref.watch(authNotifierProvider);
    final profileState = ref.watch(profileProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          if (widget.curatorModel.isVerified == false)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 150,
                  child: GlobalButton(
                    text: "Accept",
                    onPressed: () async {
                      await profileNotifier.updateVerificationStatus(
                        consultantId: widget.curatorModel.id,
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
                    onPressed: () {
                      final String userEmail =
                          authState.user?.email ?? "Unknown User";

                      showDialog(
                        context: context,
                        builder:
                            (context) => RejectionDialog(
                              consultantId: widget.curatorModel.id,
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
          if (widget.curatorModel.isVerified == true)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (profileState.singleProfile?.status == true) {
                      ref
                          .read(profileProvider.notifier)
                          .updateCuratorActiveDeactive(
                            curatorId: widget.curatorModel.id,
                            status: false,
                          );
                    } else {
                      ref
                          .read(profileProvider.notifier)
                          .updateCuratorActiveDeactive(
                            curatorId: widget.curatorModel.id,
                            status: true,
                          );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.secondary,
                    elevation: 2,
                  ),
                  child: Text(
                    profileState.singleProfile?.status == true
                        ? 'Deactivate'
                        : 'Activate',
                    style: AppStyles.style20.copyWith(
                      color: AppColors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          Row(
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios),
              ),
              const SizedBox(width: 10),
              sectionHeader("Personal Information", true),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[300],
                child: ClipOval(
                  child: Image.network(
                    widget.curatorModel.profile!.profileImage ??
                        'https://via.placeholder.com/150',
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
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
              const SizedBox(width: 10),
              if (widget.curatorModel.profile?.curatorAgreementUrl != null &&
                  widget.curatorModel.profile!.curatorAgreementUrl!.isNotEmpty)
                GlobalButton(
                  text: "View Agreement",
                  onPressed: () async {
                    URL().openUrlInNewTab(
                      widget.curatorModel.profile!.curatorAgreementUrl,
                      '_blank',
                    );
                    // await _loadPdf();
                    // if (pdfBytes != null) {
                    //   Navigator.of(context).push(
                    //     MaterialPageRoute(
                    //       builder:
                    //           (context) => WebPdfViewer(
                    //             pdfBytes: pdfBytes,
                    //             fileName: "Curator_Agreement.pdf",
                    //           ),
                    //     ),
                    //   );
                    // }
                  },
                ),
            ],
          ),
          const SizedBox(height: 10),
          personalInfoRow(
            "Full Name",
            '${widget.curatorModel.profile!.firstName} ${widget.curatorModel.profile!.lastName}',
          ),
          personalInfoRow(
            "Nationality:",
            widget.curatorModel.profile!.nationality,
          ),
          personalInfoRow("Date of Birth:", widget.curatorModel.profile!.dob),
          personalInfoRow("Email ID:", widget.curatorModel.profile!.email),
          personalInfoRow(
            "Contact Number:",
            widget.curatorModel.profile!.contactNumber,
          ),
          personalInfoRow("About:", widget.curatorModel.profile!.aboutSelf),

          const SizedBox(height: 20),
          personalInfoRow(
            'Location Mode',
            widget.curatorModel.profile?.travelPreference ?? "NA",
          ),
          const SizedBox(height: 20),
          personalSkillSetRow(
            'Slots available',
            widget.curatorModel.profile?.availabilitySlots ?? [],
          ),
          SizedBox(height: 20),

          sectionHeader('Skills', false),
          personalSkillSetRow(
            'Skillset',
            widget.curatorModel.profile?.selectedSkills ?? ['NA'],
          ),
          sectionHeader("Location", false),
          personalInfoRow(
            "Address",
            "${widget.curatorModel.profile!.addressLine1} ${widget.curatorModel.profile!.addressLine2}",
          ),
          personalInfoRow("District:", widget.curatorModel.profile!.district),
          personalInfoRow("State:", widget.curatorModel.profile!.state),
          personalInfoRow("Pincode:", widget.curatorModel.profile!.pincode),

          const SizedBox(height: 20),
          sectionHeader("Higher Education", false),
          ...widget.curatorModel.profile!.higherEducation.map(
            (edu) => personalInfoRow(edu.institute, edu.degree),
          ),

          const SizedBox(height: 20),
          sectionHeader("Work Experience", false),
          ...widget.curatorModel.profile!.workExperience.map(
            (work) => personalInfoRow(work.organization, work.role),
          ),
          const SizedBox(height: 20),
          sectionHeader('Bank Details', false),
          personalInfoRow(
            'Bank Name:',
            widget.curatorModel.profile?.bankAccountDetails?.bankName ?? 'NA',
          ),
          personalInfoRow(
            'Account Holder Name:',
            widget
                    .curatorModel
                    .profile
                    ?.bankAccountDetails
                    ?.accountHolderName ??
                'NA',
          ),
          personalInfoRow(
            'Account Number:',
            widget.curatorModel.profile?.bankAccountDetails?.accountNumber ??
                'NA',
          ),
          personalInfoRow(
            'IFSC code:',
            widget.curatorModel.profile?.bankAccountDetails?.ifscCode ?? 'NA',
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
            style: AppStyles.style20.copyWith(
              color: AppColors.primary,
              fontSize: 18,
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
              style: AppStyles.text14.copyWith(color: Colors.black87),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget personalSkillSetRow(String label, List<String> value) {
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
          Expanded(
            child: Wrap(
              children: [
                for (int i = 0; i < value.length; i++) Text('${value[i]},  '),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
