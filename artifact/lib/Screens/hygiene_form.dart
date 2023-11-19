import 'package:flutter/material.dart';
import 'hygiene_form_info.dart';

class HygieneFormWidget extends StatefulWidget {
  HygieneFormWidget(
      {Key? key,
      required this.hygieneFormInfo,
      required this.onRemove,
      this.index})
      : super(key: key);

  final index;
  HygieneFormInfo hygieneFormInfo;
  final Function onRemove;
  final state = _HygieneFormWidgetState();

  @override
  State<StatefulWidget> createState() {
    return state;
  }

  bool isValidated() => state.validate();
  TextEditingController ageController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  String genderValue = '';
  String itemValue = '';
  String sizeValue = '';
  String emergencyValue = '';
}

class _HygieneFormWidgetState extends State<HygieneFormWidget> {
  final GlobalKey<FormState> hygieneFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Material(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 1.0 / 12.0),
        child: Card(
            child: Form(
                key: hygieneFormKey,
                child: Container(
                    padding:
                        const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          )
                        ]),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Item"),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      // Clear all forms
                                      widget.hygieneFormInfo.genderValue = "";
                                      widget.hygieneFormInfo.emergencyValue =
                                          "";
                                      widget.hygieneFormInfo.itemValue = "";
                                      widget.ageController.clear();
                                      widget.notesController.clear();
                                    });
                                  },
                                  child: const Text("Clear"),
                                ),
                                TextButton(
                                  onPressed: () => widget.onRemove(),
                                  child: const Text(
                                    "Delete Form",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        DropdownButtonFormField(
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 12),
                            border: OutlineInputBorder(),
                            hintText: "Select a Gender",
                            labelText: "Gender",
                          ),
                          value: widget.genderValue,
                          items:
                              widget.hygieneFormInfo.genders.map((valueItem) {
                            return DropdownMenuItem(
                              value: valueItem,
                              child: Text(valueItem),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              widget.genderValue = value as String;
                            });
                          },
                          onSaved: (value) {
                            setState(() {
                              widget.hygieneFormInfo.genderValue =
                                  value as String;
                            });
                          },
                          validator: (value) {
                            return !(widget.genderValue == '')
                                ? null
                                : "Please select a gender";
                          },
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField(
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 12),
                            border: OutlineInputBorder(),
                            hintText: "Select an Item",
                            labelText: "Item",
                          ),
                          value: widget.itemValue,
                          items: widget.hygieneFormInfo.items.map((valueItem) {
                            return DropdownMenuItem(
                              value: valueItem,
                              child: Text(valueItem),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              widget.itemValue = value as String;
                            });
                          },
                          onSaved: (value) {
                            setState(() {
                              widget.hygieneFormInfo.itemValue =
                                  value as String;
                            });
                          },
                          validator: (value) {
                            return !(widget.itemValue == '')
                                ? null
                                : "Please select an item";
                          },
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField(
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 12),
                            border: OutlineInputBorder(),
                            hintText: "Select a size",
                            labelText: "Size",
                          ),
                          value: widget.sizeValue,
                          items: widget.hygieneFormInfo.sizes.map((valueItem) {
                            return DropdownMenuItem(
                              value: valueItem,
                              child: Text(valueItem),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              widget.sizeValue = value as String;
                            });
                          },
                          onSaved: (value) {
                            setState(() {
                              widget.hygieneFormInfo.sizeValue =
                                  value as String;
                            });
                          },
                          validator: (value) {
                            return !(widget.sizeValue == '')
                                ? null
                                : "Please select a size";
                          },
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField(
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 12),
                            border: OutlineInputBorder(),
                            hintText: "Select Emergency Level",
                            labelText: "Emergency?",
                          ),
                          value: widget.emergencyValue,
                          items:
                              widget.hygieneFormInfo.emergency.map((valueItem) {
                            return DropdownMenuItem(
                              value: valueItem,
                              child: Text(valueItem),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              widget.emergencyValue = value as String;
                            });
                          },
                          onSaved: (value) => {
                            setState(() {
                              widget.hygieneFormInfo.emergencyValue =
                                  value as String;
                            })
                          },
                          validator: (value) {
                            return !(widget.emergencyValue == '')
                                ? null
                                : "Please indicate if emergency";
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: widget.ageController,
                          onChanged: (value) =>
                              widget.hygieneFormInfo.ageValue = value,
                          onSaved: (value) =>
                              widget.hygieneFormInfo.ageValue = value,
                          validator: (value) =>
                              !(value == null || value.isEmpty)
                                  ? null
                                  : "Please enter an age",
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 12),
                            border: OutlineInputBorder(),
                            hintText: "Enter Age",
                            labelText: "Age",
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          controller: widget.notesController,
                          onChanged: (value) =>
                              widget.hygieneFormInfo.notesValue = value,
                          onSaved: (value) =>
                              widget.hygieneFormInfo.notesValue = value,
                          validator: (value) =>
                              !(value == null || value.length < 3)
                                  ? null
                                  : "Please enter 'N/A' if not applicable",
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 12),
                            border: OutlineInputBorder(),
                            hintText: "Enter Other Notes",
                            labelText: "Other Notes",
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                      ],
                    )))),
      ),
    );
  }

  bool validate() {
    // Validate the form
    bool validate = hygieneFormKey.currentState!.validate();
    if (validate) {
      hygieneFormKey.currentState!.save();
    }
    return validate;
  }
}
