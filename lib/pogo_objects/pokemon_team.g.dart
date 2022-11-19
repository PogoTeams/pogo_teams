// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon_team.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetUserPokemonTeamCollection on Isar {
  IsarCollection<UserPokemonTeam> get userPokemonTeams => this.collection();
}

const UserPokemonTeamSchema = CollectionSchema(
  name: r'UserPokemonTeam',
  id: 3301490803187761055,
  properties: {
    r'dateCreated': PropertySchema(
      id: 0,
      name: r'dateCreated',
      type: IsarType.dateTime,
    ),
    r'locked': PropertySchema(
      id: 1,
      name: r'locked',
      type: IsarType.bool,
    ),
    r'teamSize': PropertySchema(
      id: 2,
      name: r'teamSize',
      type: IsarType.long,
    )
  },
  estimateSize: _userPokemonTeamEstimateSize,
  serialize: _userPokemonTeamSerialize,
  deserialize: _userPokemonTeamDeserialize,
  deserializeProp: _userPokemonTeamDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'opponents': LinkSchema(
      id: 6438178243853818459,
      name: r'opponents',
      target: r'OpponentPokemonTeam',
      single: false,
    ),
    r'pokemonTeam': LinkSchema(
      id: -8012031155153865455,
      name: r'pokemonTeam',
      target: r'Pokemon',
      single: false,
    ),
    r'cup': LinkSchema(
      id: 2590181316853960452,
      name: r'cup',
      target: r'Cup',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _userPokemonTeamGetId,
  getLinks: _userPokemonTeamGetLinks,
  attach: _userPokemonTeamAttach,
  version: '3.0.2',
);

int _userPokemonTeamEstimateSize(
  UserPokemonTeam object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _userPokemonTeamSerialize(
  UserPokemonTeam object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.dateCreated);
  writer.writeBool(offsets[1], object.locked);
  writer.writeLong(offsets[2], object.teamSize);
}

UserPokemonTeam _userPokemonTeamDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserPokemonTeam();
  object.dateCreated = reader.readDateTimeOrNull(offsets[0]);
  object.id = id;
  object.locked = reader.readBool(offsets[1]);
  object.teamSize = reader.readLong(offsets[2]);
  return object;
}

P _userPokemonTeamDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _userPokemonTeamGetId(UserPokemonTeam object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userPokemonTeamGetLinks(UserPokemonTeam object) {
  return [object.opponents, object.pokemonTeam, object.cup];
}

void _userPokemonTeamAttach(
    IsarCollection<dynamic> col, Id id, UserPokemonTeam object) {
  object.id = id;
  object.opponents.attach(
      col, col.isar.collection<OpponentPokemonTeam>(), r'opponents', id);
  object.pokemonTeam
      .attach(col, col.isar.collection<Pokemon>(), r'pokemonTeam', id);
  object.cup.attach(col, col.isar.collection<Cup>(), r'cup', id);
}

extension UserPokemonTeamQueryWhereSort
    on QueryBuilder<UserPokemonTeam, UserPokemonTeam, QWhere> {
  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension UserPokemonTeamQueryWhere
    on QueryBuilder<UserPokemonTeam, UserPokemonTeam, QWhereClause> {
  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension UserPokemonTeamQueryFilter
    on QueryBuilder<UserPokemonTeam, UserPokemonTeam, QFilterCondition> {
  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterFilterCondition>
      dateCreatedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dateCreated',
      ));
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterFilterCondition>
      dateCreatedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dateCreated',
      ));
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterFilterCondition>
      dateCreatedEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateCreated',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterFilterCondition>
      dateCreatedGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateCreated',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterFilterCondition>
      dateCreatedLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateCreated',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterFilterCondition>
      dateCreatedBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateCreated',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterFilterCondition>
      lockedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'locked',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterFilterCondition>
      teamSizeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'teamSize',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterFilterCondition>
      teamSizeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'teamSize',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterFilterCondition>
      teamSizeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'teamSize',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterFilterCondition>
      teamSizeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'teamSize',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension UserPokemonTeamQueryObject
    on QueryBuilder<UserPokemonTeam, UserPokemonTeam, QFilterCondition> {}

extension UserPokemonTeamQueryLinks
    on QueryBuilder<UserPokemonTeam, UserPokemonTeam, QFilterCondition> {
  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterFilterCondition>
      opponents(FilterQuery<OpponentPokemonTeam> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'opponents');
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterFilterCondition>
      opponentsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'opponents', length, true, length, true);
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterFilterCondition>
      opponentsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'opponents', 0, true, 0, true);
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterFilterCondition>
      opponentsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'opponents', 0, false, 999999, true);
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterFilterCondition>
      opponentsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'opponents', 0, true, length, include);
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterFilterCondition>
      opponentsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'opponents', length, include, 999999, true);
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterFilterCondition>
      opponentsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'opponents', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterFilterCondition>
      pokemonTeam(FilterQuery<Pokemon> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'pokemonTeam');
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterFilterCondition>
      pokemonTeamLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pokemonTeam', length, true, length, true);
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterFilterCondition>
      pokemonTeamIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pokemonTeam', 0, true, 0, true);
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterFilterCondition>
      pokemonTeamIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pokemonTeam', 0, false, 999999, true);
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterFilterCondition>
      pokemonTeamLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pokemonTeam', 0, true, length, include);
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterFilterCondition>
      pokemonTeamLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pokemonTeam', length, include, 999999, true);
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterFilterCondition>
      pokemonTeamLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'pokemonTeam', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterFilterCondition> cup(
      FilterQuery<Cup> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'cup');
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterFilterCondition>
      cupIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'cup', 0, true, 0, true);
    });
  }
}

extension UserPokemonTeamQuerySortBy
    on QueryBuilder<UserPokemonTeam, UserPokemonTeam, QSortBy> {
  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterSortBy>
      sortByDateCreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCreated', Sort.asc);
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterSortBy>
      sortByDateCreatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCreated', Sort.desc);
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterSortBy> sortByLocked() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locked', Sort.asc);
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterSortBy>
      sortByLockedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locked', Sort.desc);
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterSortBy>
      sortByTeamSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teamSize', Sort.asc);
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterSortBy>
      sortByTeamSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teamSize', Sort.desc);
    });
  }
}

extension UserPokemonTeamQuerySortThenBy
    on QueryBuilder<UserPokemonTeam, UserPokemonTeam, QSortThenBy> {
  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterSortBy>
      thenByDateCreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCreated', Sort.asc);
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterSortBy>
      thenByDateCreatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCreated', Sort.desc);
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterSortBy> thenByLocked() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locked', Sort.asc);
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterSortBy>
      thenByLockedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locked', Sort.desc);
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterSortBy>
      thenByTeamSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teamSize', Sort.asc);
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QAfterSortBy>
      thenByTeamSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teamSize', Sort.desc);
    });
  }
}

extension UserPokemonTeamQueryWhereDistinct
    on QueryBuilder<UserPokemonTeam, UserPokemonTeam, QDistinct> {
  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QDistinct>
      distinctByDateCreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateCreated');
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QDistinct> distinctByLocked() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'locked');
    });
  }

  QueryBuilder<UserPokemonTeam, UserPokemonTeam, QDistinct>
      distinctByTeamSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'teamSize');
    });
  }
}

extension UserPokemonTeamQueryProperty
    on QueryBuilder<UserPokemonTeam, UserPokemonTeam, QQueryProperty> {
  QueryBuilder<UserPokemonTeam, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UserPokemonTeam, DateTime?, QQueryOperations>
      dateCreatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateCreated');
    });
  }

  QueryBuilder<UserPokemonTeam, bool, QQueryOperations> lockedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'locked');
    });
  }

  QueryBuilder<UserPokemonTeam, int, QQueryOperations> teamSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'teamSize');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetOpponentPokemonTeamCollection on Isar {
  IsarCollection<OpponentPokemonTeam> get opponentPokemonTeams =>
      this.collection();
}

const OpponentPokemonTeamSchema = CollectionSchema(
  name: r'OpponentPokemonTeam',
  id: -7576224749807174773,
  properties: {
    r'battleOutcome': PropertySchema(
      id: 0,
      name: r'battleOutcome',
      type: IsarType.byte,
      enumMap: _OpponentPokemonTeambattleOutcomeEnumValueMap,
    ),
    r'dateCreated': PropertySchema(
      id: 1,
      name: r'dateCreated',
      type: IsarType.dateTime,
    ),
    r'locked': PropertySchema(
      id: 2,
      name: r'locked',
      type: IsarType.bool,
    ),
    r'teamSize': PropertySchema(
      id: 3,
      name: r'teamSize',
      type: IsarType.long,
    )
  },
  estimateSize: _opponentPokemonTeamEstimateSize,
  serialize: _opponentPokemonTeamSerialize,
  deserialize: _opponentPokemonTeamDeserialize,
  deserializeProp: _opponentPokemonTeamDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'pokemonTeam': LinkSchema(
      id: -2229600348423611808,
      name: r'pokemonTeam',
      target: r'Pokemon',
      single: false,
    ),
    r'cup': LinkSchema(
      id: -5672612436795726436,
      name: r'cup',
      target: r'Cup',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _opponentPokemonTeamGetId,
  getLinks: _opponentPokemonTeamGetLinks,
  attach: _opponentPokemonTeamAttach,
  version: '3.0.2',
);

int _opponentPokemonTeamEstimateSize(
  OpponentPokemonTeam object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _opponentPokemonTeamSerialize(
  OpponentPokemonTeam object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeByte(offsets[0], object.battleOutcome.index);
  writer.writeDateTime(offsets[1], object.dateCreated);
  writer.writeBool(offsets[2], object.locked);
  writer.writeLong(offsets[3], object.teamSize);
}

OpponentPokemonTeam _opponentPokemonTeamDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = OpponentPokemonTeam();
  object.battleOutcome = _OpponentPokemonTeambattleOutcomeValueEnumMap[
          reader.readByteOrNull(offsets[0])] ??
      BattleOutcome.win;
  object.dateCreated = reader.readDateTimeOrNull(offsets[1]);
  object.id = id;
  object.locked = reader.readBool(offsets[2]);
  object.teamSize = reader.readLong(offsets[3]);
  return object;
}

P _opponentPokemonTeamDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (_OpponentPokemonTeambattleOutcomeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          BattleOutcome.win) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _OpponentPokemonTeambattleOutcomeEnumValueMap = {
  'win': 0,
  'loss': 1,
  'tie': 2,
};
const _OpponentPokemonTeambattleOutcomeValueEnumMap = {
  0: BattleOutcome.win,
  1: BattleOutcome.loss,
  2: BattleOutcome.tie,
};

Id _opponentPokemonTeamGetId(OpponentPokemonTeam object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _opponentPokemonTeamGetLinks(
    OpponentPokemonTeam object) {
  return [object.pokemonTeam, object.cup];
}

void _opponentPokemonTeamAttach(
    IsarCollection<dynamic> col, Id id, OpponentPokemonTeam object) {
  object.id = id;
  object.pokemonTeam
      .attach(col, col.isar.collection<Pokemon>(), r'pokemonTeam', id);
  object.cup.attach(col, col.isar.collection<Cup>(), r'cup', id);
}

extension OpponentPokemonTeamQueryWhereSort
    on QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QWhere> {
  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension OpponentPokemonTeamQueryWhere
    on QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QWhereClause> {
  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension OpponentPokemonTeamQueryFilter on QueryBuilder<OpponentPokemonTeam,
    OpponentPokemonTeam, QFilterCondition> {
  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterFilterCondition>
      battleOutcomeEqualTo(BattleOutcome value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'battleOutcome',
        value: value,
      ));
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterFilterCondition>
      battleOutcomeGreaterThan(
    BattleOutcome value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'battleOutcome',
        value: value,
      ));
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterFilterCondition>
      battleOutcomeLessThan(
    BattleOutcome value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'battleOutcome',
        value: value,
      ));
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterFilterCondition>
      battleOutcomeBetween(
    BattleOutcome lower,
    BattleOutcome upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'battleOutcome',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterFilterCondition>
      dateCreatedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dateCreated',
      ));
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterFilterCondition>
      dateCreatedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dateCreated',
      ));
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterFilterCondition>
      dateCreatedEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateCreated',
        value: value,
      ));
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterFilterCondition>
      dateCreatedGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateCreated',
        value: value,
      ));
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterFilterCondition>
      dateCreatedLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateCreated',
        value: value,
      ));
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterFilterCondition>
      dateCreatedBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateCreated',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterFilterCondition>
      lockedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'locked',
        value: value,
      ));
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterFilterCondition>
      teamSizeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'teamSize',
        value: value,
      ));
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterFilterCondition>
      teamSizeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'teamSize',
        value: value,
      ));
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterFilterCondition>
      teamSizeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'teamSize',
        value: value,
      ));
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterFilterCondition>
      teamSizeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'teamSize',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension OpponentPokemonTeamQueryObject on QueryBuilder<OpponentPokemonTeam,
    OpponentPokemonTeam, QFilterCondition> {}

extension OpponentPokemonTeamQueryLinks on QueryBuilder<OpponentPokemonTeam,
    OpponentPokemonTeam, QFilterCondition> {
  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterFilterCondition>
      pokemonTeam(FilterQuery<Pokemon> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'pokemonTeam');
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterFilterCondition>
      pokemonTeamLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pokemonTeam', length, true, length, true);
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterFilterCondition>
      pokemonTeamIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pokemonTeam', 0, true, 0, true);
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterFilterCondition>
      pokemonTeamIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pokemonTeam', 0, false, 999999, true);
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterFilterCondition>
      pokemonTeamLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pokemonTeam', 0, true, length, include);
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterFilterCondition>
      pokemonTeamLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pokemonTeam', length, include, 999999, true);
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterFilterCondition>
      pokemonTeamLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'pokemonTeam', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterFilterCondition>
      cup(FilterQuery<Cup> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'cup');
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterFilterCondition>
      cupIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'cup', 0, true, 0, true);
    });
  }
}

extension OpponentPokemonTeamQuerySortBy
    on QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QSortBy> {
  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterSortBy>
      sortByBattleOutcome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'battleOutcome', Sort.asc);
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterSortBy>
      sortByBattleOutcomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'battleOutcome', Sort.desc);
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterSortBy>
      sortByDateCreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCreated', Sort.asc);
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterSortBy>
      sortByDateCreatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCreated', Sort.desc);
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterSortBy>
      sortByLocked() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locked', Sort.asc);
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterSortBy>
      sortByLockedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locked', Sort.desc);
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterSortBy>
      sortByTeamSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teamSize', Sort.asc);
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterSortBy>
      sortByTeamSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teamSize', Sort.desc);
    });
  }
}

extension OpponentPokemonTeamQuerySortThenBy
    on QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QSortThenBy> {
  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterSortBy>
      thenByBattleOutcome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'battleOutcome', Sort.asc);
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterSortBy>
      thenByBattleOutcomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'battleOutcome', Sort.desc);
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterSortBy>
      thenByDateCreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCreated', Sort.asc);
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterSortBy>
      thenByDateCreatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCreated', Sort.desc);
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterSortBy>
      thenByLocked() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locked', Sort.asc);
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterSortBy>
      thenByLockedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locked', Sort.desc);
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterSortBy>
      thenByTeamSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teamSize', Sort.asc);
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QAfterSortBy>
      thenByTeamSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teamSize', Sort.desc);
    });
  }
}

extension OpponentPokemonTeamQueryWhereDistinct
    on QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QDistinct> {
  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QDistinct>
      distinctByBattleOutcome() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'battleOutcome');
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QDistinct>
      distinctByDateCreated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateCreated');
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QDistinct>
      distinctByLocked() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'locked');
    });
  }

  QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QDistinct>
      distinctByTeamSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'teamSize');
    });
  }
}

extension OpponentPokemonTeamQueryProperty
    on QueryBuilder<OpponentPokemonTeam, OpponentPokemonTeam, QQueryProperty> {
  QueryBuilder<OpponentPokemonTeam, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<OpponentPokemonTeam, BattleOutcome, QQueryOperations>
      battleOutcomeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'battleOutcome');
    });
  }

  QueryBuilder<OpponentPokemonTeam, DateTime?, QQueryOperations>
      dateCreatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateCreated');
    });
  }

  QueryBuilder<OpponentPokemonTeam, bool, QQueryOperations> lockedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'locked');
    });
  }

  QueryBuilder<OpponentPokemonTeam, int, QQueryOperations> teamSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'teamSize');
    });
  }
}
