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
          let message = "❌ Error initializing the Sunshine Conversations SDK: \(error.localizedDescription). Information: \(String(describing: userInfo?.description))"
          print(message)
          reject(nil, message, nil)
      } else {
          let message = "🟢 Successfully initialized the Sunshine Conversations SDK."
          print(message)
          resolve(message)
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

    print("Time to go into the queue");
    DispatchQueue.main.async {
      print("In the queue now");

      guard let viewController = Smooch.newConversationListViewController(),
            let rootController = RCTPresentedViewController() else {
        print("having issues finding a controller");
        reject(nil, "cannot show messaging view", nil)
        return
      }

      print("time to decide on controller");

      if let navigationController = rootController.navigationController {
        print("found navigation controller");
        navigationController.pushViewController(viewController, animated: true)
      } else {
        print("found modal controller");
        let navigationController = UINavigationController(rootViewController: viewController)
        rootController.present(navigationController, animated: true, completion: nil)
      }

      print("done showing");

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

 @objc(destroy:rejecter:)
  func destroy(
    resolver resolve: @escaping RCTPromiseResolveBlock,
    rejecter reject: @escaping RCTPromiseRejectBlock
  ) -> Void {
    Smooch.destroy()
    self.initialized = false
    resolve(nil)
  }
}