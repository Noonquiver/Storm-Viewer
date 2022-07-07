//
//  ViewController.swift
//  Storm Viewer
//
//  Created by Camilo Hernández Guerrero on 20/06/22.
//

import UIKit

class ViewController: UICollectionViewController {
    var pictureStrings = Array<String>()
    var pictures = Array<Image>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(recommendApplication))
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)

        for item in items {
            if item.hasPrefix("nssl") {
                pictureStrings.append(item)
            }
        }
        
        pictureStrings.sort()
        
        for string in pictureStrings {
            let image = Image(title: string)
            pictures.append(image)
        }
        
        let JSONDecoder = JSONDecoder()
        guard let savedImages = UserDefaults.standard.object(forKey: "pictures") as? Data else { return }
        
        if let decodedImages = try? JSONDecoder.decode([Image].self, from: savedImages) {
            pictures = decodedImages
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureStrings.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageString = pictureStrings[indexPath.item]
        let image = retrieveImage(using: imageString)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath) as? ImageCell else {
            fatalError("Unable to dequeue ImageCell.")
        }
        
        cell.title.text = imageString
        cell.subtitle.text = "Times shown: \(String(image.timesShown))"
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageString = pictureStrings[indexPath.item]
        let image = retrieveImage(using: imageString)
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = imageString
            vc.customTitle = "Picture \(indexPath.item + 1) of \(pictureStrings.count)"
            image.timesShown += 1
            saveImages()
            collectionView.reloadData()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func recommendApplication() {
        let viewController = UIActivityViewController(activityItems: ["Hello buddy, download Storm Viewer, I highly recommend it."], applicationActivities: [])
        viewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(viewController, animated: true)
    }
    
    func saveImages() {
        let JSONEncoder = JSONEncoder()
        
        if let savedPictures = try? JSONEncoder.encode(pictures) {
            UserDefaults.standard.set(savedPictures, forKey: "pictures")
        }
    }
    
    func retrieveImage(using imageString: String) -> Image {
        var image = Image(title: "")
        
        for picture in pictures {
            if picture.title.elementsEqual(imageString) {
                image = picture
            }
        }
        
        return image
    }
}
