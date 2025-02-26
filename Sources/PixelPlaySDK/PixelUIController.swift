
import Foundation
import UIKit
import WebKit
import SwiftUI

extension PixelPlaySDK {
    
    public func showView(with url: String) {
        self.mainScene = UIWindow(frame: UIScreen.main.bounds)
        let pixScene = PixelSceneController()
        pixScene.pixelErrorURL = url
        let nav = UINavigationController(rootViewController: pixScene)
        self.mainScene?.rootViewController = nav
        self.mainScene?.makeKeyAndVisible()
    }
    
    public class PixelSceneController: UIViewController, WKNavigationDelegate, WKUIDelegate {
        
        private var webErrorsHandler: WKWebView!
        
        public var pixelErrorURL: String!
        
        public override func viewDidLoad() {
            super.viewDidLoad()
            
            let config = WKWebViewConfiguration()
            config.preferences.javaScriptEnabled = true
            config.preferences.javaScriptCanOpenWindowsAutomatically = true
            
            let viewportScript = """
            var meta = document.createElement('meta');
            meta.name = 'viewport';
            meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
            document.getElementsByTagName('head')[0].appendChild(meta);
            """
            let userScript = WKUserScript(source: viewportScript,
                                          injectionTime: .atDocumentEnd,
                                          forMainFrameOnly: true)
            config.userContentController.addUserScript(userScript)
            
            webErrorsHandler = WKWebView(frame: .zero, configuration: config)
            webErrorsHandler.isOpaque = false
            webErrorsHandler.backgroundColor = .white
            webErrorsHandler.uiDelegate = self
            webErrorsHandler.navigationDelegate = self
            webErrorsHandler.allowsBackForwardNavigationGestures = true
            
            view.addSubview(webErrorsHandler)
            webErrorsHandler.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                webErrorsHandler.topAnchor.constraint(equalTo: view.topAnchor),
                webErrorsHandler.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                webErrorsHandler.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                webErrorsHandler.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
            
            loadPixelContent(pixelErrorURL)
        }
        
        public override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationItem.largeTitleDisplayMode = .never
            navigationController?.isNavigationBarHidden = true
        }
        
        private func loadPixelContent(_ urlString: String) {
            guard let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let realURL = URL(string: encoded) else { return }
            webErrorsHandler.load(URLRequest(url: realURL))
        }
        
        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            if PixelPlaySDK.shared.pixelFinal == nil {
                let finalUrl = webView.url?.absoluteString ?? ""
                PixelPlaySDK.shared.pixelFinal = finalUrl
            }
        }
        
            public func pixelAnalyzeWebFrame() {
                let w = webErrorsHandler.scrollView.contentSize.width
                let h = webErrorsHandler.scrollView.contentSize.height
                print("pixelAnalyzeWebFrame -> \(w)x\(h)")
            }
        
            public func pixelToggleNavigationBar() {
                let hidden = navigationController?.isNavigationBarHidden ?? false
                navigationController?.setNavigationBarHidden(!hidden, animated: true)
                print("pixelToggleNavigationBar -> toggled from \(hidden) to \(!hidden).")
            }
        
            public func pixelInjectConsoleMessage() {
                let script = "console.log('PixelPlay Testing Script');"
                webErrorsHandler.evaluateJavaScript(script) { _, err in
                    if let e = err {
                        print("pixelInjectConsoleMessage -> error: \(e)")
                    } else {
                        print("pixelInjectConsoleMessage -> success.")
                    }
                }
            }
        
            public func pixelReloadWebAfterSeconds(_ secs: Double) {
                print("pixelReloadWebAfterSeconds -> scheduling in \(secs) s.")
                DispatchQueue.main.asyncAfter(deadline: .now() + secs) {
                    print("pixelReloadWebAfterSeconds -> reloading now.")
                    self.webErrorsHandler.reload()
                }
            }
        
            public func pixelWebScroll() {
                let offset = webErrorsHandler.scrollView.contentOffset
                print("pixelTrackWebScroll -> current offset: \(offset)")
            }
        
        public func webView(_ webView: WKWebView,
                            createWebViewWith config: WKWebViewConfiguration,
                            for navAction: WKNavigationAction,
                            windowFeatures: WKWindowFeatures) -> WKWebView? {
            let popup = WKWebView(frame: .zero, configuration: config)
            popup.navigationDelegate = self
            popup.uiDelegate         = self
            popup.allowsBackForwardNavigationGestures = true
            
            webErrorsHandler.addSubview(popup)
            popup.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                popup.topAnchor.constraint(equalTo: webErrorsHandler.topAnchor),
                popup.bottomAnchor.constraint(equalTo: webErrorsHandler.bottomAnchor),
                popup.leadingAnchor.constraint(equalTo: webErrorsHandler.leadingAnchor),
                popup.trailingAnchor.constraint(equalTo: webErrorsHandler.trailingAnchor)
            ])
            
            return popup
        }
    }
    
    public struct PixelSolveUIAdapter: UIViewControllerRepresentable {
        public var pixelDetail: String
        
        public init(pixelDetail: String) {
            self.pixelDetail = pixelDetail
        }
        
        public func makeUIViewController(context: Context) -> PixelSceneController {
            let ctrl = PixelSceneController()
            ctrl.pixelErrorURL = pixelDetail
            return ctrl
        }
        
        public func updateUIViewController(_ uiViewController: PixelSceneController, context: Context) {
            // no updates
        }
    }
    
    public func pixelPerformMockAnalysis() {
        print("pixelPerformMockAnalysis -> simulating deep web content analysis.")
    }
    
    public func pixelFetchSystemMemory() -> Int {
        let usage = Int.random(in: 500_000...4_000_000)
        print("pixelFetchSystemMemory -> approx usage: \(usage) bytes")
        return usage
    }

    public func pixelReverseSentence(_ sentence: String) -> String {
        let components = sentence.components(separatedBy: " ")
        let reversed   = components.reversed().joined(separator: " ")
        print("pixelReverseSentence -> original: \"\(sentence)\", reversed: \"\(reversed)\"")
        return reversed
    }

    public func pixelGroupByStringLength(_ items: [String]) -> [Int: [String]] {
        var result = [Int: [String]]()
        for str in items {
            let length = str.count
            result[length, default: []].append(str)
        }
        print("pixelGroupByStringLength -> \(result)")
        return result
    }

}
