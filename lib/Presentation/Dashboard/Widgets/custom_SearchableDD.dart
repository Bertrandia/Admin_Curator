import 'package:admin_curator/Constants/app_colors.dart';
import 'package:admin_curator/Models/profile.dart';
import 'package:admin_curator/Providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchableDropdown extends ConsumerStatefulWidget {
  @override
  _SearchableDropdownState createState() => _SearchableDropdownState();
}

class _SearchableDropdownState extends ConsumerState<SearchableDropdown> {
  final TextEditingController _searchController = TextEditingController();
  bool _isDropdownOpen = false;
  String? selectedCurator;
  List<CuratorModel> filteredProfiles = [];

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(profileProvider.notifier).fetchActiveCurators();
      final profileState = ref.watch(profileProvider);
      filteredProfiles = profileState.verifiedProfiles ?? [];
    });
  }

  // void didChangeDependencies() {
  //     super.didChangeDependencies();
  // ref.listen(profileProvider, (previous, next) {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (mounted) {
  //       setState(() {
  //         filteredProfiles = next.profile; // Ensure update happens after build
  //       });
  //     }
  //   });
  // });
  // }

  void _toggleDropdown() {
    setState(() {
      _isDropdownOpen = !_isDropdownOpen;
      if (!_isDropdownOpen) {
        _searchController.clear();
        final profileState = ref.watch(profileProvider);
        filteredProfiles = profileState.profile;
      }
    });
  }

  void _filterItems(String query) {
    //   ref.read(profileProvider.notifier).fetchActiveCurators();
    final profileState = ref.watch(profileProvider);
    setState(() {
      filteredProfiles =
          profileState.profile
              .where(
                (profile) => profile.fullName.toLowerCase().contains(
                  query.toLowerCase(),
                ),
              )
              .toList();
    });
  }

  void _selectItem(String id) {
    setState(() {
      selectedCurator = id;
      _isDropdownOpen = false;
      _searchController.clear();
    });
    ref.read(selectedCuratorProvider.notifier).state = id;
  }

  void _clearSelection() {
    setState(() {
      selectedCurator = null;
      _isDropdownOpen = false;
      _searchController.clear();
    });
    ref.read(selectedCuratorProvider.notifier).state = null;
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _toggleDropdown,
          child: InputDecorator(
            decoration: InputDecoration(
              hintText: 'Select Curator',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              // suffixIcon: Icon(_isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down),
              suffixIcon:
                  selectedCurator != null
                      ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey),
                        onPressed: _clearSelection,
                      )
                      : Icon(
                        _isDropdownOpen
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                      ),
            ),
            child: Text(
              selectedCurator != null
                  ? profileState.profile
                      .firstWhere((p) => p.id == selectedCurator)
                      .fullName
                  : 'Select Curator',
            ),
          ),
        ),
        if (_isDropdownOpen)
          Container(
            width: 250,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black26)],
            ),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: _filterItems,
                  decoration: InputDecoration(
                    hintText: 'Search Curator',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                SizedBox(
                  height: 150,
                  child:
                      profileState.isLoading
                          ? Center(child: CircularProgressIndicator())
                          : ListView.builder(
                            itemCount: filteredProfiles.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(filteredProfiles[index].fullName),
                                onTap:
                                    () =>
                                        _selectItem(filteredProfiles[index].id),
                              );
                            },
                          ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
