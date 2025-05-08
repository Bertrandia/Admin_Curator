import 'package:admin_curator/Providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../Constants/app_colors.dart';
import '../../Constants/app_styles.dart';

class CustomDropdown extends ConsumerStatefulWidget {
  final String header;
  final String? selectedItem;
  final String hintText;
  final List<String> items;
  final double width;
  final bool isMandatory;
  final Function(String?)? onChanged;
  final bool isEnabled;
  final String taskID;
  final VoidCallback? onAssignPressed; // Callback for Assign button

  const CustomDropdown({
    super.key,
    required this.taskID,
    required this.header,
    this.selectedItem,
    required this.hintText,
    required this.items,
    this.width = 400,
    this.onChanged,
    this.isMandatory = true,
    this.isEnabled = true,
    this.onAssignPressed, // Assign button action
  });

  @override
  ConsumerState<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends ConsumerState<CustomDropdown> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedItem;
  List<String> _filteredItems = [];
  bool _isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _selectedItem = widget.selectedItem;
  }

  void _toggleDropdown() {
    if (!widget.isEnabled) return;

    setState(() {
      _isDropdownOpen = !_isDropdownOpen;
      if (!_isDropdownOpen) {
        _searchController.clear();
        _filteredItems = widget.items;
      }
    });
  }

  void _filterItems(String query) {
    setState(() {
      _filteredItems =
          widget.items
              .where((item) => item.toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

  void _selectItem(String item) {
    if (!widget.isEnabled) return;

    setState(() {
      _selectedItem = item;
      _isDropdownOpen = false;
      _searchController.clear();
      _filteredItems = widget.items;
    });
    widget.onChanged?.call(item);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width + 60, // Increased width to fit Assign button
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.header,
                      style: AppStyles.text14.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 5),
                    if (widget.isMandatory)
                      Text(
                        '*',
                        style: AppStyles.subHeadingMobile.copyWith(
                          color: AppColors.orange,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: _toggleDropdown,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: AppStyles.text14.copyWith(color: Colors.grey),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color:
                              widget.isEnabled
                                  ? AppColors.primary
                                  : Colors.grey,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 1,
                        ),
                      ),
                      suffixIcon: Icon(
                        _isDropdownOpen
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        color: widget.isEnabled ? null : Colors.grey,
                      ),
                      filled: !widget.isEnabled,
                      fillColor:
                          !widget.isEnabled ? Colors.grey.shade200 : null,
                    ),
                    child: Text(
                      _selectedItem ?? widget.hintText,
                      style: AppStyles.text14.copyWith(
                        color: widget.isEnabled ? Colors.black : Colors.grey,
                      ),
                    ),
                  ),
                ),
                if (_isDropdownOpen && widget.isEnabled)
                  Container(
                    width: widget.width,
                    margin: const EdgeInsets.only(top: 5),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _searchController,
                          onChanged: _filterItems,
                          decoration: InputDecoration(
                            hintText: "Search...",
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                              ),
                            ),
                            suffixIcon:
                                _searchController.text.isNotEmpty
                                    ? IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () {
                                        _searchController.clear();
                                        _filterItems('');
                                      },
                                    )
                                    : null,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          constraints: const BoxConstraints(maxHeight: 200),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _filteredItems.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(_filteredItems[index]),
                                onTap: () => _selectItem(_filteredItems[index]),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8), // Add spacing between dropdown and button
          Align(
            alignment: Alignment.topCenter,
            child: ElevatedButton(
              onPressed: () async {
                final profileState = ref.watch(profileProvider);
                final profile = profileState.profile.firstWhere(
                  (profile) => profile.fullName == _selectedItem,
                );
                print(profile.fullName);
                await ref
                    .read(taskProvider.notifier)
                    .updateCurator(curatorID: profile.id, taskId: widget.taskID)
                    .then((value) async {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Task Assigned to new curator')),
                      );
                      await ref
                          .read(taskProvider.notifier)
                          .notifyUser(
                            userId: profile.id,
                            title: "New Task",
                            body:
                                "A new Task has been added. Click here to check",
                            action: "NEW_TASK_ADDED",
                          );

                      print("notification triggered");
                      await ref
                          .read(taskProvider.notifier)
                          .getTaskById(id: widget.taskID)
                          .then((val) {
                            final taskModel =
                                ref.watch(taskProvider).selectedTask;
                            context.push('/crm_tasks', extra: taskModel);
                          });

                      // widget.onAssignPressed!();
                    });
              }, // Call the provided function
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Assign",
                style: AppStyles.style20.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
