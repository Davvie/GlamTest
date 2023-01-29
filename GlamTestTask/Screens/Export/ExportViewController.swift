import UIKit
import Kingfisher

final class ExportViewController: UIViewController {
    
    // MARK: - UI elements
    
    private let imageView: AnimatedImageView = {
        let imageView = AnimatedImageView()
        imageView.isSkeletonable = true
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8.0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.setTitle(" Share", for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Private propertiess
    
    private let gif: GIF
    
    init(gif: GIF) {
        self.gif = gif
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configure()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        view.addSubview(imageView)
        
        var aspectRatio = 1.0
        if let width = Double(gif.images.original.width),
           let height = Double(gif.images.original.height) {
            aspectRatio = width / height
        }
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            NSLayoutConstraint(
                item: imageView,
                attribute: .width,
                relatedBy: .equal,
                toItem: imageView,
                attribute: .height,
                multiplier: aspectRatio,
                constant: 0
            )
        ])
        
        view.addSubview(shareButton)
        NSLayoutConstraint.activate([
            shareButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configure() {
        imageView.showAnimatedGradientSkeleton()
        imageView.kf.setImage(with: gif.images.original.url) { [weak self] _ in
            self?.imageView.hideSkeleton()
        }
        
        shareButton.addTarget(self, action: #selector(share), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    }
    
    @objc private func share() {
        let activityViewController = UIActivityViewController(activityItems: [gif.url], applicationActivities: nil)
        present(activityViewController, animated: true)
    }
    
    @objc private func close() {
        dismiss(animated: true)
    }
    
}
