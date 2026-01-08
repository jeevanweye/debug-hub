// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sheet_version_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SheetVersionInfoImpl _$$SheetVersionInfoImplFromJson(
  Map<String, dynamic> json,
) => _$SheetVersionInfoImpl(
  index: (json['index'] as num?)?.toInt(),
  title: json['title'] as String?,
  sheetId: (json['sheetId'] as num?)?.toInt(),
);

Map<String, dynamic> _$$SheetVersionInfoImplToJson(
  _$SheetVersionInfoImpl instance,
) => <String, dynamic>{
  'index': instance.index,
  'title': instance.title,
  'sheetId': instance.sheetId,
};
