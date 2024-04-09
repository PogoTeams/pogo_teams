// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon_base.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPokemonBaseCollection on Isar {
  IsarCollection<PokemonBase> get basePokemon => this.collection();
}

const PokemonBaseSchema = CollectionSchema(
  name: r'PokemonBase',
  id: 1418361674229093595,
  properties: {
    r'dex': PropertySchema(
      id: 0,
      name: r'dex',
      type: IsarType.long,
    ),
    r'eliteChargeMoveIds': PropertySchema(
      id: 1,
      name: r'eliteChargeMoveIds',
      type: IsarType.stringList,
    ),
    r'eliteFastMoveIds': PropertySchema(
      id: 2,
      name: r'eliteFastMoveIds',
      type: IsarType.stringList,
    ),
    r'familyId': PropertySchema(
      id: 3,
      name: r'familyId',
      type: IsarType.string,
    ),
    r'form': PropertySchema(
      id: 4,
      name: r'form',
      type: IsarType.string,
    ),
    r'greatLeagueIVs': PropertySchema(
      id: 5,
      name: r'greatLeagueIVs',
      type: IsarType.object,
      target: r'IVs',
    ),
    r'littleCupIVs': PropertySchema(
      id: 6,
      name: r'littleCupIVs',
      type: IsarType.object,
      target: r'IVs',
    ),
    r'name': PropertySchema(
      id: 7,
      name: r'name',
      type: IsarType.string,
    ),
    r'pokemonId': PropertySchema(
      id: 8,
      name: r'pokemonId',
      type: IsarType.string,
    ),
    r'released': PropertySchema(
      id: 9,
      name: r'released',
      type: IsarType.bool,
    ),
    r'shadow': PropertySchema(
      id: 10,
      name: r'shadow',
      type: IsarType.object,
      target: r'Shadow',
    ),
    r'stats': PropertySchema(
      id: 11,
      name: r'stats',
      type: IsarType.object,
      target: r'BaseStats',
    ),
    r'tags': PropertySchema(
      id: 12,
      name: r'tags',
      type: IsarType.stringList,
    ),
    r'thirdMoveCost': PropertySchema(
      id: 13,
      name: r'thirdMoveCost',
      type: IsarType.object,
      target: r'ThirdMoveCost',
    ),
    r'typing': PropertySchema(
      id: 14,
      name: r'typing',
      type: IsarType.object,
      target: r'PokemonTyping',
    ),
    r'ultraLeagueIVs': PropertySchema(
      id: 15,
      name: r'ultraLeagueIVs',
      type: IsarType.object,
      target: r'IVs',
    )
  },
  estimateSize: _pokemonBaseEstimateSize,
  serialize: _pokemonBaseSerialize,
  deserialize: _pokemonBaseDeserialize,
  deserializeProp: _pokemonBaseDeserializeProp,
  idName: r'id',
  indexes: {
    r'pokemonId': IndexSchema(
      id: -2962037729536387078,
      name: r'pokemonId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'pokemonId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {
    r'fastMoves': LinkSchema(
      id: 8307447581083026355,
      name: r'fastMoves',
      target: r'FastMove',
      single: false,
    ),
    r'chargeMoves': LinkSchema(
      id: 3820251875354933866,
      name: r'chargeMoves',
      target: r'ChargeMove',
      single: false,
    ),
    r'evolutions': LinkSchema(
      id: -6470045320599214270,
      name: r'evolutions',
      target: r'Evolution',
      single: false,
    ),
    r'tempEvolutions': LinkSchema(
      id: 6126781498058541671,
      name: r'tempEvolutions',
      target: r'TempEvolution',
      single: false,
    )
  },
  embeddedSchemas: {
    r'PokemonTyping': PokemonTypingSchema,
    r'PokemonType': PokemonTypeSchema,
    r'BaseStats': BaseStatsSchema,
    r'ThirdMoveCost': ThirdMoveCostSchema,
    r'Shadow': ShadowSchema,
    r'IVs': IVsSchema
  },
  getId: _pokemonBaseGetId,
  getLinks: _pokemonBaseGetLinks,
  attach: _pokemonBaseAttach,
  version: '3.1.0+1',
);

int _pokemonBaseEstimateSize(
  PokemonBase object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final list = object.eliteChargeMoveIds;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final list = object.eliteFastMoveIds;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  bytesCount += 3 + object.familyId.length * 3;
  bytesCount += 3 + object.form.length * 3;
  {
    final value = object.greatLeagueIVs;
    if (value != null) {
      bytesCount +=
          3 + IVsSchema.estimateSize(value, allOffsets[IVs]!, allOffsets);
    }
  }
  {
    final value = object.littleCupIVs;
    if (value != null) {
      bytesCount +=
          3 + IVsSchema.estimateSize(value, allOffsets[IVs]!, allOffsets);
    }
  }
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.pokemonId.length * 3;
  {
    final value = object.shadow;
    if (value != null) {
      bytesCount +=
          3 + ShadowSchema.estimateSize(value, allOffsets[Shadow]!, allOffsets);
    }
  }
  bytesCount += 3 +
      BaseStatsSchema.estimateSize(
          object.stats, allOffsets[BaseStats]!, allOffsets);
  {
    final list = object.tags;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final value = object.thirdMoveCost;
    if (value != null) {
      bytesCount += 3 +
          ThirdMoveCostSchema.estimateSize(
              value, allOffsets[ThirdMoveCost]!, allOffsets);
    }
  }
  bytesCount += 3 +
      PokemonTypingSchema.estimateSize(
          object.typing, allOffsets[PokemonTyping]!, allOffsets);
  {
    final value = object.ultraLeagueIVs;
    if (value != null) {
      bytesCount +=
          3 + IVsSchema.estimateSize(value, allOffsets[IVs]!, allOffsets);
    }
  }
  return bytesCount;
}

void _pokemonBaseSerialize(
  PokemonBase object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.dex);
  writer.writeStringList(offsets[1], object.eliteChargeMoveIds);
  writer.writeStringList(offsets[2], object.eliteFastMoveIds);
  writer.writeString(offsets[3], object.familyId);
  writer.writeString(offsets[4], object.form);
  writer.writeObject<IVs>(
    offsets[5],
    allOffsets,
    IVsSchema.serialize,
    object.greatLeagueIVs,
  );
  writer.writeObject<IVs>(
    offsets[6],
    allOffsets,
    IVsSchema.serialize,
    object.littleCupIVs,
  );
  writer.writeString(offsets[7], object.name);
  writer.writeString(offsets[8], object.pokemonId);
  writer.writeBool(offsets[9], object.released);
  writer.writeObject<Shadow>(
    offsets[10],
    allOffsets,
    ShadowSchema.serialize,
    object.shadow,
  );
  writer.writeObject<BaseStats>(
    offsets[11],
    allOffsets,
    BaseStatsSchema.serialize,
    object.stats,
  );
  writer.writeStringList(offsets[12], object.tags);
  writer.writeObject<ThirdMoveCost>(
    offsets[13],
    allOffsets,
    ThirdMoveCostSchema.serialize,
    object.thirdMoveCost,
  );
  writer.writeObject<PokemonTyping>(
    offsets[14],
    allOffsets,
    PokemonTypingSchema.serialize,
    object.typing,
  );
  writer.writeObject<IVs>(
    offsets[15],
    allOffsets,
    IVsSchema.serialize,
    object.ultraLeagueIVs,
  );
}

PokemonBase _pokemonBaseDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PokemonBase(
    dex: reader.readLong(offsets[0]),
    eliteChargeMoveIds: reader.readStringList(offsets[1]),
    eliteFastMoveIds: reader.readStringList(offsets[2]),
    familyId: reader.readString(offsets[3]),
    form: reader.readString(offsets[4]),
    greatLeagueIVs: reader.readObjectOrNull<IVs>(
      offsets[5],
      IVsSchema.deserialize,
      allOffsets,
    ),
    littleCupIVs: reader.readObjectOrNull<IVs>(
      offsets[6],
      IVsSchema.deserialize,
      allOffsets,
    ),
    name: reader.readString(offsets[7]),
    pokemonId: reader.readString(offsets[8]),
    released: reader.readBool(offsets[9]),
    shadow: reader.readObjectOrNull<Shadow>(
      offsets[10],
      ShadowSchema.deserialize,
      allOffsets,
    ),
    stats: reader.readObjectOrNull<BaseStats>(
          offsets[11],
          BaseStatsSchema.deserialize,
          allOffsets,
        ) ??
        BaseStats(),
    tags: reader.readStringList(offsets[12]),
    thirdMoveCost: reader.readObjectOrNull<ThirdMoveCost>(
      offsets[13],
      ThirdMoveCostSchema.deserialize,
      allOffsets,
    ),
    typing: reader.readObjectOrNull<PokemonTyping>(
          offsets[14],
          PokemonTypingSchema.deserialize,
          allOffsets,
        ) ??
        PokemonTyping(),
    ultraLeagueIVs: reader.readObjectOrNull<IVs>(
      offsets[15],
      IVsSchema.deserialize,
      allOffsets,
    ),
  );
  object.id = id;
  return object;
}

P _pokemonBaseDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readStringList(offset)) as P;
    case 2:
      return (reader.readStringList(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readObjectOrNull<IVs>(
        offset,
        IVsSchema.deserialize,
        allOffsets,
      )) as P;
    case 6:
      return (reader.readObjectOrNull<IVs>(
        offset,
        IVsSchema.deserialize,
        allOffsets,
      )) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readObjectOrNull<Shadow>(
        offset,
        ShadowSchema.deserialize,
        allOffsets,
      )) as P;
    case 11:
      return (reader.readObjectOrNull<BaseStats>(
            offset,
            BaseStatsSchema.deserialize,
            allOffsets,
          ) ??
          BaseStats()) as P;
    case 12:
      return (reader.readStringList(offset)) as P;
    case 13:
      return (reader.readObjectOrNull<ThirdMoveCost>(
        offset,
        ThirdMoveCostSchema.deserialize,
        allOffsets,
      )) as P;
    case 14:
      return (reader.readObjectOrNull<PokemonTyping>(
            offset,
            PokemonTypingSchema.deserialize,
            allOffsets,
          ) ??
          PokemonTyping()) as P;
    case 15:
      return (reader.readObjectOrNull<IVs>(
        offset,
        IVsSchema.deserialize,
        allOffsets,
      )) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _pokemonBaseGetId(PokemonBase object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _pokemonBaseGetLinks(PokemonBase object) {
  return [
    object.fastMoves,
    object.chargeMoves,
    object.evolutions,
    object.tempEvolutions
  ];
}

void _pokemonBaseAttach(
    IsarCollection<dynamic> col, Id id, PokemonBase object) {
  object.id = id;
  object.fastMoves
      .attach(col, col.isar.collection<FastMove>(), r'fastMoves', id);
  object.chargeMoves
      .attach(col, col.isar.collection<ChargeMove>(), r'chargeMoves', id);
  object.evolutions
      .attach(col, col.isar.collection<Evolution>(), r'evolutions', id);
  object.tempEvolutions
      .attach(col, col.isar.collection<TempEvolution>(), r'tempEvolutions', id);
}

extension PokemonBaseByIndex on IsarCollection<PokemonBase> {
  Future<PokemonBase?> getByPokemonId(String pokemonId) {
    return getByIndex(r'pokemonId', [pokemonId]);
  }

  PokemonBase? getByPokemonIdSync(String pokemonId) {
    return getByIndexSync(r'pokemonId', [pokemonId]);
  }

  Future<bool> deleteByPokemonId(String pokemonId) {
    return deleteByIndex(r'pokemonId', [pokemonId]);
  }

  bool deleteByPokemonIdSync(String pokemonId) {
    return deleteByIndexSync(r'pokemonId', [pokemonId]);
  }

  Future<List<PokemonBase?>> getAllByPokemonId(List<String> pokemonIdValues) {
    final values = pokemonIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'pokemonId', values);
  }

  List<PokemonBase?> getAllByPokemonIdSync(List<String> pokemonIdValues) {
    final values = pokemonIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'pokemonId', values);
  }

  Future<int> deleteAllByPokemonId(List<String> pokemonIdValues) {
    final values = pokemonIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'pokemonId', values);
  }

  int deleteAllByPokemonIdSync(List<String> pokemonIdValues) {
    final values = pokemonIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'pokemonId', values);
  }

  Future<Id> putByPokemonId(PokemonBase object) {
    return putByIndex(r'pokemonId', object);
  }

  Id putByPokemonIdSync(PokemonBase object, {bool saveLinks = true}) {
    return putByIndexSync(r'pokemonId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByPokemonId(List<PokemonBase> objects) {
    return putAllByIndex(r'pokemonId', objects);
  }

  List<Id> putAllByPokemonIdSync(List<PokemonBase> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'pokemonId', objects, saveLinks: saveLinks);
  }
}

extension PokemonBaseQueryWhereSort
    on QueryBuilder<PokemonBase, PokemonBase, QWhere> {
  QueryBuilder<PokemonBase, PokemonBase, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PokemonBaseQueryWhere
    on QueryBuilder<PokemonBase, PokemonBase, QWhereClause> {
  QueryBuilder<PokemonBase, PokemonBase, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<PokemonBase, PokemonBase, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterWhereClause> idBetween(
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

  QueryBuilder<PokemonBase, PokemonBase, QAfterWhereClause> pokemonIdEqualTo(
      String pokemonId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'pokemonId',
        value: [pokemonId],
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterWhereClause> pokemonIdNotEqualTo(
      String pokemonId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'pokemonId',
              lower: [],
              upper: [pokemonId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'pokemonId',
              lower: [pokemonId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'pokemonId',
              lower: [pokemonId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'pokemonId',
              lower: [],
              upper: [pokemonId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension PokemonBaseQueryFilter
    on QueryBuilder<PokemonBase, PokemonBase, QFilterCondition> {
  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition> dexEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dex',
        value: value,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition> dexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dex',
        value: value,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition> dexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dex',
        value: value,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition> dexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      eliteChargeMoveIdsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'eliteChargeMoveIds',
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      eliteChargeMoveIdsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'eliteChargeMoveIds',
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      eliteChargeMoveIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eliteChargeMoveIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      eliteChargeMoveIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'eliteChargeMoveIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      eliteChargeMoveIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'eliteChargeMoveIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      eliteChargeMoveIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'eliteChargeMoveIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      eliteChargeMoveIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'eliteChargeMoveIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      eliteChargeMoveIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'eliteChargeMoveIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      eliteChargeMoveIdsElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'eliteChargeMoveIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      eliteChargeMoveIdsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'eliteChargeMoveIds',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      eliteChargeMoveIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eliteChargeMoveIds',
        value: '',
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      eliteChargeMoveIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'eliteChargeMoveIds',
        value: '',
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      eliteChargeMoveIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'eliteChargeMoveIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      eliteChargeMoveIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'eliteChargeMoveIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      eliteChargeMoveIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'eliteChargeMoveIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      eliteChargeMoveIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'eliteChargeMoveIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      eliteChargeMoveIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'eliteChargeMoveIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      eliteChargeMoveIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'eliteChargeMoveIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      eliteFastMoveIdsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'eliteFastMoveIds',
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      eliteFastMoveIdsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'eliteFastMoveIds',
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      eliteFastMoveIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eliteFastMoveIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      eliteFastMoveIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'eliteFastMoveIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      eliteFastMoveIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'eliteFastMoveIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      eliteFastMoveIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'eliteFastMoveIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      eliteFastMoveIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'eliteFastMoveIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      eliteFastMoveIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'eliteFastMoveIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      eliteFastMoveIdsElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'eliteFastMoveIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      eliteFastMoveIdsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'eliteFastMoveIds',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      eliteFastMoveIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eliteFastMoveIds',
        value: '',
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      eliteFastMoveIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'eliteFastMoveIds',
        value: '',
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      eliteFastMoveIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'eliteFastMoveIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      eliteFastMoveIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'eliteFastMoveIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      eliteFastMoveIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'eliteFastMoveIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      eliteFastMoveIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'eliteFastMoveIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      eliteFastMoveIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'eliteFastMoveIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      eliteFastMoveIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'eliteFastMoveIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition> familyIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'familyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      familyIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'familyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      familyIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'familyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition> familyIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'familyId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      familyIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'familyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      familyIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'familyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      familyIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'familyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition> familyIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'familyId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      familyIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'familyId',
        value: '',
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      familyIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'familyId',
        value: '',
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition> formEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'form',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition> formGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'form',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition> formLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'form',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition> formBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'form',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition> formStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'form',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition> formEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'form',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition> formContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'form',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition> formMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'form',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition> formIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'form',
        value: '',
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      formIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'form',
        value: '',
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      greatLeagueIVsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'greatLeagueIVs',
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      greatLeagueIVsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'greatLeagueIVs',
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition> idBetween(
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

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      littleCupIVsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'littleCupIVs',
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      littleCupIVsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'littleCupIVs',
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition> nameContains(
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

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition> nameMatches(
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

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      pokemonIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pokemonId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      pokemonIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pokemonId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      pokemonIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pokemonId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      pokemonIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pokemonId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      pokemonIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pokemonId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      pokemonIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pokemonId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      pokemonIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pokemonId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      pokemonIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pokemonId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      pokemonIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pokemonId',
        value: '',
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      pokemonIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pokemonId',
        value: '',
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition> releasedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'released',
        value: value,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition> shadowIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'shadow',
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      shadowIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'shadow',
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition> tagsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'tags',
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      tagsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'tags',
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      tagsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      tagsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      tagsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      tagsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tags',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      tagsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      tagsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      tagsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      tagsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tags',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      tagsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tags',
        value: '',
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      tagsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tags',
        value: '',
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      tagsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition> tagsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      tagsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      tagsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      tagsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      tagsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      thirdMoveCostIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'thirdMoveCost',
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      thirdMoveCostIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'thirdMoveCost',
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      ultraLeagueIVsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'ultraLeagueIVs',
      ));
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      ultraLeagueIVsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'ultraLeagueIVs',
      ));
    });
  }
}

extension PokemonBaseQueryObject
    on QueryBuilder<PokemonBase, PokemonBase, QFilterCondition> {
  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition> greatLeagueIVs(
      FilterQuery<IVs> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'greatLeagueIVs');
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition> littleCupIVs(
      FilterQuery<IVs> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'littleCupIVs');
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition> shadow(
      FilterQuery<Shadow> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'shadow');
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition> stats(
      FilterQuery<BaseStats> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'stats');
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition> thirdMoveCost(
      FilterQuery<ThirdMoveCost> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'thirdMoveCost');
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition> typing(
      FilterQuery<PokemonTyping> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'typing');
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition> ultraLeagueIVs(
      FilterQuery<IVs> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'ultraLeagueIVs');
    });
  }
}

extension PokemonBaseQueryLinks
    on QueryBuilder<PokemonBase, PokemonBase, QFilterCondition> {
  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition> fastMoves(
      FilterQuery<FastMove> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'fastMoves');
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      fastMovesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'fastMoves', length, true, length, true);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      fastMovesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'fastMoves', 0, true, 0, true);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      fastMovesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'fastMoves', 0, false, 999999, true);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      fastMovesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'fastMoves', 0, true, length, include);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      fastMovesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'fastMoves', length, include, 999999, true);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      fastMovesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'fastMoves', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition> chargeMoves(
      FilterQuery<ChargeMove> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'chargeMoves');
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      chargeMovesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'chargeMoves', length, true, length, true);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      chargeMovesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'chargeMoves', 0, true, 0, true);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      chargeMovesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'chargeMoves', 0, false, 999999, true);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      chargeMovesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'chargeMoves', 0, true, length, include);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      chargeMovesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'chargeMoves', length, include, 999999, true);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      chargeMovesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'chargeMoves', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition> evolutions(
      FilterQuery<Evolution> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'evolutions');
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      evolutionsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'evolutions', length, true, length, true);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      evolutionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'evolutions', 0, true, 0, true);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      evolutionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'evolutions', 0, false, 999999, true);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      evolutionsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'evolutions', 0, true, length, include);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      evolutionsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'evolutions', length, include, 999999, true);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      evolutionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'evolutions', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition> tempEvolutions(
      FilterQuery<TempEvolution> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'tempEvolutions');
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      tempEvolutionsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'tempEvolutions', length, true, length, true);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      tempEvolutionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'tempEvolutions', 0, true, 0, true);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      tempEvolutionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'tempEvolutions', 0, false, 999999, true);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      tempEvolutionsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'tempEvolutions', 0, true, length, include);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      tempEvolutionsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'tempEvolutions', length, include, 999999, true);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterFilterCondition>
      tempEvolutionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'tempEvolutions', lower, includeLower, upper, includeUpper);
    });
  }
}

extension PokemonBaseQuerySortBy
    on QueryBuilder<PokemonBase, PokemonBase, QSortBy> {
  QueryBuilder<PokemonBase, PokemonBase, QAfterSortBy> sortByDex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dex', Sort.asc);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterSortBy> sortByDexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dex', Sort.desc);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterSortBy> sortByFamilyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'familyId', Sort.asc);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterSortBy> sortByFamilyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'familyId', Sort.desc);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterSortBy> sortByForm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'form', Sort.asc);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterSortBy> sortByFormDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'form', Sort.desc);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterSortBy> sortByPokemonId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pokemonId', Sort.asc);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterSortBy> sortByPokemonIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pokemonId', Sort.desc);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterSortBy> sortByReleased() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'released', Sort.asc);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterSortBy> sortByReleasedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'released', Sort.desc);
    });
  }
}

extension PokemonBaseQuerySortThenBy
    on QueryBuilder<PokemonBase, PokemonBase, QSortThenBy> {
  QueryBuilder<PokemonBase, PokemonBase, QAfterSortBy> thenByDex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dex', Sort.asc);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterSortBy> thenByDexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dex', Sort.desc);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterSortBy> thenByFamilyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'familyId', Sort.asc);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterSortBy> thenByFamilyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'familyId', Sort.desc);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterSortBy> thenByForm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'form', Sort.asc);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterSortBy> thenByFormDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'form', Sort.desc);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterSortBy> thenByPokemonId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pokemonId', Sort.asc);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterSortBy> thenByPokemonIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pokemonId', Sort.desc);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterSortBy> thenByReleased() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'released', Sort.asc);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QAfterSortBy> thenByReleasedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'released', Sort.desc);
    });
  }
}

extension PokemonBaseQueryWhereDistinct
    on QueryBuilder<PokemonBase, PokemonBase, QDistinct> {
  QueryBuilder<PokemonBase, PokemonBase, QDistinct> distinctByDex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dex');
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QDistinct>
      distinctByEliteChargeMoveIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'eliteChargeMoveIds');
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QDistinct>
      distinctByEliteFastMoveIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'eliteFastMoveIds');
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QDistinct> distinctByFamilyId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'familyId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QDistinct> distinctByForm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'form', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QDistinct> distinctByPokemonId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pokemonId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QDistinct> distinctByReleased() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'released');
    });
  }

  QueryBuilder<PokemonBase, PokemonBase, QDistinct> distinctByTags() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tags');
    });
  }
}

extension PokemonBaseQueryProperty
    on QueryBuilder<PokemonBase, PokemonBase, QQueryProperty> {
  QueryBuilder<PokemonBase, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PokemonBase, int, QQueryOperations> dexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dex');
    });
  }

  QueryBuilder<PokemonBase, List<String>?, QQueryOperations>
      eliteChargeMoveIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'eliteChargeMoveIds');
    });
  }

  QueryBuilder<PokemonBase, List<String>?, QQueryOperations>
      eliteFastMoveIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'eliteFastMoveIds');
    });
  }

  QueryBuilder<PokemonBase, String, QQueryOperations> familyIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'familyId');
    });
  }

  QueryBuilder<PokemonBase, String, QQueryOperations> formProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'form');
    });
  }

  QueryBuilder<PokemonBase, IVs?, QQueryOperations> greatLeagueIVsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'greatLeagueIVs');
    });
  }

  QueryBuilder<PokemonBase, IVs?, QQueryOperations> littleCupIVsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'littleCupIVs');
    });
  }

  QueryBuilder<PokemonBase, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<PokemonBase, String, QQueryOperations> pokemonIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pokemonId');
    });
  }

  QueryBuilder<PokemonBase, bool, QQueryOperations> releasedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'released');
    });
  }

  QueryBuilder<PokemonBase, Shadow?, QQueryOperations> shadowProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shadow');
    });
  }

  QueryBuilder<PokemonBase, BaseStats, QQueryOperations> statsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stats');
    });
  }

  QueryBuilder<PokemonBase, List<String>?, QQueryOperations> tagsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tags');
    });
  }

  QueryBuilder<PokemonBase, ThirdMoveCost?, QQueryOperations>
      thirdMoveCostProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'thirdMoveCost');
    });
  }

  QueryBuilder<PokemonBase, PokemonTyping, QQueryOperations> typingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'typing');
    });
  }

  QueryBuilder<PokemonBase, IVs?, QQueryOperations> ultraLeagueIVsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ultraLeagueIVs');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetEvolutionCollection on Isar {
  IsarCollection<Evolution> get evolutions => this.collection();
}

const EvolutionSchema = CollectionSchema(
  name: r'Evolution',
  id: -3856668642502749248,
  properties: {
    r'candyCost': PropertySchema(
      id: 0,
      name: r'candyCost',
      type: IsarType.long,
    ),
    r'pokemonId': PropertySchema(
      id: 1,
      name: r'pokemonId',
      type: IsarType.string,
    ),
    r'purifiedEvolutionCost': PropertySchema(
      id: 2,
      name: r'purifiedEvolutionCost',
      type: IsarType.long,
    )
  },
  estimateSize: _evolutionEstimateSize,
  serialize: _evolutionSerialize,
  deserialize: _evolutionDeserialize,
  deserializeProp: _evolutionDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _evolutionGetId,
  getLinks: _evolutionGetLinks,
  attach: _evolutionAttach,
  version: '3.1.0+1',
);

int _evolutionEstimateSize(
  Evolution object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.pokemonId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _evolutionSerialize(
  Evolution object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.candyCost);
  writer.writeString(offsets[1], object.pokemonId);
  writer.writeLong(offsets[2], object.purifiedEvolutionCost);
}

Evolution _evolutionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Evolution(
    candyCost: reader.readLongOrNull(offsets[0]),
    pokemonId: reader.readStringOrNull(offsets[1]),
    purifiedEvolutionCost: reader.readLongOrNull(offsets[2]),
  );
  object.id = id;
  return object;
}

P _evolutionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _evolutionGetId(Evolution object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _evolutionGetLinks(Evolution object) {
  return [];
}

void _evolutionAttach(IsarCollection<dynamic> col, Id id, Evolution object) {
  object.id = id;
}

extension EvolutionQueryWhereSort
    on QueryBuilder<Evolution, Evolution, QWhere> {
  QueryBuilder<Evolution, Evolution, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension EvolutionQueryWhere
    on QueryBuilder<Evolution, Evolution, QWhereClause> {
  QueryBuilder<Evolution, Evolution, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Evolution, Evolution, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Evolution, Evolution, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Evolution, Evolution, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Evolution, Evolution, QAfterWhereClause> idBetween(
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

extension EvolutionQueryFilter
    on QueryBuilder<Evolution, Evolution, QFilterCondition> {
  QueryBuilder<Evolution, Evolution, QAfterFilterCondition> candyCostIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'candyCost',
      ));
    });
  }

  QueryBuilder<Evolution, Evolution, QAfterFilterCondition>
      candyCostIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'candyCost',
      ));
    });
  }

  QueryBuilder<Evolution, Evolution, QAfterFilterCondition> candyCostEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'candyCost',
        value: value,
      ));
    });
  }

  QueryBuilder<Evolution, Evolution, QAfterFilterCondition>
      candyCostGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'candyCost',
        value: value,
      ));
    });
  }

  QueryBuilder<Evolution, Evolution, QAfterFilterCondition> candyCostLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'candyCost',
        value: value,
      ));
    });
  }

  QueryBuilder<Evolution, Evolution, QAfterFilterCondition> candyCostBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'candyCost',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Evolution, Evolution, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Evolution, Evolution, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Evolution, Evolution, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Evolution, Evolution, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Evolution, Evolution, QAfterFilterCondition> pokemonIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pokemonId',
      ));
    });
  }

  QueryBuilder<Evolution, Evolution, QAfterFilterCondition>
      pokemonIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'pokemonId',
      ));
    });
  }

  QueryBuilder<Evolution, Evolution, QAfterFilterCondition> pokemonIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pokemonId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Evolution, Evolution, QAfterFilterCondition>
      pokemonIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pokemonId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Evolution, Evolution, QAfterFilterCondition> pokemonIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pokemonId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Evolution, Evolution, QAfterFilterCondition> pokemonIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pokemonId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Evolution, Evolution, QAfterFilterCondition> pokemonIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pokemonId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Evolution, Evolution, QAfterFilterCondition> pokemonIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pokemonId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Evolution, Evolution, QAfterFilterCondition> pokemonIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pokemonId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Evolution, Evolution, QAfterFilterCondition> pokemonIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pokemonId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Evolution, Evolution, QAfterFilterCondition> pokemonIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pokemonId',
        value: '',
      ));
    });
  }

  QueryBuilder<Evolution, Evolution, QAfterFilterCondition>
      pokemonIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pokemonId',
        value: '',
      ));
    });
  }

  QueryBuilder<Evolution, Evolution, QAfterFilterCondition>
      purifiedEvolutionCostIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'purifiedEvolutionCost',
      ));
    });
  }

  QueryBuilder<Evolution, Evolution, QAfterFilterCondition>
      purifiedEvolutionCostIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'purifiedEvolutionCost',
      ));
    });
  }

  QueryBuilder<Evolution, Evolution, QAfterFilterCondition>
      purifiedEvolutionCostEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'purifiedEvolutionCost',
        value: value,
      ));
    });
  }

  QueryBuilder<Evolution, Evolution, QAfterFilterCondition>
      purifiedEvolutionCostGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'purifiedEvolutionCost',
        value: value,
      ));
    });
  }

  QueryBuilder<Evolution, Evolution, QAfterFilterCondition>
      purifiedEvolutionCostLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'purifiedEvolutionCost',
        value: value,
      ));
    });
  }

  QueryBuilder<Evolution, Evolution, QAfterFilterCondition>
      purifiedEvolutionCostBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'purifiedEvolutionCost',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension EvolutionQueryObject
    on QueryBuilder<Evolution, Evolution, QFilterCondition> {}

extension EvolutionQueryLinks
    on QueryBuilder<Evolution, Evolution, QFilterCondition> {}

extension EvolutionQuerySortBy on QueryBuilder<Evolution, Evolution, QSortBy> {
  QueryBuilder<Evolution, Evolution, QAfterSortBy> sortByCandyCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'candyCost', Sort.asc);
    });
  }

  QueryBuilder<Evolution, Evolution, QAfterSortBy> sortByCandyCostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'candyCost', Sort.desc);
    });
  }

  QueryBuilder<Evolution, Evolution, QAfterSortBy> sortByPokemonId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pokemonId', Sort.asc);
    });
  }

  QueryBuilder<Evolution, Evolution, QAfterSortBy> sortByPokemonIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pokemonId', Sort.desc);
    });
  }

  QueryBuilder<Evolution, Evolution, QAfterSortBy>
      sortByPurifiedEvolutionCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purifiedEvolutionCost', Sort.asc);
    });
  }

  QueryBuilder<Evolution, Evolution, QAfterSortBy>
      sortByPurifiedEvolutionCostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purifiedEvolutionCost', Sort.desc);
    });
  }
}

extension EvolutionQuerySortThenBy
    on QueryBuilder<Evolution, Evolution, QSortThenBy> {
  QueryBuilder<Evolution, Evolution, QAfterSortBy> thenByCandyCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'candyCost', Sort.asc);
    });
  }

  QueryBuilder<Evolution, Evolution, QAfterSortBy> thenByCandyCostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'candyCost', Sort.desc);
    });
  }

  QueryBuilder<Evolution, Evolution, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Evolution, Evolution, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Evolution, Evolution, QAfterSortBy> thenByPokemonId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pokemonId', Sort.asc);
    });
  }

  QueryBuilder<Evolution, Evolution, QAfterSortBy> thenByPokemonIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pokemonId', Sort.desc);
    });
  }

  QueryBuilder<Evolution, Evolution, QAfterSortBy>
      thenByPurifiedEvolutionCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purifiedEvolutionCost', Sort.asc);
    });
  }

  QueryBuilder<Evolution, Evolution, QAfterSortBy>
      thenByPurifiedEvolutionCostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purifiedEvolutionCost', Sort.desc);
    });
  }
}

extension EvolutionQueryWhereDistinct
    on QueryBuilder<Evolution, Evolution, QDistinct> {
  QueryBuilder<Evolution, Evolution, QDistinct> distinctByCandyCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'candyCost');
    });
  }

  QueryBuilder<Evolution, Evolution, QDistinct> distinctByPokemonId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pokemonId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Evolution, Evolution, QDistinct>
      distinctByPurifiedEvolutionCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'purifiedEvolutionCost');
    });
  }
}

extension EvolutionQueryProperty
    on QueryBuilder<Evolution, Evolution, QQueryProperty> {
  QueryBuilder<Evolution, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Evolution, int?, QQueryOperations> candyCostProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'candyCost');
    });
  }

  QueryBuilder<Evolution, String?, QQueryOperations> pokemonIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pokemonId');
    });
  }

  QueryBuilder<Evolution, int?, QQueryOperations>
      purifiedEvolutionCostProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'purifiedEvolutionCost');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTempEvolutionCollection on Isar {
  IsarCollection<TempEvolution> get tempEvolutions => this.collection();
}

const TempEvolutionSchema = CollectionSchema(
  name: r'TempEvolution',
  id: 8218263628863549852,
  properties: {
    r'released': PropertySchema(
      id: 0,
      name: r'released',
      type: IsarType.bool,
    ),
    r'stats': PropertySchema(
      id: 1,
      name: r'stats',
      type: IsarType.object,
      target: r'BaseStats',
    ),
    r'tempEvolutionId': PropertySchema(
      id: 2,
      name: r'tempEvolutionId',
      type: IsarType.string,
    ),
    r'typing': PropertySchema(
      id: 3,
      name: r'typing',
      type: IsarType.object,
      target: r'PokemonTyping',
    )
  },
  estimateSize: _tempEvolutionEstimateSize,
  serialize: _tempEvolutionSerialize,
  deserialize: _tempEvolutionDeserialize,
  deserializeProp: _tempEvolutionDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {
    r'PokemonTyping': PokemonTypingSchema,
    r'PokemonType': PokemonTypeSchema,
    r'BaseStats': BaseStatsSchema
  },
  getId: _tempEvolutionGetId,
  getLinks: _tempEvolutionGetLinks,
  attach: _tempEvolutionAttach,
  version: '3.1.0+1',
);

int _tempEvolutionEstimateSize(
  TempEvolution object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.stats;
    if (value != null) {
      bytesCount += 3 +
          BaseStatsSchema.estimateSize(
              value, allOffsets[BaseStats]!, allOffsets);
    }
  }
  {
    final value = object.tempEvolutionId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 +
      PokemonTypingSchema.estimateSize(
          object.typing, allOffsets[PokemonTyping]!, allOffsets);
  return bytesCount;
}

void _tempEvolutionSerialize(
  TempEvolution object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.released);
  writer.writeObject<BaseStats>(
    offsets[1],
    allOffsets,
    BaseStatsSchema.serialize,
    object.stats,
  );
  writer.writeString(offsets[2], object.tempEvolutionId);
  writer.writeObject<PokemonTyping>(
    offsets[3],
    allOffsets,
    PokemonTypingSchema.serialize,
    object.typing,
  );
}

TempEvolution _tempEvolutionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TempEvolution(
    released: reader.readBool(offsets[0]),
    stats: reader.readObjectOrNull<BaseStats>(
      offsets[1],
      BaseStatsSchema.deserialize,
      allOffsets,
    ),
    tempEvolutionId: reader.readStringOrNull(offsets[2]),
    typing: reader.readObjectOrNull<PokemonTyping>(
          offsets[3],
          PokemonTypingSchema.deserialize,
          allOffsets,
        ) ??
        PokemonTyping(),
  );
  object.id = id;
  return object;
}

P _tempEvolutionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readObjectOrNull<BaseStats>(
        offset,
        BaseStatsSchema.deserialize,
        allOffsets,
      )) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readObjectOrNull<PokemonTyping>(
            offset,
            PokemonTypingSchema.deserialize,
            allOffsets,
          ) ??
          PokemonTyping()) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _tempEvolutionGetId(TempEvolution object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _tempEvolutionGetLinks(TempEvolution object) {
  return [];
}

void _tempEvolutionAttach(
    IsarCollection<dynamic> col, Id id, TempEvolution object) {
  object.id = id;
}

extension TempEvolutionQueryWhereSort
    on QueryBuilder<TempEvolution, TempEvolution, QWhere> {
  QueryBuilder<TempEvolution, TempEvolution, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TempEvolutionQueryWhere
    on QueryBuilder<TempEvolution, TempEvolution, QWhereClause> {
  QueryBuilder<TempEvolution, TempEvolution, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TempEvolution, TempEvolution, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<TempEvolution, TempEvolution, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TempEvolution, TempEvolution, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TempEvolution, TempEvolution, QAfterWhereClause> idBetween(
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

extension TempEvolutionQueryFilter
    on QueryBuilder<TempEvolution, TempEvolution, QFilterCondition> {
  QueryBuilder<TempEvolution, TempEvolution, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TempEvolution, TempEvolution, QAfterFilterCondition>
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

  QueryBuilder<TempEvolution, TempEvolution, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<TempEvolution, TempEvolution, QAfterFilterCondition> idBetween(
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

  QueryBuilder<TempEvolution, TempEvolution, QAfterFilterCondition>
      releasedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'released',
        value: value,
      ));
    });
  }

  QueryBuilder<TempEvolution, TempEvolution, QAfterFilterCondition>
      statsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'stats',
      ));
    });
  }

  QueryBuilder<TempEvolution, TempEvolution, QAfterFilterCondition>
      statsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'stats',
      ));
    });
  }

  QueryBuilder<TempEvolution, TempEvolution, QAfterFilterCondition>
      tempEvolutionIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'tempEvolutionId',
      ));
    });
  }

  QueryBuilder<TempEvolution, TempEvolution, QAfterFilterCondition>
      tempEvolutionIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'tempEvolutionId',
      ));
    });
  }

  QueryBuilder<TempEvolution, TempEvolution, QAfterFilterCondition>
      tempEvolutionIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tempEvolutionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TempEvolution, TempEvolution, QAfterFilterCondition>
      tempEvolutionIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tempEvolutionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TempEvolution, TempEvolution, QAfterFilterCondition>
      tempEvolutionIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tempEvolutionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TempEvolution, TempEvolution, QAfterFilterCondition>
      tempEvolutionIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tempEvolutionId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TempEvolution, TempEvolution, QAfterFilterCondition>
      tempEvolutionIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tempEvolutionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TempEvolution, TempEvolution, QAfterFilterCondition>
      tempEvolutionIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tempEvolutionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TempEvolution, TempEvolution, QAfterFilterCondition>
      tempEvolutionIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tempEvolutionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TempEvolution, TempEvolution, QAfterFilterCondition>
      tempEvolutionIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tempEvolutionId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TempEvolution, TempEvolution, QAfterFilterCondition>
      tempEvolutionIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tempEvolutionId',
        value: '',
      ));
    });
  }

  QueryBuilder<TempEvolution, TempEvolution, QAfterFilterCondition>
      tempEvolutionIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tempEvolutionId',
        value: '',
      ));
    });
  }
}

extension TempEvolutionQueryObject
    on QueryBuilder<TempEvolution, TempEvolution, QFilterCondition> {
  QueryBuilder<TempEvolution, TempEvolution, QAfterFilterCondition> stats(
      FilterQuery<BaseStats> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'stats');
    });
  }

  QueryBuilder<TempEvolution, TempEvolution, QAfterFilterCondition> typing(
      FilterQuery<PokemonTyping> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'typing');
    });
  }
}

extension TempEvolutionQueryLinks
    on QueryBuilder<TempEvolution, TempEvolution, QFilterCondition> {}

extension TempEvolutionQuerySortBy
    on QueryBuilder<TempEvolution, TempEvolution, QSortBy> {
  QueryBuilder<TempEvolution, TempEvolution, QAfterSortBy> sortByReleased() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'released', Sort.asc);
    });
  }

  QueryBuilder<TempEvolution, TempEvolution, QAfterSortBy>
      sortByReleasedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'released', Sort.desc);
    });
  }

  QueryBuilder<TempEvolution, TempEvolution, QAfterSortBy>
      sortByTempEvolutionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tempEvolutionId', Sort.asc);
    });
  }

  QueryBuilder<TempEvolution, TempEvolution, QAfterSortBy>
      sortByTempEvolutionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tempEvolutionId', Sort.desc);
    });
  }
}

extension TempEvolutionQuerySortThenBy
    on QueryBuilder<TempEvolution, TempEvolution, QSortThenBy> {
  QueryBuilder<TempEvolution, TempEvolution, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TempEvolution, TempEvolution, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TempEvolution, TempEvolution, QAfterSortBy> thenByReleased() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'released', Sort.asc);
    });
  }

  QueryBuilder<TempEvolution, TempEvolution, QAfterSortBy>
      thenByReleasedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'released', Sort.desc);
    });
  }

  QueryBuilder<TempEvolution, TempEvolution, QAfterSortBy>
      thenByTempEvolutionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tempEvolutionId', Sort.asc);
    });
  }

  QueryBuilder<TempEvolution, TempEvolution, QAfterSortBy>
      thenByTempEvolutionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tempEvolutionId', Sort.desc);
    });
  }
}

extension TempEvolutionQueryWhereDistinct
    on QueryBuilder<TempEvolution, TempEvolution, QDistinct> {
  QueryBuilder<TempEvolution, TempEvolution, QDistinct> distinctByReleased() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'released');
    });
  }

  QueryBuilder<TempEvolution, TempEvolution, QDistinct>
      distinctByTempEvolutionId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tempEvolutionId',
          caseSensitive: caseSensitive);
    });
  }
}

extension TempEvolutionQueryProperty
    on QueryBuilder<TempEvolution, TempEvolution, QQueryProperty> {
  QueryBuilder<TempEvolution, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TempEvolution, bool, QQueryOperations> releasedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'released');
    });
  }

  QueryBuilder<TempEvolution, BaseStats?, QQueryOperations> statsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stats');
    });
  }

  QueryBuilder<TempEvolution, String?, QQueryOperations>
      tempEvolutionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tempEvolutionId');
    });
  }

  QueryBuilder<TempEvolution, PokemonTyping, QQueryOperations>
      typingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'typing');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const ThirdMoveCostSchema = Schema(
  name: r'ThirdMoveCost',
  id: 3510165157608936801,
  properties: {
    r'candy': PropertySchema(
      id: 0,
      name: r'candy',
      type: IsarType.long,
    ),
    r'stardust': PropertySchema(
      id: 1,
      name: r'stardust',
      type: IsarType.long,
    )
  },
  estimateSize: _thirdMoveCostEstimateSize,
  serialize: _thirdMoveCostSerialize,
  deserialize: _thirdMoveCostDeserialize,
  deserializeProp: _thirdMoveCostDeserializeProp,
);

int _thirdMoveCostEstimateSize(
  ThirdMoveCost object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _thirdMoveCostSerialize(
  ThirdMoveCost object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.candy);
  writer.writeLong(offsets[1], object.stardust);
}

ThirdMoveCost _thirdMoveCostDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ThirdMoveCost(
    candy: reader.readLongOrNull(offsets[0]) ?? 0,
    stardust: reader.readLongOrNull(offsets[1]) ?? 0,
  );
  return object;
}

P _thirdMoveCostDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 1:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension ThirdMoveCostQueryFilter
    on QueryBuilder<ThirdMoveCost, ThirdMoveCost, QFilterCondition> {
  QueryBuilder<ThirdMoveCost, ThirdMoveCost, QAfterFilterCondition>
      candyEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'candy',
        value: value,
      ));
    });
  }

  QueryBuilder<ThirdMoveCost, ThirdMoveCost, QAfterFilterCondition>
      candyGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'candy',
        value: value,
      ));
    });
  }

  QueryBuilder<ThirdMoveCost, ThirdMoveCost, QAfterFilterCondition>
      candyLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'candy',
        value: value,
      ));
    });
  }

  QueryBuilder<ThirdMoveCost, ThirdMoveCost, QAfterFilterCondition>
      candyBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'candy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ThirdMoveCost, ThirdMoveCost, QAfterFilterCondition>
      stardustEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stardust',
        value: value,
      ));
    });
  }

  QueryBuilder<ThirdMoveCost, ThirdMoveCost, QAfterFilterCondition>
      stardustGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stardust',
        value: value,
      ));
    });
  }

  QueryBuilder<ThirdMoveCost, ThirdMoveCost, QAfterFilterCondition>
      stardustLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stardust',
        value: value,
      ));
    });
  }

  QueryBuilder<ThirdMoveCost, ThirdMoveCost, QAfterFilterCondition>
      stardustBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stardust',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ThirdMoveCostQueryObject
    on QueryBuilder<ThirdMoveCost, ThirdMoveCost, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const ShadowSchema = Schema(
  name: r'Shadow',
  id: -8663454203645999843,
  properties: {
    r'pokemonId': PropertySchema(
      id: 0,
      name: r'pokemonId',
      type: IsarType.string,
    ),
    r'purificationCandy': PropertySchema(
      id: 1,
      name: r'purificationCandy',
      type: IsarType.long,
    ),
    r'purificationStardust': PropertySchema(
      id: 2,
      name: r'purificationStardust',
      type: IsarType.long,
    ),
    r'purifiedChargeMove': PropertySchema(
      id: 3,
      name: r'purifiedChargeMove',
      type: IsarType.string,
    ),
    r'released': PropertySchema(
      id: 4,
      name: r'released',
      type: IsarType.bool,
    ),
    r'shadowChargeMove': PropertySchema(
      id: 5,
      name: r'shadowChargeMove',
      type: IsarType.string,
    )
  },
  estimateSize: _shadowEstimateSize,
  serialize: _shadowSerialize,
  deserialize: _shadowDeserialize,
  deserializeProp: _shadowDeserializeProp,
);

int _shadowEstimateSize(
  Shadow object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.pokemonId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.purifiedChargeMove;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.shadowChargeMove;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _shadowSerialize(
  Shadow object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.pokemonId);
  writer.writeLong(offsets[1], object.purificationCandy);
  writer.writeLong(offsets[2], object.purificationStardust);
  writer.writeString(offsets[3], object.purifiedChargeMove);
  writer.writeBool(offsets[4], object.released);
  writer.writeString(offsets[5], object.shadowChargeMove);
}

Shadow _shadowDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Shadow(
    pokemonId: reader.readStringOrNull(offsets[0]),
    purificationCandy: reader.readLongOrNull(offsets[1]),
    purificationStardust: reader.readLongOrNull(offsets[2]),
    purifiedChargeMove: reader.readStringOrNull(offsets[3]),
    released: reader.readBoolOrNull(offsets[4]),
    shadowChargeMove: reader.readStringOrNull(offsets[5]),
  );
  return object;
}

P _shadowDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readBoolOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension ShadowQueryFilter on QueryBuilder<Shadow, Shadow, QFilterCondition> {
  QueryBuilder<Shadow, Shadow, QAfterFilterCondition> pokemonIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pokemonId',
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition> pokemonIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'pokemonId',
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition> pokemonIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pokemonId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition> pokemonIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pokemonId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition> pokemonIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pokemonId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition> pokemonIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pokemonId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition> pokemonIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pokemonId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition> pokemonIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pokemonId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition> pokemonIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pokemonId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition> pokemonIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pokemonId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition> pokemonIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pokemonId',
        value: '',
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition> pokemonIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pokemonId',
        value: '',
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition>
      purificationCandyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'purificationCandy',
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition>
      purificationCandyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'purificationCandy',
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition> purificationCandyEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'purificationCandy',
        value: value,
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition>
      purificationCandyGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'purificationCandy',
        value: value,
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition> purificationCandyLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'purificationCandy',
        value: value,
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition> purificationCandyBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'purificationCandy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition>
      purificationStardustIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'purificationStardust',
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition>
      purificationStardustIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'purificationStardust',
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition>
      purificationStardustEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'purificationStardust',
        value: value,
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition>
      purificationStardustGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'purificationStardust',
        value: value,
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition>
      purificationStardustLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'purificationStardust',
        value: value,
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition>
      purificationStardustBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'purificationStardust',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition>
      purifiedChargeMoveIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'purifiedChargeMove',
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition>
      purifiedChargeMoveIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'purifiedChargeMove',
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition> purifiedChargeMoveEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'purifiedChargeMove',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition>
      purifiedChargeMoveGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'purifiedChargeMove',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition>
      purifiedChargeMoveLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'purifiedChargeMove',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition> purifiedChargeMoveBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'purifiedChargeMove',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition>
      purifiedChargeMoveStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'purifiedChargeMove',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition>
      purifiedChargeMoveEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'purifiedChargeMove',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition>
      purifiedChargeMoveContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'purifiedChargeMove',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition> purifiedChargeMoveMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'purifiedChargeMove',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition>
      purifiedChargeMoveIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'purifiedChargeMove',
        value: '',
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition>
      purifiedChargeMoveIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'purifiedChargeMove',
        value: '',
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition> releasedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'released',
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition> releasedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'released',
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition> releasedEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'released',
        value: value,
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition> shadowChargeMoveIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'shadowChargeMove',
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition>
      shadowChargeMoveIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'shadowChargeMove',
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition> shadowChargeMoveEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shadowChargeMove',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition>
      shadowChargeMoveGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'shadowChargeMove',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition> shadowChargeMoveLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'shadowChargeMove',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition> shadowChargeMoveBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'shadowChargeMove',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition>
      shadowChargeMoveStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'shadowChargeMove',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition> shadowChargeMoveEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'shadowChargeMove',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition> shadowChargeMoveContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'shadowChargeMove',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition> shadowChargeMoveMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'shadowChargeMove',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition>
      shadowChargeMoveIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shadowChargeMove',
        value: '',
      ));
    });
  }

  QueryBuilder<Shadow, Shadow, QAfterFilterCondition>
      shadowChargeMoveIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'shadowChargeMove',
        value: '',
      ));
    });
  }
}

extension ShadowQueryObject on QueryBuilder<Shadow, Shadow, QFilterCondition> {}
