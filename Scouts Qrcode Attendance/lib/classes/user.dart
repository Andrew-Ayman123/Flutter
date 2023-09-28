enum AppUserType {
  superAdmin(0),
  admin(1),
  normal(2);

  final int id;
  const AppUserType(this.id);
  static AppUserType get(int id) {
    switch (id) {
      case 0:
        return AppUserType.superAdmin;
      case 1:
        return AppUserType.admin;
      default:
        return AppUserType.normal;
    }
  }
}

class AppUser {
  String name, email, phoneNumber, imageLink, groupName, nickName;

  late AppUserType _type;
  AppUser({
    required this.email,
    required this.name,
    required this.imageLink,
    required this.phoneNumber,
    required this.groupName,
    required this.nickName,
    required int type,
  }) {
    typeSet(type);
  }

  AppUser.empty()
      : email = '',
        name = '',
        phoneNumber = '',
        imageLink = '',
        groupName = '',
        nickName = '',
        _type = AppUserType.normal;

  void typeSet(int typeInt) {
    _type = AppUserType.get(typeInt);

    // if (typeInt == 0) {
    //   _type = AppUserType.superAdmin;
    // } else if (typeInt == 1) {
    //   _type = AppUserType.admin;
    // } else {
    //   _type = AppUserType.normal;
    // }
  }

  int typeGet() {
    return _type.id;
    // if (isSuperAdmin) {
    //   return 0;
    // } else if (isAdmin) {
    //   return 1;
    // } else {
    //   return 2;
    // }
  }

  bool get isSuperAdmin => _type == AppUserType.superAdmin;
  bool get isAdmin => _type == AppUserType.admin;
  bool get isNormal => _type == AppUserType.normal;
  bool get isNotNormal => _type != AppUserType.normal;

  @override
  AppUser.fromJson(Map<String, dynamic> values)
      : email = values['email'],
        imageLink = values['image_link'],
        name = values['name'],
        phoneNumber = values['phone_number'],
        groupName = values['group_name'],
        nickName = values['nick_name'] {
    typeSet(values['type']);
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'image_link': imageLink,
      'name': name,
      'phone_number': phoneNumber,
      'group_name': groupName,
      'nick_name': nickName,
      'type': typeGet(),
    };
  }
}
