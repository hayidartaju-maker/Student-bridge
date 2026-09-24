enum AppRole {
  admin,
  teacher,
  parent,
  student,
}

extension AppRoleExtension on AppRole {
  String get value => switch (this) {
        AppRole.admin => 'admin',
        AppRole.teacher => 'teacher',
        AppRole.parent => 'parent',
        AppRole.student => 'student',
      };

  String get label => switch (this) {
        AppRole.admin => 'Admin',
        AppRole.teacher => 'Teacher',
        AppRole.parent => 'Parent',
        AppRole.student => 'Student',
      };

  static AppRole? fromValue(String? value) {
    switch (value) {
      case 'admin':
        return AppRole.admin;
      case 'teacher':
        return AppRole.teacher;
      case 'parent':
        return AppRole.parent;
      case 'student':
        return AppRole.student;
      default:
        return null;
    }
  }
}
