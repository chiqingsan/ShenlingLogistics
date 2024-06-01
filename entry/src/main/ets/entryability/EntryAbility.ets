import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { AdvertClass, UserSettingClass } from '@hm/basic'


export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
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
    const adRes = await new Promise<AdvertClass>( (resolve,reject) => {
      // 开一个定时器,模拟请求
      setTimeout(() => {
        // 返回广告配置
        resolve({
          showAd: true,
          adTime: 5,
          adImg: $r("app.media.start")
        } as AdvertClass) // 广告信息
      }, 250)
    })
    // 通过模拟请求拿到广告信息
    // 写入首选项
    await adSetting.setUserAd(adRes)
    if(adRes.showAd) {
      // 展示广告的情况 展示广告页 有时限
      // 创建一个子窗口 子窗口加载广告 广告播完 窗口销毁
      const win = await windowStage.createSubWindow("ad_window")
      await win.showWindow()
      win.setUIContent("pages/Start/Start")
    }

    // 进入首页
    windowStage.loadContent('pages/Index', (err) => {
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
