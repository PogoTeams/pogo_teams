// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ratings.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const RatingsSchema = Schema(
  name: r'Ratings',
  id: -6616197702012770720,
  properties: {
    r'closer': PropertySchema(
      id: 0,
      name: r'closer',
      type: IsarType.long,
    ),
    r'lead': PropertySchema(
      id: 1,
      name: r'lead',
      type: IsarType.long,
    ),
    r'overall': PropertySchema(
      id: 2,
      name: r'overall',
      type: IsarType.long,
    ),
    r'switchRating': PropertySchema(
      id: 3,
      name: r'switchRating',
      type: IsarType.long,
    )
  },
  estimateSize: _ratingsEstimateSize,
  serialize: _ratingsSerialize,
  deserialize: _ratingsDeserialize,
  deserializeProp: _ratingsDeserializeProp,
);

int _ratingsEstimateSize(
  Ratings object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _ratingsSerialize(
  Ratings object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.closer);
  writer.writeLong(offsets[1], object.lead);
  writer.writeLong(offsets[2], object.overall);
  writer.writeLong(offsets[3], object.switchRating);
}

Ratings _ratingsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Ratings(
    closer: reader.readLongOrNull(offsets[0]) ?? 0,
    lead: reader.readLongOrNull(offsets[1]) ?? 0,
    overall: reader.readLongOrNull(offsets[2]) ?? 0,
    switchRating: reader.readLongOrNull(offsets[3]) ?? 0,
  );
  return object;
}

P _ratingsDeserializeProp<P>(
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
      return (reader.readLongOrNull(offset) ?? 0) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension RatingsQueryFilter
    on QueryBuilder<Ratings, Ratings, QFilterCondition> {
  QueryBuilder<Ratings, Ratings, QAfterFilterCondition> closerEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'closer',
        value: value,
      ));
    });
  }

  QueryBuilder<Ratings, Ratings, QAfterFilterCondition> closerGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'closer',
        value: value,
      ));
    });
  }

  QueryBuilder<Ratings, Ratings, QAfterFilterCondition> closerLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'closer',
        value: value,
      ));
    });
  }

  QueryBuilder<Ratings, Ratings, QAfterFilterCondition> closerBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'closer',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Ratings, Ratings, QAfterFilterCondition> leadEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lead',
        value: value,
      ));
    });
  }

  QueryBuilder<Ratings, Ratings, QAfterFilterCondition> leadGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lead',
        value: value,
      ));
    });
  }

  QueryBuilder<Ratings, Ratings, QAfterFilterCondition> leadLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lead',
        value: value,
      ));
    });
  }

  QueryBuilder<Ratings, Ratings, QAfterFilterCondition> leadBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lead',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Ratings, Ratings, QAfterFilterCondition> overallEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'overall',
        value: value,
      ));
    });
  }

  QueryBuilder<Ratings, Ratings, QAfterFilterCondition> overallGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'overall',
        value: value,
      ));
    });
  }

  QueryBuilder<Ratings, Ratings, QAfterFilterCondition> overallLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'overall',
        value: value,
      ));
    });
  }

  QueryBuilder<Ratings, Ratings, QAfterFilterCondition> overallBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'overall',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Ratings, Ratings, QAfterFilterCondition> switchRatingEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'switchRating',
        value: value,
      ));
    });
  }

  QueryBuilder<Ratings, Ratings, QAfterFilterCondition> switchRatingGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'switchRating',
        value: value,
      ));
    });
  }

  QueryBuilder<Ratings, Ratings, QAfterFilterCondition> switchRatingLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'switchRating',
        value: value,
      ));
    });
  }

  QueryBuilder<Ratings, Ratings, QAfterFilterCondition> switchRatingBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'switchRating',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension RatingsQueryObject
    on QueryBuilder<Ratings, Ratings, QFilterCondition> {}
