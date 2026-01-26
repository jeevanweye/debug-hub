import 'package:flutter_test/flutter_test.dart';
import 'package:base/base.dart';

void main() {
  test('DebugLog creation', () {
    final log = DebugLog.create(
      level: AppLogLevel.info,
      message: 'Test message',
      tag: 'Test',
    );
    
    expect(log.message, 'Test message');
    expect(log.level, AppLogLevel.info);
    expect(log.tag, 'Test');
  });

  test('NetworkRequest creation', () {
    final request = NetworkRequest(
      id: 'test-id',
      timestamp: DateTime.now(),
      url: 'https://api.example.com/test',
      method: RequestMethod.get,
    );
    
    expect(request.url, 'https://api.example.com/test');
    expect(request.method, RequestMethod.get);
    expect(request.isPending, true);
  });

  test('DebugStorage adds and retrieves logs', () {
    final storage = DebugStorage();
    storage.clearLogs();
    
    final log = DebugLog.create(
      level: AppLogLevel.info,
      message: 'Test',
    );
    
    storage.addLog(log);
    
    expect(storage.getLogs().length, 1);
    expect(storage.getLogs().first.message, 'Test');
  });
}
