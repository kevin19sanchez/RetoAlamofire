//
//  DetalleAnime.swift
//  AnimeProject
//
//  Created by Miguel Orellana on 9/24/19.
//  Copyright © 2019 Miguel Orellana. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class DetalleAnime: UIViewController {
   
    @IBOutlet var image: UIImageView!
    @IBOutlet var genero: UILabel!
    @IBOutlet var descripcion: UILabel!
    
    var jkanime: Anime?

    override func viewDidLoad() {
        super.viewDidLoad()
    
    genero.text = jkanime?.genero
        descripcion.text = jkanime?.descripcion
        image.sd_setImage(with: URL(string: jkanime!.image!))
    }
}
