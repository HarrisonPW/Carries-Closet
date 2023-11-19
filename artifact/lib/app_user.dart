// Maybe some good old fashioned OOP will save us here
// Instantiate object with static field that can be referenced across the app
// Just set the field once we get a value once the user logs in

  enum PermissionStatus {
    admin,
    user,
    unknown,
  }

class AppUser {

  static late PermissionStatus isAdmin;

  AppUser() {
    isAdmin = PermissionStatus.unknown;
  }

  void setAdminStatus(PermissionStatus adminStatus) {
    isAdmin = adminStatus;
  }
}