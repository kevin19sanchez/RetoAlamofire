//
//  ViewController.swift
//  AnimeProject
//
//  Created by Miguel Orellana on 9/24/19.
//  Copyright © 2019 Miguel Orellana. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AVFoundation
import SDWebImage

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var animeCollection: UICollectionView!
    
    var animeList:[Anime] = [Anime]();
    
    var jkanime:Anime?
    
    var refreshControl: UIRefreshControl!
    
    var cellIdentifier:String = "animeCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.animeCollection.dataSource = self
        self.animeCollection.delegate = self
        
        self.refresh()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
        animeCollection.addSubview(refreshControl)
        
    }
    
    @objc func refresh(){
        print("Refresh content")
        Alamofire.request("https://raw.githubusercontent.com/kevin19sanchez/projectAnime/master/arreglo.json").responseJSON{
            response in
            switch response.result{
            case.success:
                self.parse(data:JSON(response.result.value!))
            case .failure(let error):
                print(error)
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func parse(data:JSON) {
        self.animeList.removeAll()
        
        for item in data.arrayValue{
            let anime:Anime = Anime()
            
            anime.id = item["id"].int
            anime.titulo = item["titulo"].string
            anime.genero = item["genero"].string
            anime.image = item["image"].string
            anime.descripcion = item["descripcion"].string
            
            self.animeList.append(anime)
        }
        self.animeCollection.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.animeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath as IndexPath) as! AnimeCell
        
        cell.titulo.text = self.animeList[indexPath.item].titulo;
        cell.genero.text = self.animeList[indexPath.item].genero;
        
        let imagepath = self.animeList[indexPath.item].image!
        
        print(imagepath)
        
        print(cell.titulo.text!)
        
        //Utilizamos SDWebImage para descargar imágenes
        cell.image.sd_setImage(with: URL(string:imagepath), placeholderImage: UIImage(named: "emoji.png"))
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let animeid = storyboard?.instantiateViewController(withIdentifier: "detalleAnime") as? DetalleAnime
        
        jkanime = animeList[indexPath.row]
        animeid?.jkanime = jkanime
        
        self.navigationController?.pushViewController(animeid!, animated: true)
    }


}

