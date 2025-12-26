import UIKit
import Flutter

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    
    // Obtenir l'AppDelegate
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    
    // Créer la fenêtre
    let window = UIWindow(windowScene: windowScene)
    
    // Créer le contrôleur Flutter avec le moteur de l'AppDelegate
    let flutterViewController = FlutterViewController(engine: appDelegate.flutterEngine, nibName: nil, bundle: nil)
    
    // Configurer la fenêtre
    window.rootViewController = flutterViewController
    self.window = window
    window.makeKeyAndVisible()
  }
}

