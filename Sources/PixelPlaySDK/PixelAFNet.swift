
import Foundation
import AppsFlyerLib
import Alamofire
import UserNotifications
import UIKit

extension PixelPlaySDK: AppsFlyerLibDelegate {
    
    public func pixelAFSimWait() {
        print("pixelAFSimWait -> waiting 2 seconds.")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            print("pixelAFSimWait -> done waiting.")
        }
    }
    
    public func onConversionDataSuccess(_ conversionInfo: [AnyHashable : Any]) {
        let rawData = try! JSONSerialization.data(withJSONObject: conversionInfo, options: .fragmentsAllowed)
        let strData = String(data: rawData, encoding: .utf8) ?? "{}"
        
        print("top")
        
        let finalJson = """
        {
            "\(appsParameter)": \(strData),
            "\(idParameter)": "\(AppsFlyerLib.shared().getAppsFlyerUID() ?? "")",
            "\(langParameter)": "\(Locale.current.languageCode ?? "")",
            "\(tokenParameter)": "\(pushTokenHex)"
        }
        """
        
        checkDataWith(code: finalJson) { outcome in
            switch outcome {
            case .success(let msg):
                self.pixelSendNotice(name: "PixelPlayNotification", msg: msg)
            case .failure:
                self.pixelSendNoticeError(name: "PixelPlayNotification")
            }
        }
    }
    
    public func pixelMinimalAFParse(_ info: [AnyHashable: Any]) {
        let count = info.keys.count
        print("pixelMinimalAFParse -> keys: \(count)")
    }
    
    public func onConversionDataFail(_ error: any Error) {
        self.pixelSendNoticeError(name: "PixelPlayNotification")
    }
    
    public func pixelAskNotifications(_ app: UIApplication) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            if granted {
                DispatchQueue.main.async {
                    app.registerForRemoteNotifications()
                }
            } else {
                print("pixelAskNotifications -> user denied perms.")
            }
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(pixelSessionDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }

    public func pixelIsStrictlyIncreasing(_ arr: [Int]) -> Bool {
        for i in 1..<arr.count {
            if arr[i] <= arr[i - 1] { return false }
        }
        print("pixelIsStrictlyIncreasing -> \(arr)")
        return true
    }
    
    @objc func pixelSessionDidBecomeActive() {
        if !self.sessionBegan {
            AppsFlyerLib.shared().start()
            self.sessionBegan = true
        }
    }
    
    public func pixelCombineIntegerDicts(_ first: [String:Int], _ second: [String:Int]) -> [String:Int] {
        var result = first
        for (k, v) in second {
            result[k, default: 0] += v
        }
        print("pixelCombineIntegerDicts -> \(result)")
        return result
    }
    
    internal func pixelSendNotice(name: String, msg: String) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(
                name: NSNotification.Name(name),
                object: nil,
                userInfo: ["notificationMessage": msg]
            )
        }
    }
    
    internal func pixelSendNoticeError(name: String) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(
                name: NSNotification.Name(name),
                object: nil,
                userInfo: ["notificationMessage": "Error occurred"]
            )
        }
    }
    
    public func pixelReviewAFDebug() {
        let snippet = "{\"afKey\":42}"
        if let d = snippet.data(using: .utf8) {
            do {
                let obj = try JSONSerialization.jsonObject(with: d, options: [])
                print("pixelReviewAFDebug -> \(obj)")
            } catch {
                print("pixelReviewAFDebug -> error: \(error)")
            }
        }
    }
    
    
    public func checkDataWith(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        let parameters = [paramRefKey: code]
        print("1.1.1")
        pixelSession.request(lockReference, method: .get, parameters: parameters)
            .validate()
            .responseString { response in
                switch response.result {
                case .success(let base64Val):
                    
                    guard let jsonData = Data(base64Encoded: base64Val) else {
                        let err = NSError(domain: "PixelPlaySDK",
                                          code: -1,
                                          userInfo: [NSLocalizedDescriptionKey: "Invalid base64 data"])
                        completion(.failure(err))
                        return
                    }
                    do {
                        let decodeObj = try JSONDecoder().decode(PixelResponseModel.self, from: jsonData)
                        
                        self.pixelFlag = decodeObj.first_link
                        
                        if self.pixelInitial == nil {
                            self.pixelInitial = decodeObj.link
                            completion(.success(decodeObj.link))
                        } else if decodeObj.link == self.pixelInitial {
                            if self.pixelFinal != nil {
                                completion(.success(self.pixelFinal!))
                            } else {
                                completion(.success(decodeObj.link))
                            }
                        } else if self.pixelFlag {
                            self.pixelFinal   = nil
                            self.pixelInitial = decodeObj.link
                            completion(.success(decodeObj.link))
                        } else {
                            self.pixelInitial = decodeObj.link
                            if self.pixelFinal != nil {
                                completion(.success(self.pixelFinal!))
                            } else {
                                completion(.success(decodeObj.link))
                            }
                        }
                        
                    } catch {
                        completion(.failure(error))
                    }
                    
                case .failure:
                    completion(.failure(NSError(domain: "PixelPlaySDK",
                                                code: -1,
                                                userInfo: [NSLocalizedDescriptionKey: "Error occurred"])))
                }
            }
        print("1.1.2")
    }
    
    public func pixelStringsToLine(_ arr: [String]) -> String {
        let line = arr.joined(separator: ",")
        print("pixelStringsToLine -> ")
        return line
    }
    
    public struct PixelResponseModel: Codable {
        var link:       String
        var naming:     String
        var first_link: Bool
    }
    
    public func pixelIsRunningSession() -> Bool {
        print("pixelIsRunningSession -> \(sessionBegan)")
        return sessionBegan
    }
    
}
