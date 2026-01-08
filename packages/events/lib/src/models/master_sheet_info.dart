import 'package:freezed_annotation/freezed_annotation.dart';

part 'master_sheet_info.freezed.dart';
part 'master_sheet_info.g.dart';

/// Model for master sheet configuration
/// Contains information about which sheet to use for which app
@freezed
class MasterSheetInfo with _$MasterSheetInfo {
  const factory MasterSheetInfo({
    @JsonKey(name: 's_n') String? serialNumber,
    @JsonKey(name: 'package_name') String? packageName,
    @JsonKey(name: 'sheet_id') String? sheetId,
    @JsonKey(name: 'range') String? range,
    @JsonKey(name: 'field') String? field,
  }) = _MasterSheetInfo;

  factory MasterSheetInfo.fromJson(Map<String, dynamic> json) =>
      _$MasterSheetInfoFromJson(json);

  factory MasterSheetInfo.fromSheetRow(List<dynamic> row) {
    return MasterSheetInfo(
      serialNumber: _safeStringIndex(row, 0),
      packageName: _safeStringIndex(row, 1),
      sheetId: _safeStringIndex(row, 2),
      range: _safeStringIndex(row, 3),
      field: _safeStringIndex(row, 4),
    );
  }

  static String? _safeStringIndex(List<dynamic> list, int index) {
    if (index < list.length) {
      final value = list[index];
      return value?.toString();
    }
    return null;
  }
}

