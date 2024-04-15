import 'package:equatable/equatable.dart';
import 'package:gym_repository/gym_repository.dart';
import 'package:user_repository/src/entities/entities.dart';

class MyUser extends Equatable {
  final String id;
  final String email;
  final String name;
  int? age;
  String? picture;
  Gym? gym;
  String? gender;
  String? grade;
  String? description;
  int? searchGradeLow;
  int? searchGradeHigh;
  List<String>? searchGender;
  int? searchAgeLow;
  int? searchAgeHigh;

  MyUser({
    required this.id,
    required this.email,
    required this.name,
    this.age,
    this.picture,
    this.gym,
    this.gender,
    this.grade,
    this.description,
    this.searchGradeLow,
    this.searchGradeHigh,
    this.searchGender,
    this.searchAgeLow,
    this.searchAgeHigh,
  });

  // Emtpy user which represents an unauthenticated user
  static final empty = MyUser(
    id: '',
    email: '',
    name: '',
    picture: '',
    age: 0,
    gym: Gym.empty,
    gender: '',
    grade: '',
    description: '',
    searchGradeLow: 0,
    searchGradeHigh: 0,
    searchGender: const [],
    searchAgeLow: 0,
    searchAgeHigh: 0,
  );

  // Modify MyUser fields
  MyUser copyWith({
    String? id,
    String? email,
    String? name,
    String? picture,
    int? age,
    Gym? gym,
    String? gender,
    String? grade,
    String? description,
    int? searchGradeLow,
    int? searchGradeHigh,
    List<String>? searchGender,
    int? searchAgeLow,
    int? searchAgeHigh,
  }) {
    return MyUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      picture: picture ?? this.picture,
      age: age ?? this.age,
      gym: gym ?? this.gym,
      gender: gender ?? this.gender,
      grade: grade ?? this.grade,
      description: description ?? this.description,
      searchGradeLow: searchGradeLow ?? this.searchGradeLow,
      searchGradeHigh: searchGradeHigh ?? this.searchGradeHigh,
      searchGender: searchGender ?? this.searchGender,
      searchAgeLow: searchAgeLow ?? this.searchAgeLow,
      searchAgeHigh: searchAgeHigh ?? this.searchAgeHigh,
    );
  }

  bool get isEmpty => this == MyUser.empty;

  bool get isNotEmpyt => this != MyUser.empty;

  MyUserEntity toEntity() {
    return MyUserEntity(
      id: id,
      email: email,
      name: name,
      age: age,
      picture: picture,
      gym: gym,
      gender: gender,
      grade: grade,
      description: description,
      searchGradeLow: searchGradeLow,
      searchGradeHigh: searchGradeHigh,
      searchGender: searchGender,
      searchAgeLow: searchAgeLow,
      searchAgeHigh: searchAgeHigh,
    );
  }

  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      age: entity.age,
      picture: entity.picture,
      gym: entity.gym,
      gender: entity.gender,
      grade: entity.grade,
      description: entity.description,
      searchGradeLow: entity.searchGradeLow,
      searchGradeHigh: entity.searchGradeHigh,
      searchGender: entity.searchGender,
      searchAgeLow: entity.searchAgeLow,
      searchAgeHigh: entity.searchAgeHigh,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        age,
        picture,
        gym,
        gender,
        grade,
        description,
        searchGradeLow,
        searchGradeHigh,
        searchGender,
        searchAgeLow,
        searchAgeHigh,
      ];
}
