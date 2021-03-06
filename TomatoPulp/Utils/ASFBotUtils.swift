//
//  ASFBotUtils.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/1/15.
//  Copyright © 2019 songguohua. All rights reserved.
//

import Foundation

extension SWASF {
    
    static func printDesc(key: String) -> String {
        var result: String = ""
        switch key {
        case "AutoRestart":
            result = "AutoRestart —— bool 类型，默认值为 true。本字段定义了是否允许 ASF 在需要的时候自己重新启动。ASF 在更新时（UpdatePeriod 触发或者执行 update 指令）和 ASF.json 全局设置文件改动的时候会重启，就像执行 restart 指令一样。一般地，重启包括两个过程 —— 创建新的进程，结束当前进程。对于大多数用户将本字段设置成 true 即可，然而 —— 如果你使用你自己的脚本控制 ASF 或使用 dotnet 命令启动，你需要控制启动 ASF 的进程（ASF 的父进程）来完全控制 ASF。这时就要避免例如 ASF 在后台默默运行并且没有在脚本的前台显示出来，而又启动（或重启）了一个 ASF 导致同旧的 ASF 进程一起停止运行的情况。考虑到新的进程不再是直接子进程，这样你就不能再为其使用标准的控制台输入。"
            
        case "Blacklist":
            result = "Blacklist —— HashSet<uint> 类型，默认值为空。就像字段名一样，本字段定义了一些全局的 appID（游戏）黑名单，这些 appID 会在 ASF 自动挂卡的时候忽略掉。有趣的是，Steam 喜欢把夏促和冬促的徽章 appID 设置成 “可掉落卡牌”，这会误导 ASF 认为这个 appID 是一个可以掉落卡牌的游戏。如果没有将这些 appID 添加进 Blacklist ASF 可能会一直挂一个不存在游戏的卡。ASF 的黑名单就是为了标记这些不能挂卡的 appID，在决定挂什么的时候忽略它们，避免落入陷阱"
            
        case "ConfirmationsLimiterDelay":
            result = "ConfirmationsLimiterDelay —— byte 类型，默认值为 10。通常，Steam 网络会对类似的请求有的速率限制，被限制后会阻止提供服务。因此我们必须添加一些额外的延迟，防止触发速率限制。ASF 会确保连续的两个 2FA 确认请求之间，至少有 ConfirmationsLimiterDelay 秒的间隔 —— 本字段被用于 ASF 2FA 中，例如 2faok 指令，同样也用于各种交易相关操作之间。默认值是基于我们的测试而设置的，如果你不想在使用 ASF 过程中遇到问题，就不要将其值设置得更低。除非你有 非常 充分的理由修改本字段，请将本字段保持默认。"
            
        case "ConnectionTimeout":
            result = "ConnectionTimeout —— byte 类型，默认值为 60。本字段定义了 ASF 各种网络操作的超时，单位为秒。特别地，ConnectionTimeout 定义了 HTTP 和 IPC 请求的超时，ConnectionTimeout / 10 定义了心跳检测失败的最大数，ConnectionTimeout / 30 定义了多少分钟后我们重新初始化 Steam 网络的连接。默认值 60 适合绝大多数人，然而如果你的电脑网络连接很慢，你可能需要将本字段设置更大一些 (比如 90)。需要注意，设置更大的数值并不意味着可以解决任何网络缓慢甚至无法接入 Steam 服务器的问题，所以我们不应该无限制的等待根本不会发生的事情，而是晚点再试一次就可以了。将本字段值设置地过高会在遇到网络问题时有更高的延迟，同样会降低程序的整体性能。而将本字段值设置地过低同样会降低程序整体的稳定性和性能，ASF 可能会忽略掉一个正在处理的有效请求。因此本字段值设置过低并没有什么好处，因为 Steam 服务器有时会较慢，它需要花更多的时间来处理 ASF 的请求。默认值是权衡我们网络连接稳定性和 Steam 网络处理请求能力而设置的。如果你想更快地检测处问题，或者让 ASF 重连/响应更快，默认值（或者稍微低一点点，让 ASF 少一点耐心）就可以了。如果你发现 ASF 运行时经常遇到网络问题，如请求失败、心跳包丢失或者 Steam 连接中断，你可能需要增加本字段值。但在增加该值之前，你需要确定出现网络问题 不是 因为你自己的网络问题，而是 Steam 服务器的问题。因为增加超时会让 ASF 更“耐心”，不会立即重连。如果你的网络需要更多的时间来传输数据，也可以增加本字段值。简而言之，默认值适合绝大多数情况，但是你也可以根据自己的需要来增加本字段值。尽管如此，远远超过默认值也没有多大意义，因为更大的超时并不会神奇地修复 Steam 服务器无法访问地问题。除非你有充分的理由编辑本字段值，请将本字段保持默认。"
            
        case "CurrentCulture":
            result = "CurrentCulture —— string 类型，默认值为 null。默认情况下 ASF 会尝试使用所使用的操作系统语言，并且会优先使用在那个语言中被翻译的字符。这个功能得以实现要感谢社区将 ASF 本地化成所有流行的语言。如果出于某种原因，你不想使用操作系统的语言，你可以将此字段值设置成你想要的其它任何有效的语言。你可以访问 MSDN 页面，它的 Language tag 标签页就是可用的本地化语言列表。ASF 支持多种特定的区域选项，例如 en-GB，同样支持中性的区域选项，例如 en。特定的区域选项可能会有不同的区域行为，例如货币和日期格式等。同时需要注意，如果你设置了非内置的区域选项，这些特定的语言文字可能需要额外的字体和语言支持。特别地，如果你不想用你的操作系统的语言，而想让 ASF 使用英语，你就可以通过本字段来实现。"
            
        case "Debug":
            result = "Debug —— bool 类型，默认值为 false。本字段定义了程序是否使用调试模式运行。当程序处于调试模式，ASF 会在 config 文件夹的同级目录创建一个 debug 文件夹来记录 ASF 和 Steam 服务器之间完整的通信日志。这些调试信息可以帮助你准确定位网络问题和了解 ASF 工作流程。此外，一些程序例程会记录得更加详细，例如 WebBrowser 会详细记录某些请求失败的原因是什么 —— 这些记录将会写入正常的 ASF 日志中。如果不是开发者要求，不要启用 Debug 模式。调试模式会 明显降低程序性能、降低程序稳定性 同时 在很多地方会格外详细，所以调试模式 只能 有目的地开启、短时间内使用、调试某个特定的问题、重现程序的问题或者想了解某个错误请求的详细信息。一定 不要 在正常使用时开启调试模式。你在调试模式中会看到 很多 新的错误、问题和异常 —— 如果你想自己弄清楚这些信息，需要你对 ASF、Steam 和这些术语有所了解，并且并不是所有调试日志都有用。"
            
        case "FarmingDelay":
            result = "FarmingDelay —— byte 类型，默认值为 15。为了让ASF正常工作，程序需要每 FarmingDelay 分钟检查一次正在挂卡的游戏，判断其卡牌是否已经完全掉落。将本字段值设置太低会导致短时间内发送大量的 Steam 请求，然而如果设置太高，可能导致 ASF 一直在挂一个已经完全掉落卡牌的游戏，最长会持续 FarmingDelay 分钟。默认值适合绝大多数用户，但是如果你运行了很多很多机器人，你可能要考虑增加本字段值，比如设置成 30 分钟，来防止触发 Steam 请求速率限制。幸运的是 ASF 使用基于事件的机制在每个卡牌掉落时来检查游戏徽章页面，所以通常情况下 我们并不需要设置固定时间间隔来定期检查，然而我们不完全信任 Steam 的网络状况 —— 如果我们过去的 FarmingDelay 分钟内都没有掉落卡牌，我们还是会检查徽章页面（防止 Steam 网络没有通知我们物品掉落或者类似的东西）。假设 Steam 网络正常工作且状态很好，降低本字段值 根本不会提升挂卡速度，反而 提高了网络开销 —— 我们建议不低于默认值 15 分钟。除非你有 非常 充分的理由修改本字段，请将本字段保持默认。"
            
        case "GiftsLimiterDelay":
            result = "GiftsLimiterDelay —— byte 类型，默认值为 1。通常，Steam 网络会对类似的请求有的速率限制，被限制后会阻止提供服务。因此我们必须添加一些额外的延迟，防止触发速率限制。ASF 会在连续的两个礼物/激活Key/请求授权请求之间，保证有 GiftsLimiterDelay 秒的间隔。此外，本字段还会用在请求游戏列表的全局限制中，例如 owns 指令。除非你有 非常 充分的理由修改本字段，请将本字段保持默认。"
            
        case "Headless":
            result = "Headless —— bool 类型，默认值为 false。本字段定义了是否让程序使用无头模式运行。当程序使用无头模式运行，ASF 就认为是在服务器上或者其它非交互环境运行，因此它不会尝试读取关键的账户凭据，例如 2FA 代码、手机令牌代码、密码或者其它需要 ASF 操作的数据，这相当于将 ASF 控制台设置成只读。如果在服务器上运行 ASF，Headless 模式会很有用，因为 ASF 会停止那些请求操作的账户，例如请求输入 2FA 代码。如果在非无头模式下能正常使用，除非你在服务器上运行 ASF 程序，你应该将本字段值保持 false。在无头模式中，任何用户交互都会被拒绝，程序运行时，如果程序启动时你的账户需要你 任何 控制台输入协助（如输入手机令牌代码），程序便会停止该账户。这对于服务器来说非常有用，因为 ASF 可以在请求输入凭据的时候停止账户，而不是一直（无限制地）等待用户输入。启用无头模式允许使用 input 指令来代替正常的控制台输入。如果你不确定如何设置设个字段值，就让它保持默认值 false 就可以了。"
            
        case "IdleFarmingPeriod":
            result = "IdleFarmingPeriod —— byte 类型，默认值为 8。当账户里没有卡可以挂的时候，ASF 会每隔 IdleFarmingPeriod 小时检查一下账户是否有游戏添加了卡牌可以挂。当我们激活或购买新游戏的时候并不需要这个功能，因为当你添加新的游戏时，ASF 会自动检查徽章页，看是否有卡可挂。IdleFarmingPeriod 字段设置主要是用于一些我们已经拥有的老游戏添加集换式卡牌的情况。在这种情况下，并没有触发任何事件来告诉 ASF 有卡可以挂了，所以为了能处理这种情形，ASF 不得不定期检查徽章页面。如果该字段值设置成 0 则禁用该功能。同样可以参阅 ShutdownOnFarmingFinished 字段。"
            
        case "InventoryLimiterDelay":
            result = "InventoryLimiterDelay —— byte 类型，默认值为 3。通常，Steam 网络会对类似的请求有的速率限制，被限制后会阻止提供服务。因此我们必须添加一些额外的延迟，防止触发速率限制。ASF 会确保在连续的两个库存请求之间有 InventoryLimiterDelay 秒的间隔 —— 这个延迟设置只被用于获取你的库存操作中（也只用于此功能）。默认值 3 是根据搜刮 100 个机器人而设置的值，并且适用于绝大多数用户。如果只有几个机器人，你可能想要降低这个值，你甚至想将此字段设置成 0，那么 ASF 将不会刻意设置延迟，获取库存会更加快速。不过还是需要注意，将这个值设置太低 将会 导致 Steam 暂时封禁你的 IP，不让你获取库存。如果你在 ASF 中运行了非常多的机器人并且有非常多的库存请求，你反而还要将本字段设置得比默认值更高。即使在这种情况下你应该尝试限制请求的数量。除非你有 非常 充分的理由修改本字段，请将本字段保持默认。"
            
        case "IPC":
            result = "IPC —— bool 类型，默认值为 false。本字段定义了 ASF 的 IPC 服务是否随程序启动。IPC 允许通过在指定的 IPCPrefixes 上引导本地 HTTP 服务器来进行进程间通信。如果你并不想使用 ASF 的 IPC 服务，那么就没必要启用此选项。"
            
        case "IPCPrefixes":
            result = "IPCPrefixes —— HashSet<string> 类型，默认值为 http://127.0.0.1:1242/。本字段定义了 ASF 在 IPC 接口中使用的 HttpListener 的指定前缀。换句话说，本字段指定了 ASF 的 IPC 监听接收请求的端口。更多有关 HttpListener 前缀的信息，请参阅 MSDN。"
            
        case "LoginLimiterDelay":
            result = "LoginLimiterDelay —— byte 类型，默认值为 10。通常，Steam 网络会对类似的请求有的速率限制，被限制后会阻止提供服务。因此我们必须添加一些额外的延迟，防止触发速率限制。ASF 会保证在两次连续的连接尝试之间，保证至少有 LoginLimiterDelay 秒的间隔。默认值 10 是根据 100 个机器人设置的，并且适用于绝大多数用户。如果只有几个机器人，你可能想要降低这个值，甚至想设置成 0，那么 ASF 将不会刻意设置延迟，这样连接 Steam 会更快。不过还是注意，有很多机器人的情况下将这个值设置的太低 将会 导致 Steam 暂时封禁你的 IP，这时你便无法登录 Steam，并且会产生 InvalidPassword/RateLimitExceeded（错误的密码/超速限制）错误 —— 不仅仅是 ASF，你计算机上正常的 Steam 客户端也无法登录。另外还要注意，本字段值在所有 ASF 计划的操作中被用来负载均衡缓冲，例如 SendTradePeriod 中的交易。除非你有 非常 充分的理由修改本字段，请将本字段保持默认。"
            
        case "MaxFarmingTime":
            result = "MaxFarmingTime —— byte 类型，默认值为 10。我们应该知道，Steam 并不是所有时候都能正常工作，有时候会发生一些奇怪的事情，比如 Steam 不记录我们的游玩时间，即使我们真的在玩游戏。ASF 在单一挂卡模式下只会让一个游戏最多运行 MaxFarmingTime 个小时，运行了这么长时间后，ASF 会认为这个游戏的卡已经挂完了。这会保证不会在某些奇怪的情况下，一直卡在一个游戏上。同样当 Steam 发布了新的夏促/圣诞徽章，这也可以解决一直挂这个徽章的问题（参阅：Blacklist）。默认值 10 小时足够将一个游戏的所有卡挂完。如果该字段值设置过低，可能会导致有的游戏还能掉落卡片就因达到设置的时间上限被跳过了（确实有的游戏需要 9 小时才能挂完所有的卡）。如果该字段值设置过高可能会导致挂卡阻塞。需要注意，本字段只会影响一个游戏在一个会话中的挂卡（所以在完成所有挂卡任务后还是会返回来继续挂它），是根据 ASF 内部统计的挂卡时间计算，而不是根据游戏的总时间判断。"
            
        case "MaxTradeHoldDuration":
            result = "MaxTradeHoldDuration —— byte 类型，默认值为 15。本字段定义了接收交易后，允许交易暂挂的最大天数 —— 暂挂超过 MaxTradeHoldDuration 天的交易 ASF 将会拒绝交易。这个选项只对 TradingPreferences 和 SteamTradeMatcher 类型的机器人有用，并不会影响 Master/SteamOwnerID 类型账户的交易。同样也不会影响捐赠。交易暂挂对任何人来说都很烦，都不愿意和要交易暂挂的人进行交易。ASF 崇尚自由主义和帮助任何人，所以无论交易暂挂与否，都会接受交易 —— 这也是为什么默认值是 15 的原因。然而，如果你想拒绝需要交易暂挂的交易，可以将本字段值设置成 0。将在短时间内过期的卡牌将不受本字段限制的影响，并会自动拒绝所有交易暂挂的交易请求。具体可以参阅交易一节。正因如此，所以没必要因此全局地拒绝所有人。"
            
        case "OptimizationMode":
            result = "OptimizationMode —— byte 类型，默认值为 0。本字段定义了 ASF 在运行时使用哪种优化模式。当前版本的 ASF 支持两种模式 —— 0 代表 MaxPerformance 性能优先模式，1 代表 MinMemoryUsage 低内存占用模式。默认情况下 ASF 会尽量同时处理更多事情，这会通过多核负载均衡、CPU 多线程、多套接字和多线程池任务等方案来提升程序性能。例如，ASF 会在检查是否有游戏可以挂卡的时候，先查询你的徽章的第一页，一旦完成请求，ASF 会读取到你实际有多少徽章页，然后再同时查询每个徽章页。这种模式也 几乎 是你所希望的，因为大多数情况下系统资源开销还是很小的，即使在只有单核 CPU 或者能耗很大老旧硬件上，也可以体验 ASF 异步代码带来的优势。然而，因为要并行处理很多任务，ASF 在运行时就负责维护这些任务，例如，维护套接字保持开启状态、保持线程活动和任务能被及时完成等。这些维护工作会不断增加内存的开销，如果你的可用内存十分有限，你可能需要考虑将该字段设置成 1（MinMemoryUsage，低内存占用模式）。强制让 ASF 执行尽量少的任务，同时将高效的异步的代码以同步的方式执行。在你想要修改本字段之前，建议先阅读一下低内存安装，这样你能够在内存有限的情况下减少些许内存开销，代价是牺牲巨大的性能提升。通常，修改本字段比你能想到的其它方法都要 糟糕，例如你可以限制 ASF 的使用量或者调整运行时的垃圾回收机制。具体原因在低内存安装中进行了解释。因此，只有在你使用其它任何方法都无法达到令你万亿的结果时，才启用 MinMemoryUsage 内存占用模式。"
            
        case "Statistics —— bool 类型，默认值为 true。本字段定义了 ASF 是否启用统计功能。":
            result = "Statistics"

        case "SteamOwnerID":
            result = "SteamOwnerID —— ulong 类型，默认值为 0。本字段定义了 ASF 程序的所有者的 Steam 64 位 ID，与机器人的 Master 权限类似（只不过本字段是全局有效的）。通常你会将本字段值设置成你 Steam 主账户的 64 位 ID。机器人的 Master 权限是指设置的 Steam 账户对该机器人有完全的控制权，但是对于像 exit、restart 和 update 这种全局指令，只有 SteamOwnerID 权限才能执行。这样的话，你想帮你朋友挂卡就会很方便，因为他们并没有控制 ASF 程序的权限，例如他们不能执行 exit 指令来终止 ASF 程序。默认值 0 代表程序没有所有者，没有人可以执行 ASF 全局指令。有一点需要注意，IPC需要设置 SteamOwnerID 才能正常工作，所以你如果你想使用 IPC，则要正确设置本字段值。"
          
        case "SteamProtocols":
            result = "SteamProtocols —— byte flags 类型，默认值为 7。这个字段定义了 ASF 在连接 Steam 服务器的时候使用何种 Steam 传输协议。"
            
        case "UpdateChannel":
            result = "UpdateChannel —— byte 类型，默认值为 1。本字段定义了 ASF 更新程序使用的频道，它被用于自动更新（如果设置 UpdatePeriod 字段值大于 0）和更新通知中。目前 ASF 支持三种更新频道 —— 0 代表 None 无，1 代表 Stable 稳定更新频道，2 代表 Experimental 实验更新频道。Stable 频道是默认的程序发布频道，绝大多数用户都应使用此频道。Experimental 频道是对 Stable 频道的补充，是提供给高级用户体验或给其它开发者测试新功能、发现程序错误和反馈改进的 预览版 程序。预览版程序中往往包含很多未解决的程序错误、正在开发的新功能和程序的重写。 如果你不认为自己是高级用户，请将本字段保持默认值 1（稳定更新频道）。Experimental 频道的程序专门用来让那些知道如何汇报程序错误、能够解决这些问题和能给出反馈建议的用户使用 —— 这个频道的程序不提供技术支持。如果你想了解更多内容，请查阅发行周期一章。如果你不想让程序检查更新，你可以将 UpdateChannel 设置成 0（None），虽然我们并不推荐这样做。当然，你也可能处于某种原因不想收到任何更新通知，将 UpdateChannel 设置成 0 便能完全禁用所有更新的相关功能，包括 update 指令。"
            
        case "UpdatePeriod":
            result = "UpdatePeriod —— byte 类型，默认值为 24。本字段定义了 ASF 检查自动更新的频率。更新程序不仅能体验到重要的新功能、修复某些重要的安全问题还会修复程序错误、提高性能、提升稳定性等等。当本字段值大于 0，ASF 便会在新版本发布后，自动下载、替换并在重启（如果允许 AutoRestart 的话）。为了能够自动更新，ASF 会每隔 UpdatePeriod 小时检查我们的 GitHub 仓库，看是否有更新发布。如果本字段设置成 0 则禁止自动更新，但是你仍然可以使用 update 指令触发更新。在你正确设置 UpdateChannel 字段后，可能还想知道如何设置 UpdatePeriod。"
            
        case "WebLimiterDelay":
            result = " WebLimiterDelay —— ushort 类型，默认值为 200。本字段定义了连续两个 Steam 网页服务请求间至少包含 WebLimiterDelay 毫秒的延迟。Steam 使用的 Akamai 内置了速率限制，它限制了一段时间内通过 Akamai 请求的数量。所以要设置本字段来防止触发这一速率限制。正常情况下很难触发 Akamai 的速率限制，但是如果程序任务繁重并且有大量请求队列，导致短时间内不断发送过多的请求，这时就会触发它。"
            
        default:
            result = ""
        }
        
        return result;
    }
    
}

extension SWASFBot {
    
    static func printDesc(key: String) -> String {
        var result: String = ""
        switch key {
        case "AcceptGifts":
            result = "AcceptGifts —— bool 类型，默认值为 false。当启用的时候，ASF 会帮该机器人自动接收和激活所有 Steam 礼物。甚至会接收不包含在 SteamUserPermissions 中设置的用户的礼物。本功能建议只为小号开启，因为你可能并不想让主账户激活发送过来的所有礼物。需要注意，通过电子邮件发送的礼物，并不会直接经过客户端，所以 ASF 不会自动接收（除非你额外干预），因此应该直接向账户发送 Steam 礼物。如果你不确定是否要启用本功能，那么请将本字段保持默认值 false。"
            
        case "AutoSteamSaleEvent":
            result = "AutoSteamSaleEvent —— bool 类型，默认值为 false。我们知道，在 Steam 夏季/冬季促销时，可以通过每天探索队列或者为 Steam 奖项投票来获取额外的节日集换式卡牌。当启用本功能时，每 6 隔小时 ASF 会检查你的队列和 Steam 奖项投票，如果未完成，则 ASF 会自动帮你完成。如果你想要亲自完成这些内容，那么不建议你开启本功能。所以本功能对于小号会非常有用。除此之外，如果你想得到这些卡牌，需要你的账户等级达到了 8 级。如果你不确定是否要启用本功能，那么请将本字段保持默认值 false。"
            
        case "BotBehaviour":
            result = "BotBehaviour —— byte flags 类型，默认值为 0。本字段定义了在各种情形下 ASF 机器人的行为。可定义的行为有以下几种：\n值    行为名称    行为描述\n0    None    机器人没有特殊的行为，侵入性最小的模式，默认值\n1    RejectInvalidFriendInvites    ASF 会拒绝（不是忽略）无效的好友请求\n2    RejectInvalidTrades    ASF 会拒绝（不是忽略）无效的交易报价\n4    RejectInvalidGroupInvites    ASF 会拒绝（不是忽略）无效的组邀请\n8    DismissInventoryNotifications    ASF 会自动关闭所有库存通知"
            
        case "CustomGamePlayedWhileFarming":
            result = "CustomGamePlayedWhileFarming —— string 类型，默认值为 null。在 ASF 挂卡的时候，可以自定义正在游玩的信息为“非 Steam 游戏中：CustomGamePlayedWhileFarming”，而不显示当前正在挂卡的游戏名。本功能可以在你不想更改默认的 OnlineStatus 时，告诉你的好友你正在挂卡。需要注意 ASF 并不能保证 Steam 网络实际展示的顺序，因此它可能并不能正地的显示。默认值 null 为停用此功能。"
            
        case "CustomGamePlayedWhileIdle":
            result = "CustomGamePlayedWhileIdle —— string 类型，默认值为 null。与 CustomGamePlayedWhileFarming 类似，但是本字段是在 ASF 空闲的时候（账户无卡可挂的时候）显示。默认值 null 为停用此功能。"
            
        case "Enabled":
            result = "Enabled —— bool 类型，默认值为 false。本字段定义了是否启用本机器人。如果设置为 true，在 ASF 程序启动的时候会自动启动本机器人。如果设置成 false 则需要手动启动机器人。默认所有机器人都不自动启动，所以需要将所有想要自动启动的机器人的本字段设置成 true。"
            
        case "FarmingOrders":
            result = "FarmingOrders —— HashSet<byte> 类型，默认值为空。本字段定义了 ASF 对此机器人的 首选 挂卡顺序。目前 ASF 支持以下这几种挂卡顺序：\n值    挂卡顺序名称    挂卡顺序描述\n0    Unordered    不进行排序，略微提升 CPU 性能\n1    AppIDsAscending    尝试优先挂 appID 较小的游戏\n2    AppIDsDescending    尝试优先挂 appID 较大的游戏\n3    CardDropsAscending    尝试优先挂剩余卡牌掉落数较少的游戏\n4    CardDropsDescending    尝试优先挂剩余卡牌掉落数较多的游戏\n5    HoursAscending    尝试优先挂剩余挂卡时长较短的游戏\n6    HoursDescending    尝试优先挂剩余挂卡时长较长的游戏\n7    NamesAscending    尝试按游戏名称字母排序，从 A 开始\n8    NamesDescending    尝试按游戏名称字母排序，从 Z 开始\n9    Random    尝试完全随机顺序挂卡（每次运行程序顺序都不一样）\n10    BadgeLevelsAscending    尝试优先挂徽章等级低的游戏\n11    BadgeLevelsDescending    尝试优先挂徽章等级高的游戏\n12    RedeemDateTimesAscending    尝试优先挂先激活的游戏\n13    RedeemDateTimesDescending    尝试优先挂后激活的游戏\n14    MarketableAscending    尝试优先挂不可交易卡牌的游戏\n15    MarketableDescending    尝试优先挂可交易卡牌的游戏"
            
        case "FileName":
            result = "FileName —— String 类型，默认值为 null。\n文件名"
            
        case "GamesPlayedWhileIdle":
            result = "GamesPlayedWhileIdle —— HashSet<uint> 类型，默认值为空。当 ASF 空闲的时候（没有可挂卡的游戏），它可以游玩你指定的这些游戏（appID）。这样可以增加你指定的这些游戏的游玩时长，别无它用。本字段功能可以和 CustomGamePlayedWhileIdle 字段功能同时启用。这样既可以挂你指定游戏的游玩时长，还可以显示自定义的 Steam 状态。"
            
        case "HandleOfflineMessages":
            result = "HandleOfflineMessages —— bool 类型，默认值为 false。当 OnlineStatus 字段设置成 Offline 时，机器人会因为没有登录到 Steam 社区，而无法接收到指令消息。为了解决这个问题，ASF 可以通过启用本字段支持 Steam 离线消息。如果你的小号 OnlineStatus 字段设置成 Offline，你可以考虑将本字段设置成 true 来接收指令信息并做出响应。需要注意的是，本功能基于 Steam 的离线消息机制，接收到的消息会自动标记为已读，因此不建议为主账户设置本字段。因为 ASF 会强制读取所有离线消息并标记为已读 —— 这不仅会处理 ASF 指令，还会影响到你朋友发来的离线消息。"
            
        case "HoursUntilCardDrops":
            result = "HoursUntilCardDrops —— byte 类型，默认值为 3。本字段定义了你的账户是否有卡牌掉落限制，如果账户有卡牌掉落限制的话，初始时长是多少小时。卡牌掉落限制是指，你的所有可挂卡的游戏必须至少游玩 HoursUntilCardDrops 小时才会掉落卡牌。不幸的是，我们没有办法检测你的账户是否有卡牌掉落限制，所以 ASF 只能听从你的设置。本字段也决定了使用何种挂卡算法。正确设置本字段能将利益最大会并且会减少挂卡时间。对于如何设置本字段没有非常明确的评断标准，因为这完全取决于你的 Steam 账户。似乎注册年限较长且从未申请退款的账户没有卡牌掉落限制，所以这些账户应当将本字段值设置成 0。而新注册的账户，或有过退款申请的账户有卡牌掉落限制，这些账户应当将本字段设置成 3。当然，这仅仅是一个猜测，并不是一个准确的评判标准。本字段的默认值是基于大多数用户使用情况而设置的。"
            
        case "IdlePriorityQueueOnly":
            result = "IdlePriorityQueueOnly —— bool 类型，默认值为 false。本字段定义了 ASF 是否只挂你使用 iq 指令添加到优先挂卡队列里的游戏。当启用本选项时，ASF 会自动跳过所有未在优先挂卡队列里的游戏，只会挂你挑出来的游戏。需要注意，如果你没有在有限挂卡队列中添加任何游戏，那么 ASF 什么都不会做。如果你不确定是否启用本功能，请将本字段保持默认值 false。"
            
        case "IdleRefundableGames":
            result = "IdleRefundableGames —— bool 类型，默认值为 true。本字段定义了是否允许 ASF 挂还可以退款的游戏。可退款的游戏指通过 Steam 商店购买不超过 2 周，且游玩时长不超过 2 小时的游戏，参见Steam 退款政策。默认值设置成 true，ASF 完全无视退款政策，对所有游戏进行挂卡，大多数用户也希望这样。但是，如果你不想让 ASF 挂那些还可以退款的游戏，可以将本字段值设置成 false，这可以让你自己下载游玩并考虑是否需要退款，而不用担心 ASF 挂卡影响你退款。还需要注意，如果你禁用本功能，你在 Steam 商店购买的游戏 14 天内 ASF 不会自动挂卡。如果你不确定是否启用本功能，请将本字段保持默认值 true。"
            
        case "LootableTypes":
            result = "LootableTypes —— HashSet<byte> 类型，默认值为 1, 3, 5 三种 Steam 物品类型。本字段定义了 ASF 在搜刮机器人物品时的行为 —— 包括手动搜刮和自动搜刮。ASF 只会从小号库存中搜刮 LootableTypes 中指定类型的物品发送报价。因此，本字段可以让你你指定你想要从小号发给主账户的物品种类。\n值    物品种类名称    物品种类描述\n0    Unknown    不是下面列出的任何一种类型\n1    BoosterPack    未拆开的补充包\n2    Emoticon    Steam 聊天中使用的表情\n3    FoilTradingCard    闪亮的集换式卡牌\n4    ProfileBackground    Steam 个人资料背景\n5    TradingCard    Steam 集换式卡牌（非闪卡）\n6    SteamGems    可用于制作补充包的宝珠和宝珠袋"
            
        case "MatchableTypes":
            result = " MatchableTypes —— HashSet<byte> 类型，默认值为 5 一种 Steam 物品类型。本字段定义了当 TradingPreferences 字段包含 SteamTradeMatcher 选项时，ASF 允许匹配的 Steam 物品类型。物品类型定义如下：\n值    物品种类名称    物品种类描述\n0    Unknown    不是下面列出的任何一种类型\n1    BoosterPack    未拆开的补充包\n2    Emoticon    Steam 聊天中使用的表情\n3    FoilTradingCard    闪亮的集换式卡牌\n4    ProfileBackground    Steam 个人资料背景\n5    TradingCard    Steam 集换式卡牌（非闪卡）\n6    SteamGems    可用于制作补充包的宝珠和宝珠袋"
            
        case "OnlineStatus":
            result = "OnlineStatus —— byte 类型，默认值为 1。本字段定义了在机器人登录 Steam 网络后的 Steam 社区显示的状态。目前你可以从下列状态中选择：\n值    状态名称    状态描述\n0    Offline    离线\n1    Online    在线\n2    Busy    忙碌\n3    Away    离开\n4    Snooze    打盹\n5    LookingToTrade    想要交易\n6    LookingToPlay    想要游戏\n7    Invisible    隐身"
            
        case "PasswordFormat":
            result = "PasswordFormat —— byte 类型，默认值为 0。本字段定义了 SteamPassword 账户密码的格式。目前支持的格式有 —— 0 为 PlainText 纯文本，1 为 AES 加密格式，2 为 ProtectedDataForCurrentUser 仅限当前操作系统用户使用。如果你想了解更多内容，请参阅安全一章。一定要确保 SteamPassword 字段值与 PasswordFormat 字段值相匹配。也就是说，在你更改 PasswordFormat 之前，SteamPassword 就 已经 更改成那种密码格式。除非你清楚你在做什么，否则请将本字段值保持默认值 0。"
            
        case "Paused":
            result = "Paused —— bool 类型，默认值为 false。本字段定义了 CardsFarmer 挂卡模块的初始状态，默认值 false，机器人会在 Enable 或者 start 指令启动机器人的时候自动开始挂卡。如果你想手动使用 resume 指令来开始挂卡，可以将本字段值设置为 true。例如，你只想用 play 指令来运行你指定的游戏，并且不想使用自动 CardsFarmer 挂卡模块。将本字段值设置成 true 和执行 pause 指令效果完全相同。如果你不确定是否启用本功能，请将本字段保持默认值 false。"
            
        case "RedeemingPreferences":
            result = "RedeemingPreferences —— byte flags 类型，默认值为 0。本字段定义了 ASF 在激活 CD-Key 时的行为。有以下几种行为：\n值    行为名称    行为描述\n0    None    无激活偏好\n1    Forwarding    将不可用的 CD-Key 转发给其它机器人\n2    Distributing    将所有的 CD-Key 分发给包括自己在内的所有机器人\n4    KeepMissingGames    转发时保留可能没有的游戏 CD-Key"
            
        case "SendOnFarmingFinished":
            result = "SendOnFarmingFinished —— bool 类型，默认值为 false。当 ASF 完成了本机器人的挂卡，会将所有挂卡所得自动发送给对其有 Master 权限的账户。这在你不想每次完成挂卡都手动发送报价时非常方便。本字段和 loot 指令工作原理相同，因此它需要设置 Master 权限账户，其中要包括有交易资格的帐号，此外还可能需要正确设置 SteamTradeToken Steam 交易令牌。除了在完成挂卡后进行 loot 搜刮，在每次库存内添加物品通知（不是挂卡时的物品通知）的时候也会进行 loot 搜刮，并且每次完成交易后有新物品时也会进行搜刮。在想要“转发”从他人那里收到的礼物到我们的主账户的情况下，本功能非常有用。我们也强烈建议与 ASF 2FA 一同使用，这样不用手动确认就可以自动完成交易。如果你不确定如何设置本字段，请将本字段保持默认值 false。"
            
        case "SendTradePeriod":
            result = "SendTradePeriod —— byte 类型，默认值为 0。本字段类似于 SendOnFarmingFinished 挂卡完毕后发送报价，但是有一个地方不同 —— 不是在挂卡结束后发送报价，而是不管我们还剩余多少卡需要挂，每过 SendTradePeriod 小时就向主账户发送报价。本字段适用于不等到小号挂完卡就经常 loot 搜刮的情况。默认值 0 就是禁用此功能。例如，如果你想让你的机器人每天都向你发送一次报价，就可以将本字段值设置成 24。同样我们强烈建议与 ASF 2FA 一同使用，这样不用手动确认就可以自动完成交易。如果你不确定如何设置本字段，请将本字段保持默认值 0。"
        case "SteamLogin":
            result = "SteamLogin - string type with default value of null. This property defines your steam login - the one you use for logging in to steam. In addition to defining steam login here, you may also keep default value of null if you want to enter your steam login on each ASF startup instead of putting it in the config. This may be useful for you if you don't want to save sensitive data in config file."
            
        case "SteamPassword":
            result = "SteamPassword - string type with default value of null. This property defines your steam password - the one you use for logging in to steam. In addition to defining steam password here, you may also keep default value of null if you want to enter your steam password on each ASF startup instead of putting it in the config. This may be useful for you if you don't want to save sensitive data in config file."
            
        case "SteamTradeToken":
            result = "SteamTradeToken - string type with default value of null. When you have your bot on your friend list, then bot can send a trade to you right away without worrying about trade token, therefore you can leave this property at default value of null. If you however decide to NOT have your bot on your friend list, then you will need to generate and fill a trade token as the user that this bot is expecting to send trades to. In other words, this property should be filled with trade token of the account that is defined with Master permission in SteamUserPermissions of this bot instance."
            
        case "SteamUserPermissions":
            result = "SteamUserPermissions - Dictionary<ulong, byte> type with default value of being empty. This property is a dictionary property which maps given Steam user identified by his 64-bit steam ID, to byte number that specifies his permission in ASF instance. Currently available bot permissions in ASF are defined as:\nValue    Name    Description\n0    None    No permission, this is mainly a reference value that is assigned to steam IDs missing in this dictionary - there is no need to define anybody with this permission\n1    FamilySharing    Provides minimum access for family sharing users. Once again, this is mainly a reference value since ASF is capable of automatically discovering steam IDs that we permitted for using our library\n2    Operator    Provides basic access to given bot instances, mainly adding licenses and redeeming keys\n3    Master    Provides full access to given bot instance"
            
        case "SteamMasterClanID":
            result = "SteamMasterClanID - ulong type with default value of 0. This property defines the steamID of the steam group that bot should automatically join, including group chat. You can check steamID of your group by navigating to its page, then adding /memberslistxml?xml=1 to the end of the link, so the link will look like this. Then you can get steamID of your group from the result, it's in <groupID64> tag. In above example it would be 103582791440160998. If you don't have any farm group for your bots, you should keep it at default."
            
        case "SteamParentalPIN":
            result = "SteamParentalPIN - string type with default value of 0. This property defines your steam parental PIN. ASF requires an access to resources protected by steam parental, therefore if you use that feature, you need to provide ASF with parental unlock PIN, so it can operate normally. Default value of 0 means that there is no steam parental PIN required to unlock this account, and this is probably what you want if you don't use steam parental functionality. In addition to defining steam parental PIN here, you may also use value of null if you want to enter your steam parental PIN on each ASF startup instead of putting it in the config. This may be useful for you if you don't want to save sensitive data in config file."
            
        case "ShutdownOnFarmingFinished":
            result = "ShutdownOnFarmingFinished - bool type with default value of false. ASF is occupying an account for the whole time of process being active. When given account is done with farming, ASF periodically checks it (every IdleFarmingPeriod hours), if perhaps some new games with steam cards were added in the meantime, so it can resume farming of that account without a need to restart the process. This is useful for majority of people, as ASF can automatically resume farming when needed. However, you may actually want to stop the process when given account is fully farmed, you can achieve that by setting this property to true. When enabled, ASF will proceed with logging off when account is fully farmed, which means that it won't be periodically checked or occupied anymore. You should decide yourself if you prefer ASF to work on given bot instance for the whole time, or if perhaps ASF should stop it when farming process is done. When all accounts are stopped and process is not running in --process-required mode, ASF will shutdown as well. If you're not sure how to set this property, leave it with default value of false."
       
        case "UseLoginKeys":
            result = "UseLoginKeys - bool type with default value of true. This property defines if ASF should use login keys mechanism for this Steam account. Login keys mechanism works very similar to official Steam client's remember me option, which makes it possible for ASF to store and use temporary one-time use login key for next logon attempt, effectively skipping a need of providing password, Steam Guard or 2FA code as long as our login key is valid. Login key is stored in BotName.db file and updated automatically. This is why you don't need to provide password/SteamGuard/2FA code after logging in successfully with ASF just once."
       
        case "TradingPreferences":
            result = "TradingPreferences - byte flags type with default value of 0. This property defines ASF behaviour when in trading, and is defined as below:\nValue    Name    Description\n0    None    No trading preferences - accepts only Master trades\n1    AcceptDonations    Accepts trades in which we're not losing anything\n2    SteamTradeMatcher    Accepts dupes-matching STM-like trades. Visit trading for more info\n4    MatchEverything    Requires SteamTradeMatcher to be set, and in combination with it - also accepts bad trades in addition to good and neutral ones\n8    DontAcceptBotTrades    Doesn't automatically accept loot trades from other bot instances"
        
        default:
            result = ""
        }
        
        return result;
    }
}
