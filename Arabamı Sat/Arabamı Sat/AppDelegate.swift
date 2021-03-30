//
//  AppDelegate.swift
//  Arabamı Sat
//
//  Created by mahsun abuzeyitoğlu on 30.03.2021.
//
import GoogleSignIn
import UIKit
import Firebase
@main
class AppDelegate: UIResponder, UIApplicationDelegate,GIDSignInDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = SplashScreen()
        
        GIDSignIn.sharedInstance()?.clientID = "184640423742-la60eols1528bofonv0qgf0s3251erdf.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.delegate = self
        
        return true
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("DEBUD:: User Sign In")
        print("DEBUD:: User email \(user.profile.email ?? "has no email")")
        print("DEBUD:: User name \(user.profile.name ?? "has no email")")
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }

}

