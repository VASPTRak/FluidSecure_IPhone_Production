//
//  Last10Transactions.swift
//  FuelSecure
//
//  Created by VASP on 1/4/19.
//  Copyright © 2019 VASP. All rights reserved.
//

import UIKit

class Last10Transactions
{
    var Transaction_id = ""
    var Pulses = ""
    var FuelQuantity = ""

    init(Transaction_id :String,Pulses:String,FuelQuantity:String) {

        self.Transaction_id = Transaction_id
        self.Pulses = Pulses
        self.FuelQuantity = FuelQuantity

    }
}
