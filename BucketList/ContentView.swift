//
//  ContentView.swift
//  BucketList
//
//  Created by Jasper Tan on 1/8/25.
//

import LocalAuthentication
import MapKit
import SwiftUI


struct ContentView: View {
    var body: some View {
        Text("Hello World")
    }
}

struct BiometricAuthenticationView: View {
    
    @State private var isUnlocked = false
    
    var body: some View {
        
        VStack {
            if isUnlocked {
                Text("Unlocked")
            } else {
                Text("Locked")
            }
        }
        .onAppear(perform: authenticate)
    }
    
    func authenticate() {
        /*  1. Create instance of LAContext, allows us to query biometric status and perform authentication check
            2. Ask that context if it's capable of performing biometric authentication - Important as iPodTouch users have neither Touch ID nor face ID
            3. If biometrics are possible, kick off the actual request for authentication, passing in a closure to run when authentication completes
            4. When user has been authenticated or not, completion closure is called and will tell us whether it worked or not, and if not what the error was
         */
        
        
        let context = LAContext() // 1. Create LAContext
        var error: NSError?
        
        // 2. check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) { //key note, you need to pass an &. $ is for in-out. & is for reference
            
            let reason = "We need to unlock your data"
            
            // 3. kick off actual request for authentication
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                
                // authentication has now completed
                if success {
                    //Authenticated successfully
                    isUnlocked = true
                } else {
                    
                }
            }
        } else {
            // no biometrics available - need another method to authenticate user then. Perhaps prompting passcode?
        }
        
    }
}


struct SandBoxMapView: View {
    
    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.3354, longitude: -121.8930),
            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        )
    )
    
    var body: some View {
        VStack {
            Map(position: $position)
            
            HStack {
                Button("Paris") {
                    position = MapCameraPosition.region(
                                MKCoordinateRegion(
                                    center: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522),
                                    span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
                                )
                            )
                }
                
                Spacer()
                
                Button ("Tokyo") {
                    position = MapCameraPosition.region(
                                MKCoordinateRegion(
                                    center: CLLocationCoordinate2D(latitude: 35.6897, longitude: 139.6922),
                                    span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
                                )
                            )
                }
                
                Spacer()
                
                Button("San Jose") {
                    position = MapCameraPosition.region(
                        MKCoordinateRegion(
                            center: CLLocationCoordinate2D(latitude: 37.3354, longitude: -121.8930),
                            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
                        )
                    )
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    BiometricAuthenticationView()
}
