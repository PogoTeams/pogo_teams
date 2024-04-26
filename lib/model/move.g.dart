// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'move.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFastMoveCollection on Isar {
  IsarCollection<FastMove> get fastMoves => this.collection();
}

const FastMoveSchema = CollectionSchema(
  name: r'FastMove',
  id: -831747124440209954,
  properties: {
    r'duration': PropertySchema(
      id: 0,
      name: r'duration',
      type: IsarType.long,
    ),
    r'energyDelta': PropertySchema(
      id: 1,
      name: r'energyDelta',
      type: IsarType.double,
    ),
    r'moveId': PropertySchema(
      id: 2,
      name: r'moveId',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 3,
      name: r'name',
      type: IsarType.string,
    ),
    r'power': PropertySchema(
      id: 4,
      name: r'power',
      type: IsarType.double,
    ),
    r'type': PropertySchema(
      id: 5,
      name: r'type',
      type: IsarType.object,
      target: r'PokemonType',
    )
  },
  estimateSize: _fastMoveEstimateSize,
  serialize: _fastMoveSerialize,
  deserialize: _fastMoveDeserialize,
  deserializeProp: _fastMoveDeserializeProp,
  idName: r'id',
  indexes: {
    r'moveId': IndexSchema(
      id: 7633310754490106230,
      name: r'moveId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'moveId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {r'PokemonType': PokemonTypeSchema},
  getId: _fastMoveGetId,
  getLinks: _fastMoveGetLinks,
  attach: _fastMoveAttach,
  version: '3.1.0+1',
);

int _fastMoveEstimateSize(
  FastMove object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.moveId.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 +
      PokemonTypeSchema.estimateSize(
          object.type, allOffsets[PokemonType]!, allOffsets);
  return bytesCount;
}

void _fastMoveSerialize(
  FastMove object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.duration);
  writer.writeDouble(offsets[1], object.energyDelta);
  writer.writeString(offsets[2], object.moveId);
  writer.writeString(offsets[3], object.name);
  writer.writeDouble(offsets[4], object.power);
  writer.writeObject<PokemonType>(
    offsets[5],
    allOffsets,
    PokemonTypeSchema.serialize,
    object.type,
  );
}

FastMove _fastMoveDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FastMove(
    duration: reader.readLong(offsets[0]),
    energyDelta: reader.readDouble(offsets[1]),
    moveId: reader.readString(offsets[2]),
    name: reader.readString(offsets[3]),
    power: reader.readDouble(offsets[4]),
    type: reader.readObjectOrNull<PokemonType>(
          offsets[5],
          PokemonTypeSchema.deserialize,
          allOffsets,
        ) ??
        PokemonType(),
  );
  object.id = id;
  return object;
}

P _fastMoveDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readObjectOrNull<PokemonType>(
            offset,
            PokemonTypeSchema.deserialize,
            allOffsets,
          ) ??
          PokemonType()) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _fastMoveGetId(FastMove object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _fastMoveGetLinks(FastMove object) {
  return [];
}

void _fastMoveAttach(IsarCollection<dynamic> col, Id id, FastMove object) {
  object.id = id;
}

extension FastMoveByIndex on IsarCollection<FastMove> {
  Future<FastMove?> getByMoveId(String moveId) {
    return getByIndex(r'moveId', [moveId]);
  }

  FastMove? getByMoveIdSync(String moveId) {
    return getByIndexSync(r'moveId', [moveId]);
  }

  Future<bool> deleteByMoveId(String moveId) {
    return deleteByIndex(r'moveId', [moveId]);
  }

  bool deleteByMoveIdSync(String moveId) {
    return deleteByIndexSync(r'moveId', [moveId]);
  }

  Future<List<FastMove?>> getAllByMoveId(List<String> moveIdValues) {
    final values = moveIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'moveId', values);
  }

  List<FastMove?> getAllByMoveIdSync(List<String> moveIdValues) {
    final values = moveIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'moveId', values);
  }

  Future<int> deleteAllByMoveId(List<String> moveIdValues) {
    final values = moveIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'moveId', values);
  }

  int deleteAllByMoveIdSync(List<String> moveIdValues) {
    final values = moveIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'moveId', values);
  }

  Future<Id> putByMoveId(FastMove object) {
    return putByIndex(r'moveId', object);
  }

  Id putByMoveIdSync(FastMove object, {bool saveLinks = true}) {
    return putByIndexSync(r'moveId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByMoveId(List<FastMove> objects) {
    return putAllByIndex(r'moveId', objects);
  }

  List<Id> putAllByMoveIdSync(List<FastMove> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'moveId', objects, saveLinks: saveLinks);
  }
}

extension FastMoveQueryWhereSort on QueryBuilder<FastMove, FastMove, QWhere> {
  QueryBuilder<FastMove, FastMove, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension FastMoveQueryWhere on QueryBuilder<FastMove, FastMove, QWhereClause> {
  QueryBuilder<FastMove, FastMove, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<FastMove, FastMove, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterWhereClause> idBetween(
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

  QueryBuilder<FastMove, FastMove, QAfterWhereClause> moveIdEqualTo(
      String moveId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'moveId',
        value: [moveId],
      ));
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterWhereClause> moveIdNotEqualTo(
      String moveId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'moveId',
              lower: [],
              upper: [moveId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'moveId',
              lower: [moveId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'moveId',
              lower: [moveId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'moveId',
              lower: [],
              upper: [moveId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension FastMoveQueryFilter
    on QueryBuilder<FastMove, FastMove, QFilterCondition> {
  QueryBuilder<FastMove, FastMove, QAfterFilterCondition> durationEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'duration',
        value: value,
      ));
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterFilterCondition> durationGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'duration',
        value: value,
      ));
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterFilterCondition> durationLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'duration',
        value: value,
      ));
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterFilterCondition> durationBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'duration',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterFilterCondition> energyDeltaEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'energyDelta',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterFilterCondition>
      energyDeltaGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'energyDelta',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterFilterCondition> energyDeltaLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'energyDelta',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterFilterCondition> energyDeltaBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'energyDelta',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<FastMove, FastMove, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<FastMove, FastMove, QAfterFilterCondition> idBetween(
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

  QueryBuilder<FastMove, FastMove, QAfterFilterCondition> moveIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'moveId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterFilterCondition> moveIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'moveId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterFilterCondition> moveIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'moveId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterFilterCondition> moveIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'moveId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterFilterCondition> moveIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'moveId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterFilterCondition> moveIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'moveId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterFilterCondition> moveIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'moveId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterFilterCondition> moveIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'moveId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterFilterCondition> moveIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'moveId',
        value: '',
      ));
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterFilterCondition> moveIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'moveId',
        value: '',
      ));
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterFilterCondition> powerEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'power',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterFilterCondition> powerGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'power',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterFilterCondition> powerLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'power',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterFilterCondition> powerBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'power',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension FastMoveQueryObject
    on QueryBuilder<FastMove, FastMove, QFilterCondition> {
  QueryBuilder<FastMove, FastMove, QAfterFilterCondition> type(
      FilterQuery<PokemonType> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'type');
    });
  }
}

extension FastMoveQueryLinks
    on QueryBuilder<FastMove, FastMove, QFilterCondition> {}

extension FastMoveQuerySortBy on QueryBuilder<FastMove, FastMove, QSortBy> {
  QueryBuilder<FastMove, FastMove, QAfterSortBy> sortByDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.asc);
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterSortBy> sortByDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.desc);
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterSortBy> sortByEnergyDelta() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energyDelta', Sort.asc);
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterSortBy> sortByEnergyDeltaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energyDelta', Sort.desc);
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterSortBy> sortByMoveId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moveId', Sort.asc);
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterSortBy> sortByMoveIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moveId', Sort.desc);
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterSortBy> sortByPower() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'power', Sort.asc);
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterSortBy> sortByPowerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'power', Sort.desc);
    });
  }
}

extension FastMoveQuerySortThenBy
    on QueryBuilder<FastMove, FastMove, QSortThenBy> {
  QueryBuilder<FastMove, FastMove, QAfterSortBy> thenByDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.asc);
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterSortBy> thenByDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.desc);
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterSortBy> thenByEnergyDelta() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energyDelta', Sort.asc);
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterSortBy> thenByEnergyDeltaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energyDelta', Sort.desc);
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterSortBy> thenByMoveId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moveId', Sort.asc);
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterSortBy> thenByMoveIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moveId', Sort.desc);
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterSortBy> thenByPower() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'power', Sort.asc);
    });
  }

  QueryBuilder<FastMove, FastMove, QAfterSortBy> thenByPowerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'power', Sort.desc);
    });
  }
}

extension FastMoveQueryWhereDistinct
    on QueryBuilder<FastMove, FastMove, QDistinct> {
  QueryBuilder<FastMove, FastMove, QDistinct> distinctByDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'duration');
    });
  }

  QueryBuilder<FastMove, FastMove, QDistinct> distinctByEnergyDelta() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'energyDelta');
    });
  }

  QueryBuilder<FastMove, FastMove, QDistinct> distinctByMoveId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'moveId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FastMove, FastMove, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FastMove, FastMove, QDistinct> distinctByPower() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'power');
    });
  }
}

extension FastMoveQueryProperty
    on QueryBuilder<FastMove, FastMove, QQueryProperty> {
  QueryBuilder<FastMove, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FastMove, int, QQueryOperations> durationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'duration');
    });
  }

  QueryBuilder<FastMove, double, QQueryOperations> energyDeltaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'energyDelta');
    });
  }

  QueryBuilder<FastMove, String, QQueryOperations> moveIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'moveId');
    });
  }

  QueryBuilder<FastMove, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<FastMove, double, QQueryOperations> powerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'power');
    });
  }

  QueryBuilder<FastMove, PokemonType, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetChargeMoveCollection on Isar {
  IsarCollection<ChargeMove> get chargeMoves => this.collection();
}

const ChargeMoveSchema = CollectionSchema(
  name: r'ChargeMove',
  id: 8492924329088493013,
  properties: {
    r'buffs': PropertySchema(
      id: 0,
      name: r'buffs',
      type: IsarType.object,
      target: r'MoveBuffs',
    ),
    r'energyDelta': PropertySchema(
      id: 1,
      name: r'energyDelta',
      type: IsarType.double,
    ),
    r'moveId': PropertySchema(
      id: 2,
      name: r'moveId',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 3,
      name: r'name',
      type: IsarType.string,
    ),
    r'power': PropertySchema(
      id: 4,
      name: r'power',
      type: IsarType.double,
    ),
    r'type': PropertySchema(
      id: 5,
      name: r'type',
      type: IsarType.object,
      target: r'PokemonType',
    )
  },
  estimateSize: _chargeMoveEstimateSize,
  serialize: _chargeMoveSerialize,
  deserialize: _chargeMoveDeserialize,
  deserializeProp: _chargeMoveDeserializeProp,
  idName: r'id',
  indexes: {
    r'moveId': IndexSchema(
      id: 7633310754490106230,
      name: r'moveId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'moveId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {
    r'MoveBuffs': MoveBuffsSchema,
    r'PokemonType': PokemonTypeSchema
  },
  getId: _chargeMoveGetId,
  getLinks: _chargeMoveGetLinks,
  attach: _chargeMoveAttach,
  version: '3.1.0+1',
);

int _chargeMoveEstimateSize(
  ChargeMove object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.buffs;
    if (value != null) {
      bytesCount += 3 +
          MoveBuffsSchema.estimateSize(
              value, allOffsets[MoveBuffs]!, allOffsets);
    }
  }
  bytesCount += 3 + object.moveId.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 +
      PokemonTypeSchema.estimateSize(
          object.type, allOffsets[PokemonType]!, allOffsets);
  return bytesCount;
}

void _chargeMoveSerialize(
  ChargeMove object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObject<MoveBuffs>(
    offsets[0],
    allOffsets,
    MoveBuffsSchema.serialize,
    object.buffs,
  );
  writer.writeDouble(offsets[1], object.energyDelta);
  writer.writeString(offsets[2], object.moveId);
  writer.writeString(offsets[3], object.name);
  writer.writeDouble(offsets[4], object.power);
  writer.writeObject<PokemonType>(
    offsets[5],
    allOffsets,
    PokemonTypeSchema.serialize,
    object.type,
  );
}

ChargeMove _chargeMoveDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ChargeMove(
    buffs: reader.readObjectOrNull<MoveBuffs>(
      offsets[0],
      MoveBuffsSchema.deserialize,
      allOffsets,
    ),
    energyDelta: reader.readDouble(offsets[1]),
    moveId: reader.readString(offsets[2]),
    name: reader.readString(offsets[3]),
    power: reader.readDouble(offsets[4]),
    type: reader.readObjectOrNull<PokemonType>(
          offsets[5],
          PokemonTypeSchema.deserialize,
          allOffsets,
        ) ??
        PokemonType(),
  );
  object.id = id;
  return object;
}

P _chargeMoveDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectOrNull<MoveBuffs>(
        offset,
        MoveBuffsSchema.deserialize,
        allOffsets,
      )) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readObjectOrNull<PokemonType>(
            offset,
            PokemonTypeSchema.deserialize,
            allOffsets,
          ) ??
          PokemonType()) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _chargeMoveGetId(ChargeMove object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _chargeMoveGetLinks(ChargeMove object) {
  return [];
}

void _chargeMoveAttach(IsarCollection<dynamic> col, Id id, ChargeMove object) {
  object.id = id;
}

extension ChargeMoveByIndex on IsarCollection<ChargeMove> {
  Future<ChargeMove?> getByMoveId(String moveId) {
    return getByIndex(r'moveId', [moveId]);
  }

  ChargeMove? getByMoveIdSync(String moveId) {
    return getByIndexSync(r'moveId', [moveId]);
  }

  Future<bool> deleteByMoveId(String moveId) {
    return deleteByIndex(r'moveId', [moveId]);
  }

  bool deleteByMoveIdSync(String moveId) {
    return deleteByIndexSync(r'moveId', [moveId]);
  }

  Future<List<ChargeMove?>> getAllByMoveId(List<String> moveIdValues) {
    final values = moveIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'moveId', values);
  }

  List<ChargeMove?> getAllByMoveIdSync(List<String> moveIdValues) {
    final values = moveIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'moveId', values);
  }

  Future<int> deleteAllByMoveId(List<String> moveIdValues) {
    final values = moveIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'moveId', values);
  }

  int deleteAllByMoveIdSync(List<String> moveIdValues) {
    final values = moveIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'moveId', values);
  }

  Future<Id> putByMoveId(ChargeMove object) {
    return putByIndex(r'moveId', object);
  }

  Id putByMoveIdSync(ChargeMove object, {bool saveLinks = true}) {
    return putByIndexSync(r'moveId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByMoveId(List<ChargeMove> objects) {
    return putAllByIndex(r'moveId', objects);
  }

  List<Id> putAllByMoveIdSync(List<ChargeMove> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'moveId', objects, saveLinks: saveLinks);
  }
}

extension ChargeMoveQueryWhereSort
    on QueryBuilder<ChargeMove, ChargeMove, QWhere> {
  QueryBuilder<ChargeMove, ChargeMove, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ChargeMoveQueryWhere
    on QueryBuilder<ChargeMove, ChargeMove, QWhereClause> {
  QueryBuilder<ChargeMove, ChargeMove, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<ChargeMove, ChargeMove, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterWhereClause> idBetween(
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

  QueryBuilder<ChargeMove, ChargeMove, QAfterWhereClause> moveIdEqualTo(
      String moveId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'moveId',
        value: [moveId],
      ));
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterWhereClause> moveIdNotEqualTo(
      String moveId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'moveId',
              lower: [],
              upper: [moveId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'moveId',
              lower: [moveId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'moveId',
              lower: [moveId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'moveId',
              lower: [],
              upper: [moveId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension ChargeMoveQueryFilter
    on QueryBuilder<ChargeMove, ChargeMove, QFilterCondition> {
  QueryBuilder<ChargeMove, ChargeMove, QAfterFilterCondition> buffsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'buffs',
      ));
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterFilterCondition> buffsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'buffs',
      ));
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterFilterCondition>
      energyDeltaEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'energyDelta',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterFilterCondition>
      energyDeltaGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'energyDelta',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterFilterCondition>
      energyDeltaLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'energyDelta',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterFilterCondition>
      energyDeltaBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'energyDelta',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<ChargeMove, ChargeMove, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ChargeMove, ChargeMove, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ChargeMove, ChargeMove, QAfterFilterCondition> moveIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'moveId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterFilterCondition> moveIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'moveId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterFilterCondition> moveIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'moveId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterFilterCondition> moveIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'moveId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterFilterCondition> moveIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'moveId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterFilterCondition> moveIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'moveId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterFilterCondition> moveIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'moveId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterFilterCondition> moveIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'moveId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterFilterCondition> moveIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'moveId',
        value: '',
      ));
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterFilterCondition>
      moveIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'moveId',
        value: '',
      ));
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterFilterCondition> powerEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'power',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterFilterCondition> powerGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'power',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterFilterCondition> powerLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'power',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterFilterCondition> powerBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'power',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension ChargeMoveQueryObject
    on QueryBuilder<ChargeMove, ChargeMove, QFilterCondition> {
  QueryBuilder<ChargeMove, ChargeMove, QAfterFilterCondition> buffs(
      FilterQuery<MoveBuffs> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'buffs');
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterFilterCondition> type(
      FilterQuery<PokemonType> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'type');
    });
  }
}

extension ChargeMoveQueryLinks
    on QueryBuilder<ChargeMove, ChargeMove, QFilterCondition> {}

extension ChargeMoveQuerySortBy
    on QueryBuilder<ChargeMove, ChargeMove, QSortBy> {
  QueryBuilder<ChargeMove, ChargeMove, QAfterSortBy> sortByEnergyDelta() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energyDelta', Sort.asc);
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterSortBy> sortByEnergyDeltaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energyDelta', Sort.desc);
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterSortBy> sortByMoveId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moveId', Sort.asc);
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterSortBy> sortByMoveIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moveId', Sort.desc);
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterSortBy> sortByPower() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'power', Sort.asc);
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterSortBy> sortByPowerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'power', Sort.desc);
    });
  }
}

extension ChargeMoveQuerySortThenBy
    on QueryBuilder<ChargeMove, ChargeMove, QSortThenBy> {
  QueryBuilder<ChargeMove, ChargeMove, QAfterSortBy> thenByEnergyDelta() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energyDelta', Sort.asc);
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterSortBy> thenByEnergyDeltaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energyDelta', Sort.desc);
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterSortBy> thenByMoveId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moveId', Sort.asc);
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterSortBy> thenByMoveIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moveId', Sort.desc);
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterSortBy> thenByPower() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'power', Sort.asc);
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QAfterSortBy> thenByPowerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'power', Sort.desc);
    });
  }
}

extension ChargeMoveQueryWhereDistinct
    on QueryBuilder<ChargeMove, ChargeMove, QDistinct> {
  QueryBuilder<ChargeMove, ChargeMove, QDistinct> distinctByEnergyDelta() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'energyDelta');
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QDistinct> distinctByMoveId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'moveId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChargeMove, ChargeMove, QDistinct> distinctByPower() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'power');
    });
  }
}

extension ChargeMoveQueryProperty
    on QueryBuilder<ChargeMove, ChargeMove, QQueryProperty> {
  QueryBuilder<ChargeMove, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ChargeMove, MoveBuffs?, QQueryOperations> buffsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'buffs');
    });
  }

  QueryBuilder<ChargeMove, double, QQueryOperations> energyDeltaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'energyDelta');
    });
  }

  QueryBuilder<ChargeMove, String, QQueryOperations> moveIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'moveId');
    });
  }

  QueryBuilder<ChargeMove, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<ChargeMove, double, QQueryOperations> powerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'power');
    });
  }

  QueryBuilder<ChargeMove, PokemonType, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const MoveBuffsSchema = Schema(
  name: r'MoveBuffs',
  id: 4434465768057810202,
  properties: {
    r'chance': PropertySchema(
      id: 0,
      name: r'chance',
      type: IsarType.double,
    ),
    r'opponentAttack': PropertySchema(
      id: 1,
      name: r'opponentAttack',
      type: IsarType.long,
    ),
    r'opponentDefense': PropertySchema(
      id: 2,
      name: r'opponentDefense',
      type: IsarType.long,
    ),
    r'selfAttack': PropertySchema(
      id: 3,
      name: r'selfAttack',
      type: IsarType.long,
    ),
    r'selfDefense': PropertySchema(
      id: 4,
      name: r'selfDefense',
      type: IsarType.long,
    )
  },
  estimateSize: _moveBuffsEstimateSize,
  serialize: _moveBuffsSerialize,
  deserialize: _moveBuffsDeserialize,
  deserializeProp: _moveBuffsDeserializeProp,
);

int _moveBuffsEstimateSize(
  MoveBuffs object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _moveBuffsSerialize(
  MoveBuffs object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.chance);
  writer.writeLong(offsets[1], object.opponentAttack);
  writer.writeLong(offsets[2], object.opponentDefense);
  writer.writeLong(offsets[3], object.selfAttack);
  writer.writeLong(offsets[4], object.selfDefense);
}

MoveBuffs _moveBuffsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MoveBuffs(
    chance: reader.readDoubleOrNull(offsets[0]) ?? 0,
    opponentAttack: reader.readLongOrNull(offsets[1]),
    opponentDefense: reader.readLongOrNull(offsets[2]),
    selfAttack: reader.readLongOrNull(offsets[3]),
    selfDefense: reader.readLongOrNull(offsets[4]),
  );
  return object;
}

P _moveBuffsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDoubleOrNull(offset) ?? 0) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension MoveBuffsQueryFilter
    on QueryBuilder<MoveBuffs, MoveBuffs, QFilterCondition> {
  QueryBuilder<MoveBuffs, MoveBuffs, QAfterFilterCondition> chanceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MoveBuffs, MoveBuffs, QAfterFilterCondition> chanceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MoveBuffs, MoveBuffs, QAfterFilterCondition> chanceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MoveBuffs, MoveBuffs, QAfterFilterCondition> chanceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MoveBuffs, MoveBuffs, QAfterFilterCondition>
      opponentAttackIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'opponentAttack',
      ));
    });
  }

  QueryBuilder<MoveBuffs, MoveBuffs, QAfterFilterCondition>
      opponentAttackIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'opponentAttack',
      ));
    });
  }

  QueryBuilder<MoveBuffs, MoveBuffs, QAfterFilterCondition>
      opponentAttackEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'opponentAttack',
        value: value,
      ));
    });
  }

  QueryBuilder<MoveBuffs, MoveBuffs, QAfterFilterCondition>
      opponentAttackGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'opponentAttack',
        value: value,
      ));
    });
  }

  QueryBuilder<MoveBuffs, MoveBuffs, QAfterFilterCondition>
      opponentAttackLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'opponentAttack',
        value: value,
      ));
    });
  }

  QueryBuilder<MoveBuffs, MoveBuffs, QAfterFilterCondition>
      opponentAttackBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'opponentAttack',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MoveBuffs, MoveBuffs, QAfterFilterCondition>
      opponentDefenseIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'opponentDefense',
      ));
    });
  }

  QueryBuilder<MoveBuffs, MoveBuffs, QAfterFilterCondition>
      opponentDefenseIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'opponentDefense',
      ));
    });
  }

  QueryBuilder<MoveBuffs, MoveBuffs, QAfterFilterCondition>
      opponentDefenseEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'opponentDefense',
        value: value,
      ));
    });
  }

  QueryBuilder<MoveBuffs, MoveBuffs, QAfterFilterCondition>
      opponentDefenseGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'opponentDefense',
        value: value,
      ));
    });
  }

  QueryBuilder<MoveBuffs, MoveBuffs, QAfterFilterCondition>
      opponentDefenseLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'opponentDefense',
        value: value,
      ));
    });
  }

  QueryBuilder<MoveBuffs, MoveBuffs, QAfterFilterCondition>
      opponentDefenseBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'opponentDefense',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MoveBuffs, MoveBuffs, QAfterFilterCondition> selfAttackIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'selfAttack',
      ));
    });
  }

  QueryBuilder<MoveBuffs, MoveBuffs, QAfterFilterCondition>
      selfAttackIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'selfAttack',
      ));
    });
  }

  QueryBuilder<MoveBuffs, MoveBuffs, QAfterFilterCondition> selfAttackEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selfAttack',
        value: value,
      ));
    });
  }

  QueryBuilder<MoveBuffs, MoveBuffs, QAfterFilterCondition>
      selfAttackGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'selfAttack',
        value: value,
      ));
    });
  }

  QueryBuilder<MoveBuffs, MoveBuffs, QAfterFilterCondition> selfAttackLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'selfAttack',
        value: value,
      ));
    });
  }

  QueryBuilder<MoveBuffs, MoveBuffs, QAfterFilterCondition> selfAttackBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'selfAttack',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MoveBuffs, MoveBuffs, QAfterFilterCondition>
      selfDefenseIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'selfDefense',
      ));
    });
  }

  QueryBuilder<MoveBuffs, MoveBuffs, QAfterFilterCondition>
      selfDefenseIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'selfDefense',
      ));
    });
  }

  QueryBuilder<MoveBuffs, MoveBuffs, QAfterFilterCondition> selfDefenseEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selfDefense',
        value: value,
      ));
    });
  }

  QueryBuilder<MoveBuffs, MoveBuffs, QAfterFilterCondition>
      selfDefenseGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'selfDefense',
        value: value,
      ));
    });
  }

  QueryBuilder<MoveBuffs, MoveBuffs, QAfterFilterCondition> selfDefenseLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'selfDefense',
        value: value,
      ));
    });
  }

  QueryBuilder<MoveBuffs, MoveBuffs, QAfterFilterCondition> selfDefenseBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'selfDefense',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MoveBuffsQueryObject
    on QueryBuilder<MoveBuffs, MoveBuffs, QFilterCondition> {}
