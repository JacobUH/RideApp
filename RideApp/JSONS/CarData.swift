//
//  CarData.swift
//  RideApp
//
//  Created by Jacob Rangel on 10/22/24.
//

import Foundation

struct CarData {
    static let jsonString = """
    {
      "cars": [
        {
          "carName": "Herrera Riptide - Terrier",
          "interior": "Brown",
          "exterior": "White/Silver",
          "engine": "8-speed automatic with manual shift",
          "horsepower": "500 HP",
          "mileage": "30 MPG (Hybrid mode), 50 miles on pure electric",
          "transmission": "8-speed automatic with manual paddle shift option",
          "driveType": "All-Wheel Drive (AWD)",
          "features": {
            "entertainment": "Surround sound audio system\\n12\\" holographic display",
            "convenience": "AI-integrated voice command system\\nAdvanced climate control",
            "packages": "Customizable ambient lighting\\nSpacious, ergonomic seating with heating and cooling"
          },
          "images": [
            "herreraRiptideRental",
            "herreraRiptideRental2",
            "herreraRiptideRental3",
            "herreraRiptideRental4"
          ],
          "dailyCost": "74"
        },
        {
          "carName": "Quadra Type 66 - Avenger",
          "interior": "Black/Red",
          "exterior": "Matte Black",
          "engine": "6-speed manual transmission",
          "horsepower": "450 HP",
          "mileage": "22 MPG",
          "transmission": "6-speed manual with rear-wheel drive",
          "driveType": "Rear-Wheel Drive (RWD)",
          "features": {
            "entertainment": "7-speaker stereo system\\n8\\" touchscreen",
            "convenience": "Hands-free communication\\nDual-zone climate control",
            "packages": "Sport suspension\\nTrack tires"
          },
          "images": [
            "quadraType66Rental",
            "quadraType66Rental2",
            "quadraType66Rental3"
          ],
          "dailyCost": "68"
        },
        {
          "carName": "Thorton Colby CX410",
          "interior": "Gray",
          "exterior": "Blue/Gray",
          "engine": "5-speed automatic",
          "horsepower": "180 HP",
          "mileage": "35 MPG",
          "transmission": "5-speed automatic",
          "driveType": "Front-Wheel Drive (FWD)",
          "features": {
            "entertainment": "Standard stereo system\\n7\\" display",
            "convenience": "Basic voice command\\nAir conditioning",
            "packages": "Standard cloth seating"
          },
          "images": [
            "thortonColbyRental",
            "thortonColbyRental2"
          ],
          "dailyCost": "25"
        },
        {
          "carName": "Mizutani Hozuki",
          "interior": "Black/White",
          "exterior": "Metallic Silver",
          "engine": "4-speed automatic",
          "horsepower": "200 HP",
          "mileage": "38 MPG",
          "transmission": "4-speed automatic",
          "driveType": "Front-Wheel Drive (FWD)",
          "features": {
            "entertainment": "Basic stereo system\\n6\\" display",
            "convenience": "Basic air conditioning\\nRear parking sensors",
            "packages": "Standard features with no additional packages"
          },
          "images": [
            "mizutaniHozukiRental",
            "mizutaniHozukiRental2"
          ],
          "dailyCost": "32"
        },
        {
          "carName": "Mizutani Shion",
          "interior": "Dark Red",
          "exterior": "White",
          "engine": "6-speed automatic with sport mode",
          "horsepower": "320 HP",
          "mileage": "28 MPG",
          "transmission": "6-speed automatic",
          "driveType": "All-Wheel Drive (AWD)",
          "features": {
            "entertainment": "9-speaker sound system\\n10\\" display",
            "convenience": "AI-assisted voice controls\\nHeated seats",
            "packages": "Luxury package with premium leather"
          },
          "images": [
            "mizutaniShionRental",
            "mizutaniShionRental2"
          ],
          "dailyCost": "39"
        }
      ]
    }
    """
}
