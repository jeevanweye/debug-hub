import Flutter
import UIKit
import Darwin

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let deviceMemoryChannel = FlutterMethodChannel(name: "com.debughub.memory_monitor/device_memory",
                                                   binaryMessenger: controller.binaryMessenger)
    
    deviceMemoryChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "getDeviceMemory" {
        self.getDeviceMemory(result: result)
      } else {
        result(FlutterMethodNotImplemented)
      }
    })
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func getDeviceMemory(result: FlutterResult) {
    var info = mach_task_basic_info()
    var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
    
    let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
      $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
        task_info(mach_task_self_,
                  task_flavor_t(MACH_TASK_BASIC_INFO),
                  $0,
                  &count)
      }
    }
    
    if kerr == KERN_SUCCESS {
      // Get physical memory (total device RAM)
      let physicalMemory = ProcessInfo.processInfo.physicalMemory
      let totalRAMMB = physicalMemory / (1024 * 1024)
      
      // Get used memory (resident set size)
      let usedRAMMB = info.resident_size / (1024 * 1024)
      
      // Calculate available RAM (approximate)
      let availableRAMMB = totalRAMMB - usedRAMMB
      
      // Usage percentage
      let usagePercentage = totalRAMMB > 0 ? (Double(usedRAMMB) / Double(totalRAMMB)) * 100.0 : 0.0
      
      result([
        "totalRAMMB": totalRAMMB,
        "availableRAMMB": availableRAMMB,
        "usedRAMMB": usedRAMMB,
        "usagePercentage": usagePercentage
      ])
    } else {
      result(FlutterError(code: "ERROR", message: "Failed to get device memory", details: nil))
    }
  }
}
