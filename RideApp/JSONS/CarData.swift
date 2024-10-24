//
//  CarData.swift
//  RideApp
//
//  Created by Jacob Rangel on 10/22/24.
//

import Foundation

struct CarData {
    static let jsonString =
    """
    {
      "cars": [
        {
          "carName": "Herrera Riptide - Terrier",
          "carType": "Coupe",
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
            "herreraRiptide",
            "herreraRiptide2",
            "herreraRiptide3",
            "herreraRiptide4"
          ],
          "dailyCost": "74"
        },
        {
          "carName": "Quadra Type 66 - Avenger",
          "carType": "Coupe",
          "interior": "Black/Red",
          "exterior": "Matte Silver",
          "engine": "7-speed manual transmission",
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
            "quadraType66",
            "quadraType66_2",
            "quadraType66_3",
            "quadraType66_4",

          ],
          "dailyCost": "68"
        },
        {
          "carName": "Thorton Colby CX410",
          "carType": "Truck",
          "interior": "Gray/Brown",
          "exterior": "Metallic Green",
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
            "thortonColby",
            "thortonColby2",
            "thortonColby3",
            "thortonColby4"


          ],
          "dailyCost": "25"
        },
        {
          "carName": "Mizutani Hozuki",
          "carType": "Coupe",
          "interior": "Black",
          "exterior": "Green/Red",
          "engine": "5-speed automatic",
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
            "mizutaniHozuki",
            "mizutaniHozuki2",
            "mizutaniHozuki3",
            "mizutaniHozuki4"
          ],
          "dailyCost": "32"
        },
        {
          "carName": "Quadra Sport R-7",
          "carType": "Coupe",
          "interior": "Black/Yellow",
          "exterior": "Yellow/Grey",
          "engine": "7-speed automatic with paddle shifters",
          "horsepower": "550 HP",
          "mileage": "20 MPG",
          "transmission": "7-speed automatic",
          "driveType": "Rear-Wheel Drive (RWD)",
          "features": {
            "entertainment": "Premium sound system\\n12\\" touchscreen display",
            "convenience": "Advanced voice commands\\nDual-zone climate control\\nHeated and ventilated seats",
            "packages": "Sport package with enhanced suspension\\nAerodynamic body kit"
          },
          "images": [
            "quadraSportR7"
          ],
          "dailyCost": "85"
        },
        {
          "carName": "Mizutani Shion",
          "carType": "Coupe",
          "interior": "Black",
          "exterior": "Grey/Yellow",
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
            "mizutaniShion",
            "mizutaniShion2",
            "mizutaniShion3",
            "mizutaniShion4"
          ],
          "dailyCost": "39"
        },
        {
          "carName": "Chevillion Thrax - Jefferson",
          "carType": "Sedan",
          "interior": "Black",
          "exterior": "Black",
          "engine": "7-speed automatic with manual shift",
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
            "chevillionThrax",
            "chevillionThrax2"
          ],
          "dailyCost": "64"
        },
        {
          "carName": "Porsche 911 Turbo",
          "carType": "Coupe",
          "interior": "Black",
          "exterior": "Silver/Red",
          "engine": "3.7L Twin-Turbo H6",
          "horsepower": "572 HP",
          "mileage": "24 MPG",
          "transmission": "8-speed automatic",
          "driveType": "All-Wheel Drive (AWD)",
          "features": {
            "entertainment": "Bose Surround Sound System\\n12.3\\" touchscreen",
            "convenience": "Heated & ventilated seats\\nAdaptive cruise control",
            "packages": "Sport package\\nPremium leather interior"
          },
          "images": [
            "porsche911Turbo",
            "porsche911Turbo2",
            "porsche911Turbo3",
            "porsche911Turbo4"
          ],
          "dailyCost": "150"
        },
        {
          "carName": "Archer Quartz - Bandit",
          "carType": "Sedan",
          "interior": "Tan",
          "exterior": "Matte Orange",
          "engine": "5.0L V8",
          "horsepower": "400 HP",
          "mileage": "20 MPG",
          "transmission": "6-speed automatic",
          "driveType": "Four-Wheel Drive (4WD)",
          "features": {
            "entertainment": "10-speaker system\\n10.1\\" display",
            "convenience": "Off-road navigation system\\nPanoramic sunroof",
            "packages": "Off-road package\\nRugged terrain tires"
          },
          "images": [
            "archerQuartzBandit"
          ],
          "dailyCost": "85"
        },
        {
          "carName": "Quadra Turbo-R",
          "carType": "Coupe",
          "interior": "Black",
          "exterior": "Blood Orange",
          "engine": "Twin-Turbo V10",
          "horsepower": "700 HP",
          "mileage": "15 MPG",
          "transmission": "7-speed dual-clutch",
          "driveType": "Rear-Wheel Drive (RWD)",
          "features": {
            "entertainment": "14-speaker surround\\nVirtual cockpit",
            "convenience": "AI-enhanced driver assist\\nActive suspension",
            "packages": "Track package\\nPerformance exhaust"
          },
          "images": [
            "quadraTurboR",
            "quadraTurboR2"
          ],
          "dailyCost": "120"
        },
        {
          "carName": "Archer Quartz EC-L",
          "carType": "Sedan",
          "interior": "Black/Grey",
          "exterior": "Blue/Black",
          "engine": "2.0L Hybrid",
          "horsepower": "250 HP",
          "mileage": "45 MPG",
          "transmission": "CVT",
          "driveType": "Front-Wheel Drive (FWD)",
          "features": {
            "entertainment": "9-speaker stereo\\n8.8\\" touchscreen",
            "convenience": "Wireless charging\\nRemote start",
            "packages": "Eco package\\nComfort seating"
          },
          "images": [
            "archerQuartzECL",
            "archerQuartzECL2"
          ],
          "dailyCost": "50"
        },
        {
          "carName": "Cortes V5000 Valor",
          "carType": "Sedan",
          "interior": "Grey",
          "exterior": "Purple",
          "engine": "6.2L V8",
          "horsepower": "450 HP",
          "mileage": "18 MPG",
          "transmission": "8-speed automatic",
          "driveType": "Four-Wheel Drive (4WD)",
          "features": {
            "entertainment": "12-speaker sound system\\n9\\" display",
            "convenience": "Military-grade durability\\nAdaptive terrain response",
            "packages": "Armor package\\nNight vision"
          },
          "images": [
            "cortesV5000Valor"
          ],
          "dailyCost": "110"
        }
      ]
    }
    """
}
