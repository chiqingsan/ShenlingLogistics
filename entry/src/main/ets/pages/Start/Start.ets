import { UserSettingClass, AdvertClass, windowManager } from '@hm/basic'
import { window } from '@kit.ArkUI'

@Entry
@Component
struct Start {
  userSetting: UserSettingClass = new UserSettingClass(getContext())
  @State
  adObj: AdvertClass = {} as AdvertClass
  timer: number = -1

  async aboutToAppear() {
    this.adObj = await this.userSetting.getUserAd()
    this.timer = setInterval(() => {
      if (this.adObj.adTime === 0) {
        clearInterval(this.timer)
        this.closeWin()
        return
      }
      this.adObj.adTime--
    }, 1000)
  }

  // 关闭广告
  closeWin() {
    window.findWindow("ad_window").destroyWindow()
  }

  aboutToDisappear(): void {
    // 开始沉浸式状态栏
    windowManager.enableFullScreen(true)
    clearInterval(this.timer)
  }

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
      Image(this.adObj.adImg).objectFit(ImageFit.Cover)
      Text(`${this.adObj.adTime}秒后跳过`)
        .padding({ left: 10, right: 10 })
        .margin({ right: 20, top: 20 })
        .height(30)
        .fontSize(14)
        .borderRadius(15)
        .backgroundColor($r("app.color.background_page"))
        .textAlign(TextAlign.Center)
        .onClick(() => {
          this.closeWin()
        })
        .offset({
          y: 30
        })

    }.height('100%').width('100%')
  }
}
