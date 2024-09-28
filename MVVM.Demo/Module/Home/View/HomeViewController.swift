//
//  HomeViewController.swift
//  MVVM.Demo
//
//  Created by ALY NABIL on 22/09/2024.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    //MARK: - Properties
    let viewModel: HomeViewModelProtocol = HomeViewModel()
    let bag = DisposeBag()
            
    override func viewDidLoad() {
        super.viewDidLoad()
        bindingFromViewModelWithState()
        setupRegesterTableView()
        subscirbWithTableView()
        bindToViewModel()
        viewModel.viewDidLoad()
        didSelectTableView()
    }
    
    func bindToViewModel() {
        searchTextField.rx.text.orEmpty.bind(to: viewModel.input.searchTextBehavior).disposed(by: bag)
    }
    
    func setupRegesterTableView() {
        tableView.register(UINib(nibName: String(describing: PostsCell.self),bundle: nil), forCellReuseIdentifier: String(describing: PostsCell.self))
    }
    
    func subscirbWithTableView() {
        viewModel.output.postsPublish.bind(to: tableView.rx.items(cellIdentifier: String(describing: PostsCell.self),cellType: PostsCell.self)) { index, post, cell in
            cell.titleLabel.text = post.title
            cell.descriptionLabel.text = post.description
            
        }.disposed(by: bag)
    }
    
    func didSelectTableView() {
        tableView.rx.modelSelected(Post.self).subscribe(onNext: { posts in
            print(posts.title)
        }).disposed(by: bag)
    }
}


extension HomeViewController {
    
    func bindingFromViewModelWithState() {
        viewModel.input.bindingState.subscribe(onNext: { [weak self] bindingState in
            guard let self = self else { return }
            switch bindingState {
            case .showHud:
                print("show Hud")
            case .dismissHud:
                print("dismiss Hud")
            case .succeedMessage(let succeed):
                print("succeed message \(succeed)")
            case .failMassage(let fail):
                print("fail message \(fail)")
            }
        }).disposed(by: bag)
    }
}

       
   
