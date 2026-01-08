import 'package:freezed_annotation/freezed_annotation.dart';

part 'sheet_version_info.freezed.dart';
part 'sheet_version_info.g.dart';

/// Model for sheet version/tab information
@freezed
class SheetVersionInfo with _$SheetVersionInfo {
  const factory SheetVersionInfo({
    int? index,
    String? title,
    int? sheetId,
  }) = _SheetVersionInfo;

  factory SheetVersionInfo.fromJson(Map<String, dynamic> json) =>
      _$SheetVersionInfoFromJson(json);
}

