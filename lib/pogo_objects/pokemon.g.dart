// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetCupPokemonCollection on Isar {
  IsarCollection<CupPokemon> get cupPokemon => this.collection();
}

const CupPokemonSchema = CollectionSchema(
  name: r'CupPokemon',
  id: -2640610670634422008,
  properties: {
    r'ivs': PropertySchema(
      id: 0,
      name: r'ivs',
      type: IsarType.object,
      target: r'IVs',
    ),
    r'ratings': PropertySchema(
      id: 1,
      name: r'ratings',
      type: IsarType.object,
      target: r'Ratings',
    ),
    r'selectedChargeMoveIds': PropertySchema(
      id: 2,
      name: r'selectedChargeMoveIds',
      type: IsarType.stringList,
    ),
    r'selectedFastMoveId': PropertySchema(
      id: 3,
      name: r'selectedFastMoveId',
      type: IsarType.string,
    )
  },
  estimateSize: _cupPokemonEstimateSize,
  serialize: _cupPokemonSerialize,
  deserialize: _cupPokemonDeserialize,
  deserializeProp: _cupPokemonDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'base': LinkSchema(
      id: -1825544887878624569,
      name: r'base',
      target: r'PokemonBase',
      single: true,
    )
  },
  embeddedSchemas: {r'Ratings': RatingsSchema, r'IVs': IVsSchema},
  getId: _cupPokemonGetId,
  getLinks: _cupPokemonGetLinks,
  attach: _cupPokemonAttach,
  version: '3.0.2',
);

int _cupPokemonEstimateSize(
  CupPokemon object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount +=
      3 + IVsSchema.estimateSize(object.ivs, allOffsets[IVs]!, allOffsets);
  bytesCount += 3 +
      RatingsSchema.estimateSize(
          object.ratings, allOffsets[Ratings]!, allOffsets);
  bytesCount += 3 + object.selectedChargeMoveIds.length * 3;
  {
    for (var i = 0; i < object.selectedChargeMoveIds.length; i++) {
      final value = object.selectedChargeMoveIds[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.selectedFastMoveId.length * 3;
  return bytesCount;
}

void _cupPokemonSerialize(
  CupPokemon object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObject<IVs>(
    offsets[0],
    allOffsets,
    IVsSchema.serialize,
    object.ivs,
  );
  writer.writeObject<Ratings>(
    offsets[1],
    allOffsets,
    RatingsSchema.serialize,
    object.ratings,
  );
  writer.writeStringList(offsets[2], object.selectedChargeMoveIds);
  writer.writeString(offsets[3], object.selectedFastMoveId);
}

CupPokemon _cupPokemonDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CupPokemon(
    ivs: reader.readObjectOrNull<IVs>(
          offsets[0],
          IVsSchema.deserialize,
          allOffsets,
        ) ??
        IVs(),
    ratings: reader.readObjectOrNull<Ratings>(
          offsets[1],
          RatingsSchema.deserialize,
          allOffsets,
        ) ??
        Ratings(),
    selectedChargeMoveIds: reader.readStringList(offsets[2]) ?? [],
    selectedFastMoveId: reader.readString(offsets[3]),
  );
  object.id = id;
  return object;
}

P _cupPokemonDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectOrNull<IVs>(
            offset,
            IVsSchema.deserialize,
            allOffsets,
          ) ??
          IVs()) as P;
    case 1:
      return (reader.readObjectOrNull<Ratings>(
            offset,
            RatingsSchema.deserialize,
            allOffsets,
          ) ??
          Ratings()) as P;
    case 2:
      return (reader.readStringList(offset) ?? []) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _cupPokemonGetId(CupPokemon object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _cupPokemonGetLinks(CupPokemon object) {
  return [object.base];
}

void _cupPokemonAttach(IsarCollection<dynamic> col, Id id, CupPokemon object) {
  object.id = id;
  object.base.attach(col, col.isar.collection<PokemonBase>(), r'base', id);
}

extension CupPokemonQueryWhereSort
    on QueryBuilder<CupPokemon, CupPokemon, QWhere> {
  QueryBuilder<CupPokemon, CupPokemon, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CupPokemonQueryWhere
    on QueryBuilder<CupPokemon, CupPokemon, QWhereClause> {
  QueryBuilder<CupPokemon, CupPokemon, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CupPokemon, CupPokemon, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<CupPokemon, CupPokemon, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CupPokemon, CupPokemon, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CupPokemon, CupPokemon, QAfterWhereClause> idBetween(
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

extension CupPokemonQueryFilter
    on QueryBuilder<CupPokemon, CupPokemon, QFilterCondition> {
  QueryBuilder<CupPokemon, CupPokemon, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CupPokemon, CupPokemon, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<CupPokemon, CupPokemon, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<CupPokemon, CupPokemon, QAfterFilterCondition> idBetween(
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

  QueryBuilder<CupPokemon, CupPokemon, QAfterFilterCondition>
      selectedChargeMoveIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedChargeMoveIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CupPokemon, CupPokemon, QAfterFilterCondition>
      selectedChargeMoveIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'selectedChargeMoveIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CupPokemon, CupPokemon, QAfterFilterCondition>
      selectedChargeMoveIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'selectedChargeMoveIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CupPokemon, CupPokemon, QAfterFilterCondition>
      selectedChargeMoveIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'selectedChargeMoveIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CupPokemon, CupPokemon, QAfterFilterCondition>
      selectedChargeMoveIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'selectedChargeMoveIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CupPokemon, CupPokemon, QAfterFilterCondition>
      selectedChargeMoveIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'selectedChargeMoveIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CupPokemon, CupPokemon, QAfterFilterCondition>
      selectedChargeMoveIdsElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'selectedChargeMoveIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CupPokemon, CupPokemon, QAfterFilterCondition>
      selectedChargeMoveIdsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'selectedChargeMoveIds',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CupPokemon, CupPokemon, QAfterFilterCondition>
      selectedChargeMoveIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedChargeMoveIds',
        value: '',
      ));
    });
  }

  QueryBuilder<CupPokemon, CupPokemon, QAfterFilterCondition>
      selectedChargeMoveIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'selectedChargeMoveIds',
        value: '',
      ));
    });
  }

  QueryBuilder<CupPokemon, CupPokemon, QAfterFilterCondition>
      selectedChargeMoveIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'selectedChargeMoveIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<CupPokemon, CupPokemon, QAfterFilterCondition>
      selectedChargeMoveIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'selectedChargeMoveIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<CupPokemon, CupPokemon, QAfterFilterCondition>
      selectedChargeMoveIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'selectedChargeMoveIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CupPokemon, CupPokemon, QAfterFilterCondition>
      selectedChargeMoveIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'selectedChargeMoveIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<CupPokemon, CupPokemon, QAfterFilterCondition>
      selectedChargeMoveIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'selectedChargeMoveIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CupPokemon, CupPokemon, QAfterFilterCondition>
      selectedChargeMoveIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'selectedChargeMoveIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<CupPokemon, CupPokemon, QAfterFilterCondition>
      selectedFastMoveIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedFastMoveId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CupPokemon, CupPokemon, QAfterFilterCondition>
      selectedFastMoveIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'selectedFastMoveId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CupPokemon, CupPokemon, QAfterFilterCondition>
      selectedFastMoveIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'selectedFastMoveId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CupPokemon, CupPokemon, QAfterFilterCondition>
      selectedFastMoveIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'selectedFastMoveId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CupPokemon, CupPokemon, QAfterFilterCondition>
      selectedFastMoveIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'selectedFastMoveId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CupPokemon, CupPokemon, QAfterFilterCondition>
      selectedFastMoveIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'selectedFastMoveId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CupPokemon, CupPokemon, QAfterFilterCondition>
      selectedFastMoveIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'selectedFastMoveId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CupPokemon, CupPokemon, QAfterFilterCondition>
      selectedFastMoveIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'selectedFastMoveId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CupPokemon, CupPokemon, QAfterFilterCondition>
      selectedFastMoveIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedFastMoveId',
        value: '',
      ));
    });
  }

  QueryBuilder<CupPokemon, CupPokemon, QAfterFilterCondition>
      selectedFastMoveIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'selectedFastMoveId',
        value: '',
      ));
    });
  }
}

extension CupPokemonQueryObject
    on QueryBuilder<CupPokemon, CupPokemon, QFilterCondition> {
  QueryBuilder<CupPokemon, CupPokemon, QAfterFilterCondition> ivs(
      FilterQuery<IVs> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'ivs');
    });
  }

  QueryBuilder<CupPokemon, CupPokemon, QAfterFilterCondition> ratings(
      FilterQuery<Ratings> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'ratings');
    });
  }
}

extension CupPokemonQueryLinks
    on QueryBuilder<CupPokemon, CupPokemon, QFilterCondition> {
  QueryBuilder<CupPokemon, CupPokemon, QAfterFilterCondition> base(
      FilterQuery<PokemonBase> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'base');
    });
  }

  QueryBuilder<CupPokemon, CupPokemon, QAfterFilterCondition> baseIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'base', 0, true, 0, true);
    });
  }
}

extension CupPokemonQuerySortBy
    on QueryBuilder<CupPokemon, CupPokemon, QSortBy> {
  QueryBuilder<CupPokemon, CupPokemon, QAfterSortBy>
      sortBySelectedFastMoveId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedFastMoveId', Sort.asc);
    });
  }

  QueryBuilder<CupPokemon, CupPokemon, QAfterSortBy>
      sortBySelectedFastMoveIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedFastMoveId', Sort.desc);
    });
  }
}

extension CupPokemonQuerySortThenBy
    on QueryBuilder<CupPokemon, CupPokemon, QSortThenBy> {
  QueryBuilder<CupPokemon, CupPokemon, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CupPokemon, CupPokemon, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CupPokemon, CupPokemon, QAfterSortBy>
      thenBySelectedFastMoveId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedFastMoveId', Sort.asc);
    });
  }

  QueryBuilder<CupPokemon, CupPokemon, QAfterSortBy>
      thenBySelectedFastMoveIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedFastMoveId', Sort.desc);
    });
  }
}

extension CupPokemonQueryWhereDistinct
    on QueryBuilder<CupPokemon, CupPokemon, QDistinct> {
  QueryBuilder<CupPokemon, CupPokemon, QDistinct>
      distinctBySelectedChargeMoveIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'selectedChargeMoveIds');
    });
  }

  QueryBuilder<CupPokemon, CupPokemon, QDistinct> distinctBySelectedFastMoveId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'selectedFastMoveId',
          caseSensitive: caseSensitive);
    });
  }
}

extension CupPokemonQueryProperty
    on QueryBuilder<CupPokemon, CupPokemon, QQueryProperty> {
  QueryBuilder<CupPokemon, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CupPokemon, IVs, QQueryOperations> ivsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ivs');
    });
  }

  QueryBuilder<CupPokemon, Ratings, QQueryOperations> ratingsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ratings');
    });
  }

  QueryBuilder<CupPokemon, List<String>, QQueryOperations>
      selectedChargeMoveIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'selectedChargeMoveIds');
    });
  }

  QueryBuilder<CupPokemon, String, QQueryOperations>
      selectedFastMoveIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'selectedFastMoveId');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetUserPokemonCollection on Isar {
  IsarCollection<UserPokemon> get userPokemon => this.collection();
}

const UserPokemonSchema = CollectionSchema(
  name: r'UserPokemon',
  id: -827548934704278659,
  properties: {
    r'ivs': PropertySchema(
      id: 0,
      name: r'ivs',
      type: IsarType.object,
      target: r'IVs',
    ),
    r'ratings': PropertySchema(
      id: 1,
      name: r'ratings',
      type: IsarType.object,
      target: r'Ratings',
    ),
    r'selectedChargeMoveIds': PropertySchema(
      id: 2,
      name: r'selectedChargeMoveIds',
      type: IsarType.stringList,
    ),
    r'selectedFastMoveId': PropertySchema(
      id: 3,
      name: r'selectedFastMoveId',
      type: IsarType.string,
    ),
    r'teamIndex': PropertySchema(
      id: 4,
      name: r'teamIndex',
      type: IsarType.long,
    )
  },
  estimateSize: _userPokemonEstimateSize,
  serialize: _userPokemonSerialize,
  deserialize: _userPokemonDeserialize,
  deserializeProp: _userPokemonDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'base': LinkSchema(
      id: 3357817415598922230,
      name: r'base',
      target: r'PokemonBase',
      single: true,
    )
  },
  embeddedSchemas: {r'Ratings': RatingsSchema, r'IVs': IVsSchema},
  getId: _userPokemonGetId,
  getLinks: _userPokemonGetLinks,
  attach: _userPokemonAttach,
  version: '3.0.2',
);

int _userPokemonEstimateSize(
  UserPokemon object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount +=
      3 + IVsSchema.estimateSize(object.ivs, allOffsets[IVs]!, allOffsets);
  bytesCount += 3 +
      RatingsSchema.estimateSize(
          object.ratings, allOffsets[Ratings]!, allOffsets);
  bytesCount += 3 + object.selectedChargeMoveIds.length * 3;
  {
    for (var i = 0; i < object.selectedChargeMoveIds.length; i++) {
      final value = object.selectedChargeMoveIds[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.selectedFastMoveId.length * 3;
  return bytesCount;
}

void _userPokemonSerialize(
  UserPokemon object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObject<IVs>(
    offsets[0],
    allOffsets,
    IVsSchema.serialize,
    object.ivs,
  );
  writer.writeObject<Ratings>(
    offsets[1],
    allOffsets,
    RatingsSchema.serialize,
    object.ratings,
  );
  writer.writeStringList(offsets[2], object.selectedChargeMoveIds);
  writer.writeString(offsets[3], object.selectedFastMoveId);
  writer.writeLong(offsets[4], object.teamIndex);
}

UserPokemon _userPokemonDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserPokemon(
    ivs: reader.readObjectOrNull<IVs>(
          offsets[0],
          IVsSchema.deserialize,
          allOffsets,
        ) ??
        IVs(),
    ratings: reader.readObjectOrNull<Ratings>(
          offsets[1],
          RatingsSchema.deserialize,
          allOffsets,
        ) ??
        Ratings(),
    selectedChargeMoveIds: reader.readStringList(offsets[2]) ?? [],
    selectedFastMoveId: reader.readString(offsets[3]),
    teamIndex: reader.readLongOrNull(offsets[4]),
  );
  object.id = id;
  return object;
}

P _userPokemonDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectOrNull<IVs>(
            offset,
            IVsSchema.deserialize,
            allOffsets,
          ) ??
          IVs()) as P;
    case 1:
      return (reader.readObjectOrNull<Ratings>(
            offset,
            RatingsSchema.deserialize,
            allOffsets,
          ) ??
          Ratings()) as P;
    case 2:
      return (reader.readStringList(offset) ?? []) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _userPokemonGetId(UserPokemon object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userPokemonGetLinks(UserPokemon object) {
  return [object.base];
}

void _userPokemonAttach(
    IsarCollection<dynamic> col, Id id, UserPokemon object) {
  object.id = id;
  object.base.attach(col, col.isar.collection<PokemonBase>(), r'base', id);
}

extension UserPokemonQueryWhereSort
    on QueryBuilder<UserPokemon, UserPokemon, QWhere> {
  QueryBuilder<UserPokemon, UserPokemon, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension UserPokemonQueryWhere
    on QueryBuilder<UserPokemon, UserPokemon, QWhereClause> {
  QueryBuilder<UserPokemon, UserPokemon, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<UserPokemon, UserPokemon, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterWhereClause> idBetween(
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

extension UserPokemonQueryFilter
    on QueryBuilder<UserPokemon, UserPokemon, QFilterCondition> {
  QueryBuilder<UserPokemon, UserPokemon, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<UserPokemon, UserPokemon, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<UserPokemon, UserPokemon, QAfterFilterCondition> idBetween(
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

  QueryBuilder<UserPokemon, UserPokemon, QAfterFilterCondition>
      selectedChargeMoveIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedChargeMoveIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterFilterCondition>
      selectedChargeMoveIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'selectedChargeMoveIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterFilterCondition>
      selectedChargeMoveIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'selectedChargeMoveIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterFilterCondition>
      selectedChargeMoveIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'selectedChargeMoveIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterFilterCondition>
      selectedChargeMoveIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'selectedChargeMoveIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterFilterCondition>
      selectedChargeMoveIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'selectedChargeMoveIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterFilterCondition>
      selectedChargeMoveIdsElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'selectedChargeMoveIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterFilterCondition>
      selectedChargeMoveIdsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'selectedChargeMoveIds',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterFilterCondition>
      selectedChargeMoveIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedChargeMoveIds',
        value: '',
      ));
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterFilterCondition>
      selectedChargeMoveIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'selectedChargeMoveIds',
        value: '',
      ));
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterFilterCondition>
      selectedChargeMoveIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'selectedChargeMoveIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterFilterCondition>
      selectedChargeMoveIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'selectedChargeMoveIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterFilterCondition>
      selectedChargeMoveIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'selectedChargeMoveIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterFilterCondition>
      selectedChargeMoveIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'selectedChargeMoveIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterFilterCondition>
      selectedChargeMoveIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'selectedChargeMoveIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterFilterCondition>
      selectedChargeMoveIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'selectedChargeMoveIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterFilterCondition>
      selectedFastMoveIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedFastMoveId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterFilterCondition>
      selectedFastMoveIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'selectedFastMoveId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterFilterCondition>
      selectedFastMoveIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'selectedFastMoveId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterFilterCondition>
      selectedFastMoveIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'selectedFastMoveId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterFilterCondition>
      selectedFastMoveIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'selectedFastMoveId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterFilterCondition>
      selectedFastMoveIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'selectedFastMoveId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterFilterCondition>
      selectedFastMoveIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'selectedFastMoveId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterFilterCondition>
      selectedFastMoveIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'selectedFastMoveId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterFilterCondition>
      selectedFastMoveIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedFastMoveId',
        value: '',
      ));
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterFilterCondition>
      selectedFastMoveIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'selectedFastMoveId',
        value: '',
      ));
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterFilterCondition>
      teamIndexIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'teamIndex',
      ));
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterFilterCondition>
      teamIndexIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'teamIndex',
      ));
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterFilterCondition>
      teamIndexEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'teamIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterFilterCondition>
      teamIndexGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'teamIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterFilterCondition>
      teamIndexLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'teamIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterFilterCondition>
      teamIndexBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'teamIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension UserPokemonQueryObject
    on QueryBuilder<UserPokemon, UserPokemon, QFilterCondition> {
  QueryBuilder<UserPokemon, UserPokemon, QAfterFilterCondition> ivs(
      FilterQuery<IVs> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'ivs');
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterFilterCondition> ratings(
      FilterQuery<Ratings> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'ratings');
    });
  }
}

extension UserPokemonQueryLinks
    on QueryBuilder<UserPokemon, UserPokemon, QFilterCondition> {
  QueryBuilder<UserPokemon, UserPokemon, QAfterFilterCondition> base(
      FilterQuery<PokemonBase> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'base');
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterFilterCondition> baseIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'base', 0, true, 0, true);
    });
  }
}

extension UserPokemonQuerySortBy
    on QueryBuilder<UserPokemon, UserPokemon, QSortBy> {
  QueryBuilder<UserPokemon, UserPokemon, QAfterSortBy>
      sortBySelectedFastMoveId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedFastMoveId', Sort.asc);
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterSortBy>
      sortBySelectedFastMoveIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedFastMoveId', Sort.desc);
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterSortBy> sortByTeamIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teamIndex', Sort.asc);
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterSortBy> sortByTeamIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teamIndex', Sort.desc);
    });
  }
}

extension UserPokemonQuerySortThenBy
    on QueryBuilder<UserPokemon, UserPokemon, QSortThenBy> {
  QueryBuilder<UserPokemon, UserPokemon, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterSortBy>
      thenBySelectedFastMoveId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedFastMoveId', Sort.asc);
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterSortBy>
      thenBySelectedFastMoveIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedFastMoveId', Sort.desc);
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterSortBy> thenByTeamIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teamIndex', Sort.asc);
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QAfterSortBy> thenByTeamIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'teamIndex', Sort.desc);
    });
  }
}

extension UserPokemonQueryWhereDistinct
    on QueryBuilder<UserPokemon, UserPokemon, QDistinct> {
  QueryBuilder<UserPokemon, UserPokemon, QDistinct>
      distinctBySelectedChargeMoveIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'selectedChargeMoveIds');
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QDistinct>
      distinctBySelectedFastMoveId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'selectedFastMoveId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserPokemon, UserPokemon, QDistinct> distinctByTeamIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'teamIndex');
    });
  }
}

extension UserPokemonQueryProperty
    on QueryBuilder<UserPokemon, UserPokemon, QQueryProperty> {
  QueryBuilder<UserPokemon, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UserPokemon, IVs, QQueryOperations> ivsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ivs');
    });
  }

  QueryBuilder<UserPokemon, Ratings, QQueryOperations> ratingsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ratings');
    });
  }

  QueryBuilder<UserPokemon, List<String>, QQueryOperations>
      selectedChargeMoveIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'selectedChargeMoveIds');
    });
  }

  QueryBuilder<UserPokemon, String, QQueryOperations>
      selectedFastMoveIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'selectedFastMoveId');
    });
  }

  QueryBuilder<UserPokemon, int?, QQueryOperations> teamIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'teamIndex');
    });
  }
}
