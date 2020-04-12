//
//  AppDelegate.swift
//  TabbedViews
//
//  Created by StuFF mc on 10.04.20.
//  Copyright © 2020 Manuel @StuFFmc Carrasco Molina. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var tabObject = TabObject()
    let cmdT = UIKeyCommand(input: "T", modifierFlags: .command, action: #selector(Self.commandT(command:)))
    let cmdW = UIKeyCommand(input: "W", modifierFlags: .command, action: #selector(Self.commandW(command:)))

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    override func buildMenu(with builder: UIMenuBuilder) {
        guard builder.system ==  .main else { return }
        builder.remove(menu: .format)
        let menuCmdT = UIMenu(title: "", identifier: .init("cmdT"), options: .displayInline, children: [cmdT])
        builder.insertChild(menuCmdT, atStartOfMenu: .file)
        builder.insertSibling(UIMenu(title: "", options: .displayInline, children: [cmdW]), afterMenu: .init("cmdT"))
    }

    override var keyCommands: [UIKeyCommand]? {
        [cmdT, cmdW]
    }

    @objc func commandT(command: UIKeyCommand) {
        tabObject.append()
    }
    
    @objc func commandW(command: UIKeyCommand) {
        tabObject.remove()
    }
    
    override func validate(_ command: UICommand) {
        switch command.action {
        case cmdT.action:
            command.title = "New Tab"
        case cmdW.action:
            command.title = "Close Tab"
        default:
            print(command)
            break
        }
    }
}

