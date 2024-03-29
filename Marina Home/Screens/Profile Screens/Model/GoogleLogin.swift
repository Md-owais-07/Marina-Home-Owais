//
//  GoogleLogin.swift
//  Marina Home
//
//  Created by Codilar on 12/04/23.
//

import Firebase
import GoogleSignIn
final class GoogleLogin: NSObject {
   
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func disConnectApp() {
        GIDSignIn.sharedInstance.disconnect { error in
            guard error == nil else { return }

            // Google Account disconnected from your app.
            // Perform clean-up actions, such as deleting data associated with the
            //   disconnected account.
        }
    }
}

struct GoogleSignInModel {
    var imageURL: String?
    var email: String?
    var name: String?
    var givenName: String?
    var familyName: String?
}
