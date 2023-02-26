import Cocoa
import FlutterMacOS

public class AccessingSecurityScopedResourcePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "accessing_security_scoped_resource", binaryMessenger: registrar.messenger)
    let instance = AccessingSecurityScopedResourcePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? Dictionary<String, Any> else {
      DispatchQueue.main.async {
        result(FlutterError(code: "InvalidArgsType", message: "Invalid args type", details: nil))
      }
      return
    }
    switch call.method {
    case "startAccessingSecurityScopedResourceWithFilePath":
      // Arguments are enforced on dart side.
      let filePath = args["filePath"] as! String
      
      let fileURL = URL(fileURLWithPath: filePath)
      let hasAccess = fileURL.startAccessingSecurityScopedResource()
      result(hasAccess)
      
    case "startAccessingSecurityScopedResourceWithURL":
      guard let url = URL(string: args["url"] as! String) else {
        DispatchQueue.main.async {
          result(FlutterError(code: "ArgError", message: "Invalid arguments", details: nil))
        }
        return
      }
      let hasAccess = url.startAccessingSecurityScopedResource()
      result(hasAccess)
      
    case "stopAccessingSecurityScopedResourceWithFilePath":
      // Arguments are enforced on dart side.
      let filePath = args["filePath"] as! String
      
      let fileURL = URL(fileURLWithPath: filePath)
      fileURL.stopAccessingSecurityScopedResource()
      result(nil)
      
    case "stopAccessingSecurityScopedResourceWithURL":
      guard let url = URL(string: args["url"] as! String) else {
        DispatchQueue.main.async {
          result(FlutterError(code: "ArgError", message: "Invalid arguments", details: nil))
        }
        return
      }
      url.stopAccessingSecurityScopedResource()
      result(nil)
      
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
