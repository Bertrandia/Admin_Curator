import 'package:admin_curator/Core/Notifiers/profile_notifier.dart';
import 'package:admin_curator/Providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../Models/profile.dart';
import '../CuratorProfiles/Widgets/profile_details.dart';

class CuratorProfilesList extends ConsumerStatefulWidget {
  const CuratorProfilesList({super.key});

  @override
  ConsumerState<CuratorProfilesList> createState() => _CuratorProfilesState();
}

class _CuratorProfilesState extends ConsumerState<CuratorProfilesList> {
  @override
  Widget build(BuildContext context) {
    final curatorState = ref.watch(profileProvider);
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
                const Text(
                  'Curators',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFBF4D28),
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
                        final curatorProfile = curatorState.profile[index];
                        return _buildCuratorCard(
                          profile: curatorProfile,
                          name: curatorProfile.fullName,
                          title: curatorProfile.profile!.selectedSkills[0],
                          email:
                              curatorProfile.profile?.email ??
                              'Email not available',

                          imageUrl: curatorProfile.profile?.profileImage ?? '',
                          specialties:
                              curatorProfile.profile?.selectedSkills ?? [],
                          location: curatorProfile.profile?.state ?? 'NA',
                          rate: '\$1200 per session',
                          availability:
                              DateFormat(
                                'dd/MM/yy',
                              ).format(curatorProfile.createdAt).toString(),
                          context: context,
                        );
                      },
                      itemCount: curatorState.profile.length,
                    ),
                  ),
                  // Expanded(
                  //   child: GridView.builder(
                  //     gridDelegate:
                  //         const SliverGridDelegateWithFixedCrossAxisCount(
                  //           crossAxisCount:
                  //               2, // Adjust based on your layout preference
                  //           crossAxisSpacing: 8.0,
                  //           mainAxisSpacing: 8.0,
                  //           childAspectRatio:
                  //               0.75, // Adjust based on your UI needs
                  //         ),
                  //     itemCount: curatorState.profile.length,
                  //     itemBuilder: (context, index) {
                  //       final curatorProfile = curatorState.profile[index];
                  //       return _buildCuratorCard(
                  //         profile: curatorProfile,
                  //         name: curatorProfile.fullName,
                  //         title: curatorProfile.profile!.selectedSkills[0],
                  //         email:
                  //             curatorProfile.profile?.email ??
                  //             'Email not available',
                  //         imageUrl: curatorProfile.profile?.profileImage ?? '',
                  //         specialties:
                  //             curatorProfile.profile?.selectedSkills ?? [],
                  //         location: curatorProfile.profile?.state ?? 'NA',
                  //         rate: '\$1200 per session',
                  //         availability:
                  //             DateFormat(
                  //               'dd/MM/yy',
                  //             ).format(curatorProfile.createdAt).toString(),
                  //         context: context,
                  //       );
                  //     },
                  //   ),
                  // ),

                  // const SizedBox(height: 16),
                  // _buildCuratorCard(
                  //   name: 'Priya Sharma',
                  //   title: 'Professional Organizer',
                  //   rating: 4.8,
                  //   reviewCount: 115,
                  //   imageUrl: 'assets/priya_profile.png',
                  //   specialties: [
                  //     'Full Home Organization',
                  //     'Minimalist Design',
                  //   ],
                  //   location: 'Bangalore',
                  //   rate: '\$950 per session',
                  //   availability: 'Limited availability',
                  //   context: context,
                  // ),
                  // const SizedBox(height: 16),
                  // _buildCuratorCard(
                  //   name: 'Vikram Singh',
                  //   title: 'Space Optimization Expert',
                  //   rating: 4.6,
                  //   reviewCount: 87,
                  //   imageUrl: 'assets/vikram_profile.png',
                  //   specialties: [
                  //     'Small Space Solutions',
                  //     'Kitchen Organization',
                  //   ],
                  //   location: 'Hyderabad',
                  //   rate: '\$1100 per session',
                  //   availability: 'Available this weekend',
                  //   context: context,
                  // ),
                  // const SizedBox(height: 16),
                  // _buildCuratorCard(
                  //   name: 'Neha Kapoor',
                  //   title: 'Decluttering Specialist',
                  //   rating: 4.9,
                  //   reviewCount: 156,
                  //   imageUrl: 'assets/neha_profile.png',
                  //   specialties: ['Decluttering', 'Seasonal Wardrobes'],
                  //   location: 'Chennai',
                  //   rate: '\$1000 per session',
                  //   availability: 'Available next week',
                  //   context: context,
                  // ),
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
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFBF4D28),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
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
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
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
                    child: const Text('View Profile'),
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
