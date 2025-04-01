// import 'package:admin_curator/Core/Notifiers/profile_notifier.dart';
// import 'package:flutter/material.dart';

// class RejectionBottomSheet extends StatefulWidget {
//   final String consultantId;
//   final ProfileNotifier profileNotifier;
//   final String userEmail;

//   const RejectionBottomSheet({
//     Key? key,
//     required this.consultantId,
//     required this.profileNotifier,
//     required this.userEmail,
//   }) : super(key: key);

//   @override
//   _RejectionBottomSheetState createState() => _RejectionBottomSheetState();
// }

// class _RejectionBottomSheetState extends State<RejectionBottomSheet> {
//   final TextEditingController _reasonController = TextEditingController();
//   bool _isSubmitting = false;

//   Future<void> _submitRejection() async {
//     String reason = _reasonController.text.trim();
//     if (reason.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter a reason for rejection")),
//       );
//       return;
//     }

//     setState(() => _isSubmitting = true);

//     bool success = await widget.profileNotifier.updateVerificationStatus(
//       consultantId: widget.consultantId,
//       isVerified: false,
//       isRejected: true,
//       rejectionReason: reason,
//       rejectedBy: widget.userEmail,
//       rejectedAt: DateTime.now(),
//     );

//     setState(() => _isSubmitting = false);

//     if (success) {
//       Navigator.pop(context); // Close the bottom sheet
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Profile rejected successfully")),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Failed to reject profile")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(
//         left: 16,
//         right: 16,
//         bottom: MediaQuery.of(context).viewInsets.bottom + 16,
//         top: 16,
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "Reason for Rejection",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 10),
//           TextField(
//             controller: _reasonController,
//             decoration: InputDecoration(
//               hintText: "Enter reason...",
//               border: OutlineInputBorder(),
//             ),
//             maxLines: 3,
//           ),
//           const SizedBox(height: 20),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: _isSubmitting ? null : _submitRejection,
//               child: _isSubmitting
//                   ? const CircularProgressIndicator(color: Colors.white)
//                   : const Text("Submit"),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:admin_curator/Core/Notifiers/profile_notifier.dart';
import 'package:admin_curator/Presentation/Widgets/global_btn.dart';
import 'package:flutter/material.dart';

class RejectionDialog extends StatefulWidget {
  final String consultantId;
  final ProfileNotifier profileNotifier;
  final String userEmail;

  const RejectionDialog({
    Key? key,
    required this.consultantId,
    required this.profileNotifier,
    required this.userEmail,
  }) : super(key: key);

  @override
  _RejectionDialogState createState() => _RejectionDialogState();
}

class _RejectionDialogState extends State<RejectionDialog> {
  final TextEditingController _reasonController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submitRejection() async {
    String reason = _reasonController.text.trim();
    if (reason.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a reason for rejection")),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    bool success = await widget.profileNotifier.updateVerificationStatus(
      consultantId: widget.consultantId,
      isVerified: false,
      isRejected: true,
      rejectionReason: reason,
      rejectedBy: widget.userEmail,
      rejectedAt: DateTime.now(),
    );

    setState(() => _isSubmitting = false);

    if (success) {
      Navigator.pop(context); // Close dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile rejected successfully")),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to reject profile")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Reject Profile"),
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Enter the reason for rejection:",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _reasonController,
            decoration: const InputDecoration(
              hintText: "Enter reason...",
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        // TextButton(
        //   onPressed: () => Navigator.pop(context), // Close dialog
        //   child: const Text("Cancel"),
        // ),
        SizedBox(
          width: 150,
          child: GlobalButton(
            text: "Cancel",
            onPressed: () {
              Navigator.pop(context);
            },
            height: 35,
            isOutlined: true,
          ),
        ),
        SizedBox(
          width: 150,
          child: GlobalButton(
            text: "Submit",
            onPressed: () {
              _isSubmitting ? null : _submitRejection;
            },
            height: 35,
            isOutlined: true,
          ),
        ),
        // ElevatedButton(
        //   onPressed: _isSubmitting ? null : _submitRejection,
        //   child:
        //       _isSubmitting
        //           ? const CircularProgressIndicator(color: Colors.white)
        //           : const Text("Submit"),
        // ),
      ],
    );
  }
}
