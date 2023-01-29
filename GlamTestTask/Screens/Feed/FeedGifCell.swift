import UIKit
import Kingfisher
import SkeletonView

final class FeedGifCell: UICollectionViewCell {
    
    private let imageView: AnimatedImageView = {
        let imageView = AnimatedImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        isSkeletonable = true

        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    override func prepareForReuse() {
        hideSkeleton()
    }
    
}

private extension FeedGifCell {
    
    struct Constants {
        static let skeletonColors: [UIColor] = [
            .turquoise,
            .peterRiver,
            .wisteria,
            .carrot
        ]
    }
    
}

extension FeedGifCell {
    
    struct Model {
        let id: String
        let imageUrl: URL
        let width: CGFloat
        let height: CGFloat
    }
    
    func configure(for model: Model) {
        showAnimatedSkeleton(usingColor: Constants.skeletonColors.randomElement()!)
        imageView.kf.setImage(with: model.imageUrl) { [weak self] _ in
            self?.hideSkeleton()
        }
    }
    
}
