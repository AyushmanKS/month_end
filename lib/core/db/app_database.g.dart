// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $BucketsTable extends Buckets with TableInfo<$BucketsTable, BucketRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BucketsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _syncStateMeta = const VerificationMeta(
    'syncState',
  );
  @override
  late final GeneratedColumn<String> syncState = GeneratedColumn<String>(
    'sync_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('synced'),
  );
  static const VerificationMeta _deletedLocalMeta = const VerificationMeta(
    'deletedLocal',
  );
  @override
  late final GeneratedColumn<bool> deletedLocal = GeneratedColumn<bool>(
    'deleted_local',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted_local" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtLocalMeta = const VerificationMeta(
    'updatedAtLocal',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtLocal =
      GeneratedColumn<DateTime>(
        'updated_at_local',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _serverUpdatedAtMeta = const VerificationMeta(
    'serverUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> serverUpdatedAt =
      GeneratedColumn<DateTime>(
        'server_updated_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _joinCodeMeta = const VerificationMeta(
    'joinCode',
  );
  @override
  late final GeneratedColumn<String> joinCode = GeneratedColumn<String>(
    'join_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _monthlyBudgetMeta = const VerificationMeta(
    'monthlyBudget',
  );
  @override
  late final GeneratedColumn<double> monthlyBudget = GeneratedColumn<double>(
    'monthly_budget',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _monthStartDateMeta = const VerificationMeta(
    'monthStartDate',
  );
  @override
  late final GeneratedColumn<String> monthStartDate = GeneratedColumn<String>(
    'month_start_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remainingMainBucketMeta =
      const VerificationMeta('remainingMainBucket');
  @override
  late final GeneratedColumn<double> remainingMainBucket =
      GeneratedColumn<double>(
        'remaining_main_bucket',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('INR'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedByMeta = const VerificationMeta(
    'deletedBy',
  );
  @override
  late final GeneratedColumn<String> deletedBy = GeneratedColumn<String>(
    'deleted_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    syncState,
    deletedLocal,
    updatedAtLocal,
    serverUpdatedAt,
    id,
    name,
    ownerId,
    joinCode,
    monthlyBudget,
    monthStartDate,
    remainingMainBucket,
    currency,
    status,
    deletedAt,
    deletedBy,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'buckets';
  @override
  VerificationContext validateIntegrity(
    Insertable<BucketRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('sync_state')) {
      context.handle(
        _syncStateMeta,
        syncState.isAcceptableOrUnknown(data['sync_state']!, _syncStateMeta),
      );
    }
    if (data.containsKey('deleted_local')) {
      context.handle(
        _deletedLocalMeta,
        deletedLocal.isAcceptableOrUnknown(
          data['deleted_local']!,
          _deletedLocalMeta,
        ),
      );
    }
    if (data.containsKey('updated_at_local')) {
      context.handle(
        _updatedAtLocalMeta,
        updatedAtLocal.isAcceptableOrUnknown(
          data['updated_at_local']!,
          _updatedAtLocalMeta,
        ),
      );
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
        _serverUpdatedAtMeta,
        serverUpdatedAt.isAcceptableOrUnknown(
          data['server_updated_at']!,
          _serverUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('join_code')) {
      context.handle(
        _joinCodeMeta,
        joinCode.isAcceptableOrUnknown(data['join_code']!, _joinCodeMeta),
      );
    }
    if (data.containsKey('monthly_budget')) {
      context.handle(
        _monthlyBudgetMeta,
        monthlyBudget.isAcceptableOrUnknown(
          data['monthly_budget']!,
          _monthlyBudgetMeta,
        ),
      );
    }
    if (data.containsKey('month_start_date')) {
      context.handle(
        _monthStartDateMeta,
        monthStartDate.isAcceptableOrUnknown(
          data['month_start_date']!,
          _monthStartDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_monthStartDateMeta);
    }
    if (data.containsKey('remaining_main_bucket')) {
      context.handle(
        _remainingMainBucketMeta,
        remainingMainBucket.isAcceptableOrUnknown(
          data['remaining_main_bucket']!,
          _remainingMainBucketMeta,
        ),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('deleted_by')) {
      context.handle(
        _deletedByMeta,
        deletedBy.isAcceptableOrUnknown(data['deleted_by']!, _deletedByMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BucketRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BucketRow(
      syncState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_state'],
      )!,
      deletedLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted_local'],
      )!,
      updatedAtLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_local'],
      ),
      serverUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}server_updated_at'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_id'],
      )!,
      joinCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}join_code'],
      )!,
      monthlyBudget: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}monthly_budget'],
      )!,
      monthStartDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}month_start_date'],
      )!,
      remainingMainBucket: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}remaining_main_bucket'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      deletedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deleted_by'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
    );
  }

  @override
  $BucketsTable createAlias(String alias) {
    return $BucketsTable(attachedDatabase, alias);
  }
}

class BucketRow extends DataClass implements Insertable<BucketRow> {
  final String syncState;
  final bool deletedLocal;
  final DateTime? updatedAtLocal;
  final DateTime? serverUpdatedAt;
  final String id;
  final String name;
  final String ownerId;
  final String joinCode;
  final double monthlyBudget;
  final String monthStartDate;
  final double remainingMainBucket;
  final String currency;
  final String status;
  final DateTime? deletedAt;
  final String? deletedBy;
  final DateTime? createdAt;
  const BucketRow({
    required this.syncState,
    required this.deletedLocal,
    this.updatedAtLocal,
    this.serverUpdatedAt,
    required this.id,
    required this.name,
    required this.ownerId,
    required this.joinCode,
    required this.monthlyBudget,
    required this.monthStartDate,
    required this.remainingMainBucket,
    required this.currency,
    required this.status,
    this.deletedAt,
    this.deletedBy,
    this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['sync_state'] = Variable<String>(syncState);
    map['deleted_local'] = Variable<bool>(deletedLocal);
    if (!nullToAbsent || updatedAtLocal != null) {
      map['updated_at_local'] = Variable<DateTime>(updatedAtLocal);
    }
    if (!nullToAbsent || serverUpdatedAt != null) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    }
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['owner_id'] = Variable<String>(ownerId);
    map['join_code'] = Variable<String>(joinCode);
    map['monthly_budget'] = Variable<double>(monthlyBudget);
    map['month_start_date'] = Variable<String>(monthStartDate);
    map['remaining_main_bucket'] = Variable<double>(remainingMainBucket);
    map['currency'] = Variable<String>(currency);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || deletedBy != null) {
      map['deleted_by'] = Variable<String>(deletedBy);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  BucketsCompanion toCompanion(bool nullToAbsent) {
    return BucketsCompanion(
      syncState: Value(syncState),
      deletedLocal: Value(deletedLocal),
      updatedAtLocal: updatedAtLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAtLocal),
      serverUpdatedAt: serverUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUpdatedAt),
      id: Value(id),
      name: Value(name),
      ownerId: Value(ownerId),
      joinCode: Value(joinCode),
      monthlyBudget: Value(monthlyBudget),
      monthStartDate: Value(monthStartDate),
      remainingMainBucket: Value(remainingMainBucket),
      currency: Value(currency),
      status: Value(status),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deletedBy: deletedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedBy),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory BucketRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BucketRow(
      syncState: serializer.fromJson<String>(json['syncState']),
      deletedLocal: serializer.fromJson<bool>(json['deletedLocal']),
      updatedAtLocal: serializer.fromJson<DateTime?>(json['updatedAtLocal']),
      serverUpdatedAt: serializer.fromJson<DateTime?>(json['serverUpdatedAt']),
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      joinCode: serializer.fromJson<String>(json['joinCode']),
      monthlyBudget: serializer.fromJson<double>(json['monthlyBudget']),
      monthStartDate: serializer.fromJson<String>(json['monthStartDate']),
      remainingMainBucket: serializer.fromJson<double>(
        json['remainingMainBucket'],
      ),
      currency: serializer.fromJson<String>(json['currency']),
      status: serializer.fromJson<String>(json['status']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      deletedBy: serializer.fromJson<String?>(json['deletedBy']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'syncState': serializer.toJson<String>(syncState),
      'deletedLocal': serializer.toJson<bool>(deletedLocal),
      'updatedAtLocal': serializer.toJson<DateTime?>(updatedAtLocal),
      'serverUpdatedAt': serializer.toJson<DateTime?>(serverUpdatedAt),
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'ownerId': serializer.toJson<String>(ownerId),
      'joinCode': serializer.toJson<String>(joinCode),
      'monthlyBudget': serializer.toJson<double>(monthlyBudget),
      'monthStartDate': serializer.toJson<String>(monthStartDate),
      'remainingMainBucket': serializer.toJson<double>(remainingMainBucket),
      'currency': serializer.toJson<String>(currency),
      'status': serializer.toJson<String>(status),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'deletedBy': serializer.toJson<String?>(deletedBy),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  BucketRow copyWith({
    String? syncState,
    bool? deletedLocal,
    Value<DateTime?> updatedAtLocal = const Value.absent(),
    Value<DateTime?> serverUpdatedAt = const Value.absent(),
    String? id,
    String? name,
    String? ownerId,
    String? joinCode,
    double? monthlyBudget,
    String? monthStartDate,
    double? remainingMainBucket,
    String? currency,
    String? status,
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<String?> deletedBy = const Value.absent(),
    Value<DateTime?> createdAt = const Value.absent(),
  }) => BucketRow(
    syncState: syncState ?? this.syncState,
    deletedLocal: deletedLocal ?? this.deletedLocal,
    updatedAtLocal: updatedAtLocal.present
        ? updatedAtLocal.value
        : this.updatedAtLocal,
    serverUpdatedAt: serverUpdatedAt.present
        ? serverUpdatedAt.value
        : this.serverUpdatedAt,
    id: id ?? this.id,
    name: name ?? this.name,
    ownerId: ownerId ?? this.ownerId,
    joinCode: joinCode ?? this.joinCode,
    monthlyBudget: monthlyBudget ?? this.monthlyBudget,
    monthStartDate: monthStartDate ?? this.monthStartDate,
    remainingMainBucket: remainingMainBucket ?? this.remainingMainBucket,
    currency: currency ?? this.currency,
    status: status ?? this.status,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    deletedBy: deletedBy.present ? deletedBy.value : this.deletedBy,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
  );
  BucketRow copyWithCompanion(BucketsCompanion data) {
    return BucketRow(
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      deletedLocal: data.deletedLocal.present
          ? data.deletedLocal.value
          : this.deletedLocal,
      updatedAtLocal: data.updatedAtLocal.present
          ? data.updatedAtLocal.value
          : this.updatedAtLocal,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      joinCode: data.joinCode.present ? data.joinCode.value : this.joinCode,
      monthlyBudget: data.monthlyBudget.present
          ? data.monthlyBudget.value
          : this.monthlyBudget,
      monthStartDate: data.monthStartDate.present
          ? data.monthStartDate.value
          : this.monthStartDate,
      remainingMainBucket: data.remainingMainBucket.present
          ? data.remainingMainBucket.value
          : this.remainingMainBucket,
      currency: data.currency.present ? data.currency.value : this.currency,
      status: data.status.present ? data.status.value : this.status,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deletedBy: data.deletedBy.present ? data.deletedBy.value : this.deletedBy,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BucketRow(')
          ..write('syncState: $syncState, ')
          ..write('deletedLocal: $deletedLocal, ')
          ..write('updatedAtLocal: $updatedAtLocal, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('ownerId: $ownerId, ')
          ..write('joinCode: $joinCode, ')
          ..write('monthlyBudget: $monthlyBudget, ')
          ..write('monthStartDate: $monthStartDate, ')
          ..write('remainingMainBucket: $remainingMainBucket, ')
          ..write('currency: $currency, ')
          ..write('status: $status, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    syncState,
    deletedLocal,
    updatedAtLocal,
    serverUpdatedAt,
    id,
    name,
    ownerId,
    joinCode,
    monthlyBudget,
    monthStartDate,
    remainingMainBucket,
    currency,
    status,
    deletedAt,
    deletedBy,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BucketRow &&
          other.syncState == this.syncState &&
          other.deletedLocal == this.deletedLocal &&
          other.updatedAtLocal == this.updatedAtLocal &&
          other.serverUpdatedAt == this.serverUpdatedAt &&
          other.id == this.id &&
          other.name == this.name &&
          other.ownerId == this.ownerId &&
          other.joinCode == this.joinCode &&
          other.monthlyBudget == this.monthlyBudget &&
          other.monthStartDate == this.monthStartDate &&
          other.remainingMainBucket == this.remainingMainBucket &&
          other.currency == this.currency &&
          other.status == this.status &&
          other.deletedAt == this.deletedAt &&
          other.deletedBy == this.deletedBy &&
          other.createdAt == this.createdAt);
}

class BucketsCompanion extends UpdateCompanion<BucketRow> {
  final Value<String> syncState;
  final Value<bool> deletedLocal;
  final Value<DateTime?> updatedAtLocal;
  final Value<DateTime?> serverUpdatedAt;
  final Value<String> id;
  final Value<String> name;
  final Value<String> ownerId;
  final Value<String> joinCode;
  final Value<double> monthlyBudget;
  final Value<String> monthStartDate;
  final Value<double> remainingMainBucket;
  final Value<String> currency;
  final Value<String> status;
  final Value<DateTime?> deletedAt;
  final Value<String?> deletedBy;
  final Value<DateTime?> createdAt;
  final Value<int> rowid;
  const BucketsCompanion({
    this.syncState = const Value.absent(),
    this.deletedLocal = const Value.absent(),
    this.updatedAtLocal = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.joinCode = const Value.absent(),
    this.monthlyBudget = const Value.absent(),
    this.monthStartDate = const Value.absent(),
    this.remainingMainBucket = const Value.absent(),
    this.currency = const Value.absent(),
    this.status = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BucketsCompanion.insert({
    this.syncState = const Value.absent(),
    this.deletedLocal = const Value.absent(),
    this.updatedAtLocal = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    required String id,
    this.name = const Value.absent(),
    required String ownerId,
    this.joinCode = const Value.absent(),
    this.monthlyBudget = const Value.absent(),
    required String monthStartDate,
    this.remainingMainBucket = const Value.absent(),
    this.currency = const Value.absent(),
    this.status = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deletedBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ownerId = Value(ownerId),
       monthStartDate = Value(monthStartDate);
  static Insertable<BucketRow> custom({
    Expression<String>? syncState,
    Expression<bool>? deletedLocal,
    Expression<DateTime>? updatedAtLocal,
    Expression<DateTime>? serverUpdatedAt,
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? ownerId,
    Expression<String>? joinCode,
    Expression<double>? monthlyBudget,
    Expression<String>? monthStartDate,
    Expression<double>? remainingMainBucket,
    Expression<String>? currency,
    Expression<String>? status,
    Expression<DateTime>? deletedAt,
    Expression<String>? deletedBy,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (syncState != null) 'sync_state': syncState,
      if (deletedLocal != null) 'deleted_local': deletedLocal,
      if (updatedAtLocal != null) 'updated_at_local': updatedAtLocal,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (ownerId != null) 'owner_id': ownerId,
      if (joinCode != null) 'join_code': joinCode,
      if (monthlyBudget != null) 'monthly_budget': monthlyBudget,
      if (monthStartDate != null) 'month_start_date': monthStartDate,
      if (remainingMainBucket != null)
        'remaining_main_bucket': remainingMainBucket,
      if (currency != null) 'currency': currency,
      if (status != null) 'status': status,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deletedBy != null) 'deleted_by': deletedBy,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BucketsCompanion copyWith({
    Value<String>? syncState,
    Value<bool>? deletedLocal,
    Value<DateTime?>? updatedAtLocal,
    Value<DateTime?>? serverUpdatedAt,
    Value<String>? id,
    Value<String>? name,
    Value<String>? ownerId,
    Value<String>? joinCode,
    Value<double>? monthlyBudget,
    Value<String>? monthStartDate,
    Value<double>? remainingMainBucket,
    Value<String>? currency,
    Value<String>? status,
    Value<DateTime?>? deletedAt,
    Value<String?>? deletedBy,
    Value<DateTime?>? createdAt,
    Value<int>? rowid,
  }) {
    return BucketsCompanion(
      syncState: syncState ?? this.syncState,
      deletedLocal: deletedLocal ?? this.deletedLocal,
      updatedAtLocal: updatedAtLocal ?? this.updatedAtLocal,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      id: id ?? this.id,
      name: name ?? this.name,
      ownerId: ownerId ?? this.ownerId,
      joinCode: joinCode ?? this.joinCode,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      monthStartDate: monthStartDate ?? this.monthStartDate,
      remainingMainBucket: remainingMainBucket ?? this.remainingMainBucket,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (syncState.present) {
      map['sync_state'] = Variable<String>(syncState.value);
    }
    if (deletedLocal.present) {
      map['deleted_local'] = Variable<bool>(deletedLocal.value);
    }
    if (updatedAtLocal.present) {
      map['updated_at_local'] = Variable<DateTime>(updatedAtLocal.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (joinCode.present) {
      map['join_code'] = Variable<String>(joinCode.value);
    }
    if (monthlyBudget.present) {
      map['monthly_budget'] = Variable<double>(monthlyBudget.value);
    }
    if (monthStartDate.present) {
      map['month_start_date'] = Variable<String>(monthStartDate.value);
    }
    if (remainingMainBucket.present) {
      map['remaining_main_bucket'] = Variable<double>(
        remainingMainBucket.value,
      );
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (deletedBy.present) {
      map['deleted_by'] = Variable<String>(deletedBy.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BucketsCompanion(')
          ..write('syncState: $syncState, ')
          ..write('deletedLocal: $deletedLocal, ')
          ..write('updatedAtLocal: $updatedAtLocal, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('ownerId: $ownerId, ')
          ..write('joinCode: $joinCode, ')
          ..write('monthlyBudget: $monthlyBudget, ')
          ..write('monthStartDate: $monthStartDate, ')
          ..write('remainingMainBucket: $remainingMainBucket, ')
          ..write('currency: $currency, ')
          ..write('status: $status, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deletedBy: $deletedBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeeklyBucketRowsTable extends WeeklyBucketRows
    with TableInfo<$WeeklyBucketRowsTable, WeeklyBucketRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeeklyBucketRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _syncStateMeta = const VerificationMeta(
    'syncState',
  );
  @override
  late final GeneratedColumn<String> syncState = GeneratedColumn<String>(
    'sync_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('synced'),
  );
  static const VerificationMeta _deletedLocalMeta = const VerificationMeta(
    'deletedLocal',
  );
  @override
  late final GeneratedColumn<bool> deletedLocal = GeneratedColumn<bool>(
    'deleted_local',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted_local" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtLocalMeta = const VerificationMeta(
    'updatedAtLocal',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtLocal =
      GeneratedColumn<DateTime>(
        'updated_at_local',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _serverUpdatedAtMeta = const VerificationMeta(
    'serverUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> serverUpdatedAt =
      GeneratedColumn<DateTime>(
        'server_updated_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bucketIdMeta = const VerificationMeta(
    'bucketId',
  );
  @override
  late final GeneratedColumn<String> bucketId = GeneratedColumn<String>(
    'bucket_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weekIndexMeta = const VerificationMeta(
    'weekIndex',
  );
  @override
  late final GeneratedColumn<int> weekIndex = GeneratedColumn<int>(
    'week_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<String> startDate = GeneratedColumn<String>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<String> endDate = GeneratedColumn<String>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _effectiveStartDateMeta =
      const VerificationMeta('effectiveStartDate');
  @override
  late final GeneratedColumn<String> effectiveStartDate =
      GeneratedColumn<String>(
        'effective_start_date',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _allocatedAmountMeta = const VerificationMeta(
    'allocatedAmount',
  );
  @override
  late final GeneratedColumn<double> allocatedAmount = GeneratedColumn<double>(
    'allocated_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _spentAmountMeta = const VerificationMeta(
    'spentAmount',
  );
  @override
  late final GeneratedColumn<double> spentAmount = GeneratedColumn<double>(
    'spent_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _remainingAmountMeta = const VerificationMeta(
    'remainingAmount',
  );
  @override
  late final GeneratedColumn<double> remainingAmount = GeneratedColumn<double>(
    'remaining_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    syncState,
    deletedLocal,
    updatedAtLocal,
    serverUpdatedAt,
    id,
    bucketId,
    weekIndex,
    startDate,
    endDate,
    effectiveStartDate,
    kind,
    allocatedAmount,
    spentAmount,
    remainingAmount,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weekly_bucket_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeeklyBucketRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('sync_state')) {
      context.handle(
        _syncStateMeta,
        syncState.isAcceptableOrUnknown(data['sync_state']!, _syncStateMeta),
      );
    }
    if (data.containsKey('deleted_local')) {
      context.handle(
        _deletedLocalMeta,
        deletedLocal.isAcceptableOrUnknown(
          data['deleted_local']!,
          _deletedLocalMeta,
        ),
      );
    }
    if (data.containsKey('updated_at_local')) {
      context.handle(
        _updatedAtLocalMeta,
        updatedAtLocal.isAcceptableOrUnknown(
          data['updated_at_local']!,
          _updatedAtLocalMeta,
        ),
      );
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
        _serverUpdatedAtMeta,
        serverUpdatedAt.isAcceptableOrUnknown(
          data['server_updated_at']!,
          _serverUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('bucket_id')) {
      context.handle(
        _bucketIdMeta,
        bucketId.isAcceptableOrUnknown(data['bucket_id']!, _bucketIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bucketIdMeta);
    }
    if (data.containsKey('week_index')) {
      context.handle(
        _weekIndexMeta,
        weekIndex.isAcceptableOrUnknown(data['week_index']!, _weekIndexMeta),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('effective_start_date')) {
      context.handle(
        _effectiveStartDateMeta,
        effectiveStartDate.isAcceptableOrUnknown(
          data['effective_start_date']!,
          _effectiveStartDateMeta,
        ),
      );
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    }
    if (data.containsKey('allocated_amount')) {
      context.handle(
        _allocatedAmountMeta,
        allocatedAmount.isAcceptableOrUnknown(
          data['allocated_amount']!,
          _allocatedAmountMeta,
        ),
      );
    }
    if (data.containsKey('spent_amount')) {
      context.handle(
        _spentAmountMeta,
        spentAmount.isAcceptableOrUnknown(
          data['spent_amount']!,
          _spentAmountMeta,
        ),
      );
    }
    if (data.containsKey('remaining_amount')) {
      context.handle(
        _remainingAmountMeta,
        remainingAmount.isAcceptableOrUnknown(
          data['remaining_amount']!,
          _remainingAmountMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeeklyBucketRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeeklyBucketRow(
      syncState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_state'],
      )!,
      deletedLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted_local'],
      )!,
      updatedAtLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_local'],
      ),
      serverUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}server_updated_at'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      bucketId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bucket_id'],
      )!,
      weekIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}week_index'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_date'],
      )!,
      effectiveStartDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}effective_start_date'],
      ),
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      allocatedAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}allocated_amount'],
      )!,
      spentAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}spent_amount'],
      )!,
      remainingAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}remaining_amount'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $WeeklyBucketRowsTable createAlias(String alias) {
    return $WeeklyBucketRowsTable(attachedDatabase, alias);
  }
}

class WeeklyBucketRow extends DataClass implements Insertable<WeeklyBucketRow> {
  final String syncState;
  final bool deletedLocal;
  final DateTime? updatedAtLocal;
  final DateTime? serverUpdatedAt;
  final String id;
  final String bucketId;
  final int weekIndex;
  final String startDate;
  final String endDate;
  final String? effectiveStartDate;
  final String kind;
  final double allocatedAmount;
  final double spentAmount;
  final double remainingAmount;
  final String status;
  const WeeklyBucketRow({
    required this.syncState,
    required this.deletedLocal,
    this.updatedAtLocal,
    this.serverUpdatedAt,
    required this.id,
    required this.bucketId,
    required this.weekIndex,
    required this.startDate,
    required this.endDate,
    this.effectiveStartDate,
    required this.kind,
    required this.allocatedAmount,
    required this.spentAmount,
    required this.remainingAmount,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['sync_state'] = Variable<String>(syncState);
    map['deleted_local'] = Variable<bool>(deletedLocal);
    if (!nullToAbsent || updatedAtLocal != null) {
      map['updated_at_local'] = Variable<DateTime>(updatedAtLocal);
    }
    if (!nullToAbsent || serverUpdatedAt != null) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    }
    map['id'] = Variable<String>(id);
    map['bucket_id'] = Variable<String>(bucketId);
    map['week_index'] = Variable<int>(weekIndex);
    map['start_date'] = Variable<String>(startDate);
    map['end_date'] = Variable<String>(endDate);
    if (!nullToAbsent || effectiveStartDate != null) {
      map['effective_start_date'] = Variable<String>(effectiveStartDate);
    }
    map['kind'] = Variable<String>(kind);
    map['allocated_amount'] = Variable<double>(allocatedAmount);
    map['spent_amount'] = Variable<double>(spentAmount);
    map['remaining_amount'] = Variable<double>(remainingAmount);
    map['status'] = Variable<String>(status);
    return map;
  }

  WeeklyBucketRowsCompanion toCompanion(bool nullToAbsent) {
    return WeeklyBucketRowsCompanion(
      syncState: Value(syncState),
      deletedLocal: Value(deletedLocal),
      updatedAtLocal: updatedAtLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAtLocal),
      serverUpdatedAt: serverUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUpdatedAt),
      id: Value(id),
      bucketId: Value(bucketId),
      weekIndex: Value(weekIndex),
      startDate: Value(startDate),
      endDate: Value(endDate),
      effectiveStartDate: effectiveStartDate == null && nullToAbsent
          ? const Value.absent()
          : Value(effectiveStartDate),
      kind: Value(kind),
      allocatedAmount: Value(allocatedAmount),
      spentAmount: Value(spentAmount),
      remainingAmount: Value(remainingAmount),
      status: Value(status),
    );
  }

  factory WeeklyBucketRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeeklyBucketRow(
      syncState: serializer.fromJson<String>(json['syncState']),
      deletedLocal: serializer.fromJson<bool>(json['deletedLocal']),
      updatedAtLocal: serializer.fromJson<DateTime?>(json['updatedAtLocal']),
      serverUpdatedAt: serializer.fromJson<DateTime?>(json['serverUpdatedAt']),
      id: serializer.fromJson<String>(json['id']),
      bucketId: serializer.fromJson<String>(json['bucketId']),
      weekIndex: serializer.fromJson<int>(json['weekIndex']),
      startDate: serializer.fromJson<String>(json['startDate']),
      endDate: serializer.fromJson<String>(json['endDate']),
      effectiveStartDate: serializer.fromJson<String?>(
        json['effectiveStartDate'],
      ),
      kind: serializer.fromJson<String>(json['kind']),
      allocatedAmount: serializer.fromJson<double>(json['allocatedAmount']),
      spentAmount: serializer.fromJson<double>(json['spentAmount']),
      remainingAmount: serializer.fromJson<double>(json['remainingAmount']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'syncState': serializer.toJson<String>(syncState),
      'deletedLocal': serializer.toJson<bool>(deletedLocal),
      'updatedAtLocal': serializer.toJson<DateTime?>(updatedAtLocal),
      'serverUpdatedAt': serializer.toJson<DateTime?>(serverUpdatedAt),
      'id': serializer.toJson<String>(id),
      'bucketId': serializer.toJson<String>(bucketId),
      'weekIndex': serializer.toJson<int>(weekIndex),
      'startDate': serializer.toJson<String>(startDate),
      'endDate': serializer.toJson<String>(endDate),
      'effectiveStartDate': serializer.toJson<String?>(effectiveStartDate),
      'kind': serializer.toJson<String>(kind),
      'allocatedAmount': serializer.toJson<double>(allocatedAmount),
      'spentAmount': serializer.toJson<double>(spentAmount),
      'remainingAmount': serializer.toJson<double>(remainingAmount),
      'status': serializer.toJson<String>(status),
    };
  }

  WeeklyBucketRow copyWith({
    String? syncState,
    bool? deletedLocal,
    Value<DateTime?> updatedAtLocal = const Value.absent(),
    Value<DateTime?> serverUpdatedAt = const Value.absent(),
    String? id,
    String? bucketId,
    int? weekIndex,
    String? startDate,
    String? endDate,
    Value<String?> effectiveStartDate = const Value.absent(),
    String? kind,
    double? allocatedAmount,
    double? spentAmount,
    double? remainingAmount,
    String? status,
  }) => WeeklyBucketRow(
    syncState: syncState ?? this.syncState,
    deletedLocal: deletedLocal ?? this.deletedLocal,
    updatedAtLocal: updatedAtLocal.present
        ? updatedAtLocal.value
        : this.updatedAtLocal,
    serverUpdatedAt: serverUpdatedAt.present
        ? serverUpdatedAt.value
        : this.serverUpdatedAt,
    id: id ?? this.id,
    bucketId: bucketId ?? this.bucketId,
    weekIndex: weekIndex ?? this.weekIndex,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    effectiveStartDate: effectiveStartDate.present
        ? effectiveStartDate.value
        : this.effectiveStartDate,
    kind: kind ?? this.kind,
    allocatedAmount: allocatedAmount ?? this.allocatedAmount,
    spentAmount: spentAmount ?? this.spentAmount,
    remainingAmount: remainingAmount ?? this.remainingAmount,
    status: status ?? this.status,
  );
  WeeklyBucketRow copyWithCompanion(WeeklyBucketRowsCompanion data) {
    return WeeklyBucketRow(
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      deletedLocal: data.deletedLocal.present
          ? data.deletedLocal.value
          : this.deletedLocal,
      updatedAtLocal: data.updatedAtLocal.present
          ? data.updatedAtLocal.value
          : this.updatedAtLocal,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
      id: data.id.present ? data.id.value : this.id,
      bucketId: data.bucketId.present ? data.bucketId.value : this.bucketId,
      weekIndex: data.weekIndex.present ? data.weekIndex.value : this.weekIndex,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      effectiveStartDate: data.effectiveStartDate.present
          ? data.effectiveStartDate.value
          : this.effectiveStartDate,
      kind: data.kind.present ? data.kind.value : this.kind,
      allocatedAmount: data.allocatedAmount.present
          ? data.allocatedAmount.value
          : this.allocatedAmount,
      spentAmount: data.spentAmount.present
          ? data.spentAmount.value
          : this.spentAmount,
      remainingAmount: data.remainingAmount.present
          ? data.remainingAmount.value
          : this.remainingAmount,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyBucketRow(')
          ..write('syncState: $syncState, ')
          ..write('deletedLocal: $deletedLocal, ')
          ..write('updatedAtLocal: $updatedAtLocal, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('id: $id, ')
          ..write('bucketId: $bucketId, ')
          ..write('weekIndex: $weekIndex, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('effectiveStartDate: $effectiveStartDate, ')
          ..write('kind: $kind, ')
          ..write('allocatedAmount: $allocatedAmount, ')
          ..write('spentAmount: $spentAmount, ')
          ..write('remainingAmount: $remainingAmount, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    syncState,
    deletedLocal,
    updatedAtLocal,
    serverUpdatedAt,
    id,
    bucketId,
    weekIndex,
    startDate,
    endDate,
    effectiveStartDate,
    kind,
    allocatedAmount,
    spentAmount,
    remainingAmount,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeeklyBucketRow &&
          other.syncState == this.syncState &&
          other.deletedLocal == this.deletedLocal &&
          other.updatedAtLocal == this.updatedAtLocal &&
          other.serverUpdatedAt == this.serverUpdatedAt &&
          other.id == this.id &&
          other.bucketId == this.bucketId &&
          other.weekIndex == this.weekIndex &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.effectiveStartDate == this.effectiveStartDate &&
          other.kind == this.kind &&
          other.allocatedAmount == this.allocatedAmount &&
          other.spentAmount == this.spentAmount &&
          other.remainingAmount == this.remainingAmount &&
          other.status == this.status);
}

class WeeklyBucketRowsCompanion extends UpdateCompanion<WeeklyBucketRow> {
  final Value<String> syncState;
  final Value<bool> deletedLocal;
  final Value<DateTime?> updatedAtLocal;
  final Value<DateTime?> serverUpdatedAt;
  final Value<String> id;
  final Value<String> bucketId;
  final Value<int> weekIndex;
  final Value<String> startDate;
  final Value<String> endDate;
  final Value<String?> effectiveStartDate;
  final Value<String> kind;
  final Value<double> allocatedAmount;
  final Value<double> spentAmount;
  final Value<double> remainingAmount;
  final Value<String> status;
  final Value<int> rowid;
  const WeeklyBucketRowsCompanion({
    this.syncState = const Value.absent(),
    this.deletedLocal = const Value.absent(),
    this.updatedAtLocal = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.bucketId = const Value.absent(),
    this.weekIndex = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.effectiveStartDate = const Value.absent(),
    this.kind = const Value.absent(),
    this.allocatedAmount = const Value.absent(),
    this.spentAmount = const Value.absent(),
    this.remainingAmount = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeeklyBucketRowsCompanion.insert({
    this.syncState = const Value.absent(),
    this.deletedLocal = const Value.absent(),
    this.updatedAtLocal = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    required String id,
    required String bucketId,
    this.weekIndex = const Value.absent(),
    required String startDate,
    required String endDate,
    this.effectiveStartDate = const Value.absent(),
    this.kind = const Value.absent(),
    this.allocatedAmount = const Value.absent(),
    this.spentAmount = const Value.absent(),
    this.remainingAmount = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       bucketId = Value(bucketId),
       startDate = Value(startDate),
       endDate = Value(endDate);
  static Insertable<WeeklyBucketRow> custom({
    Expression<String>? syncState,
    Expression<bool>? deletedLocal,
    Expression<DateTime>? updatedAtLocal,
    Expression<DateTime>? serverUpdatedAt,
    Expression<String>? id,
    Expression<String>? bucketId,
    Expression<int>? weekIndex,
    Expression<String>? startDate,
    Expression<String>? endDate,
    Expression<String>? effectiveStartDate,
    Expression<String>? kind,
    Expression<double>? allocatedAmount,
    Expression<double>? spentAmount,
    Expression<double>? remainingAmount,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (syncState != null) 'sync_state': syncState,
      if (deletedLocal != null) 'deleted_local': deletedLocal,
      if (updatedAtLocal != null) 'updated_at_local': updatedAtLocal,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (id != null) 'id': id,
      if (bucketId != null) 'bucket_id': bucketId,
      if (weekIndex != null) 'week_index': weekIndex,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (effectiveStartDate != null)
        'effective_start_date': effectiveStartDate,
      if (kind != null) 'kind': kind,
      if (allocatedAmount != null) 'allocated_amount': allocatedAmount,
      if (spentAmount != null) 'spent_amount': spentAmount,
      if (remainingAmount != null) 'remaining_amount': remainingAmount,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeeklyBucketRowsCompanion copyWith({
    Value<String>? syncState,
    Value<bool>? deletedLocal,
    Value<DateTime?>? updatedAtLocal,
    Value<DateTime?>? serverUpdatedAt,
    Value<String>? id,
    Value<String>? bucketId,
    Value<int>? weekIndex,
    Value<String>? startDate,
    Value<String>? endDate,
    Value<String?>? effectiveStartDate,
    Value<String>? kind,
    Value<double>? allocatedAmount,
    Value<double>? spentAmount,
    Value<double>? remainingAmount,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return WeeklyBucketRowsCompanion(
      syncState: syncState ?? this.syncState,
      deletedLocal: deletedLocal ?? this.deletedLocal,
      updatedAtLocal: updatedAtLocal ?? this.updatedAtLocal,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      id: id ?? this.id,
      bucketId: bucketId ?? this.bucketId,
      weekIndex: weekIndex ?? this.weekIndex,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      effectiveStartDate: effectiveStartDate ?? this.effectiveStartDate,
      kind: kind ?? this.kind,
      allocatedAmount: allocatedAmount ?? this.allocatedAmount,
      spentAmount: spentAmount ?? this.spentAmount,
      remainingAmount: remainingAmount ?? this.remainingAmount,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (syncState.present) {
      map['sync_state'] = Variable<String>(syncState.value);
    }
    if (deletedLocal.present) {
      map['deleted_local'] = Variable<bool>(deletedLocal.value);
    }
    if (updatedAtLocal.present) {
      map['updated_at_local'] = Variable<DateTime>(updatedAtLocal.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bucketId.present) {
      map['bucket_id'] = Variable<String>(bucketId.value);
    }
    if (weekIndex.present) {
      map['week_index'] = Variable<int>(weekIndex.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<String>(endDate.value);
    }
    if (effectiveStartDate.present) {
      map['effective_start_date'] = Variable<String>(effectiveStartDate.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (allocatedAmount.present) {
      map['allocated_amount'] = Variable<double>(allocatedAmount.value);
    }
    if (spentAmount.present) {
      map['spent_amount'] = Variable<double>(spentAmount.value);
    }
    if (remainingAmount.present) {
      map['remaining_amount'] = Variable<double>(remainingAmount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyBucketRowsCompanion(')
          ..write('syncState: $syncState, ')
          ..write('deletedLocal: $deletedLocal, ')
          ..write('updatedAtLocal: $updatedAtLocal, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('id: $id, ')
          ..write('bucketId: $bucketId, ')
          ..write('weekIndex: $weekIndex, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('effectiveStartDate: $effectiveStartDate, ')
          ..write('kind: $kind, ')
          ..write('allocatedAmount: $allocatedAmount, ')
          ..write('spentAmount: $spentAmount, ')
          ..write('remainingAmount: $remainingAmount, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses
    with TableInfo<$ExpensesTable, ExpenseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _syncStateMeta = const VerificationMeta(
    'syncState',
  );
  @override
  late final GeneratedColumn<String> syncState = GeneratedColumn<String>(
    'sync_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('synced'),
  );
  static const VerificationMeta _deletedLocalMeta = const VerificationMeta(
    'deletedLocal',
  );
  @override
  late final GeneratedColumn<bool> deletedLocal = GeneratedColumn<bool>(
    'deleted_local',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted_local" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtLocalMeta = const VerificationMeta(
    'updatedAtLocal',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtLocal =
      GeneratedColumn<DateTime>(
        'updated_at_local',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _serverUpdatedAtMeta = const VerificationMeta(
    'serverUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> serverUpdatedAt =
      GeneratedColumn<DateTime>(
        'server_updated_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bucketIdMeta = const VerificationMeta(
    'bucketId',
  );
  @override
  late final GeneratedColumn<String> bucketId = GeneratedColumn<String>(
    'bucket_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weekIdMeta = const VerificationMeta('weekId');
  @override
  late final GeneratedColumn<String> weekId = GeneratedColumn<String>(
    'week_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addedByUidMeta = const VerificationMeta(
    'addedByUid',
  );
  @override
  late final GeneratedColumn<String> addedByUid = GeneratedColumn<String>(
    'added_by_uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _receiptImageUrlMeta = const VerificationMeta(
    'receiptImageUrl',
  );
  @override
  late final GeneratedColumn<String> receiptImageUrl = GeneratedColumn<String>(
    'receipt_image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _editedByUidMeta = const VerificationMeta(
    'editedByUid',
  );
  @override
  late final GeneratedColumn<String> editedByUid = GeneratedColumn<String>(
    'edited_by_uid',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    syncState,
    deletedLocal,
    updatedAtLocal,
    serverUpdatedAt,
    id,
    bucketId,
    weekId,
    addedByUid,
    amount,
    categoryId,
    note,
    receiptImageUrl,
    createdAt,
    editedByUid,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExpenseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('sync_state')) {
      context.handle(
        _syncStateMeta,
        syncState.isAcceptableOrUnknown(data['sync_state']!, _syncStateMeta),
      );
    }
    if (data.containsKey('deleted_local')) {
      context.handle(
        _deletedLocalMeta,
        deletedLocal.isAcceptableOrUnknown(
          data['deleted_local']!,
          _deletedLocalMeta,
        ),
      );
    }
    if (data.containsKey('updated_at_local')) {
      context.handle(
        _updatedAtLocalMeta,
        updatedAtLocal.isAcceptableOrUnknown(
          data['updated_at_local']!,
          _updatedAtLocalMeta,
        ),
      );
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
        _serverUpdatedAtMeta,
        serverUpdatedAt.isAcceptableOrUnknown(
          data['server_updated_at']!,
          _serverUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('bucket_id')) {
      context.handle(
        _bucketIdMeta,
        bucketId.isAcceptableOrUnknown(data['bucket_id']!, _bucketIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bucketIdMeta);
    }
    if (data.containsKey('week_id')) {
      context.handle(
        _weekIdMeta,
        weekId.isAcceptableOrUnknown(data['week_id']!, _weekIdMeta),
      );
    }
    if (data.containsKey('added_by_uid')) {
      context.handle(
        _addedByUidMeta,
        addedByUid.isAcceptableOrUnknown(
          data['added_by_uid']!,
          _addedByUidMeta,
        ),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('receipt_image_url')) {
      context.handle(
        _receiptImageUrlMeta,
        receiptImageUrl.isAcceptableOrUnknown(
          data['receipt_image_url']!,
          _receiptImageUrlMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('edited_by_uid')) {
      context.handle(
        _editedByUidMeta,
        editedByUid.isAcceptableOrUnknown(
          data['edited_by_uid']!,
          _editedByUidMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpenseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseRow(
      syncState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_state'],
      )!,
      deletedLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted_local'],
      )!,
      updatedAtLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_local'],
      ),
      serverUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}server_updated_at'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      bucketId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bucket_id'],
      )!,
      weekId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}week_id'],
      ),
      addedByUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}added_by_uid'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      receiptImageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_image_url'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      editedByUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}edited_by_uid'],
      ),
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }
}

class ExpenseRow extends DataClass implements Insertable<ExpenseRow> {
  final String syncState;
  final bool deletedLocal;
  final DateTime? updatedAtLocal;
  final DateTime? serverUpdatedAt;
  final String id;
  final String bucketId;
  final String? weekId;
  final String addedByUid;
  final double amount;
  final String? categoryId;
  final String? note;
  final String? receiptImageUrl;
  final DateTime createdAt;
  final String? editedByUid;
  const ExpenseRow({
    required this.syncState,
    required this.deletedLocal,
    this.updatedAtLocal,
    this.serverUpdatedAt,
    required this.id,
    required this.bucketId,
    this.weekId,
    required this.addedByUid,
    required this.amount,
    this.categoryId,
    this.note,
    this.receiptImageUrl,
    required this.createdAt,
    this.editedByUid,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['sync_state'] = Variable<String>(syncState);
    map['deleted_local'] = Variable<bool>(deletedLocal);
    if (!nullToAbsent || updatedAtLocal != null) {
      map['updated_at_local'] = Variable<DateTime>(updatedAtLocal);
    }
    if (!nullToAbsent || serverUpdatedAt != null) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    }
    map['id'] = Variable<String>(id);
    map['bucket_id'] = Variable<String>(bucketId);
    if (!nullToAbsent || weekId != null) {
      map['week_id'] = Variable<String>(weekId);
    }
    map['added_by_uid'] = Variable<String>(addedByUid);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || receiptImageUrl != null) {
      map['receipt_image_url'] = Variable<String>(receiptImageUrl);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || editedByUid != null) {
      map['edited_by_uid'] = Variable<String>(editedByUid);
    }
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      syncState: Value(syncState),
      deletedLocal: Value(deletedLocal),
      updatedAtLocal: updatedAtLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAtLocal),
      serverUpdatedAt: serverUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUpdatedAt),
      id: Value(id),
      bucketId: Value(bucketId),
      weekId: weekId == null && nullToAbsent
          ? const Value.absent()
          : Value(weekId),
      addedByUid: Value(addedByUid),
      amount: Value(amount),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      receiptImageUrl: receiptImageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(receiptImageUrl),
      createdAt: Value(createdAt),
      editedByUid: editedByUid == null && nullToAbsent
          ? const Value.absent()
          : Value(editedByUid),
    );
  }

  factory ExpenseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseRow(
      syncState: serializer.fromJson<String>(json['syncState']),
      deletedLocal: serializer.fromJson<bool>(json['deletedLocal']),
      updatedAtLocal: serializer.fromJson<DateTime?>(json['updatedAtLocal']),
      serverUpdatedAt: serializer.fromJson<DateTime?>(json['serverUpdatedAt']),
      id: serializer.fromJson<String>(json['id']),
      bucketId: serializer.fromJson<String>(json['bucketId']),
      weekId: serializer.fromJson<String?>(json['weekId']),
      addedByUid: serializer.fromJson<String>(json['addedByUid']),
      amount: serializer.fromJson<double>(json['amount']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      note: serializer.fromJson<String?>(json['note']),
      receiptImageUrl: serializer.fromJson<String?>(json['receiptImageUrl']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      editedByUid: serializer.fromJson<String?>(json['editedByUid']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'syncState': serializer.toJson<String>(syncState),
      'deletedLocal': serializer.toJson<bool>(deletedLocal),
      'updatedAtLocal': serializer.toJson<DateTime?>(updatedAtLocal),
      'serverUpdatedAt': serializer.toJson<DateTime?>(serverUpdatedAt),
      'id': serializer.toJson<String>(id),
      'bucketId': serializer.toJson<String>(bucketId),
      'weekId': serializer.toJson<String?>(weekId),
      'addedByUid': serializer.toJson<String>(addedByUid),
      'amount': serializer.toJson<double>(amount),
      'categoryId': serializer.toJson<String?>(categoryId),
      'note': serializer.toJson<String?>(note),
      'receiptImageUrl': serializer.toJson<String?>(receiptImageUrl),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'editedByUid': serializer.toJson<String?>(editedByUid),
    };
  }

  ExpenseRow copyWith({
    String? syncState,
    bool? deletedLocal,
    Value<DateTime?> updatedAtLocal = const Value.absent(),
    Value<DateTime?> serverUpdatedAt = const Value.absent(),
    String? id,
    String? bucketId,
    Value<String?> weekId = const Value.absent(),
    String? addedByUid,
    double? amount,
    Value<String?> categoryId = const Value.absent(),
    Value<String?> note = const Value.absent(),
    Value<String?> receiptImageUrl = const Value.absent(),
    DateTime? createdAt,
    Value<String?> editedByUid = const Value.absent(),
  }) => ExpenseRow(
    syncState: syncState ?? this.syncState,
    deletedLocal: deletedLocal ?? this.deletedLocal,
    updatedAtLocal: updatedAtLocal.present
        ? updatedAtLocal.value
        : this.updatedAtLocal,
    serverUpdatedAt: serverUpdatedAt.present
        ? serverUpdatedAt.value
        : this.serverUpdatedAt,
    id: id ?? this.id,
    bucketId: bucketId ?? this.bucketId,
    weekId: weekId.present ? weekId.value : this.weekId,
    addedByUid: addedByUid ?? this.addedByUid,
    amount: amount ?? this.amount,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    note: note.present ? note.value : this.note,
    receiptImageUrl: receiptImageUrl.present
        ? receiptImageUrl.value
        : this.receiptImageUrl,
    createdAt: createdAt ?? this.createdAt,
    editedByUid: editedByUid.present ? editedByUid.value : this.editedByUid,
  );
  ExpenseRow copyWithCompanion(ExpensesCompanion data) {
    return ExpenseRow(
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      deletedLocal: data.deletedLocal.present
          ? data.deletedLocal.value
          : this.deletedLocal,
      updatedAtLocal: data.updatedAtLocal.present
          ? data.updatedAtLocal.value
          : this.updatedAtLocal,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
      id: data.id.present ? data.id.value : this.id,
      bucketId: data.bucketId.present ? data.bucketId.value : this.bucketId,
      weekId: data.weekId.present ? data.weekId.value : this.weekId,
      addedByUid: data.addedByUid.present
          ? data.addedByUid.value
          : this.addedByUid,
      amount: data.amount.present ? data.amount.value : this.amount,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      note: data.note.present ? data.note.value : this.note,
      receiptImageUrl: data.receiptImageUrl.present
          ? data.receiptImageUrl.value
          : this.receiptImageUrl,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      editedByUid: data.editedByUid.present
          ? data.editedByUid.value
          : this.editedByUid,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseRow(')
          ..write('syncState: $syncState, ')
          ..write('deletedLocal: $deletedLocal, ')
          ..write('updatedAtLocal: $updatedAtLocal, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('id: $id, ')
          ..write('bucketId: $bucketId, ')
          ..write('weekId: $weekId, ')
          ..write('addedByUid: $addedByUid, ')
          ..write('amount: $amount, ')
          ..write('categoryId: $categoryId, ')
          ..write('note: $note, ')
          ..write('receiptImageUrl: $receiptImageUrl, ')
          ..write('createdAt: $createdAt, ')
          ..write('editedByUid: $editedByUid')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    syncState,
    deletedLocal,
    updatedAtLocal,
    serverUpdatedAt,
    id,
    bucketId,
    weekId,
    addedByUid,
    amount,
    categoryId,
    note,
    receiptImageUrl,
    createdAt,
    editedByUid,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseRow &&
          other.syncState == this.syncState &&
          other.deletedLocal == this.deletedLocal &&
          other.updatedAtLocal == this.updatedAtLocal &&
          other.serverUpdatedAt == this.serverUpdatedAt &&
          other.id == this.id &&
          other.bucketId == this.bucketId &&
          other.weekId == this.weekId &&
          other.addedByUid == this.addedByUid &&
          other.amount == this.amount &&
          other.categoryId == this.categoryId &&
          other.note == this.note &&
          other.receiptImageUrl == this.receiptImageUrl &&
          other.createdAt == this.createdAt &&
          other.editedByUid == this.editedByUid);
}

class ExpensesCompanion extends UpdateCompanion<ExpenseRow> {
  final Value<String> syncState;
  final Value<bool> deletedLocal;
  final Value<DateTime?> updatedAtLocal;
  final Value<DateTime?> serverUpdatedAt;
  final Value<String> id;
  final Value<String> bucketId;
  final Value<String?> weekId;
  final Value<String> addedByUid;
  final Value<double> amount;
  final Value<String?> categoryId;
  final Value<String?> note;
  final Value<String?> receiptImageUrl;
  final Value<DateTime> createdAt;
  final Value<String?> editedByUid;
  final Value<int> rowid;
  const ExpensesCompanion({
    this.syncState = const Value.absent(),
    this.deletedLocal = const Value.absent(),
    this.updatedAtLocal = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.bucketId = const Value.absent(),
    this.weekId = const Value.absent(),
    this.addedByUid = const Value.absent(),
    this.amount = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.note = const Value.absent(),
    this.receiptImageUrl = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.editedByUid = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExpensesCompanion.insert({
    this.syncState = const Value.absent(),
    this.deletedLocal = const Value.absent(),
    this.updatedAtLocal = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    required String id,
    required String bucketId,
    this.weekId = const Value.absent(),
    this.addedByUid = const Value.absent(),
    this.amount = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.note = const Value.absent(),
    this.receiptImageUrl = const Value.absent(),
    required DateTime createdAt,
    this.editedByUid = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       bucketId = Value(bucketId),
       createdAt = Value(createdAt);
  static Insertable<ExpenseRow> custom({
    Expression<String>? syncState,
    Expression<bool>? deletedLocal,
    Expression<DateTime>? updatedAtLocal,
    Expression<DateTime>? serverUpdatedAt,
    Expression<String>? id,
    Expression<String>? bucketId,
    Expression<String>? weekId,
    Expression<String>? addedByUid,
    Expression<double>? amount,
    Expression<String>? categoryId,
    Expression<String>? note,
    Expression<String>? receiptImageUrl,
    Expression<DateTime>? createdAt,
    Expression<String>? editedByUid,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (syncState != null) 'sync_state': syncState,
      if (deletedLocal != null) 'deleted_local': deletedLocal,
      if (updatedAtLocal != null) 'updated_at_local': updatedAtLocal,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (id != null) 'id': id,
      if (bucketId != null) 'bucket_id': bucketId,
      if (weekId != null) 'week_id': weekId,
      if (addedByUid != null) 'added_by_uid': addedByUid,
      if (amount != null) 'amount': amount,
      if (categoryId != null) 'category_id': categoryId,
      if (note != null) 'note': note,
      if (receiptImageUrl != null) 'receipt_image_url': receiptImageUrl,
      if (createdAt != null) 'created_at': createdAt,
      if (editedByUid != null) 'edited_by_uid': editedByUid,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExpensesCompanion copyWith({
    Value<String>? syncState,
    Value<bool>? deletedLocal,
    Value<DateTime?>? updatedAtLocal,
    Value<DateTime?>? serverUpdatedAt,
    Value<String>? id,
    Value<String>? bucketId,
    Value<String?>? weekId,
    Value<String>? addedByUid,
    Value<double>? amount,
    Value<String?>? categoryId,
    Value<String?>? note,
    Value<String?>? receiptImageUrl,
    Value<DateTime>? createdAt,
    Value<String?>? editedByUid,
    Value<int>? rowid,
  }) {
    return ExpensesCompanion(
      syncState: syncState ?? this.syncState,
      deletedLocal: deletedLocal ?? this.deletedLocal,
      updatedAtLocal: updatedAtLocal ?? this.updatedAtLocal,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      id: id ?? this.id,
      bucketId: bucketId ?? this.bucketId,
      weekId: weekId ?? this.weekId,
      addedByUid: addedByUid ?? this.addedByUid,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      note: note ?? this.note,
      receiptImageUrl: receiptImageUrl ?? this.receiptImageUrl,
      createdAt: createdAt ?? this.createdAt,
      editedByUid: editedByUid ?? this.editedByUid,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (syncState.present) {
      map['sync_state'] = Variable<String>(syncState.value);
    }
    if (deletedLocal.present) {
      map['deleted_local'] = Variable<bool>(deletedLocal.value);
    }
    if (updatedAtLocal.present) {
      map['updated_at_local'] = Variable<DateTime>(updatedAtLocal.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bucketId.present) {
      map['bucket_id'] = Variable<String>(bucketId.value);
    }
    if (weekId.present) {
      map['week_id'] = Variable<String>(weekId.value);
    }
    if (addedByUid.present) {
      map['added_by_uid'] = Variable<String>(addedByUid.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (receiptImageUrl.present) {
      map['receipt_image_url'] = Variable<String>(receiptImageUrl.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (editedByUid.present) {
      map['edited_by_uid'] = Variable<String>(editedByUid.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('syncState: $syncState, ')
          ..write('deletedLocal: $deletedLocal, ')
          ..write('updatedAtLocal: $updatedAtLocal, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('id: $id, ')
          ..write('bucketId: $bucketId, ')
          ..write('weekId: $weekId, ')
          ..write('addedByUid: $addedByUid, ')
          ..write('amount: $amount, ')
          ..write('categoryId: $categoryId, ')
          ..write('note: $note, ')
          ..write('receiptImageUrl: $receiptImageUrl, ')
          ..write('createdAt: $createdAt, ')
          ..write('editedByUid: $editedByUid, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BigExpensesTable extends BigExpenses
    with TableInfo<$BigExpensesTable, BigExpenseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BigExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _syncStateMeta = const VerificationMeta(
    'syncState',
  );
  @override
  late final GeneratedColumn<String> syncState = GeneratedColumn<String>(
    'sync_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('synced'),
  );
  static const VerificationMeta _deletedLocalMeta = const VerificationMeta(
    'deletedLocal',
  );
  @override
  late final GeneratedColumn<bool> deletedLocal = GeneratedColumn<bool>(
    'deleted_local',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted_local" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtLocalMeta = const VerificationMeta(
    'updatedAtLocal',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtLocal =
      GeneratedColumn<DateTime>(
        'updated_at_local',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _serverUpdatedAtMeta = const VerificationMeta(
    'serverUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> serverUpdatedAt =
      GeneratedColumn<DateTime>(
        'server_updated_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bucketIdMeta = const VerificationMeta(
    'bucketId',
  );
  @override
  late final GeneratedColumn<String> bucketId = GeneratedColumn<String>(
    'bucket_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addedByUidMeta = const VerificationMeta(
    'addedByUid',
  );
  @override
  late final GeneratedColumn<String> addedByUid = GeneratedColumn<String>(
    'added_by_uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    syncState,
    deletedLocal,
    updatedAtLocal,
    serverUpdatedAt,
    id,
    bucketId,
    addedByUid,
    title,
    amount,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'big_expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<BigExpenseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('sync_state')) {
      context.handle(
        _syncStateMeta,
        syncState.isAcceptableOrUnknown(data['sync_state']!, _syncStateMeta),
      );
    }
    if (data.containsKey('deleted_local')) {
      context.handle(
        _deletedLocalMeta,
        deletedLocal.isAcceptableOrUnknown(
          data['deleted_local']!,
          _deletedLocalMeta,
        ),
      );
    }
    if (data.containsKey('updated_at_local')) {
      context.handle(
        _updatedAtLocalMeta,
        updatedAtLocal.isAcceptableOrUnknown(
          data['updated_at_local']!,
          _updatedAtLocalMeta,
        ),
      );
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
        _serverUpdatedAtMeta,
        serverUpdatedAt.isAcceptableOrUnknown(
          data['server_updated_at']!,
          _serverUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('bucket_id')) {
      context.handle(
        _bucketIdMeta,
        bucketId.isAcceptableOrUnknown(data['bucket_id']!, _bucketIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bucketIdMeta);
    }
    if (data.containsKey('added_by_uid')) {
      context.handle(
        _addedByUidMeta,
        addedByUid.isAcceptableOrUnknown(
          data['added_by_uid']!,
          _addedByUidMeta,
        ),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BigExpenseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BigExpenseRow(
      syncState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_state'],
      )!,
      deletedLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted_local'],
      )!,
      updatedAtLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_local'],
      ),
      serverUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}server_updated_at'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      bucketId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bucket_id'],
      )!,
      addedByUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}added_by_uid'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
    );
  }

  @override
  $BigExpensesTable createAlias(String alias) {
    return $BigExpensesTable(attachedDatabase, alias);
  }
}

class BigExpenseRow extends DataClass implements Insertable<BigExpenseRow> {
  final String syncState;
  final bool deletedLocal;
  final DateTime? updatedAtLocal;
  final DateTime? serverUpdatedAt;
  final String id;
  final String bucketId;
  final String addedByUid;
  final String title;
  final double amount;
  final DateTime? createdAt;
  const BigExpenseRow({
    required this.syncState,
    required this.deletedLocal,
    this.updatedAtLocal,
    this.serverUpdatedAt,
    required this.id,
    required this.bucketId,
    required this.addedByUid,
    required this.title,
    required this.amount,
    this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['sync_state'] = Variable<String>(syncState);
    map['deleted_local'] = Variable<bool>(deletedLocal);
    if (!nullToAbsent || updatedAtLocal != null) {
      map['updated_at_local'] = Variable<DateTime>(updatedAtLocal);
    }
    if (!nullToAbsent || serverUpdatedAt != null) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    }
    map['id'] = Variable<String>(id);
    map['bucket_id'] = Variable<String>(bucketId);
    map['added_by_uid'] = Variable<String>(addedByUid);
    map['title'] = Variable<String>(title);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  BigExpensesCompanion toCompanion(bool nullToAbsent) {
    return BigExpensesCompanion(
      syncState: Value(syncState),
      deletedLocal: Value(deletedLocal),
      updatedAtLocal: updatedAtLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAtLocal),
      serverUpdatedAt: serverUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUpdatedAt),
      id: Value(id),
      bucketId: Value(bucketId),
      addedByUid: Value(addedByUid),
      title: Value(title),
      amount: Value(amount),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory BigExpenseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BigExpenseRow(
      syncState: serializer.fromJson<String>(json['syncState']),
      deletedLocal: serializer.fromJson<bool>(json['deletedLocal']),
      updatedAtLocal: serializer.fromJson<DateTime?>(json['updatedAtLocal']),
      serverUpdatedAt: serializer.fromJson<DateTime?>(json['serverUpdatedAt']),
      id: serializer.fromJson<String>(json['id']),
      bucketId: serializer.fromJson<String>(json['bucketId']),
      addedByUid: serializer.fromJson<String>(json['addedByUid']),
      title: serializer.fromJson<String>(json['title']),
      amount: serializer.fromJson<double>(json['amount']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'syncState': serializer.toJson<String>(syncState),
      'deletedLocal': serializer.toJson<bool>(deletedLocal),
      'updatedAtLocal': serializer.toJson<DateTime?>(updatedAtLocal),
      'serverUpdatedAt': serializer.toJson<DateTime?>(serverUpdatedAt),
      'id': serializer.toJson<String>(id),
      'bucketId': serializer.toJson<String>(bucketId),
      'addedByUid': serializer.toJson<String>(addedByUid),
      'title': serializer.toJson<String>(title),
      'amount': serializer.toJson<double>(amount),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  BigExpenseRow copyWith({
    String? syncState,
    bool? deletedLocal,
    Value<DateTime?> updatedAtLocal = const Value.absent(),
    Value<DateTime?> serverUpdatedAt = const Value.absent(),
    String? id,
    String? bucketId,
    String? addedByUid,
    String? title,
    double? amount,
    Value<DateTime?> createdAt = const Value.absent(),
  }) => BigExpenseRow(
    syncState: syncState ?? this.syncState,
    deletedLocal: deletedLocal ?? this.deletedLocal,
    updatedAtLocal: updatedAtLocal.present
        ? updatedAtLocal.value
        : this.updatedAtLocal,
    serverUpdatedAt: serverUpdatedAt.present
        ? serverUpdatedAt.value
        : this.serverUpdatedAt,
    id: id ?? this.id,
    bucketId: bucketId ?? this.bucketId,
    addedByUid: addedByUid ?? this.addedByUid,
    title: title ?? this.title,
    amount: amount ?? this.amount,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
  );
  BigExpenseRow copyWithCompanion(BigExpensesCompanion data) {
    return BigExpenseRow(
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      deletedLocal: data.deletedLocal.present
          ? data.deletedLocal.value
          : this.deletedLocal,
      updatedAtLocal: data.updatedAtLocal.present
          ? data.updatedAtLocal.value
          : this.updatedAtLocal,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
      id: data.id.present ? data.id.value : this.id,
      bucketId: data.bucketId.present ? data.bucketId.value : this.bucketId,
      addedByUid: data.addedByUid.present
          ? data.addedByUid.value
          : this.addedByUid,
      title: data.title.present ? data.title.value : this.title,
      amount: data.amount.present ? data.amount.value : this.amount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BigExpenseRow(')
          ..write('syncState: $syncState, ')
          ..write('deletedLocal: $deletedLocal, ')
          ..write('updatedAtLocal: $updatedAtLocal, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('id: $id, ')
          ..write('bucketId: $bucketId, ')
          ..write('addedByUid: $addedByUid, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    syncState,
    deletedLocal,
    updatedAtLocal,
    serverUpdatedAt,
    id,
    bucketId,
    addedByUid,
    title,
    amount,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BigExpenseRow &&
          other.syncState == this.syncState &&
          other.deletedLocal == this.deletedLocal &&
          other.updatedAtLocal == this.updatedAtLocal &&
          other.serverUpdatedAt == this.serverUpdatedAt &&
          other.id == this.id &&
          other.bucketId == this.bucketId &&
          other.addedByUid == this.addedByUid &&
          other.title == this.title &&
          other.amount == this.amount &&
          other.createdAt == this.createdAt);
}

class BigExpensesCompanion extends UpdateCompanion<BigExpenseRow> {
  final Value<String> syncState;
  final Value<bool> deletedLocal;
  final Value<DateTime?> updatedAtLocal;
  final Value<DateTime?> serverUpdatedAt;
  final Value<String> id;
  final Value<String> bucketId;
  final Value<String> addedByUid;
  final Value<String> title;
  final Value<double> amount;
  final Value<DateTime?> createdAt;
  final Value<int> rowid;
  const BigExpensesCompanion({
    this.syncState = const Value.absent(),
    this.deletedLocal = const Value.absent(),
    this.updatedAtLocal = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.bucketId = const Value.absent(),
    this.addedByUid = const Value.absent(),
    this.title = const Value.absent(),
    this.amount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BigExpensesCompanion.insert({
    this.syncState = const Value.absent(),
    this.deletedLocal = const Value.absent(),
    this.updatedAtLocal = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    required String id,
    required String bucketId,
    this.addedByUid = const Value.absent(),
    this.title = const Value.absent(),
    this.amount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       bucketId = Value(bucketId);
  static Insertable<BigExpenseRow> custom({
    Expression<String>? syncState,
    Expression<bool>? deletedLocal,
    Expression<DateTime>? updatedAtLocal,
    Expression<DateTime>? serverUpdatedAt,
    Expression<String>? id,
    Expression<String>? bucketId,
    Expression<String>? addedByUid,
    Expression<String>? title,
    Expression<double>? amount,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (syncState != null) 'sync_state': syncState,
      if (deletedLocal != null) 'deleted_local': deletedLocal,
      if (updatedAtLocal != null) 'updated_at_local': updatedAtLocal,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (id != null) 'id': id,
      if (bucketId != null) 'bucket_id': bucketId,
      if (addedByUid != null) 'added_by_uid': addedByUid,
      if (title != null) 'title': title,
      if (amount != null) 'amount': amount,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BigExpensesCompanion copyWith({
    Value<String>? syncState,
    Value<bool>? deletedLocal,
    Value<DateTime?>? updatedAtLocal,
    Value<DateTime?>? serverUpdatedAt,
    Value<String>? id,
    Value<String>? bucketId,
    Value<String>? addedByUid,
    Value<String>? title,
    Value<double>? amount,
    Value<DateTime?>? createdAt,
    Value<int>? rowid,
  }) {
    return BigExpensesCompanion(
      syncState: syncState ?? this.syncState,
      deletedLocal: deletedLocal ?? this.deletedLocal,
      updatedAtLocal: updatedAtLocal ?? this.updatedAtLocal,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      id: id ?? this.id,
      bucketId: bucketId ?? this.bucketId,
      addedByUid: addedByUid ?? this.addedByUid,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (syncState.present) {
      map['sync_state'] = Variable<String>(syncState.value);
    }
    if (deletedLocal.present) {
      map['deleted_local'] = Variable<bool>(deletedLocal.value);
    }
    if (updatedAtLocal.present) {
      map['updated_at_local'] = Variable<DateTime>(updatedAtLocal.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bucketId.present) {
      map['bucket_id'] = Variable<String>(bucketId.value);
    }
    if (addedByUid.present) {
      map['added_by_uid'] = Variable<String>(addedByUid.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BigExpensesCompanion(')
          ..write('syncState: $syncState, ')
          ..write('deletedLocal: $deletedLocal, ')
          ..write('updatedAtLocal: $updatedAtLocal, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('id: $id, ')
          ..write('bucketId: $bucketId, ')
          ..write('addedByUid: $addedByUid, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BucketMemberRowsTable extends BucketMemberRows
    with TableInfo<$BucketMemberRowsTable, BucketMemberRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BucketMemberRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _syncStateMeta = const VerificationMeta(
    'syncState',
  );
  @override
  late final GeneratedColumn<String> syncState = GeneratedColumn<String>(
    'sync_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('synced'),
  );
  static const VerificationMeta _deletedLocalMeta = const VerificationMeta(
    'deletedLocal',
  );
  @override
  late final GeneratedColumn<bool> deletedLocal = GeneratedColumn<bool>(
    'deleted_local',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted_local" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtLocalMeta = const VerificationMeta(
    'updatedAtLocal',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtLocal =
      GeneratedColumn<DateTime>(
        'updated_at_local',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _serverUpdatedAtMeta = const VerificationMeta(
    'serverUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> serverUpdatedAt =
      GeneratedColumn<DateTime>(
        'server_updated_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _bucketIdMeta = const VerificationMeta(
    'bucketId',
  );
  @override
  late final GeneratedColumn<String> bucketId = GeneratedColumn<String>(
    'bucket_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _joinedAtMeta = const VerificationMeta(
    'joinedAt',
  );
  @override
  late final GeneratedColumn<DateTime> joinedAt = GeneratedColumn<DateTime>(
    'joined_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoUrlMeta = const VerificationMeta(
    'photoUrl',
  );
  @override
  late final GeneratedColumn<String> photoUrl = GeneratedColumn<String>(
    'photo_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('member'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    syncState,
    deletedLocal,
    updatedAtLocal,
    serverUpdatedAt,
    bucketId,
    userId,
    joinedAt,
    name,
    photoUrl,
    role,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bucket_member_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<BucketMemberRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('sync_state')) {
      context.handle(
        _syncStateMeta,
        syncState.isAcceptableOrUnknown(data['sync_state']!, _syncStateMeta),
      );
    }
    if (data.containsKey('deleted_local')) {
      context.handle(
        _deletedLocalMeta,
        deletedLocal.isAcceptableOrUnknown(
          data['deleted_local']!,
          _deletedLocalMeta,
        ),
      );
    }
    if (data.containsKey('updated_at_local')) {
      context.handle(
        _updatedAtLocalMeta,
        updatedAtLocal.isAcceptableOrUnknown(
          data['updated_at_local']!,
          _updatedAtLocalMeta,
        ),
      );
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
        _serverUpdatedAtMeta,
        serverUpdatedAt.isAcceptableOrUnknown(
          data['server_updated_at']!,
          _serverUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('bucket_id')) {
      context.handle(
        _bucketIdMeta,
        bucketId.isAcceptableOrUnknown(data['bucket_id']!, _bucketIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bucketIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('joined_at')) {
      context.handle(
        _joinedAtMeta,
        joinedAt.isAcceptableOrUnknown(data['joined_at']!, _joinedAtMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('photo_url')) {
      context.handle(
        _photoUrlMeta,
        photoUrl.isAcceptableOrUnknown(data['photo_url']!, _photoUrlMeta),
      );
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {bucketId, userId};
  @override
  BucketMemberRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BucketMemberRow(
      syncState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_state'],
      )!,
      deletedLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted_local'],
      )!,
      updatedAtLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_local'],
      ),
      serverUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}server_updated_at'],
      ),
      bucketId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bucket_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      joinedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}joined_at'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      photoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_url'],
      ),
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
    );
  }

  @override
  $BucketMemberRowsTable createAlias(String alias) {
    return $BucketMemberRowsTable(attachedDatabase, alias);
  }
}

class BucketMemberRow extends DataClass implements Insertable<BucketMemberRow> {
  final String syncState;
  final bool deletedLocal;
  final DateTime? updatedAtLocal;
  final DateTime? serverUpdatedAt;
  final String bucketId;
  final String userId;
  final DateTime? joinedAt;
  final String? name;
  final String? photoUrl;
  final String role;
  const BucketMemberRow({
    required this.syncState,
    required this.deletedLocal,
    this.updatedAtLocal,
    this.serverUpdatedAt,
    required this.bucketId,
    required this.userId,
    this.joinedAt,
    this.name,
    this.photoUrl,
    required this.role,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['sync_state'] = Variable<String>(syncState);
    map['deleted_local'] = Variable<bool>(deletedLocal);
    if (!nullToAbsent || updatedAtLocal != null) {
      map['updated_at_local'] = Variable<DateTime>(updatedAtLocal);
    }
    if (!nullToAbsent || serverUpdatedAt != null) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    }
    map['bucket_id'] = Variable<String>(bucketId);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || joinedAt != null) {
      map['joined_at'] = Variable<DateTime>(joinedAt);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || photoUrl != null) {
      map['photo_url'] = Variable<String>(photoUrl);
    }
    map['role'] = Variable<String>(role);
    return map;
  }

  BucketMemberRowsCompanion toCompanion(bool nullToAbsent) {
    return BucketMemberRowsCompanion(
      syncState: Value(syncState),
      deletedLocal: Value(deletedLocal),
      updatedAtLocal: updatedAtLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAtLocal),
      serverUpdatedAt: serverUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUpdatedAt),
      bucketId: Value(bucketId),
      userId: Value(userId),
      joinedAt: joinedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(joinedAt),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      photoUrl: photoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(photoUrl),
      role: Value(role),
    );
  }

  factory BucketMemberRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BucketMemberRow(
      syncState: serializer.fromJson<String>(json['syncState']),
      deletedLocal: serializer.fromJson<bool>(json['deletedLocal']),
      updatedAtLocal: serializer.fromJson<DateTime?>(json['updatedAtLocal']),
      serverUpdatedAt: serializer.fromJson<DateTime?>(json['serverUpdatedAt']),
      bucketId: serializer.fromJson<String>(json['bucketId']),
      userId: serializer.fromJson<String>(json['userId']),
      joinedAt: serializer.fromJson<DateTime?>(json['joinedAt']),
      name: serializer.fromJson<String?>(json['name']),
      photoUrl: serializer.fromJson<String?>(json['photoUrl']),
      role: serializer.fromJson<String>(json['role']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'syncState': serializer.toJson<String>(syncState),
      'deletedLocal': serializer.toJson<bool>(deletedLocal),
      'updatedAtLocal': serializer.toJson<DateTime?>(updatedAtLocal),
      'serverUpdatedAt': serializer.toJson<DateTime?>(serverUpdatedAt),
      'bucketId': serializer.toJson<String>(bucketId),
      'userId': serializer.toJson<String>(userId),
      'joinedAt': serializer.toJson<DateTime?>(joinedAt),
      'name': serializer.toJson<String?>(name),
      'photoUrl': serializer.toJson<String?>(photoUrl),
      'role': serializer.toJson<String>(role),
    };
  }

  BucketMemberRow copyWith({
    String? syncState,
    bool? deletedLocal,
    Value<DateTime?> updatedAtLocal = const Value.absent(),
    Value<DateTime?> serverUpdatedAt = const Value.absent(),
    String? bucketId,
    String? userId,
    Value<DateTime?> joinedAt = const Value.absent(),
    Value<String?> name = const Value.absent(),
    Value<String?> photoUrl = const Value.absent(),
    String? role,
  }) => BucketMemberRow(
    syncState: syncState ?? this.syncState,
    deletedLocal: deletedLocal ?? this.deletedLocal,
    updatedAtLocal: updatedAtLocal.present
        ? updatedAtLocal.value
        : this.updatedAtLocal,
    serverUpdatedAt: serverUpdatedAt.present
        ? serverUpdatedAt.value
        : this.serverUpdatedAt,
    bucketId: bucketId ?? this.bucketId,
    userId: userId ?? this.userId,
    joinedAt: joinedAt.present ? joinedAt.value : this.joinedAt,
    name: name.present ? name.value : this.name,
    photoUrl: photoUrl.present ? photoUrl.value : this.photoUrl,
    role: role ?? this.role,
  );
  BucketMemberRow copyWithCompanion(BucketMemberRowsCompanion data) {
    return BucketMemberRow(
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      deletedLocal: data.deletedLocal.present
          ? data.deletedLocal.value
          : this.deletedLocal,
      updatedAtLocal: data.updatedAtLocal.present
          ? data.updatedAtLocal.value
          : this.updatedAtLocal,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
      bucketId: data.bucketId.present ? data.bucketId.value : this.bucketId,
      userId: data.userId.present ? data.userId.value : this.userId,
      joinedAt: data.joinedAt.present ? data.joinedAt.value : this.joinedAt,
      name: data.name.present ? data.name.value : this.name,
      photoUrl: data.photoUrl.present ? data.photoUrl.value : this.photoUrl,
      role: data.role.present ? data.role.value : this.role,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BucketMemberRow(')
          ..write('syncState: $syncState, ')
          ..write('deletedLocal: $deletedLocal, ')
          ..write('updatedAtLocal: $updatedAtLocal, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('bucketId: $bucketId, ')
          ..write('userId: $userId, ')
          ..write('joinedAt: $joinedAt, ')
          ..write('name: $name, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('role: $role')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    syncState,
    deletedLocal,
    updatedAtLocal,
    serverUpdatedAt,
    bucketId,
    userId,
    joinedAt,
    name,
    photoUrl,
    role,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BucketMemberRow &&
          other.syncState == this.syncState &&
          other.deletedLocal == this.deletedLocal &&
          other.updatedAtLocal == this.updatedAtLocal &&
          other.serverUpdatedAt == this.serverUpdatedAt &&
          other.bucketId == this.bucketId &&
          other.userId == this.userId &&
          other.joinedAt == this.joinedAt &&
          other.name == this.name &&
          other.photoUrl == this.photoUrl &&
          other.role == this.role);
}

class BucketMemberRowsCompanion extends UpdateCompanion<BucketMemberRow> {
  final Value<String> syncState;
  final Value<bool> deletedLocal;
  final Value<DateTime?> updatedAtLocal;
  final Value<DateTime?> serverUpdatedAt;
  final Value<String> bucketId;
  final Value<String> userId;
  final Value<DateTime?> joinedAt;
  final Value<String?> name;
  final Value<String?> photoUrl;
  final Value<String> role;
  final Value<int> rowid;
  const BucketMemberRowsCompanion({
    this.syncState = const Value.absent(),
    this.deletedLocal = const Value.absent(),
    this.updatedAtLocal = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.bucketId = const Value.absent(),
    this.userId = const Value.absent(),
    this.joinedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.photoUrl = const Value.absent(),
    this.role = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BucketMemberRowsCompanion.insert({
    this.syncState = const Value.absent(),
    this.deletedLocal = const Value.absent(),
    this.updatedAtLocal = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    required String bucketId,
    required String userId,
    this.joinedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.photoUrl = const Value.absent(),
    this.role = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : bucketId = Value(bucketId),
       userId = Value(userId);
  static Insertable<BucketMemberRow> custom({
    Expression<String>? syncState,
    Expression<bool>? deletedLocal,
    Expression<DateTime>? updatedAtLocal,
    Expression<DateTime>? serverUpdatedAt,
    Expression<String>? bucketId,
    Expression<String>? userId,
    Expression<DateTime>? joinedAt,
    Expression<String>? name,
    Expression<String>? photoUrl,
    Expression<String>? role,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (syncState != null) 'sync_state': syncState,
      if (deletedLocal != null) 'deleted_local': deletedLocal,
      if (updatedAtLocal != null) 'updated_at_local': updatedAtLocal,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (bucketId != null) 'bucket_id': bucketId,
      if (userId != null) 'user_id': userId,
      if (joinedAt != null) 'joined_at': joinedAt,
      if (name != null) 'name': name,
      if (photoUrl != null) 'photo_url': photoUrl,
      if (role != null) 'role': role,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BucketMemberRowsCompanion copyWith({
    Value<String>? syncState,
    Value<bool>? deletedLocal,
    Value<DateTime?>? updatedAtLocal,
    Value<DateTime?>? serverUpdatedAt,
    Value<String>? bucketId,
    Value<String>? userId,
    Value<DateTime?>? joinedAt,
    Value<String?>? name,
    Value<String?>? photoUrl,
    Value<String>? role,
    Value<int>? rowid,
  }) {
    return BucketMemberRowsCompanion(
      syncState: syncState ?? this.syncState,
      deletedLocal: deletedLocal ?? this.deletedLocal,
      updatedAtLocal: updatedAtLocal ?? this.updatedAtLocal,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      bucketId: bucketId ?? this.bucketId,
      userId: userId ?? this.userId,
      joinedAt: joinedAt ?? this.joinedAt,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (syncState.present) {
      map['sync_state'] = Variable<String>(syncState.value);
    }
    if (deletedLocal.present) {
      map['deleted_local'] = Variable<bool>(deletedLocal.value);
    }
    if (updatedAtLocal.present) {
      map['updated_at_local'] = Variable<DateTime>(updatedAtLocal.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt.value);
    }
    if (bucketId.present) {
      map['bucket_id'] = Variable<String>(bucketId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (joinedAt.present) {
      map['joined_at'] = Variable<DateTime>(joinedAt.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (photoUrl.present) {
      map['photo_url'] = Variable<String>(photoUrl.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BucketMemberRowsCompanion(')
          ..write('syncState: $syncState, ')
          ..write('deletedLocal: $deletedLocal, ')
          ..write('updatedAtLocal: $updatedAtLocal, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('bucketId: $bucketId, ')
          ..write('userId: $userId, ')
          ..write('joinedAt: $joinedAt, ')
          ..write('name: $name, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('role: $role, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, CategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _syncStateMeta = const VerificationMeta(
    'syncState',
  );
  @override
  late final GeneratedColumn<String> syncState = GeneratedColumn<String>(
    'sync_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('synced'),
  );
  static const VerificationMeta _deletedLocalMeta = const VerificationMeta(
    'deletedLocal',
  );
  @override
  late final GeneratedColumn<bool> deletedLocal = GeneratedColumn<bool>(
    'deleted_local',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted_local" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtLocalMeta = const VerificationMeta(
    'updatedAtLocal',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtLocal =
      GeneratedColumn<DateTime>(
        'updated_at_local',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _serverUpdatedAtMeta = const VerificationMeta(
    'serverUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> serverUpdatedAt =
      GeneratedColumn<DateTime>(
        'server_updated_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _iconKeyMeta = const VerificationMeta(
    'iconKey',
  );
  @override
  late final GeneratedColumn<String> iconKey = GeneratedColumn<String>(
    'icon_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('other'),
  );
  static const VerificationMeta _isPresetMeta = const VerificationMeta(
    'isPreset',
  );
  @override
  late final GeneratedColumn<bool> isPreset = GeneratedColumn<bool>(
    'is_preset',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_preset" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _ownerUidMeta = const VerificationMeta(
    'ownerUid',
  );
  @override
  late final GeneratedColumn<String> ownerUid = GeneratedColumn<String>(
    'owner_uid',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    syncState,
    deletedLocal,
    updatedAtLocal,
    serverUpdatedAt,
    id,
    name,
    iconKey,
    isPreset,
    ownerUid,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('sync_state')) {
      context.handle(
        _syncStateMeta,
        syncState.isAcceptableOrUnknown(data['sync_state']!, _syncStateMeta),
      );
    }
    if (data.containsKey('deleted_local')) {
      context.handle(
        _deletedLocalMeta,
        deletedLocal.isAcceptableOrUnknown(
          data['deleted_local']!,
          _deletedLocalMeta,
        ),
      );
    }
    if (data.containsKey('updated_at_local')) {
      context.handle(
        _updatedAtLocalMeta,
        updatedAtLocal.isAcceptableOrUnknown(
          data['updated_at_local']!,
          _updatedAtLocalMeta,
        ),
      );
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
        _serverUpdatedAtMeta,
        serverUpdatedAt.isAcceptableOrUnknown(
          data['server_updated_at']!,
          _serverUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('icon_key')) {
      context.handle(
        _iconKeyMeta,
        iconKey.isAcceptableOrUnknown(data['icon_key']!, _iconKeyMeta),
      );
    }
    if (data.containsKey('is_preset')) {
      context.handle(
        _isPresetMeta,
        isPreset.isAcceptableOrUnknown(data['is_preset']!, _isPresetMeta),
      );
    }
    if (data.containsKey('owner_uid')) {
      context.handle(
        _ownerUidMeta,
        ownerUid.isAcceptableOrUnknown(data['owner_uid']!, _ownerUidMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryRow(
      syncState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_state'],
      )!,
      deletedLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted_local'],
      )!,
      updatedAtLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_local'],
      ),
      serverUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}server_updated_at'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      iconKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_key'],
      )!,
      isPreset: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_preset'],
      )!,
      ownerUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_uid'],
      ),
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class CategoryRow extends DataClass implements Insertable<CategoryRow> {
  final String syncState;
  final bool deletedLocal;
  final DateTime? updatedAtLocal;
  final DateTime? serverUpdatedAt;
  final String id;
  final String name;
  final String iconKey;
  final bool isPreset;
  final String? ownerUid;
  const CategoryRow({
    required this.syncState,
    required this.deletedLocal,
    this.updatedAtLocal,
    this.serverUpdatedAt,
    required this.id,
    required this.name,
    required this.iconKey,
    required this.isPreset,
    this.ownerUid,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['sync_state'] = Variable<String>(syncState);
    map['deleted_local'] = Variable<bool>(deletedLocal);
    if (!nullToAbsent || updatedAtLocal != null) {
      map['updated_at_local'] = Variable<DateTime>(updatedAtLocal);
    }
    if (!nullToAbsent || serverUpdatedAt != null) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    }
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['icon_key'] = Variable<String>(iconKey);
    map['is_preset'] = Variable<bool>(isPreset);
    if (!nullToAbsent || ownerUid != null) {
      map['owner_uid'] = Variable<String>(ownerUid);
    }
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      syncState: Value(syncState),
      deletedLocal: Value(deletedLocal),
      updatedAtLocal: updatedAtLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAtLocal),
      serverUpdatedAt: serverUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUpdatedAt),
      id: Value(id),
      name: Value(name),
      iconKey: Value(iconKey),
      isPreset: Value(isPreset),
      ownerUid: ownerUid == null && nullToAbsent
          ? const Value.absent()
          : Value(ownerUid),
    );
  }

  factory CategoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryRow(
      syncState: serializer.fromJson<String>(json['syncState']),
      deletedLocal: serializer.fromJson<bool>(json['deletedLocal']),
      updatedAtLocal: serializer.fromJson<DateTime?>(json['updatedAtLocal']),
      serverUpdatedAt: serializer.fromJson<DateTime?>(json['serverUpdatedAt']),
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      iconKey: serializer.fromJson<String>(json['iconKey']),
      isPreset: serializer.fromJson<bool>(json['isPreset']),
      ownerUid: serializer.fromJson<String?>(json['ownerUid']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'syncState': serializer.toJson<String>(syncState),
      'deletedLocal': serializer.toJson<bool>(deletedLocal),
      'updatedAtLocal': serializer.toJson<DateTime?>(updatedAtLocal),
      'serverUpdatedAt': serializer.toJson<DateTime?>(serverUpdatedAt),
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'iconKey': serializer.toJson<String>(iconKey),
      'isPreset': serializer.toJson<bool>(isPreset),
      'ownerUid': serializer.toJson<String?>(ownerUid),
    };
  }

  CategoryRow copyWith({
    String? syncState,
    bool? deletedLocal,
    Value<DateTime?> updatedAtLocal = const Value.absent(),
    Value<DateTime?> serverUpdatedAt = const Value.absent(),
    String? id,
    String? name,
    String? iconKey,
    bool? isPreset,
    Value<String?> ownerUid = const Value.absent(),
  }) => CategoryRow(
    syncState: syncState ?? this.syncState,
    deletedLocal: deletedLocal ?? this.deletedLocal,
    updatedAtLocal: updatedAtLocal.present
        ? updatedAtLocal.value
        : this.updatedAtLocal,
    serverUpdatedAt: serverUpdatedAt.present
        ? serverUpdatedAt.value
        : this.serverUpdatedAt,
    id: id ?? this.id,
    name: name ?? this.name,
    iconKey: iconKey ?? this.iconKey,
    isPreset: isPreset ?? this.isPreset,
    ownerUid: ownerUid.present ? ownerUid.value : this.ownerUid,
  );
  CategoryRow copyWithCompanion(CategoriesCompanion data) {
    return CategoryRow(
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      deletedLocal: data.deletedLocal.present
          ? data.deletedLocal.value
          : this.deletedLocal,
      updatedAtLocal: data.updatedAtLocal.present
          ? data.updatedAtLocal.value
          : this.updatedAtLocal,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      iconKey: data.iconKey.present ? data.iconKey.value : this.iconKey,
      isPreset: data.isPreset.present ? data.isPreset.value : this.isPreset,
      ownerUid: data.ownerUid.present ? data.ownerUid.value : this.ownerUid,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryRow(')
          ..write('syncState: $syncState, ')
          ..write('deletedLocal: $deletedLocal, ')
          ..write('updatedAtLocal: $updatedAtLocal, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('iconKey: $iconKey, ')
          ..write('isPreset: $isPreset, ')
          ..write('ownerUid: $ownerUid')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    syncState,
    deletedLocal,
    updatedAtLocal,
    serverUpdatedAt,
    id,
    name,
    iconKey,
    isPreset,
    ownerUid,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryRow &&
          other.syncState == this.syncState &&
          other.deletedLocal == this.deletedLocal &&
          other.updatedAtLocal == this.updatedAtLocal &&
          other.serverUpdatedAt == this.serverUpdatedAt &&
          other.id == this.id &&
          other.name == this.name &&
          other.iconKey == this.iconKey &&
          other.isPreset == this.isPreset &&
          other.ownerUid == this.ownerUid);
}

class CategoriesCompanion extends UpdateCompanion<CategoryRow> {
  final Value<String> syncState;
  final Value<bool> deletedLocal;
  final Value<DateTime?> updatedAtLocal;
  final Value<DateTime?> serverUpdatedAt;
  final Value<String> id;
  final Value<String> name;
  final Value<String> iconKey;
  final Value<bool> isPreset;
  final Value<String?> ownerUid;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.syncState = const Value.absent(),
    this.deletedLocal = const Value.absent(),
    this.updatedAtLocal = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.iconKey = const Value.absent(),
    this.isPreset = const Value.absent(),
    this.ownerUid = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.syncState = const Value.absent(),
    this.deletedLocal = const Value.absent(),
    this.updatedAtLocal = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    required String id,
    this.name = const Value.absent(),
    this.iconKey = const Value.absent(),
    this.isPreset = const Value.absent(),
    this.ownerUid = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<CategoryRow> custom({
    Expression<String>? syncState,
    Expression<bool>? deletedLocal,
    Expression<DateTime>? updatedAtLocal,
    Expression<DateTime>? serverUpdatedAt,
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? iconKey,
    Expression<bool>? isPreset,
    Expression<String>? ownerUid,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (syncState != null) 'sync_state': syncState,
      if (deletedLocal != null) 'deleted_local': deletedLocal,
      if (updatedAtLocal != null) 'updated_at_local': updatedAtLocal,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (iconKey != null) 'icon_key': iconKey,
      if (isPreset != null) 'is_preset': isPreset,
      if (ownerUid != null) 'owner_uid': ownerUid,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith({
    Value<String>? syncState,
    Value<bool>? deletedLocal,
    Value<DateTime?>? updatedAtLocal,
    Value<DateTime?>? serverUpdatedAt,
    Value<String>? id,
    Value<String>? name,
    Value<String>? iconKey,
    Value<bool>? isPreset,
    Value<String?>? ownerUid,
    Value<int>? rowid,
  }) {
    return CategoriesCompanion(
      syncState: syncState ?? this.syncState,
      deletedLocal: deletedLocal ?? this.deletedLocal,
      updatedAtLocal: updatedAtLocal ?? this.updatedAtLocal,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      id: id ?? this.id,
      name: name ?? this.name,
      iconKey: iconKey ?? this.iconKey,
      isPreset: isPreset ?? this.isPreset,
      ownerUid: ownerUid ?? this.ownerUid,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (syncState.present) {
      map['sync_state'] = Variable<String>(syncState.value);
    }
    if (deletedLocal.present) {
      map['deleted_local'] = Variable<bool>(deletedLocal.value);
    }
    if (updatedAtLocal.present) {
      map['updated_at_local'] = Variable<DateTime>(updatedAtLocal.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (iconKey.present) {
      map['icon_key'] = Variable<String>(iconKey.value);
    }
    if (isPreset.present) {
      map['is_preset'] = Variable<bool>(isPreset.value);
    }
    if (ownerUid.present) {
      map['owner_uid'] = Variable<String>(ownerUid.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('syncState: $syncState, ')
          ..write('deletedLocal: $deletedLocal, ')
          ..write('updatedAtLocal: $updatedAtLocal, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('iconKey: $iconKey, ')
          ..write('isPreset: $isPreset, ')
          ..write('ownerUid: $ownerUid, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotificationRowsTable extends NotificationRows
    with TableInfo<$NotificationRowsTable, NotificationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _syncStateMeta = const VerificationMeta(
    'syncState',
  );
  @override
  late final GeneratedColumn<String> syncState = GeneratedColumn<String>(
    'sync_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('synced'),
  );
  static const VerificationMeta _deletedLocalMeta = const VerificationMeta(
    'deletedLocal',
  );
  @override
  late final GeneratedColumn<bool> deletedLocal = GeneratedColumn<bool>(
    'deleted_local',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted_local" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtLocalMeta = const VerificationMeta(
    'updatedAtLocal',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtLocal =
      GeneratedColumn<DateTime>(
        'updated_at_local',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _serverUpdatedAtMeta = const VerificationMeta(
    'serverUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> serverUpdatedAt =
      GeneratedColumn<DateTime>(
        'server_updated_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bucketIdMeta = const VerificationMeta(
    'bucketId',
  );
  @override
  late final GeneratedColumn<String> bucketId = GeneratedColumn<String>(
    'bucket_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('unknown'),
  );
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actorUidMeta = const VerificationMeta(
    'actorUid',
  );
  @override
  late final GeneratedColumn<String> actorUid = GeneratedColumn<String>(
    'actor_uid',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _readByMeta = const VerificationMeta('readBy');
  @override
  late final GeneratedColumn<String> readBy = GeneratedColumn<String>(
    'read_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    syncState,
    deletedLocal,
    updatedAtLocal,
    serverUpdatedAt,
    id,
    bucketId,
    type,
    message,
    createdAt,
    actorUid,
    readBy,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notification_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotificationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('sync_state')) {
      context.handle(
        _syncStateMeta,
        syncState.isAcceptableOrUnknown(data['sync_state']!, _syncStateMeta),
      );
    }
    if (data.containsKey('deleted_local')) {
      context.handle(
        _deletedLocalMeta,
        deletedLocal.isAcceptableOrUnknown(
          data['deleted_local']!,
          _deletedLocalMeta,
        ),
      );
    }
    if (data.containsKey('updated_at_local')) {
      context.handle(
        _updatedAtLocalMeta,
        updatedAtLocal.isAcceptableOrUnknown(
          data['updated_at_local']!,
          _updatedAtLocalMeta,
        ),
      );
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
        _serverUpdatedAtMeta,
        serverUpdatedAt.isAcceptableOrUnknown(
          data['server_updated_at']!,
          _serverUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('bucket_id')) {
      context.handle(
        _bucketIdMeta,
        bucketId.isAcceptableOrUnknown(data['bucket_id']!, _bucketIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bucketIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('actor_uid')) {
      context.handle(
        _actorUidMeta,
        actorUid.isAcceptableOrUnknown(data['actor_uid']!, _actorUidMeta),
      );
    }
    if (data.containsKey('read_by')) {
      context.handle(
        _readByMeta,
        readBy.isAcceptableOrUnknown(data['read_by']!, _readByMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotificationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationRow(
      syncState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_state'],
      )!,
      deletedLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted_local'],
      )!,
      updatedAtLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_local'],
      ),
      serverUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}server_updated_at'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      bucketId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bucket_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      message: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      actorUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}actor_uid'],
      ),
      readBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}read_by'],
      )!,
    );
  }

  @override
  $NotificationRowsTable createAlias(String alias) {
    return $NotificationRowsTable(attachedDatabase, alias);
  }
}

class NotificationRow extends DataClass implements Insertable<NotificationRow> {
  final String syncState;
  final bool deletedLocal;
  final DateTime? updatedAtLocal;
  final DateTime? serverUpdatedAt;
  final String id;
  final String bucketId;
  final String type;
  final String message;
  final DateTime? createdAt;
  final String? actorUid;
  final String readBy;
  const NotificationRow({
    required this.syncState,
    required this.deletedLocal,
    this.updatedAtLocal,
    this.serverUpdatedAt,
    required this.id,
    required this.bucketId,
    required this.type,
    required this.message,
    this.createdAt,
    this.actorUid,
    required this.readBy,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['sync_state'] = Variable<String>(syncState);
    map['deleted_local'] = Variable<bool>(deletedLocal);
    if (!nullToAbsent || updatedAtLocal != null) {
      map['updated_at_local'] = Variable<DateTime>(updatedAtLocal);
    }
    if (!nullToAbsent || serverUpdatedAt != null) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    }
    map['id'] = Variable<String>(id);
    map['bucket_id'] = Variable<String>(bucketId);
    map['type'] = Variable<String>(type);
    map['message'] = Variable<String>(message);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || actorUid != null) {
      map['actor_uid'] = Variable<String>(actorUid);
    }
    map['read_by'] = Variable<String>(readBy);
    return map;
  }

  NotificationRowsCompanion toCompanion(bool nullToAbsent) {
    return NotificationRowsCompanion(
      syncState: Value(syncState),
      deletedLocal: Value(deletedLocal),
      updatedAtLocal: updatedAtLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAtLocal),
      serverUpdatedAt: serverUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUpdatedAt),
      id: Value(id),
      bucketId: Value(bucketId),
      type: Value(type),
      message: Value(message),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      actorUid: actorUid == null && nullToAbsent
          ? const Value.absent()
          : Value(actorUid),
      readBy: Value(readBy),
    );
  }

  factory NotificationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationRow(
      syncState: serializer.fromJson<String>(json['syncState']),
      deletedLocal: serializer.fromJson<bool>(json['deletedLocal']),
      updatedAtLocal: serializer.fromJson<DateTime?>(json['updatedAtLocal']),
      serverUpdatedAt: serializer.fromJson<DateTime?>(json['serverUpdatedAt']),
      id: serializer.fromJson<String>(json['id']),
      bucketId: serializer.fromJson<String>(json['bucketId']),
      type: serializer.fromJson<String>(json['type']),
      message: serializer.fromJson<String>(json['message']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      actorUid: serializer.fromJson<String?>(json['actorUid']),
      readBy: serializer.fromJson<String>(json['readBy']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'syncState': serializer.toJson<String>(syncState),
      'deletedLocal': serializer.toJson<bool>(deletedLocal),
      'updatedAtLocal': serializer.toJson<DateTime?>(updatedAtLocal),
      'serverUpdatedAt': serializer.toJson<DateTime?>(serverUpdatedAt),
      'id': serializer.toJson<String>(id),
      'bucketId': serializer.toJson<String>(bucketId),
      'type': serializer.toJson<String>(type),
      'message': serializer.toJson<String>(message),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'actorUid': serializer.toJson<String?>(actorUid),
      'readBy': serializer.toJson<String>(readBy),
    };
  }

  NotificationRow copyWith({
    String? syncState,
    bool? deletedLocal,
    Value<DateTime?> updatedAtLocal = const Value.absent(),
    Value<DateTime?> serverUpdatedAt = const Value.absent(),
    String? id,
    String? bucketId,
    String? type,
    String? message,
    Value<DateTime?> createdAt = const Value.absent(),
    Value<String?> actorUid = const Value.absent(),
    String? readBy,
  }) => NotificationRow(
    syncState: syncState ?? this.syncState,
    deletedLocal: deletedLocal ?? this.deletedLocal,
    updatedAtLocal: updatedAtLocal.present
        ? updatedAtLocal.value
        : this.updatedAtLocal,
    serverUpdatedAt: serverUpdatedAt.present
        ? serverUpdatedAt.value
        : this.serverUpdatedAt,
    id: id ?? this.id,
    bucketId: bucketId ?? this.bucketId,
    type: type ?? this.type,
    message: message ?? this.message,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    actorUid: actorUid.present ? actorUid.value : this.actorUid,
    readBy: readBy ?? this.readBy,
  );
  NotificationRow copyWithCompanion(NotificationRowsCompanion data) {
    return NotificationRow(
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      deletedLocal: data.deletedLocal.present
          ? data.deletedLocal.value
          : this.deletedLocal,
      updatedAtLocal: data.updatedAtLocal.present
          ? data.updatedAtLocal.value
          : this.updatedAtLocal,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
      id: data.id.present ? data.id.value : this.id,
      bucketId: data.bucketId.present ? data.bucketId.value : this.bucketId,
      type: data.type.present ? data.type.value : this.type,
      message: data.message.present ? data.message.value : this.message,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      actorUid: data.actorUid.present ? data.actorUid.value : this.actorUid,
      readBy: data.readBy.present ? data.readBy.value : this.readBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationRow(')
          ..write('syncState: $syncState, ')
          ..write('deletedLocal: $deletedLocal, ')
          ..write('updatedAtLocal: $updatedAtLocal, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('id: $id, ')
          ..write('bucketId: $bucketId, ')
          ..write('type: $type, ')
          ..write('message: $message, ')
          ..write('createdAt: $createdAt, ')
          ..write('actorUid: $actorUid, ')
          ..write('readBy: $readBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    syncState,
    deletedLocal,
    updatedAtLocal,
    serverUpdatedAt,
    id,
    bucketId,
    type,
    message,
    createdAt,
    actorUid,
    readBy,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationRow &&
          other.syncState == this.syncState &&
          other.deletedLocal == this.deletedLocal &&
          other.updatedAtLocal == this.updatedAtLocal &&
          other.serverUpdatedAt == this.serverUpdatedAt &&
          other.id == this.id &&
          other.bucketId == this.bucketId &&
          other.type == this.type &&
          other.message == this.message &&
          other.createdAt == this.createdAt &&
          other.actorUid == this.actorUid &&
          other.readBy == this.readBy);
}

class NotificationRowsCompanion extends UpdateCompanion<NotificationRow> {
  final Value<String> syncState;
  final Value<bool> deletedLocal;
  final Value<DateTime?> updatedAtLocal;
  final Value<DateTime?> serverUpdatedAt;
  final Value<String> id;
  final Value<String> bucketId;
  final Value<String> type;
  final Value<String> message;
  final Value<DateTime?> createdAt;
  final Value<String?> actorUid;
  final Value<String> readBy;
  final Value<int> rowid;
  const NotificationRowsCompanion({
    this.syncState = const Value.absent(),
    this.deletedLocal = const Value.absent(),
    this.updatedAtLocal = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.bucketId = const Value.absent(),
    this.type = const Value.absent(),
    this.message = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.actorUid = const Value.absent(),
    this.readBy = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotificationRowsCompanion.insert({
    this.syncState = const Value.absent(),
    this.deletedLocal = const Value.absent(),
    this.updatedAtLocal = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    required String id,
    required String bucketId,
    this.type = const Value.absent(),
    this.message = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.actorUid = const Value.absent(),
    this.readBy = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       bucketId = Value(bucketId);
  static Insertable<NotificationRow> custom({
    Expression<String>? syncState,
    Expression<bool>? deletedLocal,
    Expression<DateTime>? updatedAtLocal,
    Expression<DateTime>? serverUpdatedAt,
    Expression<String>? id,
    Expression<String>? bucketId,
    Expression<String>? type,
    Expression<String>? message,
    Expression<DateTime>? createdAt,
    Expression<String>? actorUid,
    Expression<String>? readBy,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (syncState != null) 'sync_state': syncState,
      if (deletedLocal != null) 'deleted_local': deletedLocal,
      if (updatedAtLocal != null) 'updated_at_local': updatedAtLocal,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (id != null) 'id': id,
      if (bucketId != null) 'bucket_id': bucketId,
      if (type != null) 'type': type,
      if (message != null) 'message': message,
      if (createdAt != null) 'created_at': createdAt,
      if (actorUid != null) 'actor_uid': actorUid,
      if (readBy != null) 'read_by': readBy,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotificationRowsCompanion copyWith({
    Value<String>? syncState,
    Value<bool>? deletedLocal,
    Value<DateTime?>? updatedAtLocal,
    Value<DateTime?>? serverUpdatedAt,
    Value<String>? id,
    Value<String>? bucketId,
    Value<String>? type,
    Value<String>? message,
    Value<DateTime?>? createdAt,
    Value<String?>? actorUid,
    Value<String>? readBy,
    Value<int>? rowid,
  }) {
    return NotificationRowsCompanion(
      syncState: syncState ?? this.syncState,
      deletedLocal: deletedLocal ?? this.deletedLocal,
      updatedAtLocal: updatedAtLocal ?? this.updatedAtLocal,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      id: id ?? this.id,
      bucketId: bucketId ?? this.bucketId,
      type: type ?? this.type,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      actorUid: actorUid ?? this.actorUid,
      readBy: readBy ?? this.readBy,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (syncState.present) {
      map['sync_state'] = Variable<String>(syncState.value);
    }
    if (deletedLocal.present) {
      map['deleted_local'] = Variable<bool>(deletedLocal.value);
    }
    if (updatedAtLocal.present) {
      map['updated_at_local'] = Variable<DateTime>(updatedAtLocal.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bucketId.present) {
      map['bucket_id'] = Variable<String>(bucketId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (actorUid.present) {
      map['actor_uid'] = Variable<String>(actorUid.value);
    }
    if (readBy.present) {
      map['read_by'] = Variable<String>(readBy.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationRowsCompanion(')
          ..write('syncState: $syncState, ')
          ..write('deletedLocal: $deletedLocal, ')
          ..write('updatedAtLocal: $updatedAtLocal, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('id: $id, ')
          ..write('bucketId: $bucketId, ')
          ..write('type: $type, ')
          ..write('message: $message, ')
          ..write('createdAt: $createdAt, ')
          ..write('actorUid: $actorUid, ')
          ..write('readBy: $readBy, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $JoinRequestRowsTable extends JoinRequestRows
    with TableInfo<$JoinRequestRowsTable, JoinRequestRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JoinRequestRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _syncStateMeta = const VerificationMeta(
    'syncState',
  );
  @override
  late final GeneratedColumn<String> syncState = GeneratedColumn<String>(
    'sync_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('synced'),
  );
  static const VerificationMeta _deletedLocalMeta = const VerificationMeta(
    'deletedLocal',
  );
  @override
  late final GeneratedColumn<bool> deletedLocal = GeneratedColumn<bool>(
    'deleted_local',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted_local" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtLocalMeta = const VerificationMeta(
    'updatedAtLocal',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtLocal =
      GeneratedColumn<DateTime>(
        'updated_at_local',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _serverUpdatedAtMeta = const VerificationMeta(
    'serverUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> serverUpdatedAt =
      GeneratedColumn<DateTime>(
        'server_updated_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bucketIdMeta = const VerificationMeta(
    'bucketId',
  );
  @override
  late final GeneratedColumn<String> bucketId = GeneratedColumn<String>(
    'bucket_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bucketNameMeta = const VerificationMeta(
    'bucketName',
  );
  @override
  late final GeneratedColumn<String> bucketName = GeneratedColumn<String>(
    'bucket_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _requesterUidMeta = const VerificationMeta(
    'requesterUid',
  );
  @override
  late final GeneratedColumn<String> requesterUid = GeneratedColumn<String>(
    'requester_uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _requesterNameMeta = const VerificationMeta(
    'requesterName',
  );
  @override
  late final GeneratedColumn<String> requesterName = GeneratedColumn<String>(
    'requester_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _requesterPhotoMeta = const VerificationMeta(
    'requesterPhoto',
  );
  @override
  late final GeneratedColumn<String> requesterPhoto = GeneratedColumn<String>(
    'requester_photo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _decidedAtMeta = const VerificationMeta(
    'decidedAt',
  );
  @override
  late final GeneratedColumn<DateTime> decidedAt = GeneratedColumn<DateTime>(
    'decided_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    syncState,
    deletedLocal,
    updatedAtLocal,
    serverUpdatedAt,
    id,
    bucketId,
    bucketName,
    requesterUid,
    requesterName,
    requesterPhoto,
    status,
    createdAt,
    decidedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'join_request_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<JoinRequestRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('sync_state')) {
      context.handle(
        _syncStateMeta,
        syncState.isAcceptableOrUnknown(data['sync_state']!, _syncStateMeta),
      );
    }
    if (data.containsKey('deleted_local')) {
      context.handle(
        _deletedLocalMeta,
        deletedLocal.isAcceptableOrUnknown(
          data['deleted_local']!,
          _deletedLocalMeta,
        ),
      );
    }
    if (data.containsKey('updated_at_local')) {
      context.handle(
        _updatedAtLocalMeta,
        updatedAtLocal.isAcceptableOrUnknown(
          data['updated_at_local']!,
          _updatedAtLocalMeta,
        ),
      );
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
        _serverUpdatedAtMeta,
        serverUpdatedAt.isAcceptableOrUnknown(
          data['server_updated_at']!,
          _serverUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('bucket_id')) {
      context.handle(
        _bucketIdMeta,
        bucketId.isAcceptableOrUnknown(data['bucket_id']!, _bucketIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bucketIdMeta);
    }
    if (data.containsKey('bucket_name')) {
      context.handle(
        _bucketNameMeta,
        bucketName.isAcceptableOrUnknown(data['bucket_name']!, _bucketNameMeta),
      );
    }
    if (data.containsKey('requester_uid')) {
      context.handle(
        _requesterUidMeta,
        requesterUid.isAcceptableOrUnknown(
          data['requester_uid']!,
          _requesterUidMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_requesterUidMeta);
    }
    if (data.containsKey('requester_name')) {
      context.handle(
        _requesterNameMeta,
        requesterName.isAcceptableOrUnknown(
          data['requester_name']!,
          _requesterNameMeta,
        ),
      );
    }
    if (data.containsKey('requester_photo')) {
      context.handle(
        _requesterPhotoMeta,
        requesterPhoto.isAcceptableOrUnknown(
          data['requester_photo']!,
          _requesterPhotoMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('decided_at')) {
      context.handle(
        _decidedAtMeta,
        decidedAt.isAcceptableOrUnknown(data['decided_at']!, _decidedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JoinRequestRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JoinRequestRow(
      syncState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_state'],
      )!,
      deletedLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted_local'],
      )!,
      updatedAtLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_local'],
      ),
      serverUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}server_updated_at'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      bucketId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bucket_id'],
      )!,
      bucketName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bucket_name'],
      )!,
      requesterUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}requester_uid'],
      )!,
      requesterName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}requester_name'],
      ),
      requesterPhoto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}requester_photo'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      decidedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}decided_at'],
      ),
    );
  }

  @override
  $JoinRequestRowsTable createAlias(String alias) {
    return $JoinRequestRowsTable(attachedDatabase, alias);
  }
}

class JoinRequestRow extends DataClass implements Insertable<JoinRequestRow> {
  final String syncState;
  final bool deletedLocal;
  final DateTime? updatedAtLocal;
  final DateTime? serverUpdatedAt;
  final String id;
  final String bucketId;
  final String bucketName;
  final String requesterUid;
  final String? requesterName;
  final String? requesterPhoto;
  final String status;
  final DateTime? createdAt;
  final DateTime? decidedAt;
  const JoinRequestRow({
    required this.syncState,
    required this.deletedLocal,
    this.updatedAtLocal,
    this.serverUpdatedAt,
    required this.id,
    required this.bucketId,
    required this.bucketName,
    required this.requesterUid,
    this.requesterName,
    this.requesterPhoto,
    required this.status,
    this.createdAt,
    this.decidedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['sync_state'] = Variable<String>(syncState);
    map['deleted_local'] = Variable<bool>(deletedLocal);
    if (!nullToAbsent || updatedAtLocal != null) {
      map['updated_at_local'] = Variable<DateTime>(updatedAtLocal);
    }
    if (!nullToAbsent || serverUpdatedAt != null) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    }
    map['id'] = Variable<String>(id);
    map['bucket_id'] = Variable<String>(bucketId);
    map['bucket_name'] = Variable<String>(bucketName);
    map['requester_uid'] = Variable<String>(requesterUid);
    if (!nullToAbsent || requesterName != null) {
      map['requester_name'] = Variable<String>(requesterName);
    }
    if (!nullToAbsent || requesterPhoto != null) {
      map['requester_photo'] = Variable<String>(requesterPhoto);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || decidedAt != null) {
      map['decided_at'] = Variable<DateTime>(decidedAt);
    }
    return map;
  }

  JoinRequestRowsCompanion toCompanion(bool nullToAbsent) {
    return JoinRequestRowsCompanion(
      syncState: Value(syncState),
      deletedLocal: Value(deletedLocal),
      updatedAtLocal: updatedAtLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAtLocal),
      serverUpdatedAt: serverUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUpdatedAt),
      id: Value(id),
      bucketId: Value(bucketId),
      bucketName: Value(bucketName),
      requesterUid: Value(requesterUid),
      requesterName: requesterName == null && nullToAbsent
          ? const Value.absent()
          : Value(requesterName),
      requesterPhoto: requesterPhoto == null && nullToAbsent
          ? const Value.absent()
          : Value(requesterPhoto),
      status: Value(status),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      decidedAt: decidedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(decidedAt),
    );
  }

  factory JoinRequestRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JoinRequestRow(
      syncState: serializer.fromJson<String>(json['syncState']),
      deletedLocal: serializer.fromJson<bool>(json['deletedLocal']),
      updatedAtLocal: serializer.fromJson<DateTime?>(json['updatedAtLocal']),
      serverUpdatedAt: serializer.fromJson<DateTime?>(json['serverUpdatedAt']),
      id: serializer.fromJson<String>(json['id']),
      bucketId: serializer.fromJson<String>(json['bucketId']),
      bucketName: serializer.fromJson<String>(json['bucketName']),
      requesterUid: serializer.fromJson<String>(json['requesterUid']),
      requesterName: serializer.fromJson<String?>(json['requesterName']),
      requesterPhoto: serializer.fromJson<String?>(json['requesterPhoto']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      decidedAt: serializer.fromJson<DateTime?>(json['decidedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'syncState': serializer.toJson<String>(syncState),
      'deletedLocal': serializer.toJson<bool>(deletedLocal),
      'updatedAtLocal': serializer.toJson<DateTime?>(updatedAtLocal),
      'serverUpdatedAt': serializer.toJson<DateTime?>(serverUpdatedAt),
      'id': serializer.toJson<String>(id),
      'bucketId': serializer.toJson<String>(bucketId),
      'bucketName': serializer.toJson<String>(bucketName),
      'requesterUid': serializer.toJson<String>(requesterUid),
      'requesterName': serializer.toJson<String?>(requesterName),
      'requesterPhoto': serializer.toJson<String?>(requesterPhoto),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'decidedAt': serializer.toJson<DateTime?>(decidedAt),
    };
  }

  JoinRequestRow copyWith({
    String? syncState,
    bool? deletedLocal,
    Value<DateTime?> updatedAtLocal = const Value.absent(),
    Value<DateTime?> serverUpdatedAt = const Value.absent(),
    String? id,
    String? bucketId,
    String? bucketName,
    String? requesterUid,
    Value<String?> requesterName = const Value.absent(),
    Value<String?> requesterPhoto = const Value.absent(),
    String? status,
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> decidedAt = const Value.absent(),
  }) => JoinRequestRow(
    syncState: syncState ?? this.syncState,
    deletedLocal: deletedLocal ?? this.deletedLocal,
    updatedAtLocal: updatedAtLocal.present
        ? updatedAtLocal.value
        : this.updatedAtLocal,
    serverUpdatedAt: serverUpdatedAt.present
        ? serverUpdatedAt.value
        : this.serverUpdatedAt,
    id: id ?? this.id,
    bucketId: bucketId ?? this.bucketId,
    bucketName: bucketName ?? this.bucketName,
    requesterUid: requesterUid ?? this.requesterUid,
    requesterName: requesterName.present
        ? requesterName.value
        : this.requesterName,
    requesterPhoto: requesterPhoto.present
        ? requesterPhoto.value
        : this.requesterPhoto,
    status: status ?? this.status,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    decidedAt: decidedAt.present ? decidedAt.value : this.decidedAt,
  );
  JoinRequestRow copyWithCompanion(JoinRequestRowsCompanion data) {
    return JoinRequestRow(
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      deletedLocal: data.deletedLocal.present
          ? data.deletedLocal.value
          : this.deletedLocal,
      updatedAtLocal: data.updatedAtLocal.present
          ? data.updatedAtLocal.value
          : this.updatedAtLocal,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
      id: data.id.present ? data.id.value : this.id,
      bucketId: data.bucketId.present ? data.bucketId.value : this.bucketId,
      bucketName: data.bucketName.present
          ? data.bucketName.value
          : this.bucketName,
      requesterUid: data.requesterUid.present
          ? data.requesterUid.value
          : this.requesterUid,
      requesterName: data.requesterName.present
          ? data.requesterName.value
          : this.requesterName,
      requesterPhoto: data.requesterPhoto.present
          ? data.requesterPhoto.value
          : this.requesterPhoto,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      decidedAt: data.decidedAt.present ? data.decidedAt.value : this.decidedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JoinRequestRow(')
          ..write('syncState: $syncState, ')
          ..write('deletedLocal: $deletedLocal, ')
          ..write('updatedAtLocal: $updatedAtLocal, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('id: $id, ')
          ..write('bucketId: $bucketId, ')
          ..write('bucketName: $bucketName, ')
          ..write('requesterUid: $requesterUid, ')
          ..write('requesterName: $requesterName, ')
          ..write('requesterPhoto: $requesterPhoto, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('decidedAt: $decidedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    syncState,
    deletedLocal,
    updatedAtLocal,
    serverUpdatedAt,
    id,
    bucketId,
    bucketName,
    requesterUid,
    requesterName,
    requesterPhoto,
    status,
    createdAt,
    decidedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JoinRequestRow &&
          other.syncState == this.syncState &&
          other.deletedLocal == this.deletedLocal &&
          other.updatedAtLocal == this.updatedAtLocal &&
          other.serverUpdatedAt == this.serverUpdatedAt &&
          other.id == this.id &&
          other.bucketId == this.bucketId &&
          other.bucketName == this.bucketName &&
          other.requesterUid == this.requesterUid &&
          other.requesterName == this.requesterName &&
          other.requesterPhoto == this.requesterPhoto &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.decidedAt == this.decidedAt);
}

class JoinRequestRowsCompanion extends UpdateCompanion<JoinRequestRow> {
  final Value<String> syncState;
  final Value<bool> deletedLocal;
  final Value<DateTime?> updatedAtLocal;
  final Value<DateTime?> serverUpdatedAt;
  final Value<String> id;
  final Value<String> bucketId;
  final Value<String> bucketName;
  final Value<String> requesterUid;
  final Value<String?> requesterName;
  final Value<String?> requesterPhoto;
  final Value<String> status;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> decidedAt;
  final Value<int> rowid;
  const JoinRequestRowsCompanion({
    this.syncState = const Value.absent(),
    this.deletedLocal = const Value.absent(),
    this.updatedAtLocal = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.bucketId = const Value.absent(),
    this.bucketName = const Value.absent(),
    this.requesterUid = const Value.absent(),
    this.requesterName = const Value.absent(),
    this.requesterPhoto = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.decidedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  JoinRequestRowsCompanion.insert({
    this.syncState = const Value.absent(),
    this.deletedLocal = const Value.absent(),
    this.updatedAtLocal = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    required String id,
    required String bucketId,
    this.bucketName = const Value.absent(),
    required String requesterUid,
    this.requesterName = const Value.absent(),
    this.requesterPhoto = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.decidedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       bucketId = Value(bucketId),
       requesterUid = Value(requesterUid);
  static Insertable<JoinRequestRow> custom({
    Expression<String>? syncState,
    Expression<bool>? deletedLocal,
    Expression<DateTime>? updatedAtLocal,
    Expression<DateTime>? serverUpdatedAt,
    Expression<String>? id,
    Expression<String>? bucketId,
    Expression<String>? bucketName,
    Expression<String>? requesterUid,
    Expression<String>? requesterName,
    Expression<String>? requesterPhoto,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? decidedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (syncState != null) 'sync_state': syncState,
      if (deletedLocal != null) 'deleted_local': deletedLocal,
      if (updatedAtLocal != null) 'updated_at_local': updatedAtLocal,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (id != null) 'id': id,
      if (bucketId != null) 'bucket_id': bucketId,
      if (bucketName != null) 'bucket_name': bucketName,
      if (requesterUid != null) 'requester_uid': requesterUid,
      if (requesterName != null) 'requester_name': requesterName,
      if (requesterPhoto != null) 'requester_photo': requesterPhoto,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (decidedAt != null) 'decided_at': decidedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  JoinRequestRowsCompanion copyWith({
    Value<String>? syncState,
    Value<bool>? deletedLocal,
    Value<DateTime?>? updatedAtLocal,
    Value<DateTime?>? serverUpdatedAt,
    Value<String>? id,
    Value<String>? bucketId,
    Value<String>? bucketName,
    Value<String>? requesterUid,
    Value<String?>? requesterName,
    Value<String?>? requesterPhoto,
    Value<String>? status,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? decidedAt,
    Value<int>? rowid,
  }) {
    return JoinRequestRowsCompanion(
      syncState: syncState ?? this.syncState,
      deletedLocal: deletedLocal ?? this.deletedLocal,
      updatedAtLocal: updatedAtLocal ?? this.updatedAtLocal,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      id: id ?? this.id,
      bucketId: bucketId ?? this.bucketId,
      bucketName: bucketName ?? this.bucketName,
      requesterUid: requesterUid ?? this.requesterUid,
      requesterName: requesterName ?? this.requesterName,
      requesterPhoto: requesterPhoto ?? this.requesterPhoto,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      decidedAt: decidedAt ?? this.decidedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (syncState.present) {
      map['sync_state'] = Variable<String>(syncState.value);
    }
    if (deletedLocal.present) {
      map['deleted_local'] = Variable<bool>(deletedLocal.value);
    }
    if (updatedAtLocal.present) {
      map['updated_at_local'] = Variable<DateTime>(updatedAtLocal.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bucketId.present) {
      map['bucket_id'] = Variable<String>(bucketId.value);
    }
    if (bucketName.present) {
      map['bucket_name'] = Variable<String>(bucketName.value);
    }
    if (requesterUid.present) {
      map['requester_uid'] = Variable<String>(requesterUid.value);
    }
    if (requesterName.present) {
      map['requester_name'] = Variable<String>(requesterName.value);
    }
    if (requesterPhoto.present) {
      map['requester_photo'] = Variable<String>(requesterPhoto.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (decidedAt.present) {
      map['decided_at'] = Variable<DateTime>(decidedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JoinRequestRowsCompanion(')
          ..write('syncState: $syncState, ')
          ..write('deletedLocal: $deletedLocal, ')
          ..write('updatedAtLocal: $updatedAtLocal, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('id: $id, ')
          ..write('bucketId: $bucketId, ')
          ..write('bucketName: $bucketName, ')
          ..write('requesterUid: $requesterUid, ')
          ..write('requesterName: $requesterName, ')
          ..write('requesterPhoto: $requesterPhoto, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('decidedAt: $decidedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserNotificationRowsTable extends UserNotificationRows
    with TableInfo<$UserNotificationRowsTable, UserNotificationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserNotificationRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _syncStateMeta = const VerificationMeta(
    'syncState',
  );
  @override
  late final GeneratedColumn<String> syncState = GeneratedColumn<String>(
    'sync_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('synced'),
  );
  static const VerificationMeta _deletedLocalMeta = const VerificationMeta(
    'deletedLocal',
  );
  @override
  late final GeneratedColumn<bool> deletedLocal = GeneratedColumn<bool>(
    'deleted_local',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted_local" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtLocalMeta = const VerificationMeta(
    'updatedAtLocal',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtLocal =
      GeneratedColumn<DateTime>(
        'updated_at_local',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _serverUpdatedAtMeta = const VerificationMeta(
    'serverUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> serverUpdatedAt =
      GeneratedColumn<DateTime>(
        'server_updated_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recipientUidMeta = const VerificationMeta(
    'recipientUid',
  );
  @override
  late final GeneratedColumn<String> recipientUid = GeneratedColumn<String>(
    'recipient_uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<String> eventId = GeneratedColumn<String>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('unknown'),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('bucket'),
  );
  static const VerificationMeta _bucketIdMeta = const VerificationMeta(
    'bucketId',
  );
  @override
  late final GeneratedColumn<String> bucketId = GeneratedColumn<String>(
    'bucket_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bucketNameMeta = const VerificationMeta(
    'bucketName',
  );
  @override
  late final GeneratedColumn<String> bucketName = GeneratedColumn<String>(
    'bucket_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _actorUidMeta = const VerificationMeta(
    'actorUid',
  );
  @override
  late final GeneratedColumn<String> actorUid = GeneratedColumn<String>(
    'actor_uid',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _metadataMeta = const VerificationMeta(
    'metadata',
  );
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
    'metadata',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _correlationIdMeta = const VerificationMeta(
    'correlationId',
  );
  @override
  late final GeneratedColumn<String> correlationId = GeneratedColumn<String>(
    'correlation_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _readAtMeta = const VerificationMeta('readAt');
  @override
  late final GeneratedColumn<DateTime> readAt = GeneratedColumn<DateTime>(
    'read_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    syncState,
    deletedLocal,
    updatedAtLocal,
    serverUpdatedAt,
    id,
    recipientUid,
    eventId,
    type,
    category,
    bucketId,
    bucketName,
    actorUid,
    title,
    body,
    metadata,
    correlationId,
    createdAt,
    readAt,
    archivedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_notification_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserNotificationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('sync_state')) {
      context.handle(
        _syncStateMeta,
        syncState.isAcceptableOrUnknown(data['sync_state']!, _syncStateMeta),
      );
    }
    if (data.containsKey('deleted_local')) {
      context.handle(
        _deletedLocalMeta,
        deletedLocal.isAcceptableOrUnknown(
          data['deleted_local']!,
          _deletedLocalMeta,
        ),
      );
    }
    if (data.containsKey('updated_at_local')) {
      context.handle(
        _updatedAtLocalMeta,
        updatedAtLocal.isAcceptableOrUnknown(
          data['updated_at_local']!,
          _updatedAtLocalMeta,
        ),
      );
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
        _serverUpdatedAtMeta,
        serverUpdatedAt.isAcceptableOrUnknown(
          data['server_updated_at']!,
          _serverUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('recipient_uid')) {
      context.handle(
        _recipientUidMeta,
        recipientUid.isAcceptableOrUnknown(
          data['recipient_uid']!,
          _recipientUidMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recipientUidMeta);
    }
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('bucket_id')) {
      context.handle(
        _bucketIdMeta,
        bucketId.isAcceptableOrUnknown(data['bucket_id']!, _bucketIdMeta),
      );
    }
    if (data.containsKey('bucket_name')) {
      context.handle(
        _bucketNameMeta,
        bucketName.isAcceptableOrUnknown(data['bucket_name']!, _bucketNameMeta),
      );
    }
    if (data.containsKey('actor_uid')) {
      context.handle(
        _actorUidMeta,
        actorUid.isAcceptableOrUnknown(data['actor_uid']!, _actorUidMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    }
    if (data.containsKey('metadata')) {
      context.handle(
        _metadataMeta,
        metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta),
      );
    }
    if (data.containsKey('correlation_id')) {
      context.handle(
        _correlationIdMeta,
        correlationId.isAcceptableOrUnknown(
          data['correlation_id']!,
          _correlationIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('read_at')) {
      context.handle(
        _readAtMeta,
        readAt.isAcceptableOrUnknown(data['read_at']!, _readAtMeta),
      );
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserNotificationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserNotificationRow(
      syncState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_state'],
      )!,
      deletedLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted_local'],
      )!,
      updatedAtLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_local'],
      ),
      serverUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}server_updated_at'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      recipientUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipient_uid'],
      )!,
      eventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      bucketId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bucket_id'],
      ),
      bucketName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bucket_name'],
      )!,
      actorUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}actor_uid'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      metadata: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata'],
      )!,
      correlationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}correlation_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      readAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}read_at'],
      ),
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
    );
  }

  @override
  $UserNotificationRowsTable createAlias(String alias) {
    return $UserNotificationRowsTable(attachedDatabase, alias);
  }
}

class UserNotificationRow extends DataClass
    implements Insertable<UserNotificationRow> {
  final String syncState;
  final bool deletedLocal;
  final DateTime? updatedAtLocal;
  final DateTime? serverUpdatedAt;
  final String id;
  final String recipientUid;
  final String eventId;
  final String type;
  final String category;
  final String? bucketId;
  final String bucketName;
  final String? actorUid;
  final String title;
  final String body;
  final String metadata;
  final String? correlationId;
  final DateTime? createdAt;
  final DateTime? readAt;
  final DateTime? archivedAt;
  const UserNotificationRow({
    required this.syncState,
    required this.deletedLocal,
    this.updatedAtLocal,
    this.serverUpdatedAt,
    required this.id,
    required this.recipientUid,
    required this.eventId,
    required this.type,
    required this.category,
    this.bucketId,
    required this.bucketName,
    this.actorUid,
    required this.title,
    required this.body,
    required this.metadata,
    this.correlationId,
    this.createdAt,
    this.readAt,
    this.archivedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['sync_state'] = Variable<String>(syncState);
    map['deleted_local'] = Variable<bool>(deletedLocal);
    if (!nullToAbsent || updatedAtLocal != null) {
      map['updated_at_local'] = Variable<DateTime>(updatedAtLocal);
    }
    if (!nullToAbsent || serverUpdatedAt != null) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    }
    map['id'] = Variable<String>(id);
    map['recipient_uid'] = Variable<String>(recipientUid);
    map['event_id'] = Variable<String>(eventId);
    map['type'] = Variable<String>(type);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || bucketId != null) {
      map['bucket_id'] = Variable<String>(bucketId);
    }
    map['bucket_name'] = Variable<String>(bucketName);
    if (!nullToAbsent || actorUid != null) {
      map['actor_uid'] = Variable<String>(actorUid);
    }
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    map['metadata'] = Variable<String>(metadata);
    if (!nullToAbsent || correlationId != null) {
      map['correlation_id'] = Variable<String>(correlationId);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || readAt != null) {
      map['read_at'] = Variable<DateTime>(readAt);
    }
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    return map;
  }

  UserNotificationRowsCompanion toCompanion(bool nullToAbsent) {
    return UserNotificationRowsCompanion(
      syncState: Value(syncState),
      deletedLocal: Value(deletedLocal),
      updatedAtLocal: updatedAtLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAtLocal),
      serverUpdatedAt: serverUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUpdatedAt),
      id: Value(id),
      recipientUid: Value(recipientUid),
      eventId: Value(eventId),
      type: Value(type),
      category: Value(category),
      bucketId: bucketId == null && nullToAbsent
          ? const Value.absent()
          : Value(bucketId),
      bucketName: Value(bucketName),
      actorUid: actorUid == null && nullToAbsent
          ? const Value.absent()
          : Value(actorUid),
      title: Value(title),
      body: Value(body),
      metadata: Value(metadata),
      correlationId: correlationId == null && nullToAbsent
          ? const Value.absent()
          : Value(correlationId),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      readAt: readAt == null && nullToAbsent
          ? const Value.absent()
          : Value(readAt),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
    );
  }

  factory UserNotificationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserNotificationRow(
      syncState: serializer.fromJson<String>(json['syncState']),
      deletedLocal: serializer.fromJson<bool>(json['deletedLocal']),
      updatedAtLocal: serializer.fromJson<DateTime?>(json['updatedAtLocal']),
      serverUpdatedAt: serializer.fromJson<DateTime?>(json['serverUpdatedAt']),
      id: serializer.fromJson<String>(json['id']),
      recipientUid: serializer.fromJson<String>(json['recipientUid']),
      eventId: serializer.fromJson<String>(json['eventId']),
      type: serializer.fromJson<String>(json['type']),
      category: serializer.fromJson<String>(json['category']),
      bucketId: serializer.fromJson<String?>(json['bucketId']),
      bucketName: serializer.fromJson<String>(json['bucketName']),
      actorUid: serializer.fromJson<String?>(json['actorUid']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      metadata: serializer.fromJson<String>(json['metadata']),
      correlationId: serializer.fromJson<String?>(json['correlationId']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      readAt: serializer.fromJson<DateTime?>(json['readAt']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'syncState': serializer.toJson<String>(syncState),
      'deletedLocal': serializer.toJson<bool>(deletedLocal),
      'updatedAtLocal': serializer.toJson<DateTime?>(updatedAtLocal),
      'serverUpdatedAt': serializer.toJson<DateTime?>(serverUpdatedAt),
      'id': serializer.toJson<String>(id),
      'recipientUid': serializer.toJson<String>(recipientUid),
      'eventId': serializer.toJson<String>(eventId),
      'type': serializer.toJson<String>(type),
      'category': serializer.toJson<String>(category),
      'bucketId': serializer.toJson<String?>(bucketId),
      'bucketName': serializer.toJson<String>(bucketName),
      'actorUid': serializer.toJson<String?>(actorUid),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'metadata': serializer.toJson<String>(metadata),
      'correlationId': serializer.toJson<String?>(correlationId),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'readAt': serializer.toJson<DateTime?>(readAt),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
    };
  }

  UserNotificationRow copyWith({
    String? syncState,
    bool? deletedLocal,
    Value<DateTime?> updatedAtLocal = const Value.absent(),
    Value<DateTime?> serverUpdatedAt = const Value.absent(),
    String? id,
    String? recipientUid,
    String? eventId,
    String? type,
    String? category,
    Value<String?> bucketId = const Value.absent(),
    String? bucketName,
    Value<String?> actorUid = const Value.absent(),
    String? title,
    String? body,
    String? metadata,
    Value<String?> correlationId = const Value.absent(),
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> readAt = const Value.absent(),
    Value<DateTime?> archivedAt = const Value.absent(),
  }) => UserNotificationRow(
    syncState: syncState ?? this.syncState,
    deletedLocal: deletedLocal ?? this.deletedLocal,
    updatedAtLocal: updatedAtLocal.present
        ? updatedAtLocal.value
        : this.updatedAtLocal,
    serverUpdatedAt: serverUpdatedAt.present
        ? serverUpdatedAt.value
        : this.serverUpdatedAt,
    id: id ?? this.id,
    recipientUid: recipientUid ?? this.recipientUid,
    eventId: eventId ?? this.eventId,
    type: type ?? this.type,
    category: category ?? this.category,
    bucketId: bucketId.present ? bucketId.value : this.bucketId,
    bucketName: bucketName ?? this.bucketName,
    actorUid: actorUid.present ? actorUid.value : this.actorUid,
    title: title ?? this.title,
    body: body ?? this.body,
    metadata: metadata ?? this.metadata,
    correlationId: correlationId.present
        ? correlationId.value
        : this.correlationId,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    readAt: readAt.present ? readAt.value : this.readAt,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
  );
  UserNotificationRow copyWithCompanion(UserNotificationRowsCompanion data) {
    return UserNotificationRow(
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      deletedLocal: data.deletedLocal.present
          ? data.deletedLocal.value
          : this.deletedLocal,
      updatedAtLocal: data.updatedAtLocal.present
          ? data.updatedAtLocal.value
          : this.updatedAtLocal,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
      id: data.id.present ? data.id.value : this.id,
      recipientUid: data.recipientUid.present
          ? data.recipientUid.value
          : this.recipientUid,
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      type: data.type.present ? data.type.value : this.type,
      category: data.category.present ? data.category.value : this.category,
      bucketId: data.bucketId.present ? data.bucketId.value : this.bucketId,
      bucketName: data.bucketName.present
          ? data.bucketName.value
          : this.bucketName,
      actorUid: data.actorUid.present ? data.actorUid.value : this.actorUid,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      correlationId: data.correlationId.present
          ? data.correlationId.value
          : this.correlationId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      readAt: data.readAt.present ? data.readAt.value : this.readAt,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserNotificationRow(')
          ..write('syncState: $syncState, ')
          ..write('deletedLocal: $deletedLocal, ')
          ..write('updatedAtLocal: $updatedAtLocal, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('id: $id, ')
          ..write('recipientUid: $recipientUid, ')
          ..write('eventId: $eventId, ')
          ..write('type: $type, ')
          ..write('category: $category, ')
          ..write('bucketId: $bucketId, ')
          ..write('bucketName: $bucketName, ')
          ..write('actorUid: $actorUid, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('metadata: $metadata, ')
          ..write('correlationId: $correlationId, ')
          ..write('createdAt: $createdAt, ')
          ..write('readAt: $readAt, ')
          ..write('archivedAt: $archivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    syncState,
    deletedLocal,
    updatedAtLocal,
    serverUpdatedAt,
    id,
    recipientUid,
    eventId,
    type,
    category,
    bucketId,
    bucketName,
    actorUid,
    title,
    body,
    metadata,
    correlationId,
    createdAt,
    readAt,
    archivedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserNotificationRow &&
          other.syncState == this.syncState &&
          other.deletedLocal == this.deletedLocal &&
          other.updatedAtLocal == this.updatedAtLocal &&
          other.serverUpdatedAt == this.serverUpdatedAt &&
          other.id == this.id &&
          other.recipientUid == this.recipientUid &&
          other.eventId == this.eventId &&
          other.type == this.type &&
          other.category == this.category &&
          other.bucketId == this.bucketId &&
          other.bucketName == this.bucketName &&
          other.actorUid == this.actorUid &&
          other.title == this.title &&
          other.body == this.body &&
          other.metadata == this.metadata &&
          other.correlationId == this.correlationId &&
          other.createdAt == this.createdAt &&
          other.readAt == this.readAt &&
          other.archivedAt == this.archivedAt);
}

class UserNotificationRowsCompanion
    extends UpdateCompanion<UserNotificationRow> {
  final Value<String> syncState;
  final Value<bool> deletedLocal;
  final Value<DateTime?> updatedAtLocal;
  final Value<DateTime?> serverUpdatedAt;
  final Value<String> id;
  final Value<String> recipientUid;
  final Value<String> eventId;
  final Value<String> type;
  final Value<String> category;
  final Value<String?> bucketId;
  final Value<String> bucketName;
  final Value<String?> actorUid;
  final Value<String> title;
  final Value<String> body;
  final Value<String> metadata;
  final Value<String?> correlationId;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> readAt;
  final Value<DateTime?> archivedAt;
  final Value<int> rowid;
  const UserNotificationRowsCompanion({
    this.syncState = const Value.absent(),
    this.deletedLocal = const Value.absent(),
    this.updatedAtLocal = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.recipientUid = const Value.absent(),
    this.eventId = const Value.absent(),
    this.type = const Value.absent(),
    this.category = const Value.absent(),
    this.bucketId = const Value.absent(),
    this.bucketName = const Value.absent(),
    this.actorUid = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.metadata = const Value.absent(),
    this.correlationId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.readAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserNotificationRowsCompanion.insert({
    this.syncState = const Value.absent(),
    this.deletedLocal = const Value.absent(),
    this.updatedAtLocal = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    required String id,
    required String recipientUid,
    this.eventId = const Value.absent(),
    this.type = const Value.absent(),
    this.category = const Value.absent(),
    this.bucketId = const Value.absent(),
    this.bucketName = const Value.absent(),
    this.actorUid = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.metadata = const Value.absent(),
    this.correlationId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.readAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       recipientUid = Value(recipientUid);
  static Insertable<UserNotificationRow> custom({
    Expression<String>? syncState,
    Expression<bool>? deletedLocal,
    Expression<DateTime>? updatedAtLocal,
    Expression<DateTime>? serverUpdatedAt,
    Expression<String>? id,
    Expression<String>? recipientUid,
    Expression<String>? eventId,
    Expression<String>? type,
    Expression<String>? category,
    Expression<String>? bucketId,
    Expression<String>? bucketName,
    Expression<String>? actorUid,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? metadata,
    Expression<String>? correlationId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? readAt,
    Expression<DateTime>? archivedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (syncState != null) 'sync_state': syncState,
      if (deletedLocal != null) 'deleted_local': deletedLocal,
      if (updatedAtLocal != null) 'updated_at_local': updatedAtLocal,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (id != null) 'id': id,
      if (recipientUid != null) 'recipient_uid': recipientUid,
      if (eventId != null) 'event_id': eventId,
      if (type != null) 'type': type,
      if (category != null) 'category': category,
      if (bucketId != null) 'bucket_id': bucketId,
      if (bucketName != null) 'bucket_name': bucketName,
      if (actorUid != null) 'actor_uid': actorUid,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (metadata != null) 'metadata': metadata,
      if (correlationId != null) 'correlation_id': correlationId,
      if (createdAt != null) 'created_at': createdAt,
      if (readAt != null) 'read_at': readAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserNotificationRowsCompanion copyWith({
    Value<String>? syncState,
    Value<bool>? deletedLocal,
    Value<DateTime?>? updatedAtLocal,
    Value<DateTime?>? serverUpdatedAt,
    Value<String>? id,
    Value<String>? recipientUid,
    Value<String>? eventId,
    Value<String>? type,
    Value<String>? category,
    Value<String?>? bucketId,
    Value<String>? bucketName,
    Value<String?>? actorUid,
    Value<String>? title,
    Value<String>? body,
    Value<String>? metadata,
    Value<String?>? correlationId,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? readAt,
    Value<DateTime?>? archivedAt,
    Value<int>? rowid,
  }) {
    return UserNotificationRowsCompanion(
      syncState: syncState ?? this.syncState,
      deletedLocal: deletedLocal ?? this.deletedLocal,
      updatedAtLocal: updatedAtLocal ?? this.updatedAtLocal,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      id: id ?? this.id,
      recipientUid: recipientUid ?? this.recipientUid,
      eventId: eventId ?? this.eventId,
      type: type ?? this.type,
      category: category ?? this.category,
      bucketId: bucketId ?? this.bucketId,
      bucketName: bucketName ?? this.bucketName,
      actorUid: actorUid ?? this.actorUid,
      title: title ?? this.title,
      body: body ?? this.body,
      metadata: metadata ?? this.metadata,
      correlationId: correlationId ?? this.correlationId,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
      archivedAt: archivedAt ?? this.archivedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (syncState.present) {
      map['sync_state'] = Variable<String>(syncState.value);
    }
    if (deletedLocal.present) {
      map['deleted_local'] = Variable<bool>(deletedLocal.value);
    }
    if (updatedAtLocal.present) {
      map['updated_at_local'] = Variable<DateTime>(updatedAtLocal.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (recipientUid.present) {
      map['recipient_uid'] = Variable<String>(recipientUid.value);
    }
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (bucketId.present) {
      map['bucket_id'] = Variable<String>(bucketId.value);
    }
    if (bucketName.present) {
      map['bucket_name'] = Variable<String>(bucketName.value);
    }
    if (actorUid.present) {
      map['actor_uid'] = Variable<String>(actorUid.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (correlationId.present) {
      map['correlation_id'] = Variable<String>(correlationId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (readAt.present) {
      map['read_at'] = Variable<DateTime>(readAt.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserNotificationRowsCompanion(')
          ..write('syncState: $syncState, ')
          ..write('deletedLocal: $deletedLocal, ')
          ..write('updatedAtLocal: $updatedAtLocal, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('id: $id, ')
          ..write('recipientUid: $recipientUid, ')
          ..write('eventId: $eventId, ')
          ..write('type: $type, ')
          ..write('category: $category, ')
          ..write('bucketId: $bucketId, ')
          ..write('bucketName: $bucketName, ')
          ..write('actorUid: $actorUid, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('metadata: $metadata, ')
          ..write('correlationId: $correlationId, ')
          ..write('createdAt: $createdAt, ')
          ..write('readAt: $readAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BucketActivityRowsTable extends BucketActivityRows
    with TableInfo<$BucketActivityRowsTable, BucketActivityRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BucketActivityRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _syncStateMeta = const VerificationMeta(
    'syncState',
  );
  @override
  late final GeneratedColumn<String> syncState = GeneratedColumn<String>(
    'sync_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('synced'),
  );
  static const VerificationMeta _deletedLocalMeta = const VerificationMeta(
    'deletedLocal',
  );
  @override
  late final GeneratedColumn<bool> deletedLocal = GeneratedColumn<bool>(
    'deleted_local',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted_local" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtLocalMeta = const VerificationMeta(
    'updatedAtLocal',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtLocal =
      GeneratedColumn<DateTime>(
        'updated_at_local',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _serverUpdatedAtMeta = const VerificationMeta(
    'serverUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> serverUpdatedAt =
      GeneratedColumn<DateTime>(
        'server_updated_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bucketIdMeta = const VerificationMeta(
    'bucketId',
  );
  @override
  late final GeneratedColumn<String> bucketId = GeneratedColumn<String>(
    'bucket_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actorUidMeta = const VerificationMeta(
    'actorUid',
  );
  @override
  late final GeneratedColumn<String> actorUid = GeneratedColumn<String>(
    'actor_uid',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('unknown'),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('bucket'),
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _metadataMeta = const VerificationMeta(
    'metadata',
  );
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
    'metadata',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _correlationIdMeta = const VerificationMeta(
    'correlationId',
  );
  @override
  late final GeneratedColumn<String> correlationId = GeneratedColumn<String>(
    'correlation_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    syncState,
    deletedLocal,
    updatedAtLocal,
    serverUpdatedAt,
    id,
    bucketId,
    actorUid,
    type,
    category,
    summary,
    metadata,
    correlationId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bucket_activity_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<BucketActivityRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('sync_state')) {
      context.handle(
        _syncStateMeta,
        syncState.isAcceptableOrUnknown(data['sync_state']!, _syncStateMeta),
      );
    }
    if (data.containsKey('deleted_local')) {
      context.handle(
        _deletedLocalMeta,
        deletedLocal.isAcceptableOrUnknown(
          data['deleted_local']!,
          _deletedLocalMeta,
        ),
      );
    }
    if (data.containsKey('updated_at_local')) {
      context.handle(
        _updatedAtLocalMeta,
        updatedAtLocal.isAcceptableOrUnknown(
          data['updated_at_local']!,
          _updatedAtLocalMeta,
        ),
      );
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
        _serverUpdatedAtMeta,
        serverUpdatedAt.isAcceptableOrUnknown(
          data['server_updated_at']!,
          _serverUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('bucket_id')) {
      context.handle(
        _bucketIdMeta,
        bucketId.isAcceptableOrUnknown(data['bucket_id']!, _bucketIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bucketIdMeta);
    }
    if (data.containsKey('actor_uid')) {
      context.handle(
        _actorUidMeta,
        actorUid.isAcceptableOrUnknown(data['actor_uid']!, _actorUidMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    }
    if (data.containsKey('metadata')) {
      context.handle(
        _metadataMeta,
        metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta),
      );
    }
    if (data.containsKey('correlation_id')) {
      context.handle(
        _correlationIdMeta,
        correlationId.isAcceptableOrUnknown(
          data['correlation_id']!,
          _correlationIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BucketActivityRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BucketActivityRow(
      syncState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_state'],
      )!,
      deletedLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted_local'],
      )!,
      updatedAtLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_local'],
      ),
      serverUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}server_updated_at'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      bucketId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bucket_id'],
      )!,
      actorUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}actor_uid'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      )!,
      metadata: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata'],
      )!,
      correlationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}correlation_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
    );
  }

  @override
  $BucketActivityRowsTable createAlias(String alias) {
    return $BucketActivityRowsTable(attachedDatabase, alias);
  }
}

class BucketActivityRow extends DataClass
    implements Insertable<BucketActivityRow> {
  final String syncState;
  final bool deletedLocal;
  final DateTime? updatedAtLocal;
  final DateTime? serverUpdatedAt;
  final String id;
  final String bucketId;
  final String? actorUid;
  final String type;
  final String category;
  final String summary;
  final String metadata;
  final String? correlationId;
  final DateTime? createdAt;
  const BucketActivityRow({
    required this.syncState,
    required this.deletedLocal,
    this.updatedAtLocal,
    this.serverUpdatedAt,
    required this.id,
    required this.bucketId,
    this.actorUid,
    required this.type,
    required this.category,
    required this.summary,
    required this.metadata,
    this.correlationId,
    this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['sync_state'] = Variable<String>(syncState);
    map['deleted_local'] = Variable<bool>(deletedLocal);
    if (!nullToAbsent || updatedAtLocal != null) {
      map['updated_at_local'] = Variable<DateTime>(updatedAtLocal);
    }
    if (!nullToAbsent || serverUpdatedAt != null) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    }
    map['id'] = Variable<String>(id);
    map['bucket_id'] = Variable<String>(bucketId);
    if (!nullToAbsent || actorUid != null) {
      map['actor_uid'] = Variable<String>(actorUid);
    }
    map['type'] = Variable<String>(type);
    map['category'] = Variable<String>(category);
    map['summary'] = Variable<String>(summary);
    map['metadata'] = Variable<String>(metadata);
    if (!nullToAbsent || correlationId != null) {
      map['correlation_id'] = Variable<String>(correlationId);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  BucketActivityRowsCompanion toCompanion(bool nullToAbsent) {
    return BucketActivityRowsCompanion(
      syncState: Value(syncState),
      deletedLocal: Value(deletedLocal),
      updatedAtLocal: updatedAtLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAtLocal),
      serverUpdatedAt: serverUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUpdatedAt),
      id: Value(id),
      bucketId: Value(bucketId),
      actorUid: actorUid == null && nullToAbsent
          ? const Value.absent()
          : Value(actorUid),
      type: Value(type),
      category: Value(category),
      summary: Value(summary),
      metadata: Value(metadata),
      correlationId: correlationId == null && nullToAbsent
          ? const Value.absent()
          : Value(correlationId),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory BucketActivityRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BucketActivityRow(
      syncState: serializer.fromJson<String>(json['syncState']),
      deletedLocal: serializer.fromJson<bool>(json['deletedLocal']),
      updatedAtLocal: serializer.fromJson<DateTime?>(json['updatedAtLocal']),
      serverUpdatedAt: serializer.fromJson<DateTime?>(json['serverUpdatedAt']),
      id: serializer.fromJson<String>(json['id']),
      bucketId: serializer.fromJson<String>(json['bucketId']),
      actorUid: serializer.fromJson<String?>(json['actorUid']),
      type: serializer.fromJson<String>(json['type']),
      category: serializer.fromJson<String>(json['category']),
      summary: serializer.fromJson<String>(json['summary']),
      metadata: serializer.fromJson<String>(json['metadata']),
      correlationId: serializer.fromJson<String?>(json['correlationId']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'syncState': serializer.toJson<String>(syncState),
      'deletedLocal': serializer.toJson<bool>(deletedLocal),
      'updatedAtLocal': serializer.toJson<DateTime?>(updatedAtLocal),
      'serverUpdatedAt': serializer.toJson<DateTime?>(serverUpdatedAt),
      'id': serializer.toJson<String>(id),
      'bucketId': serializer.toJson<String>(bucketId),
      'actorUid': serializer.toJson<String?>(actorUid),
      'type': serializer.toJson<String>(type),
      'category': serializer.toJson<String>(category),
      'summary': serializer.toJson<String>(summary),
      'metadata': serializer.toJson<String>(metadata),
      'correlationId': serializer.toJson<String?>(correlationId),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  BucketActivityRow copyWith({
    String? syncState,
    bool? deletedLocal,
    Value<DateTime?> updatedAtLocal = const Value.absent(),
    Value<DateTime?> serverUpdatedAt = const Value.absent(),
    String? id,
    String? bucketId,
    Value<String?> actorUid = const Value.absent(),
    String? type,
    String? category,
    String? summary,
    String? metadata,
    Value<String?> correlationId = const Value.absent(),
    Value<DateTime?> createdAt = const Value.absent(),
  }) => BucketActivityRow(
    syncState: syncState ?? this.syncState,
    deletedLocal: deletedLocal ?? this.deletedLocal,
    updatedAtLocal: updatedAtLocal.present
        ? updatedAtLocal.value
        : this.updatedAtLocal,
    serverUpdatedAt: serverUpdatedAt.present
        ? serverUpdatedAt.value
        : this.serverUpdatedAt,
    id: id ?? this.id,
    bucketId: bucketId ?? this.bucketId,
    actorUid: actorUid.present ? actorUid.value : this.actorUid,
    type: type ?? this.type,
    category: category ?? this.category,
    summary: summary ?? this.summary,
    metadata: metadata ?? this.metadata,
    correlationId: correlationId.present
        ? correlationId.value
        : this.correlationId,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
  );
  BucketActivityRow copyWithCompanion(BucketActivityRowsCompanion data) {
    return BucketActivityRow(
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      deletedLocal: data.deletedLocal.present
          ? data.deletedLocal.value
          : this.deletedLocal,
      updatedAtLocal: data.updatedAtLocal.present
          ? data.updatedAtLocal.value
          : this.updatedAtLocal,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
      id: data.id.present ? data.id.value : this.id,
      bucketId: data.bucketId.present ? data.bucketId.value : this.bucketId,
      actorUid: data.actorUid.present ? data.actorUid.value : this.actorUid,
      type: data.type.present ? data.type.value : this.type,
      category: data.category.present ? data.category.value : this.category,
      summary: data.summary.present ? data.summary.value : this.summary,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      correlationId: data.correlationId.present
          ? data.correlationId.value
          : this.correlationId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BucketActivityRow(')
          ..write('syncState: $syncState, ')
          ..write('deletedLocal: $deletedLocal, ')
          ..write('updatedAtLocal: $updatedAtLocal, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('id: $id, ')
          ..write('bucketId: $bucketId, ')
          ..write('actorUid: $actorUid, ')
          ..write('type: $type, ')
          ..write('category: $category, ')
          ..write('summary: $summary, ')
          ..write('metadata: $metadata, ')
          ..write('correlationId: $correlationId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    syncState,
    deletedLocal,
    updatedAtLocal,
    serverUpdatedAt,
    id,
    bucketId,
    actorUid,
    type,
    category,
    summary,
    metadata,
    correlationId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BucketActivityRow &&
          other.syncState == this.syncState &&
          other.deletedLocal == this.deletedLocal &&
          other.updatedAtLocal == this.updatedAtLocal &&
          other.serverUpdatedAt == this.serverUpdatedAt &&
          other.id == this.id &&
          other.bucketId == this.bucketId &&
          other.actorUid == this.actorUid &&
          other.type == this.type &&
          other.category == this.category &&
          other.summary == this.summary &&
          other.metadata == this.metadata &&
          other.correlationId == this.correlationId &&
          other.createdAt == this.createdAt);
}

class BucketActivityRowsCompanion extends UpdateCompanion<BucketActivityRow> {
  final Value<String> syncState;
  final Value<bool> deletedLocal;
  final Value<DateTime?> updatedAtLocal;
  final Value<DateTime?> serverUpdatedAt;
  final Value<String> id;
  final Value<String> bucketId;
  final Value<String?> actorUid;
  final Value<String> type;
  final Value<String> category;
  final Value<String> summary;
  final Value<String> metadata;
  final Value<String?> correlationId;
  final Value<DateTime?> createdAt;
  final Value<int> rowid;
  const BucketActivityRowsCompanion({
    this.syncState = const Value.absent(),
    this.deletedLocal = const Value.absent(),
    this.updatedAtLocal = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.bucketId = const Value.absent(),
    this.actorUid = const Value.absent(),
    this.type = const Value.absent(),
    this.category = const Value.absent(),
    this.summary = const Value.absent(),
    this.metadata = const Value.absent(),
    this.correlationId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BucketActivityRowsCompanion.insert({
    this.syncState = const Value.absent(),
    this.deletedLocal = const Value.absent(),
    this.updatedAtLocal = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    required String id,
    required String bucketId,
    this.actorUid = const Value.absent(),
    this.type = const Value.absent(),
    this.category = const Value.absent(),
    this.summary = const Value.absent(),
    this.metadata = const Value.absent(),
    this.correlationId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       bucketId = Value(bucketId);
  static Insertable<BucketActivityRow> custom({
    Expression<String>? syncState,
    Expression<bool>? deletedLocal,
    Expression<DateTime>? updatedAtLocal,
    Expression<DateTime>? serverUpdatedAt,
    Expression<String>? id,
    Expression<String>? bucketId,
    Expression<String>? actorUid,
    Expression<String>? type,
    Expression<String>? category,
    Expression<String>? summary,
    Expression<String>? metadata,
    Expression<String>? correlationId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (syncState != null) 'sync_state': syncState,
      if (deletedLocal != null) 'deleted_local': deletedLocal,
      if (updatedAtLocal != null) 'updated_at_local': updatedAtLocal,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (id != null) 'id': id,
      if (bucketId != null) 'bucket_id': bucketId,
      if (actorUid != null) 'actor_uid': actorUid,
      if (type != null) 'type': type,
      if (category != null) 'category': category,
      if (summary != null) 'summary': summary,
      if (metadata != null) 'metadata': metadata,
      if (correlationId != null) 'correlation_id': correlationId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BucketActivityRowsCompanion copyWith({
    Value<String>? syncState,
    Value<bool>? deletedLocal,
    Value<DateTime?>? updatedAtLocal,
    Value<DateTime?>? serverUpdatedAt,
    Value<String>? id,
    Value<String>? bucketId,
    Value<String?>? actorUid,
    Value<String>? type,
    Value<String>? category,
    Value<String>? summary,
    Value<String>? metadata,
    Value<String?>? correlationId,
    Value<DateTime?>? createdAt,
    Value<int>? rowid,
  }) {
    return BucketActivityRowsCompanion(
      syncState: syncState ?? this.syncState,
      deletedLocal: deletedLocal ?? this.deletedLocal,
      updatedAtLocal: updatedAtLocal ?? this.updatedAtLocal,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      id: id ?? this.id,
      bucketId: bucketId ?? this.bucketId,
      actorUid: actorUid ?? this.actorUid,
      type: type ?? this.type,
      category: category ?? this.category,
      summary: summary ?? this.summary,
      metadata: metadata ?? this.metadata,
      correlationId: correlationId ?? this.correlationId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (syncState.present) {
      map['sync_state'] = Variable<String>(syncState.value);
    }
    if (deletedLocal.present) {
      map['deleted_local'] = Variable<bool>(deletedLocal.value);
    }
    if (updatedAtLocal.present) {
      map['updated_at_local'] = Variable<DateTime>(updatedAtLocal.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bucketId.present) {
      map['bucket_id'] = Variable<String>(bucketId.value);
    }
    if (actorUid.present) {
      map['actor_uid'] = Variable<String>(actorUid.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (correlationId.present) {
      map['correlation_id'] = Variable<String>(correlationId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BucketActivityRowsCompanion(')
          ..write('syncState: $syncState, ')
          ..write('deletedLocal: $deletedLocal, ')
          ..write('updatedAtLocal: $updatedAtLocal, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('id: $id, ')
          ..write('bucketId: $bucketId, ')
          ..write('actorUid: $actorUid, ')
          ..write('type: $type, ')
          ..write('category: $category, ')
          ..write('summary: $summary, ')
          ..write('metadata: $metadata, ')
          ..write('correlationId: $correlationId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OutboxTable extends Outbox with TableInfo<$OutboxTable, OutboxData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutboxTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityMeta = const VerificationMeta('entity');
  @override
  late final GeneratedColumn<String> entity = GeneratedColumn<String>(
    'entity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _opMeta = const VerificationMeta('op');
  @override
  late final GeneratedColumn<String> op = GeneratedColumn<String>(
    'op',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _baseVersionMeta = const VerificationMeta(
    'baseVersion',
  );
  @override
  late final GeneratedColumn<int> baseVersion = GeneratedColumn<int>(
    'base_version',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actorMeta = const VerificationMeta('actor');
  @override
  late final GeneratedColumn<String> actor = GeneratedColumn<String>(
    'actor',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncStateMeta = const VerificationMeta(
    'syncState',
  );
  @override
  late final GeneratedColumn<String> syncState = GeneratedColumn<String>(
    'sync_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _attemptCountMeta = const VerificationMeta(
    'attemptCount',
  );
  @override
  late final GeneratedColumn<int> attemptCount = GeneratedColumn<int>(
    'attempt_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entity,
    entityId,
    op,
    payload,
    baseVersion,
    actor,
    createdAt,
    syncState,
    attemptCount,
    lastError,
    priority,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outbox';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutboxData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity')) {
      context.handle(
        _entityMeta,
        entity.isAcceptableOrUnknown(data['entity']!, _entityMeta),
      );
    } else if (isInserting) {
      context.missing(_entityMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('op')) {
      context.handle(_opMeta, op.isAcceptableOrUnknown(data['op']!, _opMeta));
    } else if (isInserting) {
      context.missing(_opMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    }
    if (data.containsKey('base_version')) {
      context.handle(
        _baseVersionMeta,
        baseVersion.isAcceptableOrUnknown(
          data['base_version']!,
          _baseVersionMeta,
        ),
      );
    }
    if (data.containsKey('actor')) {
      context.handle(
        _actorMeta,
        actor.isAcceptableOrUnknown(data['actor']!, _actorMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('sync_state')) {
      context.handle(
        _syncStateMeta,
        syncState.isAcceptableOrUnknown(data['sync_state']!, _syncStateMeta),
      );
    }
    if (data.containsKey('attempt_count')) {
      context.handle(
        _attemptCountMeta,
        attemptCount.isAcceptableOrUnknown(
          data['attempt_count']!,
          _attemptCountMeta,
        ),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OutboxData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      entity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      op: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}op'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      baseVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}base_version'],
      ),
      actor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}actor'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      syncState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_state'],
      )!,
      attemptCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempt_count'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
    );
  }

  @override
  $OutboxTable createAlias(String alias) {
    return $OutboxTable(attachedDatabase, alias);
  }
}

class OutboxData extends DataClass implements Insertable<OutboxData> {
  final String id;
  final String entity;
  final String entityId;
  final String op;
  final String payload;
  final int? baseVersion;
  final String? actor;
  final DateTime createdAt;
  final String syncState;
  final int attemptCount;
  final String? lastError;
  final int priority;
  const OutboxData({
    required this.id,
    required this.entity,
    required this.entityId,
    required this.op,
    required this.payload,
    this.baseVersion,
    this.actor,
    required this.createdAt,
    required this.syncState,
    required this.attemptCount,
    this.lastError,
    required this.priority,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity'] = Variable<String>(entity);
    map['entity_id'] = Variable<String>(entityId);
    map['op'] = Variable<String>(op);
    map['payload'] = Variable<String>(payload);
    if (!nullToAbsent || baseVersion != null) {
      map['base_version'] = Variable<int>(baseVersion);
    }
    if (!nullToAbsent || actor != null) {
      map['actor'] = Variable<String>(actor);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['sync_state'] = Variable<String>(syncState);
    map['attempt_count'] = Variable<int>(attemptCount);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['priority'] = Variable<int>(priority);
    return map;
  }

  OutboxCompanion toCompanion(bool nullToAbsent) {
    return OutboxCompanion(
      id: Value(id),
      entity: Value(entity),
      entityId: Value(entityId),
      op: Value(op),
      payload: Value(payload),
      baseVersion: baseVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(baseVersion),
      actor: actor == null && nullToAbsent
          ? const Value.absent()
          : Value(actor),
      createdAt: Value(createdAt),
      syncState: Value(syncState),
      attemptCount: Value(attemptCount),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      priority: Value(priority),
    );
  }

  factory OutboxData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxData(
      id: serializer.fromJson<String>(json['id']),
      entity: serializer.fromJson<String>(json['entity']),
      entityId: serializer.fromJson<String>(json['entityId']),
      op: serializer.fromJson<String>(json['op']),
      payload: serializer.fromJson<String>(json['payload']),
      baseVersion: serializer.fromJson<int?>(json['baseVersion']),
      actor: serializer.fromJson<String?>(json['actor']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      syncState: serializer.fromJson<String>(json['syncState']),
      attemptCount: serializer.fromJson<int>(json['attemptCount']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      priority: serializer.fromJson<int>(json['priority']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entity': serializer.toJson<String>(entity),
      'entityId': serializer.toJson<String>(entityId),
      'op': serializer.toJson<String>(op),
      'payload': serializer.toJson<String>(payload),
      'baseVersion': serializer.toJson<int?>(baseVersion),
      'actor': serializer.toJson<String?>(actor),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'syncState': serializer.toJson<String>(syncState),
      'attemptCount': serializer.toJson<int>(attemptCount),
      'lastError': serializer.toJson<String?>(lastError),
      'priority': serializer.toJson<int>(priority),
    };
  }

  OutboxData copyWith({
    String? id,
    String? entity,
    String? entityId,
    String? op,
    String? payload,
    Value<int?> baseVersion = const Value.absent(),
    Value<String?> actor = const Value.absent(),
    DateTime? createdAt,
    String? syncState,
    int? attemptCount,
    Value<String?> lastError = const Value.absent(),
    int? priority,
  }) => OutboxData(
    id: id ?? this.id,
    entity: entity ?? this.entity,
    entityId: entityId ?? this.entityId,
    op: op ?? this.op,
    payload: payload ?? this.payload,
    baseVersion: baseVersion.present ? baseVersion.value : this.baseVersion,
    actor: actor.present ? actor.value : this.actor,
    createdAt: createdAt ?? this.createdAt,
    syncState: syncState ?? this.syncState,
    attemptCount: attemptCount ?? this.attemptCount,
    lastError: lastError.present ? lastError.value : this.lastError,
    priority: priority ?? this.priority,
  );
  OutboxData copyWithCompanion(OutboxCompanion data) {
    return OutboxData(
      id: data.id.present ? data.id.value : this.id,
      entity: data.entity.present ? data.entity.value : this.entity,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      op: data.op.present ? data.op.value : this.op,
      payload: data.payload.present ? data.payload.value : this.payload,
      baseVersion: data.baseVersion.present
          ? data.baseVersion.value
          : this.baseVersion,
      actor: data.actor.present ? data.actor.value : this.actor,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      attemptCount: data.attemptCount.present
          ? data.attemptCount.value
          : this.attemptCount,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      priority: data.priority.present ? data.priority.value : this.priority,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxData(')
          ..write('id: $id, ')
          ..write('entity: $entity, ')
          ..write('entityId: $entityId, ')
          ..write('op: $op, ')
          ..write('payload: $payload, ')
          ..write('baseVersion: $baseVersion, ')
          ..write('actor: $actor, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncState: $syncState, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('lastError: $lastError, ')
          ..write('priority: $priority')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entity,
    entityId,
    op,
    payload,
    baseVersion,
    actor,
    createdAt,
    syncState,
    attemptCount,
    lastError,
    priority,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxData &&
          other.id == this.id &&
          other.entity == this.entity &&
          other.entityId == this.entityId &&
          other.op == this.op &&
          other.payload == this.payload &&
          other.baseVersion == this.baseVersion &&
          other.actor == this.actor &&
          other.createdAt == this.createdAt &&
          other.syncState == this.syncState &&
          other.attemptCount == this.attemptCount &&
          other.lastError == this.lastError &&
          other.priority == this.priority);
}

class OutboxCompanion extends UpdateCompanion<OutboxData> {
  final Value<String> id;
  final Value<String> entity;
  final Value<String> entityId;
  final Value<String> op;
  final Value<String> payload;
  final Value<int?> baseVersion;
  final Value<String?> actor;
  final Value<DateTime> createdAt;
  final Value<String> syncState;
  final Value<int> attemptCount;
  final Value<String?> lastError;
  final Value<int> priority;
  final Value<int> rowid;
  const OutboxCompanion({
    this.id = const Value.absent(),
    this.entity = const Value.absent(),
    this.entityId = const Value.absent(),
    this.op = const Value.absent(),
    this.payload = const Value.absent(),
    this.baseVersion = const Value.absent(),
    this.actor = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncState = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.priority = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OutboxCompanion.insert({
    required String id,
    required String entity,
    required String entityId,
    required String op,
    this.payload = const Value.absent(),
    this.baseVersion = const Value.absent(),
    this.actor = const Value.absent(),
    required DateTime createdAt,
    this.syncState = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.priority = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       entity = Value(entity),
       entityId = Value(entityId),
       op = Value(op),
       createdAt = Value(createdAt);
  static Insertable<OutboxData> custom({
    Expression<String>? id,
    Expression<String>? entity,
    Expression<String>? entityId,
    Expression<String>? op,
    Expression<String>? payload,
    Expression<int>? baseVersion,
    Expression<String>? actor,
    Expression<DateTime>? createdAt,
    Expression<String>? syncState,
    Expression<int>? attemptCount,
    Expression<String>? lastError,
    Expression<int>? priority,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entity != null) 'entity': entity,
      if (entityId != null) 'entity_id': entityId,
      if (op != null) 'op': op,
      if (payload != null) 'payload': payload,
      if (baseVersion != null) 'base_version': baseVersion,
      if (actor != null) 'actor': actor,
      if (createdAt != null) 'created_at': createdAt,
      if (syncState != null) 'sync_state': syncState,
      if (attemptCount != null) 'attempt_count': attemptCount,
      if (lastError != null) 'last_error': lastError,
      if (priority != null) 'priority': priority,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OutboxCompanion copyWith({
    Value<String>? id,
    Value<String>? entity,
    Value<String>? entityId,
    Value<String>? op,
    Value<String>? payload,
    Value<int?>? baseVersion,
    Value<String?>? actor,
    Value<DateTime>? createdAt,
    Value<String>? syncState,
    Value<int>? attemptCount,
    Value<String?>? lastError,
    Value<int>? priority,
    Value<int>? rowid,
  }) {
    return OutboxCompanion(
      id: id ?? this.id,
      entity: entity ?? this.entity,
      entityId: entityId ?? this.entityId,
      op: op ?? this.op,
      payload: payload ?? this.payload,
      baseVersion: baseVersion ?? this.baseVersion,
      actor: actor ?? this.actor,
      createdAt: createdAt ?? this.createdAt,
      syncState: syncState ?? this.syncState,
      attemptCount: attemptCount ?? this.attemptCount,
      lastError: lastError ?? this.lastError,
      priority: priority ?? this.priority,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entity.present) {
      map['entity'] = Variable<String>(entity.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (op.present) {
      map['op'] = Variable<String>(op.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (baseVersion.present) {
      map['base_version'] = Variable<int>(baseVersion.value);
    }
    if (actor.present) {
      map['actor'] = Variable<String>(actor.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (syncState.present) {
      map['sync_state'] = Variable<String>(syncState.value);
    }
    if (attemptCount.present) {
      map['attempt_count'] = Variable<int>(attemptCount.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutboxCompanion(')
          ..write('id: $id, ')
          ..write('entity: $entity, ')
          ..write('entityId: $entityId, ')
          ..write('op: $op, ')
          ..write('payload: $payload, ')
          ..write('baseVersion: $baseVersion, ')
          ..write('actor: $actor, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncState: $syncState, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('lastError: $lastError, ')
          ..write('priority: $priority, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BucketsTable buckets = $BucketsTable(this);
  late final $WeeklyBucketRowsTable weeklyBucketRows = $WeeklyBucketRowsTable(
    this,
  );
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final $BigExpensesTable bigExpenses = $BigExpensesTable(this);
  late final $BucketMemberRowsTable bucketMemberRows = $BucketMemberRowsTable(
    this,
  );
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $NotificationRowsTable notificationRows = $NotificationRowsTable(
    this,
  );
  late final $JoinRequestRowsTable joinRequestRows = $JoinRequestRowsTable(
    this,
  );
  late final $UserNotificationRowsTable userNotificationRows =
      $UserNotificationRowsTable(this);
  late final $BucketActivityRowsTable bucketActivityRows =
      $BucketActivityRowsTable(this);
  late final $OutboxTable outbox = $OutboxTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    buckets,
    weeklyBucketRows,
    expenses,
    bigExpenses,
    bucketMemberRows,
    categories,
    notificationRows,
    joinRequestRows,
    userNotificationRows,
    bucketActivityRows,
    outbox,
  ];
}

typedef $$BucketsTableCreateCompanionBuilder =
    BucketsCompanion Function({
      Value<String> syncState,
      Value<bool> deletedLocal,
      Value<DateTime?> updatedAtLocal,
      Value<DateTime?> serverUpdatedAt,
      required String id,
      Value<String> name,
      required String ownerId,
      Value<String> joinCode,
      Value<double> monthlyBudget,
      required String monthStartDate,
      Value<double> remainingMainBucket,
      Value<String> currency,
      Value<String> status,
      Value<DateTime?> deletedAt,
      Value<String?> deletedBy,
      Value<DateTime?> createdAt,
      Value<int> rowid,
    });
typedef $$BucketsTableUpdateCompanionBuilder =
    BucketsCompanion Function({
      Value<String> syncState,
      Value<bool> deletedLocal,
      Value<DateTime?> updatedAtLocal,
      Value<DateTime?> serverUpdatedAt,
      Value<String> id,
      Value<String> name,
      Value<String> ownerId,
      Value<String> joinCode,
      Value<double> monthlyBudget,
      Value<String> monthStartDate,
      Value<double> remainingMainBucket,
      Value<String> currency,
      Value<String> status,
      Value<DateTime?> deletedAt,
      Value<String?> deletedBy,
      Value<DateTime?> createdAt,
      Value<int> rowid,
    });

class $$BucketsTableFilterComposer
    extends Composer<_$AppDatabase, $BucketsTable> {
  $$BucketsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deletedLocal => $composableBuilder(
    column: $table.deletedLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get joinCode => $composableBuilder(
    column: $table.joinCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get monthlyBudget => $composableBuilder(
    column: $table.monthlyBudget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get monthStartDate => $composableBuilder(
    column: $table.monthStartDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get remainingMainBucket => $composableBuilder(
    column: $table.remainingMainBucket,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deletedBy => $composableBuilder(
    column: $table.deletedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BucketsTableOrderingComposer
    extends Composer<_$AppDatabase, $BucketsTable> {
  $$BucketsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deletedLocal => $composableBuilder(
    column: $table.deletedLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get joinCode => $composableBuilder(
    column: $table.joinCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get monthlyBudget => $composableBuilder(
    column: $table.monthlyBudget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get monthStartDate => $composableBuilder(
    column: $table.monthStartDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get remainingMainBucket => $composableBuilder(
    column: $table.remainingMainBucket,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deletedBy => $composableBuilder(
    column: $table.deletedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BucketsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BucketsTable> {
  $$BucketsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get syncState =>
      $composableBuilder(column: $table.syncState, builder: (column) => column);

  GeneratedColumn<bool> get deletedLocal => $composableBuilder(
    column: $table.deletedLocal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get joinCode =>
      $composableBuilder(column: $table.joinCode, builder: (column) => column);

  GeneratedColumn<double> get monthlyBudget => $composableBuilder(
    column: $table.monthlyBudget,
    builder: (column) => column,
  );

  GeneratedColumn<String> get monthStartDate => $composableBuilder(
    column: $table.monthStartDate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get remainingMainBucket => $composableBuilder(
    column: $table.remainingMainBucket,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get deletedBy =>
      $composableBuilder(column: $table.deletedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BucketsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BucketsTable,
          BucketRow,
          $$BucketsTableFilterComposer,
          $$BucketsTableOrderingComposer,
          $$BucketsTableAnnotationComposer,
          $$BucketsTableCreateCompanionBuilder,
          $$BucketsTableUpdateCompanionBuilder,
          (BucketRow, BaseReferences<_$AppDatabase, $BucketsTable, BucketRow>),
          BucketRow,
          PrefetchHooks Function()
        > {
  $$BucketsTableTableManager(_$AppDatabase db, $BucketsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BucketsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BucketsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BucketsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> syncState = const Value.absent(),
                Value<bool> deletedLocal = const Value.absent(),
                Value<DateTime?> updatedAtLocal = const Value.absent(),
                Value<DateTime?> serverUpdatedAt = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> ownerId = const Value.absent(),
                Value<String> joinCode = const Value.absent(),
                Value<double> monthlyBudget = const Value.absent(),
                Value<String> monthStartDate = const Value.absent(),
                Value<double> remainingMainBucket = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> deletedBy = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BucketsCompanion(
                syncState: syncState,
                deletedLocal: deletedLocal,
                updatedAtLocal: updatedAtLocal,
                serverUpdatedAt: serverUpdatedAt,
                id: id,
                name: name,
                ownerId: ownerId,
                joinCode: joinCode,
                monthlyBudget: monthlyBudget,
                monthStartDate: monthStartDate,
                remainingMainBucket: remainingMainBucket,
                currency: currency,
                status: status,
                deletedAt: deletedAt,
                deletedBy: deletedBy,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> syncState = const Value.absent(),
                Value<bool> deletedLocal = const Value.absent(),
                Value<DateTime?> updatedAtLocal = const Value.absent(),
                Value<DateTime?> serverUpdatedAt = const Value.absent(),
                required String id,
                Value<String> name = const Value.absent(),
                required String ownerId,
                Value<String> joinCode = const Value.absent(),
                Value<double> monthlyBudget = const Value.absent(),
                required String monthStartDate,
                Value<double> remainingMainBucket = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> deletedBy = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BucketsCompanion.insert(
                syncState: syncState,
                deletedLocal: deletedLocal,
                updatedAtLocal: updatedAtLocal,
                serverUpdatedAt: serverUpdatedAt,
                id: id,
                name: name,
                ownerId: ownerId,
                joinCode: joinCode,
                monthlyBudget: monthlyBudget,
                monthStartDate: monthStartDate,
                remainingMainBucket: remainingMainBucket,
                currency: currency,
                status: status,
                deletedAt: deletedAt,
                deletedBy: deletedBy,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BucketsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BucketsTable,
      BucketRow,
      $$BucketsTableFilterComposer,
      $$BucketsTableOrderingComposer,
      $$BucketsTableAnnotationComposer,
      $$BucketsTableCreateCompanionBuilder,
      $$BucketsTableUpdateCompanionBuilder,
      (BucketRow, BaseReferences<_$AppDatabase, $BucketsTable, BucketRow>),
      BucketRow,
      PrefetchHooks Function()
    >;
typedef $$WeeklyBucketRowsTableCreateCompanionBuilder =
    WeeklyBucketRowsCompanion Function({
      Value<String> syncState,
      Value<bool> deletedLocal,
      Value<DateTime?> updatedAtLocal,
      Value<DateTime?> serverUpdatedAt,
      required String id,
      required String bucketId,
      Value<int> weekIndex,
      required String startDate,
      required String endDate,
      Value<String?> effectiveStartDate,
      Value<String> kind,
      Value<double> allocatedAmount,
      Value<double> spentAmount,
      Value<double> remainingAmount,
      Value<String> status,
      Value<int> rowid,
    });
typedef $$WeeklyBucketRowsTableUpdateCompanionBuilder =
    WeeklyBucketRowsCompanion Function({
      Value<String> syncState,
      Value<bool> deletedLocal,
      Value<DateTime?> updatedAtLocal,
      Value<DateTime?> serverUpdatedAt,
      Value<String> id,
      Value<String> bucketId,
      Value<int> weekIndex,
      Value<String> startDate,
      Value<String> endDate,
      Value<String?> effectiveStartDate,
      Value<String> kind,
      Value<double> allocatedAmount,
      Value<double> spentAmount,
      Value<double> remainingAmount,
      Value<String> status,
      Value<int> rowid,
    });

class $$WeeklyBucketRowsTableFilterComposer
    extends Composer<_$AppDatabase, $WeeklyBucketRowsTable> {
  $$WeeklyBucketRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deletedLocal => $composableBuilder(
    column: $table.deletedLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bucketId => $composableBuilder(
    column: $table.bucketId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekIndex => $composableBuilder(
    column: $table.weekIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get effectiveStartDate => $composableBuilder(
    column: $table.effectiveStartDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get allocatedAmount => $composableBuilder(
    column: $table.allocatedAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get spentAmount => $composableBuilder(
    column: $table.spentAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get remainingAmount => $composableBuilder(
    column: $table.remainingAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeeklyBucketRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $WeeklyBucketRowsTable> {
  $$WeeklyBucketRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deletedLocal => $composableBuilder(
    column: $table.deletedLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bucketId => $composableBuilder(
    column: $table.bucketId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekIndex => $composableBuilder(
    column: $table.weekIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get effectiveStartDate => $composableBuilder(
    column: $table.effectiveStartDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get allocatedAmount => $composableBuilder(
    column: $table.allocatedAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get spentAmount => $composableBuilder(
    column: $table.spentAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get remainingAmount => $composableBuilder(
    column: $table.remainingAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeeklyBucketRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeeklyBucketRowsTable> {
  $$WeeklyBucketRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get syncState =>
      $composableBuilder(column: $table.syncState, builder: (column) => column);

  GeneratedColumn<bool> get deletedLocal => $composableBuilder(
    column: $table.deletedLocal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get bucketId =>
      $composableBuilder(column: $table.bucketId, builder: (column) => column);

  GeneratedColumn<int> get weekIndex =>
      $composableBuilder(column: $table.weekIndex, builder: (column) => column);

  GeneratedColumn<String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get effectiveStartDate => $composableBuilder(
    column: $table.effectiveStartDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<double> get allocatedAmount => $composableBuilder(
    column: $table.allocatedAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get spentAmount => $composableBuilder(
    column: $table.spentAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get remainingAmount => $composableBuilder(
    column: $table.remainingAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$WeeklyBucketRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeeklyBucketRowsTable,
          WeeklyBucketRow,
          $$WeeklyBucketRowsTableFilterComposer,
          $$WeeklyBucketRowsTableOrderingComposer,
          $$WeeklyBucketRowsTableAnnotationComposer,
          $$WeeklyBucketRowsTableCreateCompanionBuilder,
          $$WeeklyBucketRowsTableUpdateCompanionBuilder,
          (
            WeeklyBucketRow,
            BaseReferences<
              _$AppDatabase,
              $WeeklyBucketRowsTable,
              WeeklyBucketRow
            >,
          ),
          WeeklyBucketRow,
          PrefetchHooks Function()
        > {
  $$WeeklyBucketRowsTableTableManager(
    _$AppDatabase db,
    $WeeklyBucketRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeeklyBucketRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeeklyBucketRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeeklyBucketRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> syncState = const Value.absent(),
                Value<bool> deletedLocal = const Value.absent(),
                Value<DateTime?> updatedAtLocal = const Value.absent(),
                Value<DateTime?> serverUpdatedAt = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> bucketId = const Value.absent(),
                Value<int> weekIndex = const Value.absent(),
                Value<String> startDate = const Value.absent(),
                Value<String> endDate = const Value.absent(),
                Value<String?> effectiveStartDate = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<double> allocatedAmount = const Value.absent(),
                Value<double> spentAmount = const Value.absent(),
                Value<double> remainingAmount = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeeklyBucketRowsCompanion(
                syncState: syncState,
                deletedLocal: deletedLocal,
                updatedAtLocal: updatedAtLocal,
                serverUpdatedAt: serverUpdatedAt,
                id: id,
                bucketId: bucketId,
                weekIndex: weekIndex,
                startDate: startDate,
                endDate: endDate,
                effectiveStartDate: effectiveStartDate,
                kind: kind,
                allocatedAmount: allocatedAmount,
                spentAmount: spentAmount,
                remainingAmount: remainingAmount,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> syncState = const Value.absent(),
                Value<bool> deletedLocal = const Value.absent(),
                Value<DateTime?> updatedAtLocal = const Value.absent(),
                Value<DateTime?> serverUpdatedAt = const Value.absent(),
                required String id,
                required String bucketId,
                Value<int> weekIndex = const Value.absent(),
                required String startDate,
                required String endDate,
                Value<String?> effectiveStartDate = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<double> allocatedAmount = const Value.absent(),
                Value<double> spentAmount = const Value.absent(),
                Value<double> remainingAmount = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeeklyBucketRowsCompanion.insert(
                syncState: syncState,
                deletedLocal: deletedLocal,
                updatedAtLocal: updatedAtLocal,
                serverUpdatedAt: serverUpdatedAt,
                id: id,
                bucketId: bucketId,
                weekIndex: weekIndex,
                startDate: startDate,
                endDate: endDate,
                effectiveStartDate: effectiveStartDate,
                kind: kind,
                allocatedAmount: allocatedAmount,
                spentAmount: spentAmount,
                remainingAmount: remainingAmount,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeeklyBucketRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeeklyBucketRowsTable,
      WeeklyBucketRow,
      $$WeeklyBucketRowsTableFilterComposer,
      $$WeeklyBucketRowsTableOrderingComposer,
      $$WeeklyBucketRowsTableAnnotationComposer,
      $$WeeklyBucketRowsTableCreateCompanionBuilder,
      $$WeeklyBucketRowsTableUpdateCompanionBuilder,
      (
        WeeklyBucketRow,
        BaseReferences<_$AppDatabase, $WeeklyBucketRowsTable, WeeklyBucketRow>,
      ),
      WeeklyBucketRow,
      PrefetchHooks Function()
    >;
typedef $$ExpensesTableCreateCompanionBuilder =
    ExpensesCompanion Function({
      Value<String> syncState,
      Value<bool> deletedLocal,
      Value<DateTime?> updatedAtLocal,
      Value<DateTime?> serverUpdatedAt,
      required String id,
      required String bucketId,
      Value<String?> weekId,
      Value<String> addedByUid,
      Value<double> amount,
      Value<String?> categoryId,
      Value<String?> note,
      Value<String?> receiptImageUrl,
      required DateTime createdAt,
      Value<String?> editedByUid,
      Value<int> rowid,
    });
typedef $$ExpensesTableUpdateCompanionBuilder =
    ExpensesCompanion Function({
      Value<String> syncState,
      Value<bool> deletedLocal,
      Value<DateTime?> updatedAtLocal,
      Value<DateTime?> serverUpdatedAt,
      Value<String> id,
      Value<String> bucketId,
      Value<String?> weekId,
      Value<String> addedByUid,
      Value<double> amount,
      Value<String?> categoryId,
      Value<String?> note,
      Value<String?> receiptImageUrl,
      Value<DateTime> createdAt,
      Value<String?> editedByUid,
      Value<int> rowid,
    });

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deletedLocal => $composableBuilder(
    column: $table.deletedLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bucketId => $composableBuilder(
    column: $table.bucketId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weekId => $composableBuilder(
    column: $table.weekId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addedByUid => $composableBuilder(
    column: $table.addedByUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiptImageUrl => $composableBuilder(
    column: $table.receiptImageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get editedByUid => $composableBuilder(
    column: $table.editedByUid,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deletedLocal => $composableBuilder(
    column: $table.deletedLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bucketId => $composableBuilder(
    column: $table.bucketId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weekId => $composableBuilder(
    column: $table.weekId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addedByUid => $composableBuilder(
    column: $table.addedByUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptImageUrl => $composableBuilder(
    column: $table.receiptImageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get editedByUid => $composableBuilder(
    column: $table.editedByUid,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get syncState =>
      $composableBuilder(column: $table.syncState, builder: (column) => column);

  GeneratedColumn<bool> get deletedLocal => $composableBuilder(
    column: $table.deletedLocal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get bucketId =>
      $composableBuilder(column: $table.bucketId, builder: (column) => column);

  GeneratedColumn<String> get weekId =>
      $composableBuilder(column: $table.weekId, builder: (column) => column);

  GeneratedColumn<String> get addedByUid => $composableBuilder(
    column: $table.addedByUid,
    builder: (column) => column,
  );

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get receiptImageUrl => $composableBuilder(
    column: $table.receiptImageUrl,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get editedByUid => $composableBuilder(
    column: $table.editedByUid,
    builder: (column) => column,
  );
}

class $$ExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpensesTable,
          ExpenseRow,
          $$ExpensesTableFilterComposer,
          $$ExpensesTableOrderingComposer,
          $$ExpensesTableAnnotationComposer,
          $$ExpensesTableCreateCompanionBuilder,
          $$ExpensesTableUpdateCompanionBuilder,
          (
            ExpenseRow,
            BaseReferences<_$AppDatabase, $ExpensesTable, ExpenseRow>,
          ),
          ExpenseRow,
          PrefetchHooks Function()
        > {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> syncState = const Value.absent(),
                Value<bool> deletedLocal = const Value.absent(),
                Value<DateTime?> updatedAtLocal = const Value.absent(),
                Value<DateTime?> serverUpdatedAt = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> bucketId = const Value.absent(),
                Value<String?> weekId = const Value.absent(),
                Value<String> addedByUid = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> receiptImageUrl = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> editedByUid = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExpensesCompanion(
                syncState: syncState,
                deletedLocal: deletedLocal,
                updatedAtLocal: updatedAtLocal,
                serverUpdatedAt: serverUpdatedAt,
                id: id,
                bucketId: bucketId,
                weekId: weekId,
                addedByUid: addedByUid,
                amount: amount,
                categoryId: categoryId,
                note: note,
                receiptImageUrl: receiptImageUrl,
                createdAt: createdAt,
                editedByUid: editedByUid,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> syncState = const Value.absent(),
                Value<bool> deletedLocal = const Value.absent(),
                Value<DateTime?> updatedAtLocal = const Value.absent(),
                Value<DateTime?> serverUpdatedAt = const Value.absent(),
                required String id,
                required String bucketId,
                Value<String?> weekId = const Value.absent(),
                Value<String> addedByUid = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> receiptImageUrl = const Value.absent(),
                required DateTime createdAt,
                Value<String?> editedByUid = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExpensesCompanion.insert(
                syncState: syncState,
                deletedLocal: deletedLocal,
                updatedAtLocal: updatedAtLocal,
                serverUpdatedAt: serverUpdatedAt,
                id: id,
                bucketId: bucketId,
                weekId: weekId,
                addedByUid: addedByUid,
                amount: amount,
                categoryId: categoryId,
                note: note,
                receiptImageUrl: receiptImageUrl,
                createdAt: createdAt,
                editedByUid: editedByUid,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpensesTable,
      ExpenseRow,
      $$ExpensesTableFilterComposer,
      $$ExpensesTableOrderingComposer,
      $$ExpensesTableAnnotationComposer,
      $$ExpensesTableCreateCompanionBuilder,
      $$ExpensesTableUpdateCompanionBuilder,
      (ExpenseRow, BaseReferences<_$AppDatabase, $ExpensesTable, ExpenseRow>),
      ExpenseRow,
      PrefetchHooks Function()
    >;
typedef $$BigExpensesTableCreateCompanionBuilder =
    BigExpensesCompanion Function({
      Value<String> syncState,
      Value<bool> deletedLocal,
      Value<DateTime?> updatedAtLocal,
      Value<DateTime?> serverUpdatedAt,
      required String id,
      required String bucketId,
      Value<String> addedByUid,
      Value<String> title,
      Value<double> amount,
      Value<DateTime?> createdAt,
      Value<int> rowid,
    });
typedef $$BigExpensesTableUpdateCompanionBuilder =
    BigExpensesCompanion Function({
      Value<String> syncState,
      Value<bool> deletedLocal,
      Value<DateTime?> updatedAtLocal,
      Value<DateTime?> serverUpdatedAt,
      Value<String> id,
      Value<String> bucketId,
      Value<String> addedByUid,
      Value<String> title,
      Value<double> amount,
      Value<DateTime?> createdAt,
      Value<int> rowid,
    });

class $$BigExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $BigExpensesTable> {
  $$BigExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deletedLocal => $composableBuilder(
    column: $table.deletedLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bucketId => $composableBuilder(
    column: $table.bucketId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addedByUid => $composableBuilder(
    column: $table.addedByUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BigExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $BigExpensesTable> {
  $$BigExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deletedLocal => $composableBuilder(
    column: $table.deletedLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bucketId => $composableBuilder(
    column: $table.bucketId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addedByUid => $composableBuilder(
    column: $table.addedByUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BigExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BigExpensesTable> {
  $$BigExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get syncState =>
      $composableBuilder(column: $table.syncState, builder: (column) => column);

  GeneratedColumn<bool> get deletedLocal => $composableBuilder(
    column: $table.deletedLocal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get bucketId =>
      $composableBuilder(column: $table.bucketId, builder: (column) => column);

  GeneratedColumn<String> get addedByUid => $composableBuilder(
    column: $table.addedByUid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BigExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BigExpensesTable,
          BigExpenseRow,
          $$BigExpensesTableFilterComposer,
          $$BigExpensesTableOrderingComposer,
          $$BigExpensesTableAnnotationComposer,
          $$BigExpensesTableCreateCompanionBuilder,
          $$BigExpensesTableUpdateCompanionBuilder,
          (
            BigExpenseRow,
            BaseReferences<_$AppDatabase, $BigExpensesTable, BigExpenseRow>,
          ),
          BigExpenseRow,
          PrefetchHooks Function()
        > {
  $$BigExpensesTableTableManager(_$AppDatabase db, $BigExpensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BigExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BigExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BigExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> syncState = const Value.absent(),
                Value<bool> deletedLocal = const Value.absent(),
                Value<DateTime?> updatedAtLocal = const Value.absent(),
                Value<DateTime?> serverUpdatedAt = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> bucketId = const Value.absent(),
                Value<String> addedByUid = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BigExpensesCompanion(
                syncState: syncState,
                deletedLocal: deletedLocal,
                updatedAtLocal: updatedAtLocal,
                serverUpdatedAt: serverUpdatedAt,
                id: id,
                bucketId: bucketId,
                addedByUid: addedByUid,
                title: title,
                amount: amount,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> syncState = const Value.absent(),
                Value<bool> deletedLocal = const Value.absent(),
                Value<DateTime?> updatedAtLocal = const Value.absent(),
                Value<DateTime?> serverUpdatedAt = const Value.absent(),
                required String id,
                required String bucketId,
                Value<String> addedByUid = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BigExpensesCompanion.insert(
                syncState: syncState,
                deletedLocal: deletedLocal,
                updatedAtLocal: updatedAtLocal,
                serverUpdatedAt: serverUpdatedAt,
                id: id,
                bucketId: bucketId,
                addedByUid: addedByUid,
                title: title,
                amount: amount,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BigExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BigExpensesTable,
      BigExpenseRow,
      $$BigExpensesTableFilterComposer,
      $$BigExpensesTableOrderingComposer,
      $$BigExpensesTableAnnotationComposer,
      $$BigExpensesTableCreateCompanionBuilder,
      $$BigExpensesTableUpdateCompanionBuilder,
      (
        BigExpenseRow,
        BaseReferences<_$AppDatabase, $BigExpensesTable, BigExpenseRow>,
      ),
      BigExpenseRow,
      PrefetchHooks Function()
    >;
typedef $$BucketMemberRowsTableCreateCompanionBuilder =
    BucketMemberRowsCompanion Function({
      Value<String> syncState,
      Value<bool> deletedLocal,
      Value<DateTime?> updatedAtLocal,
      Value<DateTime?> serverUpdatedAt,
      required String bucketId,
      required String userId,
      Value<DateTime?> joinedAt,
      Value<String?> name,
      Value<String?> photoUrl,
      Value<String> role,
      Value<int> rowid,
    });
typedef $$BucketMemberRowsTableUpdateCompanionBuilder =
    BucketMemberRowsCompanion Function({
      Value<String> syncState,
      Value<bool> deletedLocal,
      Value<DateTime?> updatedAtLocal,
      Value<DateTime?> serverUpdatedAt,
      Value<String> bucketId,
      Value<String> userId,
      Value<DateTime?> joinedAt,
      Value<String?> name,
      Value<String?> photoUrl,
      Value<String> role,
      Value<int> rowid,
    });

class $$BucketMemberRowsTableFilterComposer
    extends Composer<_$AppDatabase, $BucketMemberRowsTable> {
  $$BucketMemberRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deletedLocal => $composableBuilder(
    column: $table.deletedLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bucketId => $composableBuilder(
    column: $table.bucketId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get joinedAt => $composableBuilder(
    column: $table.joinedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoUrl => $composableBuilder(
    column: $table.photoUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BucketMemberRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $BucketMemberRowsTable> {
  $$BucketMemberRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deletedLocal => $composableBuilder(
    column: $table.deletedLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bucketId => $composableBuilder(
    column: $table.bucketId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get joinedAt => $composableBuilder(
    column: $table.joinedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoUrl => $composableBuilder(
    column: $table.photoUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BucketMemberRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BucketMemberRowsTable> {
  $$BucketMemberRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get syncState =>
      $composableBuilder(column: $table.syncState, builder: (column) => column);

  GeneratedColumn<bool> get deletedLocal => $composableBuilder(
    column: $table.deletedLocal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bucketId =>
      $composableBuilder(column: $table.bucketId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get joinedAt =>
      $composableBuilder(column: $table.joinedAt, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get photoUrl =>
      $composableBuilder(column: $table.photoUrl, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);
}

class $$BucketMemberRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BucketMemberRowsTable,
          BucketMemberRow,
          $$BucketMemberRowsTableFilterComposer,
          $$BucketMemberRowsTableOrderingComposer,
          $$BucketMemberRowsTableAnnotationComposer,
          $$BucketMemberRowsTableCreateCompanionBuilder,
          $$BucketMemberRowsTableUpdateCompanionBuilder,
          (
            BucketMemberRow,
            BaseReferences<
              _$AppDatabase,
              $BucketMemberRowsTable,
              BucketMemberRow
            >,
          ),
          BucketMemberRow,
          PrefetchHooks Function()
        > {
  $$BucketMemberRowsTableTableManager(
    _$AppDatabase db,
    $BucketMemberRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BucketMemberRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BucketMemberRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BucketMemberRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> syncState = const Value.absent(),
                Value<bool> deletedLocal = const Value.absent(),
                Value<DateTime?> updatedAtLocal = const Value.absent(),
                Value<DateTime?> serverUpdatedAt = const Value.absent(),
                Value<String> bucketId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime?> joinedAt = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String?> photoUrl = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BucketMemberRowsCompanion(
                syncState: syncState,
                deletedLocal: deletedLocal,
                updatedAtLocal: updatedAtLocal,
                serverUpdatedAt: serverUpdatedAt,
                bucketId: bucketId,
                userId: userId,
                joinedAt: joinedAt,
                name: name,
                photoUrl: photoUrl,
                role: role,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> syncState = const Value.absent(),
                Value<bool> deletedLocal = const Value.absent(),
                Value<DateTime?> updatedAtLocal = const Value.absent(),
                Value<DateTime?> serverUpdatedAt = const Value.absent(),
                required String bucketId,
                required String userId,
                Value<DateTime?> joinedAt = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String?> photoUrl = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BucketMemberRowsCompanion.insert(
                syncState: syncState,
                deletedLocal: deletedLocal,
                updatedAtLocal: updatedAtLocal,
                serverUpdatedAt: serverUpdatedAt,
                bucketId: bucketId,
                userId: userId,
                joinedAt: joinedAt,
                name: name,
                photoUrl: photoUrl,
                role: role,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BucketMemberRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BucketMemberRowsTable,
      BucketMemberRow,
      $$BucketMemberRowsTableFilterComposer,
      $$BucketMemberRowsTableOrderingComposer,
      $$BucketMemberRowsTableAnnotationComposer,
      $$BucketMemberRowsTableCreateCompanionBuilder,
      $$BucketMemberRowsTableUpdateCompanionBuilder,
      (
        BucketMemberRow,
        BaseReferences<_$AppDatabase, $BucketMemberRowsTable, BucketMemberRow>,
      ),
      BucketMemberRow,
      PrefetchHooks Function()
    >;
typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      Value<String> syncState,
      Value<bool> deletedLocal,
      Value<DateTime?> updatedAtLocal,
      Value<DateTime?> serverUpdatedAt,
      required String id,
      Value<String> name,
      Value<String> iconKey,
      Value<bool> isPreset,
      Value<String?> ownerUid,
      Value<int> rowid,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<String> syncState,
      Value<bool> deletedLocal,
      Value<DateTime?> updatedAtLocal,
      Value<DateTime?> serverUpdatedAt,
      Value<String> id,
      Value<String> name,
      Value<String> iconKey,
      Value<bool> isPreset,
      Value<String?> ownerUid,
      Value<int> rowid,
    });

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deletedLocal => $composableBuilder(
    column: $table.deletedLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPreset => $composableBuilder(
    column: $table.isPreset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerUid => $composableBuilder(
    column: $table.ownerUid,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deletedLocal => $composableBuilder(
    column: $table.deletedLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPreset => $composableBuilder(
    column: $table.isPreset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerUid => $composableBuilder(
    column: $table.ownerUid,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get syncState =>
      $composableBuilder(column: $table.syncState, builder: (column) => column);

  GeneratedColumn<bool> get deletedLocal => $composableBuilder(
    column: $table.deletedLocal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get iconKey =>
      $composableBuilder(column: $table.iconKey, builder: (column) => column);

  GeneratedColumn<bool> get isPreset =>
      $composableBuilder(column: $table.isPreset, builder: (column) => column);

  GeneratedColumn<String> get ownerUid =>
      $composableBuilder(column: $table.ownerUid, builder: (column) => column);
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          CategoryRow,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (
            CategoryRow,
            BaseReferences<_$AppDatabase, $CategoriesTable, CategoryRow>,
          ),
          CategoryRow,
          PrefetchHooks Function()
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> syncState = const Value.absent(),
                Value<bool> deletedLocal = const Value.absent(),
                Value<DateTime?> updatedAtLocal = const Value.absent(),
                Value<DateTime?> serverUpdatedAt = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> iconKey = const Value.absent(),
                Value<bool> isPreset = const Value.absent(),
                Value<String?> ownerUid = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion(
                syncState: syncState,
                deletedLocal: deletedLocal,
                updatedAtLocal: updatedAtLocal,
                serverUpdatedAt: serverUpdatedAt,
                id: id,
                name: name,
                iconKey: iconKey,
                isPreset: isPreset,
                ownerUid: ownerUid,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> syncState = const Value.absent(),
                Value<bool> deletedLocal = const Value.absent(),
                Value<DateTime?> updatedAtLocal = const Value.absent(),
                Value<DateTime?> serverUpdatedAt = const Value.absent(),
                required String id,
                Value<String> name = const Value.absent(),
                Value<String> iconKey = const Value.absent(),
                Value<bool> isPreset = const Value.absent(),
                Value<String?> ownerUid = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion.insert(
                syncState: syncState,
                deletedLocal: deletedLocal,
                updatedAtLocal: updatedAtLocal,
                serverUpdatedAt: serverUpdatedAt,
                id: id,
                name: name,
                iconKey: iconKey,
                isPreset: isPreset,
                ownerUid: ownerUid,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      CategoryRow,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (
        CategoryRow,
        BaseReferences<_$AppDatabase, $CategoriesTable, CategoryRow>,
      ),
      CategoryRow,
      PrefetchHooks Function()
    >;
typedef $$NotificationRowsTableCreateCompanionBuilder =
    NotificationRowsCompanion Function({
      Value<String> syncState,
      Value<bool> deletedLocal,
      Value<DateTime?> updatedAtLocal,
      Value<DateTime?> serverUpdatedAt,
      required String id,
      required String bucketId,
      Value<String> type,
      Value<String> message,
      Value<DateTime?> createdAt,
      Value<String?> actorUid,
      Value<String> readBy,
      Value<int> rowid,
    });
typedef $$NotificationRowsTableUpdateCompanionBuilder =
    NotificationRowsCompanion Function({
      Value<String> syncState,
      Value<bool> deletedLocal,
      Value<DateTime?> updatedAtLocal,
      Value<DateTime?> serverUpdatedAt,
      Value<String> id,
      Value<String> bucketId,
      Value<String> type,
      Value<String> message,
      Value<DateTime?> createdAt,
      Value<String?> actorUid,
      Value<String> readBy,
      Value<int> rowid,
    });

class $$NotificationRowsTableFilterComposer
    extends Composer<_$AppDatabase, $NotificationRowsTable> {
  $$NotificationRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deletedLocal => $composableBuilder(
    column: $table.deletedLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bucketId => $composableBuilder(
    column: $table.bucketId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actorUid => $composableBuilder(
    column: $table.actorUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get readBy => $composableBuilder(
    column: $table.readBy,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotificationRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificationRowsTable> {
  $$NotificationRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deletedLocal => $composableBuilder(
    column: $table.deletedLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bucketId => $composableBuilder(
    column: $table.bucketId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actorUid => $composableBuilder(
    column: $table.actorUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get readBy => $composableBuilder(
    column: $table.readBy,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotificationRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificationRowsTable> {
  $$NotificationRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get syncState =>
      $composableBuilder(column: $table.syncState, builder: (column) => column);

  GeneratedColumn<bool> get deletedLocal => $composableBuilder(
    column: $table.deletedLocal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get bucketId =>
      $composableBuilder(column: $table.bucketId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get actorUid =>
      $composableBuilder(column: $table.actorUid, builder: (column) => column);

  GeneratedColumn<String> get readBy =>
      $composableBuilder(column: $table.readBy, builder: (column) => column);
}

class $$NotificationRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotificationRowsTable,
          NotificationRow,
          $$NotificationRowsTableFilterComposer,
          $$NotificationRowsTableOrderingComposer,
          $$NotificationRowsTableAnnotationComposer,
          $$NotificationRowsTableCreateCompanionBuilder,
          $$NotificationRowsTableUpdateCompanionBuilder,
          (
            NotificationRow,
            BaseReferences<
              _$AppDatabase,
              $NotificationRowsTable,
              NotificationRow
            >,
          ),
          NotificationRow,
          PrefetchHooks Function()
        > {
  $$NotificationRowsTableTableManager(
    _$AppDatabase db,
    $NotificationRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotificationRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotificationRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> syncState = const Value.absent(),
                Value<bool> deletedLocal = const Value.absent(),
                Value<DateTime?> updatedAtLocal = const Value.absent(),
                Value<DateTime?> serverUpdatedAt = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> bucketId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> message = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<String?> actorUid = const Value.absent(),
                Value<String> readBy = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotificationRowsCompanion(
                syncState: syncState,
                deletedLocal: deletedLocal,
                updatedAtLocal: updatedAtLocal,
                serverUpdatedAt: serverUpdatedAt,
                id: id,
                bucketId: bucketId,
                type: type,
                message: message,
                createdAt: createdAt,
                actorUid: actorUid,
                readBy: readBy,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> syncState = const Value.absent(),
                Value<bool> deletedLocal = const Value.absent(),
                Value<DateTime?> updatedAtLocal = const Value.absent(),
                Value<DateTime?> serverUpdatedAt = const Value.absent(),
                required String id,
                required String bucketId,
                Value<String> type = const Value.absent(),
                Value<String> message = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<String?> actorUid = const Value.absent(),
                Value<String> readBy = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotificationRowsCompanion.insert(
                syncState: syncState,
                deletedLocal: deletedLocal,
                updatedAtLocal: updatedAtLocal,
                serverUpdatedAt: serverUpdatedAt,
                id: id,
                bucketId: bucketId,
                type: type,
                message: message,
                createdAt: createdAt,
                actorUid: actorUid,
                readBy: readBy,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotificationRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotificationRowsTable,
      NotificationRow,
      $$NotificationRowsTableFilterComposer,
      $$NotificationRowsTableOrderingComposer,
      $$NotificationRowsTableAnnotationComposer,
      $$NotificationRowsTableCreateCompanionBuilder,
      $$NotificationRowsTableUpdateCompanionBuilder,
      (
        NotificationRow,
        BaseReferences<_$AppDatabase, $NotificationRowsTable, NotificationRow>,
      ),
      NotificationRow,
      PrefetchHooks Function()
    >;
typedef $$JoinRequestRowsTableCreateCompanionBuilder =
    JoinRequestRowsCompanion Function({
      Value<String> syncState,
      Value<bool> deletedLocal,
      Value<DateTime?> updatedAtLocal,
      Value<DateTime?> serverUpdatedAt,
      required String id,
      required String bucketId,
      Value<String> bucketName,
      required String requesterUid,
      Value<String?> requesterName,
      Value<String?> requesterPhoto,
      Value<String> status,
      Value<DateTime?> createdAt,
      Value<DateTime?> decidedAt,
      Value<int> rowid,
    });
typedef $$JoinRequestRowsTableUpdateCompanionBuilder =
    JoinRequestRowsCompanion Function({
      Value<String> syncState,
      Value<bool> deletedLocal,
      Value<DateTime?> updatedAtLocal,
      Value<DateTime?> serverUpdatedAt,
      Value<String> id,
      Value<String> bucketId,
      Value<String> bucketName,
      Value<String> requesterUid,
      Value<String?> requesterName,
      Value<String?> requesterPhoto,
      Value<String> status,
      Value<DateTime?> createdAt,
      Value<DateTime?> decidedAt,
      Value<int> rowid,
    });

class $$JoinRequestRowsTableFilterComposer
    extends Composer<_$AppDatabase, $JoinRequestRowsTable> {
  $$JoinRequestRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deletedLocal => $composableBuilder(
    column: $table.deletedLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bucketId => $composableBuilder(
    column: $table.bucketId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bucketName => $composableBuilder(
    column: $table.bucketName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get requesterUid => $composableBuilder(
    column: $table.requesterUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get requesterName => $composableBuilder(
    column: $table.requesterName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get requesterPhoto => $composableBuilder(
    column: $table.requesterPhoto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get decidedAt => $composableBuilder(
    column: $table.decidedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$JoinRequestRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $JoinRequestRowsTable> {
  $$JoinRequestRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deletedLocal => $composableBuilder(
    column: $table.deletedLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bucketId => $composableBuilder(
    column: $table.bucketId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bucketName => $composableBuilder(
    column: $table.bucketName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get requesterUid => $composableBuilder(
    column: $table.requesterUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get requesterName => $composableBuilder(
    column: $table.requesterName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get requesterPhoto => $composableBuilder(
    column: $table.requesterPhoto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get decidedAt => $composableBuilder(
    column: $table.decidedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$JoinRequestRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $JoinRequestRowsTable> {
  $$JoinRequestRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get syncState =>
      $composableBuilder(column: $table.syncState, builder: (column) => column);

  GeneratedColumn<bool> get deletedLocal => $composableBuilder(
    column: $table.deletedLocal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get bucketId =>
      $composableBuilder(column: $table.bucketId, builder: (column) => column);

  GeneratedColumn<String> get bucketName => $composableBuilder(
    column: $table.bucketName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get requesterUid => $composableBuilder(
    column: $table.requesterUid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get requesterName => $composableBuilder(
    column: $table.requesterName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get requesterPhoto => $composableBuilder(
    column: $table.requesterPhoto,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get decidedAt =>
      $composableBuilder(column: $table.decidedAt, builder: (column) => column);
}

class $$JoinRequestRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $JoinRequestRowsTable,
          JoinRequestRow,
          $$JoinRequestRowsTableFilterComposer,
          $$JoinRequestRowsTableOrderingComposer,
          $$JoinRequestRowsTableAnnotationComposer,
          $$JoinRequestRowsTableCreateCompanionBuilder,
          $$JoinRequestRowsTableUpdateCompanionBuilder,
          (
            JoinRequestRow,
            BaseReferences<
              _$AppDatabase,
              $JoinRequestRowsTable,
              JoinRequestRow
            >,
          ),
          JoinRequestRow,
          PrefetchHooks Function()
        > {
  $$JoinRequestRowsTableTableManager(
    _$AppDatabase db,
    $JoinRequestRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JoinRequestRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JoinRequestRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JoinRequestRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> syncState = const Value.absent(),
                Value<bool> deletedLocal = const Value.absent(),
                Value<DateTime?> updatedAtLocal = const Value.absent(),
                Value<DateTime?> serverUpdatedAt = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> bucketId = const Value.absent(),
                Value<String> bucketName = const Value.absent(),
                Value<String> requesterUid = const Value.absent(),
                Value<String?> requesterName = const Value.absent(),
                Value<String?> requesterPhoto = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> decidedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => JoinRequestRowsCompanion(
                syncState: syncState,
                deletedLocal: deletedLocal,
                updatedAtLocal: updatedAtLocal,
                serverUpdatedAt: serverUpdatedAt,
                id: id,
                bucketId: bucketId,
                bucketName: bucketName,
                requesterUid: requesterUid,
                requesterName: requesterName,
                requesterPhoto: requesterPhoto,
                status: status,
                createdAt: createdAt,
                decidedAt: decidedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> syncState = const Value.absent(),
                Value<bool> deletedLocal = const Value.absent(),
                Value<DateTime?> updatedAtLocal = const Value.absent(),
                Value<DateTime?> serverUpdatedAt = const Value.absent(),
                required String id,
                required String bucketId,
                Value<String> bucketName = const Value.absent(),
                required String requesterUid,
                Value<String?> requesterName = const Value.absent(),
                Value<String?> requesterPhoto = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> decidedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => JoinRequestRowsCompanion.insert(
                syncState: syncState,
                deletedLocal: deletedLocal,
                updatedAtLocal: updatedAtLocal,
                serverUpdatedAt: serverUpdatedAt,
                id: id,
                bucketId: bucketId,
                bucketName: bucketName,
                requesterUid: requesterUid,
                requesterName: requesterName,
                requesterPhoto: requesterPhoto,
                status: status,
                createdAt: createdAt,
                decidedAt: decidedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$JoinRequestRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $JoinRequestRowsTable,
      JoinRequestRow,
      $$JoinRequestRowsTableFilterComposer,
      $$JoinRequestRowsTableOrderingComposer,
      $$JoinRequestRowsTableAnnotationComposer,
      $$JoinRequestRowsTableCreateCompanionBuilder,
      $$JoinRequestRowsTableUpdateCompanionBuilder,
      (
        JoinRequestRow,
        BaseReferences<_$AppDatabase, $JoinRequestRowsTable, JoinRequestRow>,
      ),
      JoinRequestRow,
      PrefetchHooks Function()
    >;
typedef $$UserNotificationRowsTableCreateCompanionBuilder =
    UserNotificationRowsCompanion Function({
      Value<String> syncState,
      Value<bool> deletedLocal,
      Value<DateTime?> updatedAtLocal,
      Value<DateTime?> serverUpdatedAt,
      required String id,
      required String recipientUid,
      Value<String> eventId,
      Value<String> type,
      Value<String> category,
      Value<String?> bucketId,
      Value<String> bucketName,
      Value<String?> actorUid,
      Value<String> title,
      Value<String> body,
      Value<String> metadata,
      Value<String?> correlationId,
      Value<DateTime?> createdAt,
      Value<DateTime?> readAt,
      Value<DateTime?> archivedAt,
      Value<int> rowid,
    });
typedef $$UserNotificationRowsTableUpdateCompanionBuilder =
    UserNotificationRowsCompanion Function({
      Value<String> syncState,
      Value<bool> deletedLocal,
      Value<DateTime?> updatedAtLocal,
      Value<DateTime?> serverUpdatedAt,
      Value<String> id,
      Value<String> recipientUid,
      Value<String> eventId,
      Value<String> type,
      Value<String> category,
      Value<String?> bucketId,
      Value<String> bucketName,
      Value<String?> actorUid,
      Value<String> title,
      Value<String> body,
      Value<String> metadata,
      Value<String?> correlationId,
      Value<DateTime?> createdAt,
      Value<DateTime?> readAt,
      Value<DateTime?> archivedAt,
      Value<int> rowid,
    });

class $$UserNotificationRowsTableFilterComposer
    extends Composer<_$AppDatabase, $UserNotificationRowsTable> {
  $$UserNotificationRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deletedLocal => $composableBuilder(
    column: $table.deletedLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recipientUid => $composableBuilder(
    column: $table.recipientUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bucketId => $composableBuilder(
    column: $table.bucketId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bucketName => $composableBuilder(
    column: $table.bucketName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actorUid => $composableBuilder(
    column: $table.actorUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get correlationId => $composableBuilder(
    column: $table.correlationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get readAt => $composableBuilder(
    column: $table.readAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserNotificationRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserNotificationRowsTable> {
  $$UserNotificationRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deletedLocal => $composableBuilder(
    column: $table.deletedLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recipientUid => $composableBuilder(
    column: $table.recipientUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bucketId => $composableBuilder(
    column: $table.bucketId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bucketName => $composableBuilder(
    column: $table.bucketName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actorUid => $composableBuilder(
    column: $table.actorUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get correlationId => $composableBuilder(
    column: $table.correlationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get readAt => $composableBuilder(
    column: $table.readAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserNotificationRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserNotificationRowsTable> {
  $$UserNotificationRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get syncState =>
      $composableBuilder(column: $table.syncState, builder: (column) => column);

  GeneratedColumn<bool> get deletedLocal => $composableBuilder(
    column: $table.deletedLocal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get recipientUid => $composableBuilder(
    column: $table.recipientUid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get eventId =>
      $composableBuilder(column: $table.eventId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get bucketId =>
      $composableBuilder(column: $table.bucketId, builder: (column) => column);

  GeneratedColumn<String> get bucketName => $composableBuilder(
    column: $table.bucketName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get actorUid =>
      $composableBuilder(column: $table.actorUid, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  GeneratedColumn<String> get correlationId => $composableBuilder(
    column: $table.correlationId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get readAt =>
      $composableBuilder(column: $table.readAt, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );
}

class $$UserNotificationRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserNotificationRowsTable,
          UserNotificationRow,
          $$UserNotificationRowsTableFilterComposer,
          $$UserNotificationRowsTableOrderingComposer,
          $$UserNotificationRowsTableAnnotationComposer,
          $$UserNotificationRowsTableCreateCompanionBuilder,
          $$UserNotificationRowsTableUpdateCompanionBuilder,
          (
            UserNotificationRow,
            BaseReferences<
              _$AppDatabase,
              $UserNotificationRowsTable,
              UserNotificationRow
            >,
          ),
          UserNotificationRow,
          PrefetchHooks Function()
        > {
  $$UserNotificationRowsTableTableManager(
    _$AppDatabase db,
    $UserNotificationRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserNotificationRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserNotificationRowsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$UserNotificationRowsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> syncState = const Value.absent(),
                Value<bool> deletedLocal = const Value.absent(),
                Value<DateTime?> updatedAtLocal = const Value.absent(),
                Value<DateTime?> serverUpdatedAt = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> recipientUid = const Value.absent(),
                Value<String> eventId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String?> bucketId = const Value.absent(),
                Value<String> bucketName = const Value.absent(),
                Value<String?> actorUid = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String> metadata = const Value.absent(),
                Value<String?> correlationId = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> readAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserNotificationRowsCompanion(
                syncState: syncState,
                deletedLocal: deletedLocal,
                updatedAtLocal: updatedAtLocal,
                serverUpdatedAt: serverUpdatedAt,
                id: id,
                recipientUid: recipientUid,
                eventId: eventId,
                type: type,
                category: category,
                bucketId: bucketId,
                bucketName: bucketName,
                actorUid: actorUid,
                title: title,
                body: body,
                metadata: metadata,
                correlationId: correlationId,
                createdAt: createdAt,
                readAt: readAt,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> syncState = const Value.absent(),
                Value<bool> deletedLocal = const Value.absent(),
                Value<DateTime?> updatedAtLocal = const Value.absent(),
                Value<DateTime?> serverUpdatedAt = const Value.absent(),
                required String id,
                required String recipientUid,
                Value<String> eventId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String?> bucketId = const Value.absent(),
                Value<String> bucketName = const Value.absent(),
                Value<String?> actorUid = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String> metadata = const Value.absent(),
                Value<String?> correlationId = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> readAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserNotificationRowsCompanion.insert(
                syncState: syncState,
                deletedLocal: deletedLocal,
                updatedAtLocal: updatedAtLocal,
                serverUpdatedAt: serverUpdatedAt,
                id: id,
                recipientUid: recipientUid,
                eventId: eventId,
                type: type,
                category: category,
                bucketId: bucketId,
                bucketName: bucketName,
                actorUid: actorUid,
                title: title,
                body: body,
                metadata: metadata,
                correlationId: correlationId,
                createdAt: createdAt,
                readAt: readAt,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserNotificationRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserNotificationRowsTable,
      UserNotificationRow,
      $$UserNotificationRowsTableFilterComposer,
      $$UserNotificationRowsTableOrderingComposer,
      $$UserNotificationRowsTableAnnotationComposer,
      $$UserNotificationRowsTableCreateCompanionBuilder,
      $$UserNotificationRowsTableUpdateCompanionBuilder,
      (
        UserNotificationRow,
        BaseReferences<
          _$AppDatabase,
          $UserNotificationRowsTable,
          UserNotificationRow
        >,
      ),
      UserNotificationRow,
      PrefetchHooks Function()
    >;
typedef $$BucketActivityRowsTableCreateCompanionBuilder =
    BucketActivityRowsCompanion Function({
      Value<String> syncState,
      Value<bool> deletedLocal,
      Value<DateTime?> updatedAtLocal,
      Value<DateTime?> serverUpdatedAt,
      required String id,
      required String bucketId,
      Value<String?> actorUid,
      Value<String> type,
      Value<String> category,
      Value<String> summary,
      Value<String> metadata,
      Value<String?> correlationId,
      Value<DateTime?> createdAt,
      Value<int> rowid,
    });
typedef $$BucketActivityRowsTableUpdateCompanionBuilder =
    BucketActivityRowsCompanion Function({
      Value<String> syncState,
      Value<bool> deletedLocal,
      Value<DateTime?> updatedAtLocal,
      Value<DateTime?> serverUpdatedAt,
      Value<String> id,
      Value<String> bucketId,
      Value<String?> actorUid,
      Value<String> type,
      Value<String> category,
      Value<String> summary,
      Value<String> metadata,
      Value<String?> correlationId,
      Value<DateTime?> createdAt,
      Value<int> rowid,
    });

class $$BucketActivityRowsTableFilterComposer
    extends Composer<_$AppDatabase, $BucketActivityRowsTable> {
  $$BucketActivityRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deletedLocal => $composableBuilder(
    column: $table.deletedLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bucketId => $composableBuilder(
    column: $table.bucketId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actorUid => $composableBuilder(
    column: $table.actorUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get correlationId => $composableBuilder(
    column: $table.correlationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BucketActivityRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $BucketActivityRowsTable> {
  $$BucketActivityRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deletedLocal => $composableBuilder(
    column: $table.deletedLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bucketId => $composableBuilder(
    column: $table.bucketId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actorUid => $composableBuilder(
    column: $table.actorUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get correlationId => $composableBuilder(
    column: $table.correlationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BucketActivityRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BucketActivityRowsTable> {
  $$BucketActivityRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get syncState =>
      $composableBuilder(column: $table.syncState, builder: (column) => column);

  GeneratedColumn<bool> get deletedLocal => $composableBuilder(
    column: $table.deletedLocal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get bucketId =>
      $composableBuilder(column: $table.bucketId, builder: (column) => column);

  GeneratedColumn<String> get actorUid =>
      $composableBuilder(column: $table.actorUid, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  GeneratedColumn<String> get correlationId => $composableBuilder(
    column: $table.correlationId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BucketActivityRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BucketActivityRowsTable,
          BucketActivityRow,
          $$BucketActivityRowsTableFilterComposer,
          $$BucketActivityRowsTableOrderingComposer,
          $$BucketActivityRowsTableAnnotationComposer,
          $$BucketActivityRowsTableCreateCompanionBuilder,
          $$BucketActivityRowsTableUpdateCompanionBuilder,
          (
            BucketActivityRow,
            BaseReferences<
              _$AppDatabase,
              $BucketActivityRowsTable,
              BucketActivityRow
            >,
          ),
          BucketActivityRow,
          PrefetchHooks Function()
        > {
  $$BucketActivityRowsTableTableManager(
    _$AppDatabase db,
    $BucketActivityRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BucketActivityRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BucketActivityRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BucketActivityRowsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> syncState = const Value.absent(),
                Value<bool> deletedLocal = const Value.absent(),
                Value<DateTime?> updatedAtLocal = const Value.absent(),
                Value<DateTime?> serverUpdatedAt = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> bucketId = const Value.absent(),
                Value<String?> actorUid = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> summary = const Value.absent(),
                Value<String> metadata = const Value.absent(),
                Value<String?> correlationId = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BucketActivityRowsCompanion(
                syncState: syncState,
                deletedLocal: deletedLocal,
                updatedAtLocal: updatedAtLocal,
                serverUpdatedAt: serverUpdatedAt,
                id: id,
                bucketId: bucketId,
                actorUid: actorUid,
                type: type,
                category: category,
                summary: summary,
                metadata: metadata,
                correlationId: correlationId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> syncState = const Value.absent(),
                Value<bool> deletedLocal = const Value.absent(),
                Value<DateTime?> updatedAtLocal = const Value.absent(),
                Value<DateTime?> serverUpdatedAt = const Value.absent(),
                required String id,
                required String bucketId,
                Value<String?> actorUid = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> summary = const Value.absent(),
                Value<String> metadata = const Value.absent(),
                Value<String?> correlationId = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BucketActivityRowsCompanion.insert(
                syncState: syncState,
                deletedLocal: deletedLocal,
                updatedAtLocal: updatedAtLocal,
                serverUpdatedAt: serverUpdatedAt,
                id: id,
                bucketId: bucketId,
                actorUid: actorUid,
                type: type,
                category: category,
                summary: summary,
                metadata: metadata,
                correlationId: correlationId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BucketActivityRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BucketActivityRowsTable,
      BucketActivityRow,
      $$BucketActivityRowsTableFilterComposer,
      $$BucketActivityRowsTableOrderingComposer,
      $$BucketActivityRowsTableAnnotationComposer,
      $$BucketActivityRowsTableCreateCompanionBuilder,
      $$BucketActivityRowsTableUpdateCompanionBuilder,
      (
        BucketActivityRow,
        BaseReferences<
          _$AppDatabase,
          $BucketActivityRowsTable,
          BucketActivityRow
        >,
      ),
      BucketActivityRow,
      PrefetchHooks Function()
    >;
typedef $$OutboxTableCreateCompanionBuilder =
    OutboxCompanion Function({
      required String id,
      required String entity,
      required String entityId,
      required String op,
      Value<String> payload,
      Value<int?> baseVersion,
      Value<String?> actor,
      required DateTime createdAt,
      Value<String> syncState,
      Value<int> attemptCount,
      Value<String?> lastError,
      Value<int> priority,
      Value<int> rowid,
    });
typedef $$OutboxTableUpdateCompanionBuilder =
    OutboxCompanion Function({
      Value<String> id,
      Value<String> entity,
      Value<String> entityId,
      Value<String> op,
      Value<String> payload,
      Value<int?> baseVersion,
      Value<String?> actor,
      Value<DateTime> createdAt,
      Value<String> syncState,
      Value<int> attemptCount,
      Value<String?> lastError,
      Value<int> priority,
      Value<int> rowid,
    });

class $$OutboxTableFilterComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get baseVersion => $composableBuilder(
    column: $table.baseVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actor => $composableBuilder(
    column: $table.actor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OutboxTableOrderingComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get baseVersion => $composableBuilder(
    column: $table.baseVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actor => $composableBuilder(
    column: $table.actor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OutboxTableAnnotationComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entity =>
      $composableBuilder(column: $table.entity, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get op =>
      $composableBuilder(column: $table.op, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<int> get baseVersion => $composableBuilder(
    column: $table.baseVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get actor =>
      $composableBuilder(column: $table.actor, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get syncState =>
      $composableBuilder(column: $table.syncState, builder: (column) => column);

  GeneratedColumn<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);
}

class $$OutboxTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OutboxTable,
          OutboxData,
          $$OutboxTableFilterComposer,
          $$OutboxTableOrderingComposer,
          $$OutboxTableAnnotationComposer,
          $$OutboxTableCreateCompanionBuilder,
          $$OutboxTableUpdateCompanionBuilder,
          (OutboxData, BaseReferences<_$AppDatabase, $OutboxTable, OutboxData>),
          OutboxData,
          PrefetchHooks Function()
        > {
  $$OutboxTableTableManager(_$AppDatabase db, $OutboxTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutboxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutboxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutboxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> entity = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> op = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<int?> baseVersion = const Value.absent(),
                Value<String?> actor = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> syncState = const Value.absent(),
                Value<int> attemptCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OutboxCompanion(
                id: id,
                entity: entity,
                entityId: entityId,
                op: op,
                payload: payload,
                baseVersion: baseVersion,
                actor: actor,
                createdAt: createdAt,
                syncState: syncState,
                attemptCount: attemptCount,
                lastError: lastError,
                priority: priority,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String entity,
                required String entityId,
                required String op,
                Value<String> payload = const Value.absent(),
                Value<int?> baseVersion = const Value.absent(),
                Value<String?> actor = const Value.absent(),
                required DateTime createdAt,
                Value<String> syncState = const Value.absent(),
                Value<int> attemptCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OutboxCompanion.insert(
                id: id,
                entity: entity,
                entityId: entityId,
                op: op,
                payload: payload,
                baseVersion: baseVersion,
                actor: actor,
                createdAt: createdAt,
                syncState: syncState,
                attemptCount: attemptCount,
                lastError: lastError,
                priority: priority,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OutboxTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OutboxTable,
      OutboxData,
      $$OutboxTableFilterComposer,
      $$OutboxTableOrderingComposer,
      $$OutboxTableAnnotationComposer,
      $$OutboxTableCreateCompanionBuilder,
      $$OutboxTableUpdateCompanionBuilder,
      (OutboxData, BaseReferences<_$AppDatabase, $OutboxTable, OutboxData>),
      OutboxData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BucketsTableTableManager get buckets =>
      $$BucketsTableTableManager(_db, _db.buckets);
  $$WeeklyBucketRowsTableTableManager get weeklyBucketRows =>
      $$WeeklyBucketRowsTableTableManager(_db, _db.weeklyBucketRows);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
  $$BigExpensesTableTableManager get bigExpenses =>
      $$BigExpensesTableTableManager(_db, _db.bigExpenses);
  $$BucketMemberRowsTableTableManager get bucketMemberRows =>
      $$BucketMemberRowsTableTableManager(_db, _db.bucketMemberRows);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$NotificationRowsTableTableManager get notificationRows =>
      $$NotificationRowsTableTableManager(_db, _db.notificationRows);
  $$JoinRequestRowsTableTableManager get joinRequestRows =>
      $$JoinRequestRowsTableTableManager(_db, _db.joinRequestRows);
  $$UserNotificationRowsTableTableManager get userNotificationRows =>
      $$UserNotificationRowsTableTableManager(_db, _db.userNotificationRows);
  $$BucketActivityRowsTableTableManager get bucketActivityRows =>
      $$BucketActivityRowsTableTableManager(_db, _db.bucketActivityRows);
  $$OutboxTableTableManager get outbox =>
      $$OutboxTableTableManager(_db, _db.outbox);
}
