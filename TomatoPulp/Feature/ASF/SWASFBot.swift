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
    
    
    /// AcceptGifts —— bool 类型，默认值为 false。当启用的时候，ASF 会帮该机器人自动接收和激活所有 Steam 礼物。甚至会接收不包含在 SteamUserPermissions 中设置的用户的礼物。本功能建议只为小号开启，因为你可能并不想让主账户激活发送过来的所有礼物。需要注意，通过电子邮件发送的礼物，并不会直接经过客户端，所以 ASF 不会自动接收（除非你额外干预），因此应该直接向账户发送 Steam 礼物。如果你不确定是否要启用本功能，那么请将本字段保持默认值 false。
    var AcceptGifts: Bool = false
    
    /// AutoSteamSaleEvent —— bool 类型，默认值为 false。我们知道，在 Steam 夏季/冬季促销时，可以通过每天探索队列或者为 Steam 奖项投票来获取额外的节日集换式卡牌。当启用本功能时，每 6 隔小时 ASF 会检查你的队列和 Steam 奖项投票，如果未完成，则 ASF 会自动帮你完成。如果你想要亲自完成这些内容，那么不建议你开启本功能。所以本功能对于小号会非常有用。除此之外，如果你想得到这些卡牌，需要你的账户等级达到了 8 级。如果你不确定是否要启用本功能，那么请将本字段保持默认值 false。
    var AutoSteamSaleEvent: Bool = false

    
    /// BotBehaviour —— byte flags 类型，默认值为 0。本字段定义了在各种情形下 ASF 机器人的行为。可定义的行为有以下几种：
    /*
    值    行为名称    行为描述
    0    None    机器人没有特殊的行为，侵入性最小的模式，默认值
    1    RejectInvalidFriendInvites    ASF 会拒绝（不是忽略）无效的好友请求
    2    RejectInvalidTrades    ASF 会拒绝（不是忽略）无效的交易报价
    4    RejectInvalidGroupInvites    ASF 会拒绝（不是忽略）无效的组邀请
    8    DismissInventoryNotifications    ASF 会自动关闭所有库存通知
    */
    var BotBehaviour: Int = 0
    
    /// CustomGamePlayedWhileFarming —— string 类型，默认值为 null。在 ASF 挂卡的时候，可以自定义正在游玩的信息为“非 Steam 游戏中：CustomGamePlayedWhileFarming”，而不显示当前正在挂卡的游戏名。本功能可以在你不想更改默认的 OnlineStatus 时，告诉你的好友你正在挂卡。需要注意 ASF 并不能保证 Steam 网络实际展示的顺序，因此它可能并不能正地的显示。默认值 null 为停用此功能。
    var CustomGamePlayedWhileFarming: String?
    
    /// CustomGamePlayedWhileIdle —— string 类型，默认值为 null。与 CustomGamePlayedWhileFarming 类似，但是本字段是在 ASF 空闲的时候（账户无卡可挂的时候）显示。默认值 null 为停用此功能。
    var CustomGamePlayedWhileIdle : String?
    
    /// Enabled —— bool 类型，默认值为 false。本字段定义了是否启用本机器人。如果设置为 true，在 ASF 程序启动的时候会自动启动本机器人。如果设置成 false 则需要手动启动机器人。默认所有机器人都不自动启动，所以需要将所有想要自动启动的机器人的本字段设置成 true。
    var Enabled: Bool = false

//    var FilePath: String = ""
    var FileName: String = ""
    
    /*
     FarmingOrders —— HashSet<byte> 类型，默认值为空。本字段定义了 ASF 对此机器人的 首选 挂卡顺序。目前 ASF 支持以下这几种挂卡顺序：
     
     值    挂卡顺序名称    挂卡顺序描述
     0    Unordered    不进行排序，略微提升 CPU 性能
     1    AppIDsAscending    尝试优先挂 appID 较小的游戏
     2    AppIDsDescending    尝试优先挂 appID 较大的游戏
     3    CardDropsAscending    尝试优先挂剩余卡牌掉落数较少的游戏
     4    CardDropsDescending    尝试优先挂剩余卡牌掉落数较多的游戏
     5    HoursAscending    尝试优先挂剩余挂卡时长较短的游戏
     6    HoursDescending    尝试优先挂剩余挂卡时长较长的游戏
     7    NamesAscending    尝试按游戏名称字母排序，从 A 开始
     8    NamesDescending    尝试按游戏名称字母排序，从 Z 开始
     9    Random    尝试完全随机顺序挂卡（每次运行程序顺序都不一样）
     10    BadgeLevelsAscending    尝试优先挂徽章等级低的游戏
     11    BadgeLevelsDescending    尝试优先挂徽章等级高的游戏
     12    RedeemDateTimesAscending    尝试优先挂先激活的游戏
     13    RedeemDateTimesDescending    尝试优先挂后激活的游戏
     14    MarketableAscending    尝试优先挂不可交易卡牌的游戏
     15    MarketableDescending    尝试优先挂可交易卡牌的游戏
 */
    var FarmingOrders: Set<Int>?
    
    /// GamesPlayedWhileIdle —— HashSet<uint> 类型，默认值为空。当 ASF 空闲的时候（没有可挂卡的游戏），它可以游玩你指定的这些游戏（appID）。这样可以增加你指定的这些游戏的游玩时长，别无它用。本字段功能可以和 CustomGamePlayedWhileIdle 字段功能同时启用。这样既可以挂你指定游戏的游玩时长，还可以显示自定义的 Steam 状态。但是某些情况下，如设置了
    var GamesPlayedWhileIdle: Set<UInt>?

    /// HandleOfflineMessages —— bool 类型，默认值为 false。当 OnlineStatus 字段设置成 Offline 时，机器人会因为没有登录到 Steam 社区，而无法接收到指令消息。为了解决这个问题，ASF 可以通过启用本字段支持 Steam 离线消息。如果你的小号 OnlineStatus 字段设置成 Offline，你可以考虑将本字段设置成 true 来接收指令信息并做出响应。需要注意的是，本功能基于 Steam 的离线消息机制，接收到的消息会自动标记为已读，因此不建议为主账户设置本字段。因为 ASF 会强制读取所有离线消息并标记为已读 —— 这不仅会处理 ASF 指令，还会影响到你朋友发来的离线消息。
    var HandleOfflineMessages: Bool = false

    /// HoursUntilCardDrops —— byte 类型，默认值为 3。本字段定义了你的账户是否有卡牌掉落限制，如果账户有卡牌掉落限制的话，初始时长是多少小时。卡牌掉落限制是指，你的所有可挂卡的游戏必须至少游玩 HoursUntilCardDrops 小时才会掉落卡牌。不幸的是，我们没有办法检测你的账户是否有卡牌掉落限制，所以 ASF 只能听从你的设置。本字段也决定了使用何种挂卡算法。正确设置本字段能将利益最大会并且会减少挂卡时间。对于如何设置本字段没有非常明确的评断标准，因为这完全取决于你的 Steam 账户。似乎注册年限较长且从未申请退款的账户没有卡牌掉落限制，所以这些账户应当将本字段值设置成 0。而新注册的账户，或有过退款申请的账户有卡牌掉落限制，这些账户应当将本字段设置成 3。当然，这仅仅是一个猜测，并不是一个准确的评判标准。本字段的默认值是基于大多数用户使用情况而设置的。
    var HoursUntilCardDrops: Int = 0

    /// IdlePriorityQueueOnly —— bool 类型，默认值为 false。本字段定义了 ASF 是否只挂你使用 iq 指令添加到优先挂卡队列里的游戏。当启用本选项时，ASF 会自动跳过所有未在优先挂卡队列里的游戏，只会挂你挑出来的游戏。需要注意，如果你没有在有限挂卡队列中添加任何游戏，那么 ASF 什么都不会做。如果你不确定是否启用本功能，请将本字段保持默认值 false。
    var IdlePriorityQueueOnly: Bool = false
    
    /// IdleRefundableGames —— bool 类型，默认值为 true。本字段定义了是否允许 ASF 挂还可以退款的游戏。可退款的游戏指通过 Steam 商店购买不超过 2 周，且游玩时长不超过 2 小时的游戏，参见Steam 退款政策。默认值设置成 true，ASF 完全无视退款政策，对所有游戏进行挂卡，大多数用户也希望这样。但是，如果你不想让 ASF 挂那些还可以退款的游戏，可以将本字段值设置成 false，这可以让你自己下载游玩并考虑是否需要退款，而不用担心 ASF 挂卡影响你退款。还需要注意，如果你禁用本功能，你在 Steam 商店购买的游戏 14 天内 ASF 不会自动挂卡。如果你不确定是否启用本功能，请将本字段保持默认值 true。
    var IdleRefundableGames:Bool = false
    

    
    /// LootableTypes —— HashSet<byte> 类型，默认值为 1, 3, 5 三种 Steam 物品类型。本字段定义了 ASF 在搜刮机器人物品时的行为 —— 包括手动搜刮和自动搜刮。ASF 只会从小号库存中搜刮 LootableTypes 中指定类型的物品发送报价。因此，本字段可以让你你指定你想要从小号发给主账户的物品种类。
    /*
    值    物品种类名称    物品种类描述
    0    Unknown    不是下面列出的任何一种类型
    1    BoosterPack    未拆开的补充包
    2    Emoticon    Steam 聊天中使用的表情
    3    FoilTradingCard    闪亮的集换式卡牌
    4    ProfileBackground    Steam 个人资料背景
    5    TradingCard    Steam 集换式卡牌（非闪卡）
    6    SteamGems    可用于制作补充包的宝珠和宝珠袋
 */
    var LootableTypes: Set<Int>?
    
    
    /// MatchableTypes —— HashSet<byte> 类型，默认值为 5 一种 Steam 物品类型。本字段定义了当 TradingPreferences 字段包含 SteamTradeMatcher 选项时，ASF 允许匹配的 Steam 物品类型。物品类型定义如下：
    /*
    值    物品种类名称    物品种类描述
    0    Unknown    不是下面列出的任何一种类型
    1    BoosterPack    未拆开的补充包
    2    Emoticon    Steam 聊天中使用的表情
    3    FoilTradingCard    闪亮的集换式卡牌
    4    ProfileBackground    Steam 个人资料背景
    5    TradingCard    Steam 集换式卡牌（非闪卡）
    6    SteamGems    可用于制作补充包的宝珠和宝珠袋
 */
    var MatchableTypes: Set<Int>?

    
    /// OnlineStatus —— byte 类型，默认值为 1。本字段定义了在机器人登录 Steam 网络后的 Steam 社区显示的状态。目前你可以从下列状态中选择：
    /*
    值    状态名称    状态描述
    0    Offline    离线
    1    Online    在线
    2    Busy    忙碌
    3    Away    离开
    4    Snooze    打盹
    5    LookingToTrade    想要交易
    6    LookingToPlay    想要游戏
    7    Invisible    隐身
 */
    var OnlineStatus: Int = 0

    /// PasswordFormat —— byte 类型，默认值为 0。本字段定义了 SteamPassword 账户密码的格式。目前支持的格式有 —— 0 为 PlainText 纯文本，1 为 AES 加密格式，2 为 ProtectedDataForCurrentUser 仅限当前操作系统用户使用。如果你想了解更多内容，请参阅安全一章。一定要确保 SteamPassword 字段值与 PasswordFormat 字段值相匹配。也就是说，在你更改 PasswordFormat 之前，SteamPassword 就 已经 更改成那种密码格式。除非你清楚你在做什么，否则请将本字段值保持默认值 0。
    var PasswordFormat: Int = 0

    /// Paused —— bool 类型，默认值为 false。本字段定义了 CardsFarmer 挂卡模块的初始状态，默认值 false，机器人会在 Enable 或者 start 指令启动机器人的时候自动开始挂卡。如果你想手动使用 resume 指令来开始挂卡，可以将本字段值设置为 true。例如，你只想用 play 指令来运行你指定的游戏，并且不想使用自动 CardsFarmer 挂卡模块。将本字段值设置成 true 和执行 pause 指令效果完全相同。如果你不确定是否启用本功能，请将本字段保持默认值 false。
    var Paused:Bool = false
    
    
    /// RedeemingPreferences —— byte flags 类型，默认值为 0。本字段定义了 ASF 在激活 CD-Key 时的行为。有以下几种行为：
    /*
    值    行为名称    行为描述
    0    None    无激活偏好
    1    Forwarding    将不可用的 CD-Key 转发给其它机器人
    2    Distributing    将所有的 CD-Key 分发给包括自己在内的所有机器人
    4    KeepMissingGames    转发时保留可能没有的游戏 CD-Key
 */
    var RedeemingPreferences: Int = 0
    
    /// SendOnFarmingFinished —— bool 类型，默认值为 false。当 ASF 完成了本机器人的挂卡，会将所有挂卡所得自动发送给对其有 Master 权限的账户。这在你不想每次完成挂卡都手动发送报价时非常方便。本字段和 loot 指令工作原理相同，因此它需要设置 Master 权限账户，其中要包括有交易资格的帐号，此外还可能需要正确设置 SteamTradeToken Steam 交易令牌。除了在完成挂卡后进行 loot 搜刮，在每次库存内添加物品通知（不是挂卡时的物品通知）的时候也会进行 loot 搜刮，并且每次完成交易后有新物品时也会进行搜刮。在想要“转发”从他人那里收到的礼物到我们的主账户的情况下，本功能非常有用。我们也强烈建议与 ASF 2FA 一同使用，这样不用手动确认就可以自动完成交易。如果你不确定如何设置本字段，请将本字段保持默认值 false。
    var SendOnFarmingFinished: Bool = false

    /// SendTradePeriod —— byte 类型，默认值为 0。本字段类似于 SendOnFarmingFinished 挂卡完毕后发送报价，但是有一个地方不同 —— 不是在挂卡结束后发送报价，而是不管我们还剩余多少卡需要挂，每过 SendTradePeriod 小时就向主账户发送报价。本字段适用于不等到小号挂完卡就经常 loot 搜刮的情况。默认值 0 就是禁用此功能。例如，如果你想让你的机器人每天都向你发送一次报价，就可以将本字段值设置成 24。同样我们强烈建议与 ASF 2FA 一同使用，这样不用手动确认就可以自动完成交易。如果你不确定如何设置本字段，请将本字段保持默认值 0。
    var SendTradePeriod: Int = 0
    
    /// SteamLogin - string type with default value of null. This property defines your steam login - the one you use for logging in to steam. In addition to defining steam login here, you may also keep default value of null if you want to enter your steam login on each ASF startup instead of putting it in the config. This may be useful for you if you don't want to save sensitive data in config file.
    var SteamLogin: String?
    
    /// SteamPassword - string type with default value of null. This property defines your steam password - the one you use for logging in to steam. In addition to defining steam password here, you may also keep default value of null if you want to enter your steam password on each ASF startup instead of putting it in the config. This may be useful for you if you don't want to save sensitive data in config file.
    var SteamPassword: String?
    
    /// SteamTradeToken - string type with default value of null. When you have your bot on your friend list, then bot can send a trade to you right away without worrying about trade token, therefore you can leave this property at default value of null. If you however decide to NOT have your bot on your friend list, then you will need to generate and fill a trade token as the user that this bot is expecting to send trades to. In other words, this property should be filled with trade token of the account that is defined with Master permission in SteamUserPermissions of this bot instance.
    var SteamTradeToken: String?
    
    /// SteamUserPermissions - Dictionary<ulong, byte> type with default value of being empty. This property is a dictionary property which maps given Steam user identified by his 64-bit steam ID, to byte number that specifies his permission in ASF instance. Currently available bot permissions in ASF are defined as:
    /*
    Value    Name    Description
    0    None    No permission, this is mainly a reference value that is assigned to steam IDs missing in this dictionary - there is no need to define anybody with this permission
    1    FamilySharing    Provides minimum access for family sharing users. Once again, this is mainly a reference value since ASF is capable of automatically discovering steam IDs that we permitted for using our library
    2    Operator    Provides basic access to given bot instances, mainly adding licenses and redeeming keys
    3    Master    Provides full access to given bot instance
 */
    var SteamUserPermissions: Dictionary<String, Int>?
    
    /// SteamMasterClanID - ulong type with default value of 0. This property defines the steamID of the steam group that bot should automatically join, including group chat. You can check steamID of your group by navigating to its page, then adding /memberslistxml?xml=1 to the end of the link, so the link will look like this. Then you can get steamID of your group from the result, it's in <groupID64> tag. In above example it would be 103582791440160998. If you don't have any "farm group" for your bots, you should keep it at default.
    var SteamMasterClanID: Int64 = 0
    
    /// SteamParentalPIN - string type with default value of 0. This property defines your steam parental PIN. ASF requires an access to resources protected by steam parental, therefore if you use that feature, you need to provide ASF with parental unlock PIN, so it can operate normally. Default value of 0 means that there is no steam parental PIN required to unlock this account, and this is probably what you want if you don't use steam parental functionality. In addition to defining steam parental PIN here, you may also use value of null if you want to enter your steam parental PIN on each ASF startup instead of putting it in the config. This may be useful for you if you don't want to save sensitive data in config file.
    var SteamParentalPIN: String?
    
    /// ShutdownOnFarmingFinished - bool type with default value of false. ASF is "occupying" an account for the whole time of process being active. When given account is done with farming, ASF periodically checks it (every IdleFarmingPeriod hours), if perhaps some new games with steam cards were added in the meantime, so it can resume farming of that account without a need to restart the process. This is useful for majority of people, as ASF can automatically resume farming when needed. However, you may actually want to stop the process when given account is fully farmed, you can achieve that by setting this property to true. When enabled, ASF will proceed with logging off when account is fully farmed, which means that it won't be periodically checked or occupied anymore. You should decide yourself if you prefer ASF to work on given bot instance for the whole time, or if perhaps ASF should stop it when farming process is done. When all accounts are stopped and process is not running in --process-required mode, ASF will shutdown as well. If you're not sure how to set this property, leave it with default value of false.
    var ShutdownOnFarmingFinished: Bool = false
    
    /// UseLoginKeys - bool type with default value of true. This property defines if ASF should use login keys mechanism for this Steam account. Login keys mechanism works very similar to official Steam client's "remember me" option, which makes it possible for ASF to store and use temporary one-time use login key for next logon attempt, effectively skipping a need of providing password, Steam Guard or 2FA code as long as our login key is valid. Login key is stored in BotName.db file and updated automatically. This is why you don't need to provide password/SteamGuard/2FA code after logging in successfully with ASF just once.
    var UseLoginKeys:Bool = true
    
    /// TradingPreferences - byte flags type with default value of 0. This property defines ASF behaviour when in trading, and is defined as below:
    /*
    Value    Name    Description
    0    None    No trading preferences - accepts only Master trades
    1    AcceptDonations    Accepts trades in which we're not losing anything
    2    SteamTradeMatcher    Accepts dupes-matching STM-like trades. Visit trading for more info
    4    MatchEverything    Requires SteamTradeMatcher to be set, and in combination with it - also accepts bad trades in addition to good and neutral ones
    8    DontAcceptBotTrades    Doesn't automatically accept loot trades from other bot instances
 */
    var TradingPreferences: Int = 0
    
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
