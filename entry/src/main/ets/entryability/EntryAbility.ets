import { AbilityConstant, errorManager, UIAbility, Want } from '@kit.AbilityKit';
import { FaultLogger, hilog } from '@kit.PerformanceAnalysisKit';
import { promptAction, window } from '@kit.ArkUI';
import { AdvertClass, TOKEN_KEY, UserSettingClass } from '@hm/basic'
import { Log } from '@abner/log';

let errorManagerId = -1

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');

    // todo 需要对错误信息进行记录或者上报
    // 注册错误观察器,来捕获未知的错误
    errorManagerId = errorManager.on("error", {
      async onUnhandledException() {
        const errorInfoList = await FaultLogger.query(FaultLogger.FaultType.JS_CRASH)
        const errorInfo = errorInfoList[0]
        // AlertDialog.show({
        //   message: JSON.stringify(errorInfo, null, 2)
        // })
        promptAction.showToast({
          message: "出现未知错误"
        })
        // 打印错误日志
        Log.error(errorInfo)
      }
    })

    // 初始化第三方日志模块
    Log.init({
      tag: "ShenLing",
      domain: 0x0000,
      close: false,
      isHilog: true,
      showLogLocation: true,
      logSize: 1024
    })
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    // 拿到持久化广告类的对象
    const adSetting = new UserSettingClass(this.context)

    // 模拟异步请求,拿到广告的配置
    const adRes = await new Promise<AdvertClass>((resolve, reject) => {
      // 开一个定时器,模拟请求
      setTimeout(() => {
        // 返回广告配置
        // todo 开发时为了方便,广告业默认不展示
        resolve({
          showAd: false,
          adTime: 5,
          adImg: $r("app.media.start")
        } as AdvertClass) // 广告信息
      }, 200)
    })
    // 通过模拟请求拿到广告信息
    // 写入首选项
    await adSetting.setUserAd(adRes)
    if (adRes.showAd) {
      // 展示广告的情况 展示广告页 有时限
      // 创建一个子窗口 子窗口加载广告 广告播完 窗口销毁
      const win = await windowStage.createSubWindow("ad_window")
      await win.showWindow()
      win.setUIContent("pages/Start/Start")
    }
    // 尝试获取用户的token
    const token = await adSetting.getUserToken()
    // 设置需要进入的页面路径
    let pagePath: string
    if (token) {
      AppStorage.setOrCreate(TOKEN_KEY, token)
      pagePath = '/pages/Index/Index'.slice(1)
    } else {
      pagePath = "/pages/Login/Login".slice(1)
    }

    // 进入pages页面
    windowStage.loadContent(pagePath, (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
