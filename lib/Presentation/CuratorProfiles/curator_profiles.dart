import 'package:admin_curator/Constants/app_colors.dart';
import 'package:admin_curator/Models/profile.dart';
import 'package:admin_curator/Presentation/CuratorProfiles/Widgets/profile_details.dart';
import 'package:admin_curator/Providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CuratorProfiles extends ConsumerStatefulWidget {
  const CuratorProfiles({super.key});

  @override
  ConsumerState<CuratorProfiles> createState() => _CuratorProfilesState();
}

class _CuratorProfilesState extends ConsumerState<CuratorProfiles> {
  String selectedChip = 'Unverified';

  List<CuratorModel> curators = [];

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    curators = profileState.profile;
    return Scaffold(
      backgroundColor: Colors.white70,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Profile Verification',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                _buildChoiceChips(),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              spacing: 14,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatsCard(
                  'Total Profiles',
                  profileState.profile.length,
                  Icons.people,
                  AppColors.primary,
                ),
                _buildStatsCard(
                  'Pending Verifications',
                  curators.where((p) => p.isVerified == false).length,
                  Icons.verified_user,
                  AppColors.primary,
                ),
                _buildStatsCard(
                  'Approved Profiles',
                  curators.where((p) => p.isVerified == true).length,
                  Icons.check_circle,
                  AppColors.primary,
                ),
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount:
                    curators
                        .where(
                          (curator) =>
                              selectedChip == 'Verified'
                                  ? curator.isVerified
                                  : !curator.isVerified,
                        )
                        .length,
                itemBuilder: (context, index) {
                  final profile =
                      curators
                          .where(
                            (curator) =>
                                selectedChip == 'Verified'
                                    ? curator.isVerified
                                    : !curator.isVerified,
                          )
                          .toList()[index];
                  return _buildProfileCard(profile);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceChips() {
    return Row(
      children: [
        ChoiceChip(
          label: Text(
            'Unverified',
            style: TextStyle(color: AppColors.secondary),
          ),
          selected: selectedChip == 'Unverified',
          selectedColor: AppColors.primary,
          onSelected: (bool isSelected) {
            if (isSelected) {
              setState(() {
                selectedChip = 'Unverified';
              });
            }
          },
        ),
        const SizedBox(width: 10),
        ChoiceChip(
          label: const Text('Verified'),
          selected: selectedChip == 'Verified',
          selectedColor: Colors.green,
          onSelected: (bool isSelected) {
            if (isSelected) {
              setState(() {
                selectedChip = 'Verified';
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildStatsCard(String title, int count, IconData icon, Color color) {
    return Container(
      width: 270,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            spreadRadius: 1,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            // ignore: deprecated_member_use
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, size: 22, color: color),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(CuratorModel profile) {
    return Card(
      color: Colors.white,
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 16,
        ),
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(profile.profile!.profileImage),
        ),
        title: Text(
          "${profile.profile!.firstName} ${profile.profile!.lastName}",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              profile.profile!.gender,
              style: const TextStyle(color: Colors.grey),
            ),
            Text(profile.profile!.email, style: const TextStyle(fontSize: 12)),
          ],
        ),
        trailing: _buildStatusButton(
          profile.isVerified ? "Verified" : "Unverified",
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ProfileDetailsPage(curatorModel: profile),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusButton(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: status == 'Unverified' ? Colors.orangeAccent : Colors.green,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
