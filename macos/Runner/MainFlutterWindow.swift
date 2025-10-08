import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    let channel = FlutterMethodChannel(name: "com.cleandev.app/file_operations", binaryMessenger: flutterViewController.engine.binaryMessenger)
    channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "moveToTrash" {
        if let args = call.arguments as? [String: Any],
           let filePath = args["filePath"] as? String {
          let fileURL = URL(fileURLWithPath: filePath)
          do {
            try FileManager.default.trashItem(at: fileURL, resultingItemURL: nil)
            result(true)
          } catch {
            result(FlutterError(code: "TRASH_ERROR", message: error.localizedDescription, details: nil))
          }
        } else {
          result(FlutterError(code: "INVALID_ARGUMENTS", message: "filePath not provided or invalid", details: nil))
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
