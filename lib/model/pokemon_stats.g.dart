// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon_stats.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const BaseStatsSchema = Schema(
  name: r'BaseStats',
  id: 8131902131752474426,
  properties: {
    r'atk': PropertySchema(
      id: 0,
      name: r'atk',
      type: IsarType.long,
    ),
    r'def': PropertySchema(
      id: 1,
      name: r'def',
      type: IsarType.long,
    ),
    r'hp': PropertySchema(
      id: 2,
      name: r'hp',
      type: IsarType.long,
    )
  },
  estimateSize: _baseStatsEstimateSize,
  serialize: _baseStatsSerialize,
  deserialize: _baseStatsDeserialize,
  deserializeProp: _baseStatsDeserializeProp,
);

int _baseStatsEstimateSize(
  BaseStats object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _baseStatsSerialize(
  BaseStats object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.atk);
  writer.writeLong(offsets[1], object.def);
  writer.writeLong(offsets[2], object.hp);
}

BaseStats _baseStatsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BaseStats(
    atk: reader.readLongOrNull(offsets[0]) ?? 0,
    def: reader.readLongOrNull(offsets[1]) ?? 0,
    hp: reader.readLongOrNull(offsets[2]) ?? 0,
  );
  return object;
}

P _baseStatsDeserializeProp<P>(
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
    case 2:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension BaseStatsQueryFilter
    on QueryBuilder<BaseStats, BaseStats, QFilterCondition> {
  QueryBuilder<BaseStats, BaseStats, QAfterFilterCondition> atkEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'atk',
        value: value,
      ));
    });
  }

  QueryBuilder<BaseStats, BaseStats, QAfterFilterCondition> atkGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'atk',
        value: value,
      ));
    });
  }

  QueryBuilder<BaseStats, BaseStats, QAfterFilterCondition> atkLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'atk',
        value: value,
      ));
    });
  }

  QueryBuilder<BaseStats, BaseStats, QAfterFilterCondition> atkBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'atk',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BaseStats, BaseStats, QAfterFilterCondition> defEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'def',
        value: value,
      ));
    });
  }

  QueryBuilder<BaseStats, BaseStats, QAfterFilterCondition> defGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'def',
        value: value,
      ));
    });
  }

  QueryBuilder<BaseStats, BaseStats, QAfterFilterCondition> defLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'def',
        value: value,
      ));
    });
  }

  QueryBuilder<BaseStats, BaseStats, QAfterFilterCondition> defBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'def',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BaseStats, BaseStats, QAfterFilterCondition> hpEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hp',
        value: value,
      ));
    });
  }

  QueryBuilder<BaseStats, BaseStats, QAfterFilterCondition> hpGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hp',
        value: value,
      ));
    });
  }

  QueryBuilder<BaseStats, BaseStats, QAfterFilterCondition> hpLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hp',
        value: value,
      ));
    });
  }

  QueryBuilder<BaseStats, BaseStats, QAfterFilterCondition> hpBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BaseStatsQueryObject
    on QueryBuilder<BaseStats, BaseStats, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const IVsSchema = Schema(
  name: r'IVs',
  id: -3511015941727405225,
  properties: {
    r'atk': PropertySchema(
      id: 0,
      name: r'atk',
      type: IsarType.long,
    ),
    r'def': PropertySchema(
      id: 1,
      name: r'def',
      type: IsarType.long,
    ),
    r'hp': PropertySchema(
      id: 2,
      name: r'hp',
      type: IsarType.long,
    ),
    r'level': PropertySchema(
      id: 3,
      name: r'level',
      type: IsarType.double,
    )
  },
  estimateSize: _iVsEstimateSize,
  serialize: _iVsSerialize,
  deserialize: _iVsDeserialize,
  deserializeProp: _iVsDeserializeProp,
);

int _iVsEstimateSize(
  IVs object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _iVsSerialize(
  IVs object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.atk);
  writer.writeLong(offsets[1], object.def);
  writer.writeLong(offsets[2], object.hp);
  writer.writeDouble(offsets[3], object.level);
}

IVs _iVsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IVs(
    atk: reader.readLongOrNull(offsets[0]) ?? 0,
    def: reader.readLongOrNull(offsets[1]) ?? 0,
    hp: reader.readLongOrNull(offsets[2]) ?? 0,
    level: reader.readDoubleOrNull(offsets[3]) ?? 1,
  );
  return object;
}

P _iVsDeserializeProp<P>(
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
    case 2:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 3:
      return (reader.readDoubleOrNull(offset) ?? 1) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension IVsQueryFilter on QueryBuilder<IVs, IVs, QFilterCondition> {
  QueryBuilder<IVs, IVs, QAfterFilterCondition> atkEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'atk',
        value: value,
      ));
    });
  }

  QueryBuilder<IVs, IVs, QAfterFilterCondition> atkGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'atk',
        value: value,
      ));
    });
  }

  QueryBuilder<IVs, IVs, QAfterFilterCondition> atkLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'atk',
        value: value,
      ));
    });
  }

  QueryBuilder<IVs, IVs, QAfterFilterCondition> atkBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'atk',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IVs, IVs, QAfterFilterCondition> defEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'def',
        value: value,
      ));
    });
  }

  QueryBuilder<IVs, IVs, QAfterFilterCondition> defGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'def',
        value: value,
      ));
    });
  }

  QueryBuilder<IVs, IVs, QAfterFilterCondition> defLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'def',
        value: value,
      ));
    });
  }

  QueryBuilder<IVs, IVs, QAfterFilterCondition> defBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'def',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IVs, IVs, QAfterFilterCondition> hpEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hp',
        value: value,
      ));
    });
  }

  QueryBuilder<IVs, IVs, QAfterFilterCondition> hpGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hp',
        value: value,
      ));
    });
  }

  QueryBuilder<IVs, IVs, QAfterFilterCondition> hpLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hp',
        value: value,
      ));
    });
  }

  QueryBuilder<IVs, IVs, QAfterFilterCondition> hpBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IVs, IVs, QAfterFilterCondition> levelEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'level',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IVs, IVs, QAfterFilterCondition> levelGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'level',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IVs, IVs, QAfterFilterCondition> levelLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'level',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IVs, IVs, QAfterFilterCondition> levelBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'level',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension IVsQueryObject on QueryBuilder<IVs, IVs, QFilterCondition> {}
