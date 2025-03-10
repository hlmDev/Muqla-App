//
//  UIApplication+Extensions.swift
//  muqlla
//
//  Created by Mohammad Alturbaq on 10/03/2025.
//

import UIKit

extension UIApplication {

    class func getTopViewController(base: UIViewController? = UIApplication.shared.currentUIWindow()?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
    
    func currentUIWindow() -> UIWindow? {
            let connectedScenes = UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .compactMap { $0 as? UIWindowScene }
            
            let window = connectedScenes.first?
                .windows
                .first { $0.isKeyWindow }

            return window
            
        }
}
