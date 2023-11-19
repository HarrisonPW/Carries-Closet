import 'package:artifact/Screens/clothing_confirmation_page.dart';
import 'package:artifact/Screens/clothing_form_info.dart';
import 'package:artifact/Screens/clothing_form.dart';
import 'package:artifact/admin_home_page.dart';
import 'package:artifact/app_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:artifact/home_page.dart';

// New page by Eph

class MultiClothingFormWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MultiClothingFormWidgetState();
  }
}

class _MultiClothingFormWidgetState extends State<MultiClothingFormWidget> {
  List<ClothingFormWidget> clothingForms = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        // appBar: AppBar(
        //   title: Text("Create Multi Contacts"),
        // ),

        bottomNavigationBar: Padding(
            padding: EdgeInsets.only(
                top: height * 1.0 / 32.0,
                left: width * 1.0 / 5.0,
                right: width * 1.0 / 5.0,
                bottom: height * 1.0 / 32.0),
            child: SizedBox(
              child: CupertinoButton(
                color: Color(0xFF7EA5F4),
                onPressed: () {
                  onSave();
                },
                child: Text(
                  "Save",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            )),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFFEEE0FF),
          child: Icon(
            Icons.add,
            color: Color(0xFF000000),
          ),
          onPressed: () {
            onAdd();
          },
        ),
        body: SingleChildScrollView(
            physics: const ScrollPhysics(),
            // appBar: AppBar(actions: [Actions(actions: <Widget>[]>, child: child)]),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              SizedBox(height: height * 1.0 / 18.0),
              Stack(alignment: Alignment.topLeft, children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                        iconSize: width * 1.0 / 18.0,
                        onPressed: () {
                          if (AppUser.isAdmin == PermissionStatus.admin) {
                            Navigator.push(context,
                                MaterialPageRoute(builder: ((context) {
                              return const AdminHomePage();
                            })));
                          } else {
                            Navigator.push(context,
                                MaterialPageRoute(builder: ((context) {
                              return const HomePage();
                            })));
                          }
                        },
                        icon: const Icon(Icons.arrow_back))),
              ]),
              const Text("Clothing Request",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 1.0 / 12.0,
                    vertical: height * 1.0 / 36.0),
                child: const Text(
                    "Please fill out information to request a clothing item. If you chose a teenager size, please the specific size in the “Other Notes” section.",
                    textAlign: TextAlign.center),
              ),
              Flexible(
                  child: clothingForms.isNotEmpty
                      ? ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: clothingForms.length,
                          itemBuilder: (_, index) {
                            return clothingForms[index];
                          })
                      : const Center(child: Text("Tap on + to Add a Request"))),
            ])));
  }

  //Validate all forms and submit
  onSave() {
    bool allValid = true;
    if (clothingForms.isEmpty) {
      allValid = false;
    }
    //If any form validation function returns false means all forms are not valid
    clothingForms
        .forEach((element) => allValid = (allValid && element.isValidated()));

    if (allValid) {
      var genders = [];
      var items = [];
      var sizes = [];
      var emergencies = [];
      var ages = [];
      var notes = [];
      for (int i = 0; i < clothingForms.length; i++) {
        ClothingFormWidget item = clothingForms[i];
        genders.add(item.clothingFormInfo.genderValue);
        items.add(item.clothingFormInfo.itemValue);
        sizes.add(item.clothingFormInfo.sizeValue);
        emergencies.add(item.clothingFormInfo.emergencyValue);
        ages.add(item.clothingFormInfo.ageValue);
        notes.add(item.clothingFormInfo.notesValue);
      }
      Navigator.push(context, MaterialPageRoute(builder: ((context) {
        return ClothingConfirmationPage(
          genders: genders,
          items: items,
          sizes: sizes,
          emergencies: emergencies,
          ages: ages,
          notes: notes,
        );
      })));
    } else {
      debugPrint("Form is Not Valid");
    }
  }

  //Delete specific form
  onRemove(ClothingFormInfo form) {
    setState(() {
      int index = clothingForms
          .indexWhere((element) => element.clothingFormInfo.id == form.id);
      if (clothingForms != null) clothingForms.removeAt(index);
    });
  }

  //Add New Form
  onAdd() {
    setState(() {
      ClothingFormInfo clothingForm =
          ClothingFormInfo(id: clothingForms.length);
      clothingForms.add(ClothingFormWidget(
        index: clothingForms.length,
        clothingFormInfo: clothingForm,
        onRemove: () => onRemove(clothingForm),
      ));
    });
  }
}
