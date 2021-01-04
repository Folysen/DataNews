//
//  DNError.swift
//  DataNews
//
//  Created by Yaroslav on 1/4/21.
//

import Foundation

enum DNError: String, Error {
    case unableToComplete   = "Unable to complete your request. Please check your internet connection"
    case invalidResponse    = "Invalid response from the server. Please try aagain."
    case invalidData        = "The data received from server was invalid. Please try again."
    case somethingWentWrong = "Something went wrong. Please try again."
    case needToPermitRightsForPhotoAlbum = "In order to save photo, you need to enable using photo album in app privacy"
}
