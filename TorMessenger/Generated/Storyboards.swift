// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import UIKit

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Storyboard Scenes

// swiftlint:disable explicit_type_interface identifier_name line_length type_body_length type_name
internal enum StoryboardScene {
  internal enum Auth: StoryboardType {
    internal static let storyboardName = "Auth"

    internal static let authViewController = SceneType<TorMessenger.AuthViewController>(storyboard: Auth.self, identifier: "AuthViewController")
  }
  internal enum Chats: StoryboardType {
    internal static let storyboardName = "Chats"

    internal static let chatsViewController = SceneType<TorMessenger.ChatsViewController>(storyboard: Chats.self, identifier: "ChatsViewController")
  }
  internal enum Contacts: StoryboardType {
    internal static let storyboardName = "Contacts"

    internal static let contactsViewController = SceneType<TorMessenger.ContactsViewController>(storyboard: Contacts.self, identifier: "ContactsViewController")
  }
  internal enum LaunchScreen: StoryboardType {
    internal static let storyboardName = "LaunchScreen"

    internal static let initialScene = InitialSceneType<UIKit.UIViewController>(storyboard: LaunchScreen.self)
  }
  internal enum Registration: StoryboardType {
    internal static let storyboardName = "Registration"

    internal static let registrationViewController = SceneType<TorMessenger.RegistrationViewController>(storyboard: Registration.self, identifier: "RegistrationViewController")
  }
  internal enum TorIndicator: StoryboardType {
    internal static let storyboardName = "TorIndicator"

    internal static let torIndicatorViewController = SceneType<TorMessenger.TorIndicatorViewController>(storyboard: TorIndicator.self, identifier: "TorIndicatorViewController")
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

// MARK: - Implementation Details

internal protocol StoryboardType {
  static var storyboardName: String { get }
}

internal extension StoryboardType {
  static var storyboard: UIStoryboard {
    let name = self.storyboardName
    return UIStoryboard(name: name, bundle: Bundle(for: BundleToken.self))
  }
}

internal struct SceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type
  internal let identifier: String

  internal func instantiate() -> T {
    let identifier = self.identifier
    guard let controller = storyboard.storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
      fatalError("ViewController '\(identifier)' is not of the expected class \(T.self).")
    }
    return controller
  }
}

internal struct InitialSceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type

  internal func instantiate() -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController() as? T else {
      fatalError("ViewController is not of the expected class \(T.self).")
    }
    return controller
  }
}

private final class BundleToken {}
