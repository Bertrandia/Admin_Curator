import 'package:admin_curator/Core/Notifiers/profile_notifier.dart';
import 'package:admin_curator/Providers/providers.dart';
import 'package:admin_curator/Providers/textproviders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../Constants/app_colors.dart';
import '../../Constants/app_styles.dart';
import '../../Models/profile.dart';
import '../CuratorProfiles/Widgets/profile_details.dart';

class CuratorProfilesList extends ConsumerStatefulWidget {
  const CuratorProfilesList({super.key});

  @override
  ConsumerState<CuratorProfilesList> createState() => _CuratorProfilesState();
}

class _CuratorProfilesState extends ConsumerState<CuratorProfilesList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(
      () => ref.read(profileProvider.notifier).fetchVerifiedCurators(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final curatorState = ref.watch(profileProvider);
    final selectedChip = ref.watch(selectedChoicCuratorChipProvider);
    final searchQuery = ref.watch(curatorSearchQueryProvider);
    //   final selectedChipProvider = ref.watch(selectedCuratorChipProvider);

    if (curatorState.verifiedProfiles == null ||
        curatorState.verifiedProfiles!.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    final filteredList =
        curatorState.verifiedProfiles?.where((profile) {
          final matchesStatus =
              selectedChip == 'Active'
                  ? profile.status == true
                  : profile.status == false;
          final matchesSearch =
              searchQuery.isEmpty ||
              profile.fullName.toLowerCase().contains(searchQuery) ||
              (profile.profile?.email.toLowerCase().contains(searchQuery) ??
                  false);
          return matchesStatus && matchesSearch;
        }).toList();
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top App Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            color: Colors.white,
            child: Row(
              children: [
                Text(
                  'Curators',
                  style: AppStyles.style20.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontSize: 24,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.settings, color: Color(0xFFBF4D28)),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(
                    Icons.notifications,
                    color: Color(0xFFBF4D28),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 24.0,
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search curators by name or email',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary),

                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary),

                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary),

                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
              ),
              onChanged: (value) {
                ref.read(curatorSearchQueryProvider.notifier).state = value;
              },
            ),
          ),
          Wrap(
            spacing: 8,
            children:
                ['Active', 'Deactive'].map((filter) {
                  return FilterChip(
                    label: Text(filter),
                    selected: selectedChip == filter,
                    selectedColor: const Color(0xFFF2A65A).withOpacity(0.3),
                    checkmarkColor: const Color(0xFFBF4D28),
                    backgroundColor: Colors.white,
                    labelStyle: AppStyles.style20.copyWith(
                      fontWeight: FontWeight.bold,
                      color:
                          selectedChip == filter
                              ? AppColors.primary
                              : Colors.black87,
                      fontSize: 17,
                    ),
                    onSelected: (bool isSelected) {
                      if (isSelected) {
                        ref
                            .read(selectedChoicCuratorChipProvider.notifier)
                            .state = filter;
                      }
                    },
                  );
                }).toList(),
          ),
          // Main content with scrolling
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        final curatorProfile = filteredList![index];
                        return _buildCuratorCard(
                          profile: curatorProfile,
                          name: curatorProfile.fullName,
                          title:
                              curatorProfile.profile?.selectedSkills[0] ??
                              'Skills',
                          email:
                              curatorProfile.profile?.email ??
                              'Email not available',

                          imageUrl: curatorProfile.profile?.profileImage ?? '',
                          specialties:
                              curatorProfile.profile?.selectedSkills ?? [],
                          location: curatorProfile.profile?.state ?? 'NA',
                          rate: '\$1200 per session',
                          availability:
                              DateFormat('dd/MM/yy')
                                  .format(
                                    curatorProfile.createdAt ?? DateTime.now(),
                                  )
                                  .toString(),
                          context: context,
                        );
                      },
                      itemCount: filteredList?.length ?? 0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCuratorCard({
    required String name,
    required String title,
    required String email,
    required String imageUrl,
    required List<String> specialties,
    required String location,
    required String rate,
    required String availability,
    required BuildContext context,
    required CuratorModel profile,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        // onTap: () {
        //   Navigator.of(context).push(MaterialPageRoute(
        //       builder: (context) => CuratorTaskDetailsPage()));
        // },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color(0xFFF2A65A).withOpacity(0.3),
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: AppStyles.style20.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          title,
                          style: AppStyles.style20.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            // const Icon(
                            //   Icons.star,
                            //   color: Color(0xFFF2A65A),
                            //   size: 18,
                            // ),
                            const SizedBox(width: 4),
                            Text(
                              '$email',
                              style: AppStyles.style20.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black45,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 4),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children:
                    specialties
                        .map(
                          (specialty) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2A65A).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              specialty,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFFBF4D28),
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    location,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8F0),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFF2A65A).withOpacity(0.5),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Color(0xFFBF4D28),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Joined in ${availability}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFFBF4D28),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  ProfileDetailsPage(curatorModel: profile),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFBF4D28),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      'View Profile',
                      style: AppStyles.style20.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                        fontSize: 21,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
