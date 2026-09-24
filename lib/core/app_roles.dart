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
    return switch (value) {
      'admin' => AppRole.admin,
      'teacher' => AppRole.teacher,
      'parent' => AppRole.parent,
      'student' => AppRole.student,
      _ => null,
    };
  }
}
