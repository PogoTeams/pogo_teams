// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon_typing.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const PokemonTypingSchema = Schema(
  name: r'PokemonTyping',
  id: 406485828557978735,
  properties: {
    r'typeA': PropertySchema(
      id: 0,
      name: r'typeA',
      type: IsarType.object,
      target: r'PokemonType',
    ),
    r'typeB': PropertySchema(
      id: 1,
      name: r'typeB',
      type: IsarType.object,
      target: r'PokemonType',
    )
  },
  estimateSize: _pokemonTypingEstimateSize,
  serialize: _pokemonTypingSerialize,
  deserialize: _pokemonTypingDeserialize,
  deserializeProp: _pokemonTypingDeserializeProp,
);

int _pokemonTypingEstimateSize(
  PokemonTyping object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 +
      PokemonTypeSchema.estimateSize(
          object.typeA, allOffsets[PokemonType]!, allOffsets);
  {
    final value = object.typeB;
    if (value != null) {
      bytesCount += 3 +
          PokemonTypeSchema.estimateSize(
              value, allOffsets[PokemonType]!, allOffsets);
    }
  }
  return bytesCount;
}

void _pokemonTypingSerialize(
  PokemonTyping object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObject<PokemonType>(
    offsets[0],
    allOffsets,
    PokemonTypeSchema.serialize,
    object.typeA,
  );
  writer.writeObject<PokemonType>(
    offsets[1],
    allOffsets,
    PokemonTypeSchema.serialize,
    object.typeB,
  );
}

PokemonTyping _pokemonTypingDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PokemonTyping();
  object.typeA = reader.readObjectOrNull<PokemonType>(
        offsets[0],
        PokemonTypeSchema.deserialize,
        allOffsets,
      ) ??
      PokemonType();
  object.typeB = reader.readObjectOrNull<PokemonType>(
    offsets[1],
    PokemonTypeSchema.deserialize,
    allOffsets,
  );
  return object;
}

P _pokemonTypingDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectOrNull<PokemonType>(
            offset,
            PokemonTypeSchema.deserialize,
            allOffsets,
          ) ??
          PokemonType()) as P;
    case 1:
      return (reader.readObjectOrNull<PokemonType>(
        offset,
        PokemonTypeSchema.deserialize,
        allOffsets,
      )) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension PokemonTypingQueryFilter
    on QueryBuilder<PokemonTyping, PokemonTyping, QFilterCondition> {
  QueryBuilder<PokemonTyping, PokemonTyping, QAfterFilterCondition>
      typeBIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'typeB',
      ));
    });
  }

  QueryBuilder<PokemonTyping, PokemonTyping, QAfterFilterCondition>
      typeBIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'typeB',
      ));
    });
  }
}

extension PokemonTypingQueryObject
    on QueryBuilder<PokemonTyping, PokemonTyping, QFilterCondition> {
  QueryBuilder<PokemonTyping, PokemonTyping, QAfterFilterCondition> typeA(
      FilterQuery<PokemonType> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'typeA');
    });
  }

  QueryBuilder<PokemonTyping, PokemonTyping, QAfterFilterCondition> typeB(
      FilterQuery<PokemonType> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'typeB');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const PokemonTypeSchema = Schema(
  name: r'PokemonType',
  id: 229780386400146563,
  properties: {
    r'typeId': PropertySchema(
      id: 0,
      name: r'typeId',
      type: IsarType.string,
    )
  },
  estimateSize: _pokemonTypeEstimateSize,
  serialize: _pokemonTypeSerialize,
  deserialize: _pokemonTypeDeserialize,
  deserializeProp: _pokemonTypeDeserializeProp,
);

int _pokemonTypeEstimateSize(
  PokemonType object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.typeId.length * 3;
  return bytesCount;
}

void _pokemonTypeSerialize(
  PokemonType object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.typeId);
}

PokemonType _pokemonTypeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PokemonType(
    typeId: reader.readStringOrNull(offsets[0]) ?? 'none',
  );
  return object;
}

P _pokemonTypeDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset) ?? 'none') as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension PokemonTypeQueryFilter
    on QueryBuilder<PokemonType, PokemonType, QFilterCondition> {
  QueryBuilder<PokemonType, PokemonType, QAfterFilterCondition> typeIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'typeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonType, PokemonType, QAfterFilterCondition>
      typeIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'typeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonType, PokemonType, QAfterFilterCondition> typeIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'typeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonType, PokemonType, QAfterFilterCondition> typeIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'typeId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonType, PokemonType, QAfterFilterCondition>
      typeIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'typeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonType, PokemonType, QAfterFilterCondition> typeIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'typeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonType, PokemonType, QAfterFilterCondition> typeIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'typeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonType, PokemonType, QAfterFilterCondition> typeIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'typeId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PokemonType, PokemonType, QAfterFilterCondition>
      typeIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'typeId',
        value: '',
      ));
    });
  }

  QueryBuilder<PokemonType, PokemonType, QAfterFilterCondition>
      typeIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'typeId',
        value: '',
      ));
    });
  }
}

extension PokemonTypeQueryObject
    on QueryBuilder<PokemonType, PokemonType, QFilterCondition> {}
