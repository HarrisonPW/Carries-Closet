class HygieneFormInfo {
  final List genders = ["", "Male", "Female", "Non-binary", "Other"];
  String? genderValue;

  final List items = ["", "Toothpaste", "Toothbrush", "Deodorant", "Other"];
  String? itemValue;

  final List sizes = ["", "Small", "Medium", "Large", "X-Large"];
  String? sizeValue;

  final List emergency = ["", "Yes", "No"];
  String? emergencyValue;

  String? ageValue;
  String? notesValue;

  int? id;

  HygieneFormInfo(
      {this.genderValue,
      this.itemValue,
      this.sizeValue,
      this.emergencyValue,
      this.id});
}
