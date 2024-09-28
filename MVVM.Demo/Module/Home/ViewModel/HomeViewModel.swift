//
//  HomeViewModel.swift
//  MVVM.Demo
//
//  Created by ALY NABIL on 22/09/2024.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewModel: AnyObject {
    associatedtype Input
    associatedtype Output
}

protocol HomeViewModelProtocol: AnyObject {
//    var postsPublish: PublishSubject<[Post]> { get }
    var input: HomeViewModel.Input { get }
    var output: HomeViewModel.Output { get }
    func viewDidLoad()
}

enum HomeBinding {
    case showHud
    case dismissHud
    case succeedMessage(String)
    case failMassage(String)
}

class HomeViewModel: HomeViewModelProtocol, ViewModel {
    
   //Input
    class Input {
        var searchTextBehavior: BehaviorRelay<String> = .init(value: "")
        var bindingState: PublishSubject<HomeBinding> = .init()

    }
    
    //Output
    class Output {
        var postsPublish: PublishSubject<[Post]> = .init()
    }
    
    
    //MARK: - Properties
    var input: Input = .init()
    var output: Output = .init()
    private var bag = DisposeBag()
    private var collectedAllPostsPublish: PublishSubject<[Post]> = .init()
    
    init() {}
    
    func viewDidLoad() {
        handelSearchWithPostsOutput()
        callPostFromApi()
    }
    
    private func callPostFromApi() {
        input.bindingState.onNext(.showHud)
        let postsFromApi:[Post] = [
            .init(title: "Ali1", description: "Is A Good Man"),
            .init(title: "Ali2", description: "Is A Good Man"),
            .init(title: "Ali3", description: "Is A Good Man"),
            .init(title: "Ali4", description: "Is A Good Man"),
            .init(title: "Ali5", description: "Is A Good Man"),
            .init(title: "Ali6", description: "Is A Good Man"),
            .init(title: "Ali7", description: "Is A Good Man"),
            .init(title: "Ali8", description: "Is A Good Man"),
            .init(title: "Ali9", description: "Is A Good Man"),
            .init(title: "Ali10", description: "Is A Good Man")
        ]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
//            self.output.postsPublish.onNext(postsFromApi)
            self.collectedAllPostsPublish.onNext(postsFromApi)
            self.input.bindingState.onNext(.dismissHud)
        }
    }
    
    private func handelSearchWithPostsOutput() {
        Observable.combineLatest(collectedAllPostsPublish, input.searchTextBehavior)
            .map { (posts, search) in
                if search == "" {return posts}
                return posts.filter { $0.title.lowercased().contains(search.lowercased()) }
            }.bind(to: output.postsPublish).disposed(by: bag)
        
    }
    
}

 
