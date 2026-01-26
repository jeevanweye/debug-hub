// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'master_sheet_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MasterSheetInfoImpl _$$MasterSheetInfoImplFromJson(
  Map<String, dynamic> json,
) => _$MasterSheetInfoImpl(
  serialNumber: json['s_n'] as String?,
  packageName: json['package_name'] as String?,
  sheetId: json['sheet_id'] as String?,
  range: json['range'] as String?,
  field: json['field'] as String?,
);

Map<String, dynamic> _$$MasterSheetInfoImplToJson(
  _$MasterSheetInfoImpl instance,
) => <String, dynamic>{
  's_n': instance.serialNumber,
  'package_name': instance.packageName,
  'sheet_id': instance.sheetId,
  'range': instance.range,
  'field': instance.field,
};
