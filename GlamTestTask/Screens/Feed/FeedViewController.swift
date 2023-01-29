import UIKit
import CHTCollectionViewWaterfallLayout

final class FeedViewController: UIViewController {
    
    // MARK: - UI elements
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let collectionViewLayout: CHTCollectionViewWaterfallLayout = {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.columnCount = 2
        layout.minimumColumnSpacing = 4
        layout.minimumInteritemSpacing = 4
        return layout
    }()
        
    // MARK: - Private properties
    
    private let apiClient: GiphyApiClient
    private var gifs = [GIF]()
    private var items = [FeedGifCell.Model]()
    
    init(apiClient: GiphyApiClient) {
        self.apiClient = apiClient
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        fetchGifs()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        view.addSubview(collectionView)
                
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.register(FeedGifCell.self, forCellWithReuseIdentifier: Constants.cellId)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func fetchGifs() {
        apiClient.fetchTrendingGifs { gifs in
            let items: [FeedGifCell.Model] = gifs.compactMap { gif in
                guard let width = Double(gif.images.fixedHeight.width),
                      let height = Double(gif.images.fixedHeight.height)
                else { return nil }
                return .init(
                    id: gif.id,
                    imageUrl: gif.images.fixedHeight.url,
                    width: width,
                    height: height
                )
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                self.gifs = gifs
                self.items = items
                self.collectionView.reloadData()
            }
        }
    }
    
    private func showGifDetails(gif: GIF) {
        let exportViewController = ExportViewController(gif: gif)
        present(exportViewController, animated: true)
    }

}

private extension FeedViewController {

    struct Constants {
        static let cellId = "Cell"
    }
    
}

extension FeedViewController: CHTCollectionViewDelegateWaterfallLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = items[indexPath.row]
        let width = (collectionView.frame.width - self.collectionViewLayout.minimumColumnSpacing) / 2.0
        let height = width * (item.height / item.width)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let gif = gifs[indexPath.row]
        showGifDetails(gif: gif)
    }
    
}

extension FeedViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellId, for: indexPath) as? FeedGifCell else {
            return UICollectionViewCell()
        }
        
        let item = items[indexPath.row]
        cell.configure(for: item)
        return cell
    }
    
}
