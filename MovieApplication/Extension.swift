//
//  Extension.swift
//  FilmApplication
//
//  Created by Yildirim on 15.02.2023.
//

import Foundation

extension String {
    func capitalizedFirstLatter() -> String{
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
