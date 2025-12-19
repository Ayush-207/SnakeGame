//
//  ViewController.swift
//  MeeshoPractice
//
//  Created by Ayush Goyal on 19/12/25.
//

import UIKit

class SnakeGameVC: UIViewController {

    internal var viewModel: SnakeGameVM
    private var timer: Timer?
    
    init(rows: Int, column: Int) {
        self.viewModel = .init(maxRows: rows, maxColumns: column)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupViews()
        setupTimer()
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    private lazy var popUp: GameEndedPopupView = {
       let view = GameEndedPopupView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var scoreLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.text = "Score: 0"
        return label
    }()
    
    private lazy var upBtn: UIButton = {
        let upBtn = UIButton()
        upBtn.translatesAutoresizingMaskIntoConstraints = false
        upBtn.setTitle("UP", for: .normal)
        upBtn.addTarget(self, action: #selector(onTapUp), for: .touchUpInside)
        upBtn.backgroundColor = .blue.withAlphaComponent(0.5)
        return upBtn
    }()
    
    private lazy var rightBtn: UIButton = {
        let upBtn = UIButton()
        upBtn.translatesAutoresizingMaskIntoConstraints = false
        upBtn.setTitle("RIGHT", for: .normal)
        upBtn.addTarget(self, action: #selector(onTapRight), for: .touchUpInside)
        upBtn.backgroundColor = .blue.withAlphaComponent(0.5)
        return upBtn
    }()

    private lazy var downBtn: UIButton = {
        let upBtn = UIButton()
        upBtn.translatesAutoresizingMaskIntoConstraints = false
        upBtn.setTitle("DOWN", for: .normal)
        upBtn.addTarget(self, action: #selector(onTapDown), for: .touchUpInside)
        upBtn.backgroundColor = .blue.withAlphaComponent(0.5)
        return upBtn
    }()
    
    private lazy var leftBtn: UIButton = {
        let upBtn = UIButton()
        upBtn.translatesAutoresizingMaskIntoConstraints = false
        upBtn.setTitle("LEFT", for: .normal)
        upBtn.addTarget(self, action: #selector(onTapLeft), for: .touchUpInside)
        upBtn.backgroundColor = .blue.withAlphaComponent(0.5)
        return upBtn
    }()
    
    private lazy var btnsContainer: UIView = {
       let uiview = UIView()
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.heightAnchor.constraint(equalToConstant: 250).isActive = true
        uiview.widthAnchor.constraint(equalToConstant: 250).isActive = true
        return uiview
    }()

    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 3
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SnakeGameCell.self, forCellWithReuseIdentifier: SnakeGameCell.reuseIdentifier)
        return collectionView
    }()
    
    private func setupViews() {
        view.addSubview(scoreLabel)
        scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 50).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: viewModel.getCollectionViewSize().height).isActive = true
        collectionView.widthAnchor.constraint(equalToConstant: viewModel.getCollectionViewSize().width).isActive = true
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(btnsContainer)
        btnsContainer.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 50).isActive = true
        btnsContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        btnsContainer.addSubview(upBtn)
        upBtn.topAnchor.constraint(equalTo: btnsContainer.topAnchor).isActive = true
        upBtn.centerXAnchor.constraint(equalTo: btnsContainer.centerXAnchor).isActive = true
        
        
        btnsContainer.addSubview(downBtn)
        downBtn.bottomAnchor.constraint(equalTo: btnsContainer.bottomAnchor).isActive = true
        downBtn.centerXAnchor.constraint(equalTo: btnsContainer.centerXAnchor).isActive = true
        
        btnsContainer.addSubview(leftBtn)
        leftBtn.leadingAnchor.constraint(equalTo: btnsContainer.leadingAnchor).isActive = true
        leftBtn.centerYAnchor.constraint(equalTo: btnsContainer.centerYAnchor).isActive = true
        
        
        btnsContainer.addSubview(rightBtn)
        rightBtn.trailingAnchor.constraint(equalTo: btnsContainer.trailingAnchor).isActive = true
        rightBtn.centerYAnchor.constraint(equalTo: btnsContainer.centerYAnchor).isActive = true
    }
    
    private func setupTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { [weak self] timer in
            guard let self else { return }
            viewModel.updateSnakePositionOnTimer()
        }
        
        timer?.fire()
    }
    
    @objc func onTapUp() {
        viewModel.updateDirection(with: .up)
    }

    @objc func onTapDown() {
        viewModel.updateDirection(with: .down)
    }
    
    @objc func onTapLeft() {
        viewModel.updateDirection(with: .left)
    }
    
    @objc func onTapRight() {
        viewModel.updateDirection(with: .right)
    }
}

extension SnakeGameVC: SnakeGameVMDelegate {
    func updateGrid(with indexPaths: [IndexPath]) {
        collectionView.performBatchUpdates {
            collectionView.reloadItems(at: indexPaths)
        }
    }
    
    func finishGame(score: Int) {
        collectionView.reloadData()
        timer?.invalidate()
        view.addSubview(popUp)
        popUp.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popUp.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        popUp.updatePopup(with: "Score: \(score)")
        popUp.onTapClosure = { [weak viewModel, weak popUp] in
            viewModel?.resetGame()
            popUp?.removeFromSuperview()
        }
    }
    
    func updateScore(score: Int) {
        scoreLabel.text = "Score: \(score)"
    }
    
    func resetGame() {
        collectionView.reloadData()
        setupTimer()
    }
}

class GameEndedPopupView: UIView {
    
    var onTapClosure: (()->Void)?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    private lazy var resetGame: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("RESET", for: .normal)
        btn.addTarget(self, action: #selector(resetGameAction), for: .touchUpInside)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        self.backgroundColor = .blue.withAlphaComponent(0.7)
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 4
        self.heightAnchor.constraint(equalToConstant: 200).isActive = true
        self.widthAnchor.constraint(equalToConstant: 200).isActive = true
        addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        addSubview(resetGame)
        resetGame.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        resetGame.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    func updatePopup(with text: String) {
        self.titleLabel.text = text
    }
        
    @objc func resetGameAction() {
        onTapClosure?()
    }
}
