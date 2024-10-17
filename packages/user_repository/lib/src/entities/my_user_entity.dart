import 'package:equatable/equatable.dart';
import 'package:gym_repository/gym_repository.dart';

class MyUserEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final int? age;
  final String? picture;
  final Gym? gym;
  final String? gender;
  final String? grade;
  final String? description;
  final int? searchGradeLow;
  final int? searchGradeHigh;
  final List<String>? searchGender;
  final int? searchAgeLow;
  final int? searchAgeHigh;
  final String? instagram;
  final String? facebook;
  final String? twitter;
  final List<String>? buddies;
  final List<String>? incoming;
  final List<String>? outgoing;

  const MyUserEntity({
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

  Map<String, Object?> toDocument() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'age': age,
      'picture': picture,
      'gym': gym == null
          ? Gym.empty.toEntity().toDocument()
          : gym!.toEntity().toDocument(),
      'gender': gender,
      'grade': grade,
      'description': description,
      'searchGradeLow': searchGradeLow,
      'searchGradeHigh': searchGradeHigh,
      'searchGender': searchGender,
      'searchAgeLow': searchAgeLow,
      'searchAgeHigh': searchAgeHigh,
      'instagram': instagram,
      'facebook': facebook,
      'twitter': twitter,
      'buddies': buddies,
      'incoming': incoming,
      'outgoing': outgoing,
    };
  }

  static MyUserEntity fromDocument(Map<String, dynamic> doc) {
    List<dynamic>? searchGenderDynamic = doc['searchGender'];
    List<String>? searchGender =
        searchGenderDynamic?.map((value) => value as String).toList();

    List<dynamic>? buddiesDynamic = doc['buddies'];
    List<String>? buddies =
        buddiesDynamic?.map((value) => value as String).toList();

    List<dynamic>? incomingDynamic = doc['incoming'];
    List<String>? incoming =
        incomingDynamic?.map((value) => value as String).toList();

    List<dynamic>? outgoingDynamic = doc['outgoing'];
    List<String>? outgoing =
        outgoingDynamic?.map((value) => value as String).toList();

    return MyUserEntity(
      id: doc['id'] as String,
      email: doc['email'] as String,
      name: doc['name'] as String,
      age: doc['age'] as int?,
      picture: doc['picture'] as String?,
      gym: doc['gym'] == null
          ? Gym.empty
          : Gym.fromEntity(GymEntity.fromDocument(doc['gym'])),
      gender: doc['gender'] as String?,
      grade: doc['grade'] as String?,
      description: doc['description'] as String?,
      searchGradeLow: doc['searchGradeLow'] as int?,
      searchGradeHigh: doc['searchGradeHigh'] as int?,
      searchGender: searchGender,
      searchAgeLow: doc['searchAgeLow'] as int?,
      searchAgeHigh: doc['searchAgeHigh'] as int?,
      instagram: doc['instagram'] as String?,
      facebook: doc['facebook'] as String?,
      twitter: doc['twitter'] as String?,
      buddies: buddies,
      incoming: incoming,
      outgoing: outgoing,
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

  @override
  String toString() {
    return '''UserEntity {
      id: $id
      email: $email
      name: $name
      age: $age
      picture: $picture
      gender: $gender
      grade: $grade
      description: $description
      searchGradeLow: $searchGradeLow
      searchGradeHigh: $searchGradeHigh
      searchGender: ${searchGender.toString()}
      searchAgeLow: $searchAgeLow
      searchAgeHigh: $searchAgeHigh
      instagam: $instagram
      facebook: $facebook
      twitter: $twitter
      buddies: ${buddies.toString()}
      incoming: ${incoming.toString()}
      outgoing: ${outgoing.toString()}
    }''';
  }
}
