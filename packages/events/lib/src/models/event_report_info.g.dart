// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_report_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventReportInfoImpl _$$EventReportInfoImplFromJson(
  Map<String, dynamic> json,
) => _$EventReportInfoImpl(
  sheetEvent: json['sheetEvent'] == null
      ? null
      : SheetEventInfo.fromJson(json['sheetEvent'] as Map<String, dynamic>),
  devEvent: json['devEvent'] == null
      ? null
      : SheetEventInfo.fromJson(json['devEvent'] as Map<String, dynamic>),
  isFound: json['isFound'] as bool? ?? false,
  isCorrect: json['isCorrect'] as bool? ?? false,
);

Map<String, dynamic> _$$EventReportInfoImplToJson(
  _$EventReportInfoImpl instance,
) => <String, dynamic>{
  'sheetEvent': instance.sheetEvent,
  'devEvent': instance.devEvent,
  'isFound': instance.isFound,
  'isCorrect': instance.isCorrect,
};
