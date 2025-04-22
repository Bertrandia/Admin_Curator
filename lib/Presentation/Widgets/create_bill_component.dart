import 'dart:math';
import 'package:admin_curator/Constants/firebase_collections.dart';
import 'package:admin_curator/Models/model_tasks.dart';
import 'package:admin_curator/Providers/providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddBill extends ConsumerStatefulWidget {
  final TaskModel model;
  final String curatorRef;

  const AddBill(this.model, this.curatorRef, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => AddNewBillFormState();
}

class AddNewBillFormState extends ConsumerState<AddBill> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _taskTimeController = TextEditingController();
  final TextEditingController _taskDateController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      ref.read(profileProvider.notifier).getCuratorById(widget.curatorRef);
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    print('id is ${profileState.singleProfile?.id}');
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: const Color(0xFFFFF8F0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add New Bill',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD55E00),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Price
                    _buildFormField(
                      ' Price(in Rupees)',
                      _priceController,
                      isRequired: true,
                      keyboardType: TextInputType.number,
                      // onChanged:
                      //     (value) => ref
                      //         .read(billDataProvider.notifier)
                      //         .updatePrice(value),
                    ),
                    const SizedBox(height: 16),

                    // Description
                    _buildFormField(
                      'Invoice Description',
                      _descriptionController,
                      isRequired: true,
                      maxLines: 4,
                      // onChanged:
                      //     (value) => ref
                      //         .read(billDataProvider.notifier)
                      //         .updateDescription(value),
                    ),
                    const SizedBox(height: 16),

                    // Task Time
                    _buildFormField(
                      'Task Time(In Hours)',
                      _taskTimeController,
                      // onChanged:
                      //     (value) => ref
                      //         .read(billDataProvider.notifier)
                      //         .updateTaskTime(value),
                    ),
                    const SizedBox(height: 16),

                    const SizedBox(height: 16),

                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            side: const BorderSide(color: Color(0xFFD55E00)),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Color(0xFFD55E00)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () async {
                            final curatorRef = FirebaseFirestore.instance
                                .collection(
                                  FirebaseCollections.consultantCollection,
                                )
                                .doc(widget.model.taskAssignedToCurator);
                            final taskDocRef = FirebaseFirestore.instance
                                .collection(
                                  FirebaseCollections.createTaskCollection,
                                )
                                .doc(widget.model.taskRef);

                            await ref
                                .read(curatorBillProvider.notifier)
                                .createCuratorBill(
                                  taskHours:
                                      double.tryParse(
                                        _taskTimeController.text,
                                      ) ??
                                      0,

                                  taskPrice:
                                      double.tryParse(_priceController.text) ??
                                      0,
                                  fileName:
                                      '${profileState.singleProfile?.fullName}_${widget.model.taskSubject}_${DateTime.now()}',
                                  vendorName: 'Pinch Lifestyle Pvt Ltd.',
                                  invoiceNumber: getRandomString(10),
                                  invoiceDate: DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(DateTime.now()),
                                  soldTo:
                                      profileState.singleProfile?.fullName ??
                                      '',
                                  items: [
                                    {
                                      'task': widget.model.taskSubject,

                                      'description':
                                          _descriptionController.text,

                                      'taskHours': _taskTimeController.text,

                                      'taskPrice': _priceController.text,

                                      'date': DateFormat(
                                        'dd MMM yyyy, hh:mm a',
                                      ).format(widget.model.taskDate.toDate()),

                                      'totalAmount': double.tryParse(
                                        _priceController.text,
                                      ),
                                    },
                                  ],
                                  taskRef: taskDocRef,
                                  curatorRef: curatorRef,
                                  invoiceDescription:
                                      _descriptionController.text,
                                  totalAmount:
                                      double.tryParse(_priceController.text) ??
                                      0,
                                )
                                .then((value) {
                                  if (value) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('PDF generated')),
                                    );
                                  }
                                  Navigator.pop(context);
                                });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD55E00),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          child: const Text(
                            'Generate Bill',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String getRandomString(int length) {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => characters.codeUnitAt(random.nextInt(characters.length)),
      ),
    );
  }

  Widget _buildFormField(
    String label,
    TextEditingController controller, {
    bool isRequired = false,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label ${isRequired ? '*' : ''}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFFD55E00),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: 'Enter ${label.toLowerCase()}',
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD55E00), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD55E00), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          validator:
              isRequired
                  ? (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter $label';
                    }
                    return null;
                  }
                  : null,
        ),
      ],
    );
  }
}
