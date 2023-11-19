import 'package:flutter/material.dart';
import 'clothing_form_info.dart';

// New page by Eph

class ClothingFormWidget extends StatefulWidget {
  ClothingFormWidget(
      {Key? key,
      required this.clothingFormInfo,
      required this.onRemove,
      this.index})
      : super(key: key);

  final index;
  ClothingFormInfo clothingFormInfo;
  final Function onRemove;
  final state = _ClothingFormWidgetState();

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

class _ClothingFormWidgetState extends State<ClothingFormWidget> {
  final GlobalKey<FormState> clothingFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Material(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 1.0 / 12.0),
        child: Card(
            child: Form(
                key: clothingFormKey,
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
                                      widget.clothingFormInfo.genderValue = "";
                                      widget.clothingFormInfo.emergencyValue =
                                          "";
                                      widget.clothingFormInfo.itemValue = "";
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
                              widget.clothingFormInfo.genders.map((valueItem) {
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
                              widget.clothingFormInfo.genderValue = value as String;
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
                          items: widget.clothingFormInfo.items.map((valueItem) {
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
                            widget.clothingFormInfo.itemValue = value as String;
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
                          items: widget.clothingFormInfo.sizes.map((valueItem) {
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
                              widget.clothingFormInfo.sizeValue = value as String;
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
                          items: widget.clothingFormInfo.emergency
                              .map((valueItem) {
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
                              widget.clothingFormInfo.emergencyValue = value as String;
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
                              widget.clothingFormInfo.ageValue = value,
                          onSaved: (value) =>
                              widget.clothingFormInfo.ageValue = value,
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
                              widget.clothingFormInfo.notesValue = value,
                          onSaved: (value) =>
                              widget.clothingFormInfo.notesValue = value,
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
    bool validate = clothingFormKey.currentState!.validate();
    if (validate) {
      clothingFormKey.currentState!.save();
    }
    return validate;
  }
}
