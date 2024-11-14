//
//  HapticsManager.swift
//  UsuariosProject
//
//  Created by Juan Hernandez Pazos on 11/11/24.
//

import Foundation
import UIKit

// https://developer.apple.com/design/human-interface-guidelines/playing-haptics

fileprivate final class HapticManager {
    static let shared = HapticManager()
    
    private let feedback = UINotificationFeedbackGenerator()
    
    private init() {}
    
    func trigger(_ notification: UINotificationFeedbackGenerator.FeedbackType) {
        feedback.notificationOccurred(notification)
    }
}

// Para no tener que hacer toda la llamada: HapticManager.shared.trigger(notification)
func haptic(_ notification: UINotificationFeedbackGenerator.FeedbackType) {
    if UserDefaults.standard.bool(forKey: UserDefaultsKeys.hapticEnabled) {
        HapticManager.shared.trigger(notification)
    }
}
