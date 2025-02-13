//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Jasper Tan on 1/14/25.
//

import CoreLocation
import Foundation
import LocalAuthentication
import MapKit
import _MapKit_SwiftUI


extension ContentView {
    @Observable
    class ViewModel {
        
        let savePath = URL.documentsDirectory.appending(path: "SavedPlaces")
        
        private(set) var locations: [Location]
        var selectedPlace: Location?
        
        var isUnlocked = false
        
        var mapStyle = "Standard"
        
        // Biometric authentication alerts
        var biometricErrorAlert = false
        var biometricErrorMessage = ""
    
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        func addLocation(at point: CLLocationCoordinate2D) {
            let newLocation = Location(id: UUID(), name: "New Location", description: "", latitude: point.latitude, longitude: point.longitude)
            locations.append(newLocation)
        }
        
        func update(location: Location) {
            guard let selectedPlace else { return }
            
            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
            }
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Unable to save data.")
            }
        }
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock your places."
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    if success {
                        self.isUnlocked = true
                    } else {
                        print(String(describing: authenticationError))
                        self.biometricErrorAlert = true
                        self.biometricErrorMessage = "User Authentication Error"
                    }
                }
            } else {
                print(String(describing: error))
                self.biometricErrorAlert = true
                self.biometricErrorMessage = "Authentication not possible on this device"
            }
        }
        
        func swapMapStyle() {
            if (mapStyle == "Standard") {
                mapStyle = "Hybrid"
            }
            else {
                mapStyle = "Standard"
            }
        }
    }
}
