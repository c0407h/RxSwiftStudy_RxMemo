//
//  SceneDelegate.swift
//  RxMemo
//
//  Created by Chung Wussup on 12/20/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        //의존성 주입을위해 시작점 구현
        guard let _ = (scene as? UIWindowScene) else { return }
        
        //앱을 실행하면 MemoryStorage와 SceneCoordinator가 생성됨
        //viewmodel은 두 인스턴스를 통해서 메모를 저장하고 화면전환을 처리함
//        let storage = MemoryStorage()
        
        let storage = CoreDataStorage(modelName: "RxMemo")
        let coordinator = SceneCoordinator(window: window!)
        
        //위 두 인스턴스에 대한 의존성은 viewmodel을 생성할때 init을 통해 주입함
        let listViewModel = MemoListViewModel(title: "나의 메모", sceneCoordinator: coordinator, storage: storage)
        
        //리스트 화면을 만들때 viewModel을 연관값으로 전달해야함
        let listScene = Scene.list(listViewModel)
        
        //listScene을 root 씬으로 변경
        coordinator.transition(to: listScene, using: .root, animated
                               : false)
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
    }


}

