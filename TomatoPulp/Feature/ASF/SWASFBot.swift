//
//  SWASFBot.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/1/13.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit

import HandyJSON

class SWASFBot: HandyJSON {
    
    var AutoSteamSaleEvent: Bool = false
    var AcceptGifts: Bool = false
    
    var BotBehaviour: Int = 0
    
    var CustomGamePlayedWhileIdle : String?
    var CustomGamePlayedWhileFarming: String?
    
    var Enabled: Bool = false

    var filepath: String?
    var filename: String?
    var FarmingOrders: Array<Int>?
    
    var GamesPlayedWhileIdle: Array<Int>?

    var HoursUntilCardDrops: Int = 0

    var IdlePriorityQueueOnly: Bool = false
    var IdleRefundableGames:Bool = false

    var LootableTypes: Array<Int>?
    var MatchableTypes: Array<Int>?

    var OnlineStatus: Int = 0
   
    var SteamLogin: String?
    var SteamPassword: String?
    var SteamTradeToken: String?
    var SteamUserPermissions: Dictionary<String, Int>?
    var SteamMasterClanID: Int64 = 0
    var SteamParentalPIN: String?
   
    var SendTradePeriod: Int = 0
    var SendOnFarmingFinished: Bool = false
    var ShutdownOnFarmingFinished: Bool = false
    
    var UseLoginKeys:Bool = false
    
    var Paused:Bool = false
    var PasswordFormat: Int = 0

    var TradingPreferences: Int = 0
    var RedeemingPreferences: Int = 0
    
    required init() {}
}

/*

 "SteamTradeToken":null,
 "CustomGamePlayedWhileIdle":null,
 "IdlePriorityQueueOnly":false,
 "CustomGamePlayedWhileFarming":null,
 "SendOnFarmingFinished":true,
 "SteamUserPermissions":{"76561198193152589":3},
 "SteamLogin":"steam10446627",
 "filepath":"/root/ArchiSteamFarm/asf_linux/config/steam10446627.json",
 "PasswordFormat":0,
 "GamesPlayedWhileIdle":[578080],
 "ShutdownOnFarmingFinished":false,
 "Paused":false,
 "AutoSteamSaleEvent":true,
 "BotBehaviour":0,
 "HoursUntilCardDrops":3,
 "SteamPassword":"Swing.1993",
 "IdleRefundableGames":true,
 "LootableTypes":[1,3,5],
 "FarmingOrders":[],
 "OnlineStatus":1,
 "SendTradePeriod":23,
 "Enabled":true,
 "MatchableTypes":[5],
 "AcceptGifts":true,
 "UseLoginKeys":true,
 "filename":"steam10446627.json",
 "SteamMasterClanID":103582791463387376,
 "SteamParentalPIN":"0",
 "TradingPreferences":0,
 "RedeemingPreferences":0
 */
