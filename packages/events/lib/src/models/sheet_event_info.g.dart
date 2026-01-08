// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sheet_event_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SheetEventInfoImpl _$$SheetEventInfoImplFromJson(Map<String, dynamic> json) =>
    _$SheetEventInfoImpl(
      serialNumber: json['sn'] as String?,
      eventName: json['event_name'] as String?,
      eventAction: json['event_action'] as String?,
      eventCategory: json['event_category'] as String?,
      screenName: json['screen_name'] as String?,
      vehicleId: json['vehicle_id'] as String?,
      entity: json['entity'] as String?,
      miscellaneous: json['miscellaneous'] as String?,
      targetProduct: json['target_product'] as String?,
    );

Map<String, dynamic> _$$SheetEventInfoImplToJson(
  _$SheetEventInfoImpl instance,
) => <String, dynamic>{
  'sn': instance.serialNumber,
  'event_name': instance.eventName,
  'event_action': instance.eventAction,
  'event_category': instance.eventCategory,
  'screen_name': instance.screenName,
  'vehicle_id': instance.vehicleId,
  'entity': instance.entity,
  'miscellaneous': instance.miscellaneous,
  'target_product': instance.targetProduct,
};
