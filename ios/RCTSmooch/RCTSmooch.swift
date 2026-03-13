import Foundation
import React
import Smooch

@objc(RCTSmooch)
class RCTSmooch: NSObject {
  private var initialized = false

  @objc(initialize:resolver:rejecter:)
  func initialize(
    integrationId: String,
    resolver resolve: @escaping RCTPromiseResolveBlock,
    rejecter reject: @escaping RCTPromiseRejectBlock
  ) -> Void {
    if initialized {
      resolve(nil)
      return
    }

    let settings = SKTSettings(integrationId: integrationId)

    Smooch.initWith(settings) { error, userInfo in
      if let error = error {
          print("❌ Error initializing the Sunshine Conversations SDK: \(error.localizedDescription). Information: \(String(describing: userInfo?.description))")
      } else {
          print("🟢 Successfully initialized the Sunshine Conversations SDK.")
          self.initialized = true
      }
    }
  }

  @objc(show:rejecter:)
  func show(
    resolver resolve: @escaping RCTPromiseResolveBlock,
    rejecter reject: @escaping RCTPromiseRejectBlock
  ) -> Void {
    if !initialized {
      reject(nil, "Smooch instance not initialized", nil)
      return
    }

    DispatchQueue.main.async {
      guard let viewController = Smooch.newConversationListViewController(),
            let rootController = RCTPresentedViewController() else {
        reject(nil, "cannot show messaging view", nil)
        return
      }

      if let navigationController = rootController.navigationController {
        navigationController.pushViewController(viewController, animated: true)
      } else {
        let navigationController = UINavigationController(rootViewController: viewController)
        rootController.present(navigationController, animated: true, completion: nil)
      }
      resolve(nil)
    }
  }

 @objc(close:rejecter:)
  func close(
    resolver resolve: @escaping RCTPromiseResolveBlock,
    rejecter reject: @escaping RCTPromiseRejectBlock
  ) -> Void {
    if !initialized {
      reject(nil, "Zendesk instance not initialized", nil)
      return
    }

    DispatchQueue.main.async {
      guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else {
        reject(nil, "cannot close messaging view", nil)
        return
      }
      rootViewController.dismiss(animated: true, completion: nil)
      resolve(nil)
    }
  }
}