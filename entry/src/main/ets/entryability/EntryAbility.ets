import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';
import abilityAccessCtrl from '@ohos.abilityAccessCtrl'
import { UserSettingClass, AVPlayerClass } from 'shenling_common';
import promptAction from '@ohos.promptAction';
import notificationManager from '@ohos.notificationManager';
import wantAgent from '@ohos.app.ability.wantAgent';
import { AbilityConstant, Want } from '@kit.AbilityKit';
import notification from '@ohos.notification';

export default class EntryAbility extends UIAbility {
  async onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): Promise<void> {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    const manager = abilityAccessCtrl.createAtManager()
    try {
      await manager.requestPermissionsFromUser(this.context, [
        'ohos.permission.LOCATION',
        'ohos.permission.APPROXIMATELY_LOCATION'
      ])
      await notificationManager.requestEnableNotification()

    } catch (error) {
      promptAction.showToast({
        message: '申请权限失败'
      })
    }

  }

  onDestroy() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  async onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    // 判断有没有广告
    const userSetting = new UserSettingClass(this.context)
    // 请求一下网络 云
    // const result = await new Promise<AdvertClass>((resolve) => {
    //   setTimeout(() => {
    //     resolve({
    //       showAd: true,
    //       adTime: 10,
    //       adImg: 'https://pic1.zhimg.com/50/fe762e46aff74bfb5ffe6a7bee3bda70_hd.jpg'
    //     } as AdvertClass)
    //   }, 500)
    // })
    // // 写入到首选项中去
    // await userSetting.setUserAd(result)
    const adSetting = await userSetting.getUserAd()
    this.publishMessage()
    // 发布通知 10秒之后发布通知
    if (adSetting.showAd) {
      // 去广告页
      windowStage.loadContent('pages/Start/Start')
    } else {
      const token = await userSetting.getUserToken()
      if (token) {
        windowStage.loadContent('pages/Index/Index')
      } else {
        windowStage.loadContent('pages/Login/Login')
      }
    }

  }

  publishMessage() {
    setTimeout(async () => {
      try {
        // 发起一个通知
        await notificationManager.publish({
          content: {
            notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
            normal: {
              title: '温馨提示',
              text: '您有一个新的订单',
              additionalText: '订单提醒'
            }
          },
          wantAgent: await wantAgent.getWantAgent({
            wants: [{
              bundleName: 'com.itheima.shenling2',
              abilityName: 'ListenAbility',
              parameters: {
                order_id: Date.now()
              }
            }],
            actionType: wantAgent.OperationType.START_ABILITY,
            requestCode: 0
          })
        })
        AVPlayerClass.playAudio("information.m4a", this.context)
      }
      catch (error) {
        AlertDialog.show({ message: error.message })
      }
    }, 10000)
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
