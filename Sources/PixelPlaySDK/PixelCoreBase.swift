
import Foundation
import UIKit
import AppsFlyerLib
import Alamofire
import SwiftUI
import Combine
import WebKit

public class PixelPlaySDK: NSObject {
    
    @AppStorage("initialStart") var pixelInitial: String?
    @AppStorage("statusFlag")   var pixelFlag:    Bool = false
    @AppStorage("finalData")    var pixelFinal:   String?
    
     var sessionBegan       = false
     var pushTokenHex       = ""
     var pixelSession:      Session
     var combineDisposable  = Set<AnyCancellable>()
    
     var appsParameter: String = ""
     var idParameter:   String = ""
     var langParameter: String = ""
     var tokenParameter:String = ""
    
     var lockReference: String = ""
     var paramRefKey:   String = ""
    
     var mainScene:     UIWindow?
    
    public static let shared = PixelPlaySDK()
    
    private override init() {
        let cfg = URLSessionConfiguration.default
        cfg.timeoutIntervalForRequest  = 20
        cfg.timeoutIntervalForResource = 20
        self.pixelSession = Alamofire.Session(configuration: cfg)
        super.init()
    }
    
    public func pixelComputeMidRange(_ numbers: [Int]) -> Double {
        guard !numbers.isEmpty else {
            print("pixelComputeMidRange -> empty array.")
            return 0.0
        }
        let minVal = numbers.min() ?? 0
        let maxVal = numbers.max() ?? 0
        let mid    = Double(minVal + maxVal) / 2.0
        print("pixelComputeMidRange -> \(numbers) => mid: \(mid)")
        return mid
    }
    
    public func pixelGenerateSessionLabel() -> String {
        let code = Int.random(in: 1000...9999)
        let label = "PXsession-\(code)"
        print("pixelGenerateSessionLabel -> \(label)")
        return label
    }
    
    public func StartSDK(
        application: UIApplication,
        window: UIWindow,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        self.appsParameter  = "chocData"
        self.idParameter    = "chocId"
        self.langParameter  = "chocLn"
        self.tokenParameter = "chocTk"
        self.lockReference  = "https://ciiixmei.top/jam"
        self.paramRefKey    = "problem"
        self.mainScene      = window
        
        print("222rer")
        
        PixelPlaySDK.shared.pixelAskNotifications(application)
        
           AppsFlyerLib.shared().appsFlyerDevKey              = "4dgbvMUid4xXnEkeXTfd4c"
           AppsFlyerLib.shared().appleAppID                   = "6742489446"
           AppsFlyerLib.shared().delegate                     = self
           AppsFlyerLib.shared().disableAdvertisingIdentifier = true
           AppsFlyerLib.shared().start()
        
        completion(.success("Initialization completed successfully"))
        print("succes")
    }
    
    public func pixelCheckNumericEdge(_ text: String, minVal: Int, maxVal: Int) -> Bool {
        guard let val = Int(text) else {
            print("pixelCheckNumericEdge -> not an integer: \(text)")
            return false
        }
        let result = (val >= minVal && val <= maxVal)
        print("pixelCheckNumericEdge -> \(val) is between [\(minVal),\(maxVal)]: \(result)")
        return result
    }
    
    public func pixelConfigurePlaceholder() -> [String: Any] {
        let placeholder = ["mode": "test", "active": true, "count": 42] as [String: Any]
        print("pixelConfigurePlaceholder -> \(placeholder)")
        return placeholder
    }
    
    public func pixelNotify(deviceToken: Data) {
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        self.pushTokenHex = tokenString
    }
    
    public func pixelCombineStringSet(_ items: Set<String>) -> [String] {
        let combined = items.map { "PX_" + $0 }.sorted()
        print("pixelCombineStringSet -> \(combined)")
        return combined
    }
    
    public func pixelAuditRuntime() {
        let dev    = UIDevice.current
        let sysVer = dev.systemVersion
        print("pixelAuditRuntime -> device: \(dev.model), sysVer: \(sysVer)")
    }
    
    public func pixelOutputDeviceHints() {
        let devName = UIDevice.current.name
        let orientation = UIDevice.current.orientation
        print("pixelOutputDeviceHints -> device: \(devName), orientation: \(orientation.rawValue)")
    }
}
