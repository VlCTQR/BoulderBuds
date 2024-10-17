import 'package:cloud_firestore/cloud_firestore.dart';
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
  String? instagram;
  String? facebook;
  String? twitter;
  List<String>? buddies;
  List<String>? incoming;
  List<String>? outgoing;

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
    this.instagram,
    this.facebook,
    this.twitter,
    this.buddies,
    this.incoming,
    this.outgoing,
  });

  // Empty user which represents an unauthenticated user
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
    instagram: '',
    facebook: '',
    twitter: '',
    buddies: const [],
    incoming: const [],
    outgoing: const [],
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
    String? instagram,
    String? facebook,
    String? twitter,
    List<String>? buddies,
    List<String>? incoming,
    List<String>? outgoing,
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
      instagram: instagram ?? this.instagram,
      facebook: facebook ?? this.facebook,
      twitter: twitter ?? this.twitter,
      buddies: buddies ?? this.buddies,
      incoming: incoming ?? this.incoming,
      outgoing: outgoing ?? this.outgoing,
    );
  }

  bool get isEmpty => this == MyUser.empty;

  bool get isNotEmpty => this != MyUser.empty;

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
      instagram: instagram,
      facebook: facebook,
      twitter: twitter,
      buddies: buddies,
      incoming: incoming,
      outgoing: outgoing,
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
      instagram: entity.instagram,
      facebook: entity.facebook,
      twitter: entity.twitter,
      buddies: entity.buddies,
      incoming: entity.incoming,
      outgoing: entity.outgoing,
    );
  }

  static MyUser fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return MyUser(
      id: snapshot.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      age: data['age'],
      picture: data['picture'],
      gym: data['gym'] != null
          ? Gym.fromMap(data['gym'])
          : null, // Assuming Gym has a fromMap method
      gender: data['gender'],
      grade: data['grade'],
      description: data['description'],
      searchGradeLow: data['searchGradeLow'],
      searchGradeHigh: data['searchGradeHigh'],
      searchGender: List<String>.from(data['searchGender'] ?? []),
      searchAgeLow: data['searchAgeLow'],
      searchAgeHigh: data['searchAgeHigh'],
      instagram: data['instagram'],
      facebook: data['facebook'],
      twitter: data['twitter'],
      buddies: List<String>.from(data['buddies'] ?? []),
      incoming: List<String>.from(data['incoming'] ?? []),
      outgoing: List<String>.from(data['outgoing'] ?? []),
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
        instagram,
        facebook,
        twitter,
        buddies,
        incoming,
        outgoing,
      ];
}
