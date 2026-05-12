//
//  BookeeApp.swift
//  Bookee
//
//  Created by sieunnnx on 5/9/26.
//

import SwiftUI
import FirebaseCore
import KakaoSDKCommon
import KakaoSDKAuth
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        
        FirebaseApp.configure()
        
        return true
    }
}

@main
struct BookeeApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        KakaoSDK.initSDK(appKey: AppConfig.kakaoNativeAppKey)
    }
    
    var body: some Scene {
        WindowGroup {
            LoginView()
                .onOpenURL { url in
                    
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        _ = AuthController.handleOpenUrl(url: url)
                        return
                    }
                    
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}
