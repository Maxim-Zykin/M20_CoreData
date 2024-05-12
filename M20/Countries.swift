//
//  Countries.swift
//  M20
//
//  Created by Максим Зыкин on 12.05.2024.
//

import Foundation

struct Countries {
    
    var countries: [String] = {
        var arrayOfCountries: [String] = []

        for code in NSLocale.isoCountryCodes as [String] {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "ru_Ru").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            arrayOfCountries.append(name)
        }

        return arrayOfCountries
    }()
}
