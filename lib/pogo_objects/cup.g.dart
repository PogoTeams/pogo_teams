// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cup.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetCupCollection on Isar {
  IsarCollection<Cup> get cups => this.collection();
}

const CupSchema = CollectionSchema(
  name: r'Cup',
  id: 7866454282606101393,
  properties: {
    r'cp': PropertySchema(
      id: 0,
      name: r'cp',
      type: IsarType.long,
    ),
    r'cupId': PropertySchema(
      id: 1,
      name: r'cupId',
      type: IsarType.string,
    ),
    r'live': PropertySchema(
      id: 2,
      name: r'live',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(
      id: 3,
      name: r'name',
      type: IsarType.string,
    ),
    r'partySize': PropertySchema(
      id: 4,
      name: r'partySize',
      type: IsarType.long,
    ),
    r'publisher': PropertySchema(
      id: 5,
      name: r'publisher',
      type: IsarType.string,
    ),
    r'uiColor': PropertySchema(
      id: 6,
      name: r'uiColor',
      type: IsarType.string,
    )
  },
  estimateSize: _cupEstimateSize,
  serialize: _cupSerialize,
  deserialize: _cupDeserialize,
  deserializeProp: _cupDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'includeFilters': LinkSchema(
      id: 7425088563612649887,
      name: r'includeFilters',
      target: r'CupFilter',
      single: false,
    ),
    r'excludeFilters': LinkSchema(
      id: -7267867558453503378,
      name: r'excludeFilters',
      target: r'CupFilter',
      single: false,
    ),
    r'rankings': LinkSchema(
      id: -7345411310555650539,
      name: r'rankings',
      target: r'Pokemon',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _cupGetId,
  getLinks: _cupGetLinks,
  attach: _cupAttach,
  version: '3.0.2',
);

int _cupEstimateSize(
  Cup object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.cupId.length * 3;
  bytesCount += 3 + object.name.length * 3;
  {
    final value = object.publisher;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.uiColor;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _cupSerialize(
  Cup object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.cp);
  writer.writeString(offsets[1], object.cupId);
  writer.writeBool(offsets[2], object.live);
  writer.writeString(offsets[3], object.name);
  writer.writeLong(offsets[4], object.partySize);
  writer.writeString(offsets[5], object.publisher);
  writer.writeString(offsets[6], object.uiColor);
}

Cup _cupDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Cup(
    cp: reader.readLong(offsets[0]),
    cupId: reader.readString(offsets[1]),
    live: reader.readBool(offsets[2]),
    name: reader.readString(offsets[3]),
    partySize: reader.readLong(offsets[4]),
    publisher: reader.readStringOrNull(offsets[5]),
    uiColor: reader.readStringOrNull(offsets[6]),
  );
  object.id = id;
  return object;
}

P _cupDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _cupGetId(Cup object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _cupGetLinks(Cup object) {
  return [object.includeFilters, object.excludeFilters, object.rankings];
}

void _cupAttach(IsarCollection<dynamic> col, Id id, Cup object) {
  object.id = id;
  object.includeFilters
      .attach(col, col.isar.collection<CupFilter>(), r'includeFilters', id);
  object.excludeFilters
      .attach(col, col.isar.collection<CupFilter>(), r'excludeFilters', id);
  object.rankings.attach(col, col.isar.collection<Pokemon>(), r'rankings', id);
}

extension CupQueryWhereSort on QueryBuilder<Cup, Cup, QWhere> {
  QueryBuilder<Cup, Cup, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CupQueryWhere on QueryBuilder<Cup, Cup, QWhereClause> {
  QueryBuilder<Cup, Cup, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Cup, Cup, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Cup, Cup, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Cup, Cup, QAfterWhereClause> idBetween(
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

extension CupQueryFilter on QueryBuilder<Cup, Cup, QFilterCondition> {
  QueryBuilder<Cup, Cup, QAfterFilterCondition> cpEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cp',
        value: value,
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> cpGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cp',
        value: value,
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> cpLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cp',
        value: value,
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> cpBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> cupIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> cupIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> cupIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> cupIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cupId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> cupIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> cupIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> cupIdContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> cupIdMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cupId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> cupIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cupId',
        value: '',
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> cupIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cupId',
        value: '',
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Cup, Cup, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Cup, Cup, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Cup, Cup, QAfterFilterCondition> liveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'live',
        value: value,
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<Cup, Cup, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<Cup, Cup, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<Cup, Cup, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<Cup, Cup, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<Cup, Cup, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<Cup, Cup, QAfterFilterCondition> nameContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> nameMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> partySizeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'partySize',
        value: value,
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> partySizeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'partySize',
        value: value,
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> partySizeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'partySize',
        value: value,
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> partySizeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'partySize',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> publisherIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'publisher',
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> publisherIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'publisher',
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> publisherEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'publisher',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> publisherGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'publisher',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> publisherLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'publisher',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> publisherBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'publisher',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> publisherStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'publisher',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> publisherEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'publisher',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> publisherContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'publisher',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> publisherMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'publisher',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> publisherIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'publisher',
        value: '',
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> publisherIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'publisher',
        value: '',
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> uiColorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'uiColor',
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> uiColorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'uiColor',
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> uiColorEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uiColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> uiColorGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uiColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> uiColorLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uiColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> uiColorBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uiColor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> uiColorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uiColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> uiColorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uiColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> uiColorContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uiColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> uiColorMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uiColor',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> uiColorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uiColor',
        value: '',
      ));
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> uiColorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uiColor',
        value: '',
      ));
    });
  }
}

extension CupQueryObject on QueryBuilder<Cup, Cup, QFilterCondition> {}

extension CupQueryLinks on QueryBuilder<Cup, Cup, QFilterCondition> {
  QueryBuilder<Cup, Cup, QAfterFilterCondition> includeFilters(
      FilterQuery<CupFilter> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'includeFilters');
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> includeFiltersLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'includeFilters', length, true, length, true);
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> includeFiltersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'includeFilters', 0, true, 0, true);
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> includeFiltersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'includeFilters', 0, false, 999999, true);
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> includeFiltersLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'includeFilters', 0, true, length, include);
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> includeFiltersLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'includeFilters', length, include, 999999, true);
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> includeFiltersLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'includeFilters', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> excludeFilters(
      FilterQuery<CupFilter> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'excludeFilters');
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> excludeFiltersLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'excludeFilters', length, true, length, true);
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> excludeFiltersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'excludeFilters', 0, true, 0, true);
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> excludeFiltersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'excludeFilters', 0, false, 999999, true);
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> excludeFiltersLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'excludeFilters', 0, true, length, include);
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> excludeFiltersLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'excludeFilters', length, include, 999999, true);
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> excludeFiltersLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'excludeFilters', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> rankings(
      FilterQuery<Pokemon> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'rankings');
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> rankingsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'rankings', length, true, length, true);
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> rankingsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'rankings', 0, true, 0, true);
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> rankingsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'rankings', 0, false, 999999, true);
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> rankingsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'rankings', 0, true, length, include);
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> rankingsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'rankings', length, include, 999999, true);
    });
  }

  QueryBuilder<Cup, Cup, QAfterFilterCondition> rankingsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'rankings', lower, includeLower, upper, includeUpper);
    });
  }
}

extension CupQuerySortBy on QueryBuilder<Cup, Cup, QSortBy> {
  QueryBuilder<Cup, Cup, QAfterSortBy> sortByCp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cp', Sort.asc);
    });
  }

  QueryBuilder<Cup, Cup, QAfterSortBy> sortByCpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cp', Sort.desc);
    });
  }

  QueryBuilder<Cup, Cup, QAfterSortBy> sortByCupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cupId', Sort.asc);
    });
  }

  QueryBuilder<Cup, Cup, QAfterSortBy> sortByCupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cupId', Sort.desc);
    });
  }

  QueryBuilder<Cup, Cup, QAfterSortBy> sortByLive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'live', Sort.asc);
    });
  }

  QueryBuilder<Cup, Cup, QAfterSortBy> sortByLiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'live', Sort.desc);
    });
  }

  QueryBuilder<Cup, Cup, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Cup, Cup, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Cup, Cup, QAfterSortBy> sortByPartySize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partySize', Sort.asc);
    });
  }

  QueryBuilder<Cup, Cup, QAfterSortBy> sortByPartySizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partySize', Sort.desc);
    });
  }

  QueryBuilder<Cup, Cup, QAfterSortBy> sortByPublisher() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'publisher', Sort.asc);
    });
  }

  QueryBuilder<Cup, Cup, QAfterSortBy> sortByPublisherDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'publisher', Sort.desc);
    });
  }

  QueryBuilder<Cup, Cup, QAfterSortBy> sortByUiColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uiColor', Sort.asc);
    });
  }

  QueryBuilder<Cup, Cup, QAfterSortBy> sortByUiColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uiColor', Sort.desc);
    });
  }
}

extension CupQuerySortThenBy on QueryBuilder<Cup, Cup, QSortThenBy> {
  QueryBuilder<Cup, Cup, QAfterSortBy> thenByCp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cp', Sort.asc);
    });
  }

  QueryBuilder<Cup, Cup, QAfterSortBy> thenByCpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cp', Sort.desc);
    });
  }

  QueryBuilder<Cup, Cup, QAfterSortBy> thenByCupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cupId', Sort.asc);
    });
  }

  QueryBuilder<Cup, Cup, QAfterSortBy> thenByCupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cupId', Sort.desc);
    });
  }

  QueryBuilder<Cup, Cup, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Cup, Cup, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Cup, Cup, QAfterSortBy> thenByLive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'live', Sort.asc);
    });
  }

  QueryBuilder<Cup, Cup, QAfterSortBy> thenByLiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'live', Sort.desc);
    });
  }

  QueryBuilder<Cup, Cup, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Cup, Cup, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Cup, Cup, QAfterSortBy> thenByPartySize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partySize', Sort.asc);
    });
  }

  QueryBuilder<Cup, Cup, QAfterSortBy> thenByPartySizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partySize', Sort.desc);
    });
  }

  QueryBuilder<Cup, Cup, QAfterSortBy> thenByPublisher() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'publisher', Sort.asc);
    });
  }

  QueryBuilder<Cup, Cup, QAfterSortBy> thenByPublisherDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'publisher', Sort.desc);
    });
  }

  QueryBuilder<Cup, Cup, QAfterSortBy> thenByUiColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uiColor', Sort.asc);
    });
  }

  QueryBuilder<Cup, Cup, QAfterSortBy> thenByUiColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uiColor', Sort.desc);
    });
  }
}

extension CupQueryWhereDistinct on QueryBuilder<Cup, Cup, QDistinct> {
  QueryBuilder<Cup, Cup, QDistinct> distinctByCp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cp');
    });
  }

  QueryBuilder<Cup, Cup, QDistinct> distinctByCupId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cupId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Cup, Cup, QDistinct> distinctByLive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'live');
    });
  }

  QueryBuilder<Cup, Cup, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Cup, Cup, QDistinct> distinctByPartySize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'partySize');
    });
  }

  QueryBuilder<Cup, Cup, QDistinct> distinctByPublisher(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'publisher', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Cup, Cup, QDistinct> distinctByUiColor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uiColor', caseSensitive: caseSensitive);
    });
  }
}

extension CupQueryProperty on QueryBuilder<Cup, Cup, QQueryProperty> {
  QueryBuilder<Cup, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Cup, int, QQueryOperations> cpProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cp');
    });
  }

  QueryBuilder<Cup, String, QQueryOperations> cupIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cupId');
    });
  }

  QueryBuilder<Cup, bool, QQueryOperations> liveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'live');
    });
  }

  QueryBuilder<Cup, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<Cup, int, QQueryOperations> partySizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'partySize');
    });
  }

  QueryBuilder<Cup, String?, QQueryOperations> publisherProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'publisher');
    });
  }

  QueryBuilder<Cup, String?, QQueryOperations> uiColorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uiColor');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetCupFilterCollection on Isar {
  IsarCollection<CupFilter> get cupFilters => this.collection();
}

const CupFilterSchema = CollectionSchema(
  name: r'CupFilter',
  id: 402391262993358025,
  properties: {
    r'filterType': PropertySchema(
      id: 0,
      name: r'filterType',
      type: IsarType.byte,
      enumMap: _CupFilterfilterTypeEnumValueMap,
    ),
    r'values': PropertySchema(
      id: 1,
      name: r'values',
      type: IsarType.stringList,
    )
  },
  estimateSize: _cupFilterEstimateSize,
  serialize: _cupFilterSerialize,
  deserialize: _cupFilterDeserialize,
  deserializeProp: _cupFilterDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _cupFilterGetId,
  getLinks: _cupFilterGetLinks,
  attach: _cupFilterAttach,
  version: '3.0.2',
);

int _cupFilterEstimateSize(
  CupFilter object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.values.length * 3;
  {
    for (var i = 0; i < object.values.length; i++) {
      final value = object.values[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _cupFilterSerialize(
  CupFilter object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeByte(offsets[0], object.filterType.index);
  writer.writeStringList(offsets[1], object.values);
}

CupFilter _cupFilterDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CupFilter(
    filterType:
        _CupFilterfilterTypeValueEnumMap[reader.readByteOrNull(offsets[0])] ??
            CupFilterType.dex,
    values: reader.readStringList(offsets[1]) ?? [],
  );
  object.id = id;
  return object;
}

P _cupFilterDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (_CupFilterfilterTypeValueEnumMap[reader.readByteOrNull(offset)] ??
          CupFilterType.dex) as P;
    case 1:
      return (reader.readStringList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _CupFilterfilterTypeEnumValueMap = {
  'dex': 0,
  'pokemonId': 1,
  'type': 2,
  'tags': 3,
};
const _CupFilterfilterTypeValueEnumMap = {
  0: CupFilterType.dex,
  1: CupFilterType.pokemonId,
  2: CupFilterType.type,
  3: CupFilterType.tags,
};

Id _cupFilterGetId(CupFilter object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _cupFilterGetLinks(CupFilter object) {
  return [];
}

void _cupFilterAttach(IsarCollection<dynamic> col, Id id, CupFilter object) {
  object.id = id;
}

extension CupFilterQueryWhereSort
    on QueryBuilder<CupFilter, CupFilter, QWhere> {
  QueryBuilder<CupFilter, CupFilter, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CupFilterQueryWhere
    on QueryBuilder<CupFilter, CupFilter, QWhereClause> {
  QueryBuilder<CupFilter, CupFilter, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CupFilter, CupFilter, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<CupFilter, CupFilter, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CupFilter, CupFilter, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CupFilter, CupFilter, QAfterWhereClause> idBetween(
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

extension CupFilterQueryFilter
    on QueryBuilder<CupFilter, CupFilter, QFilterCondition> {
  QueryBuilder<CupFilter, CupFilter, QAfterFilterCondition> filterTypeEqualTo(
      CupFilterType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'filterType',
        value: value,
      ));
    });
  }

  QueryBuilder<CupFilter, CupFilter, QAfterFilterCondition>
      filterTypeGreaterThan(
    CupFilterType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'filterType',
        value: value,
      ));
    });
  }

  QueryBuilder<CupFilter, CupFilter, QAfterFilterCondition> filterTypeLessThan(
    CupFilterType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'filterType',
        value: value,
      ));
    });
  }

  QueryBuilder<CupFilter, CupFilter, QAfterFilterCondition> filterTypeBetween(
    CupFilterType lower,
    CupFilterType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'filterType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CupFilter, CupFilter, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CupFilter, CupFilter, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<CupFilter, CupFilter, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<CupFilter, CupFilter, QAfterFilterCondition> idBetween(
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

  QueryBuilder<CupFilter, CupFilter, QAfterFilterCondition>
      valuesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'values',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CupFilter, CupFilter, QAfterFilterCondition>
      valuesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'values',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CupFilter, CupFilter, QAfterFilterCondition>
      valuesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'values',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CupFilter, CupFilter, QAfterFilterCondition>
      valuesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'values',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CupFilter, CupFilter, QAfterFilterCondition>
      valuesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'values',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CupFilter, CupFilter, QAfterFilterCondition>
      valuesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'values',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CupFilter, CupFilter, QAfterFilterCondition>
      valuesElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'values',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CupFilter, CupFilter, QAfterFilterCondition>
      valuesElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'values',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CupFilter, CupFilter, QAfterFilterCondition>
      valuesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'values',
        value: '',
      ));
    });
  }

  QueryBuilder<CupFilter, CupFilter, QAfterFilterCondition>
      valuesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'values',
        value: '',
      ));
    });
  }

  QueryBuilder<CupFilter, CupFilter, QAfterFilterCondition> valuesLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'values',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<CupFilter, CupFilter, QAfterFilterCondition> valuesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'values',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<CupFilter, CupFilter, QAfterFilterCondition> valuesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'values',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CupFilter, CupFilter, QAfterFilterCondition>
      valuesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'values',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<CupFilter, CupFilter, QAfterFilterCondition>
      valuesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'values',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CupFilter, CupFilter, QAfterFilterCondition> valuesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'values',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension CupFilterQueryObject
    on QueryBuilder<CupFilter, CupFilter, QFilterCondition> {}

extension CupFilterQueryLinks
    on QueryBuilder<CupFilter, CupFilter, QFilterCondition> {}

extension CupFilterQuerySortBy on QueryBuilder<CupFilter, CupFilter, QSortBy> {
  QueryBuilder<CupFilter, CupFilter, QAfterSortBy> sortByFilterType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filterType', Sort.asc);
    });
  }

  QueryBuilder<CupFilter, CupFilter, QAfterSortBy> sortByFilterTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filterType', Sort.desc);
    });
  }
}

extension CupFilterQuerySortThenBy
    on QueryBuilder<CupFilter, CupFilter, QSortThenBy> {
  QueryBuilder<CupFilter, CupFilter, QAfterSortBy> thenByFilterType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filterType', Sort.asc);
    });
  }

  QueryBuilder<CupFilter, CupFilter, QAfterSortBy> thenByFilterTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filterType', Sort.desc);
    });
  }

  QueryBuilder<CupFilter, CupFilter, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CupFilter, CupFilter, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension CupFilterQueryWhereDistinct
    on QueryBuilder<CupFilter, CupFilter, QDistinct> {
  QueryBuilder<CupFilter, CupFilter, QDistinct> distinctByFilterType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'filterType');
    });
  }

  QueryBuilder<CupFilter, CupFilter, QDistinct> distinctByValues() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'values');
    });
  }
}

extension CupFilterQueryProperty
    on QueryBuilder<CupFilter, CupFilter, QQueryProperty> {
  QueryBuilder<CupFilter, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CupFilter, CupFilterType, QQueryOperations>
      filterTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'filterType');
    });
  }

  QueryBuilder<CupFilter, List<String>, QQueryOperations> valuesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'values');
    });
  }
}
