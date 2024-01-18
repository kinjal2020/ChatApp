class UserModel {
  final String? email;
  final String? password;
  final String? uid;

  UserModel({required this.email, required this.password, required this.uid});

  factory UserModel.fromJson(Map mapData){
    return UserModel(email: mapData['email'],
        password: mapData['password'],
        uid: mapData['uid']);
  }
}

List<UserModel> userList = [];


