
import { TOKEN_KEY,AdvertClass, UserSettingClass } from 'shenling_common'
import { router } from '@kit.ArkUI'


PersistentStorage.persistProp(TOKEN_KEY, "")
@Entry
@Component
struct Start {
  userSetting: UserSettingClass = new UserSettingClass(getContext(this))
  @State
  adObj: AdvertClass = {
    showAd: false,
    adTime: 5,
    adImg: ''
  }
  timer: number = -1
  async aboutToAppear() {
   this.adObj = await this.userSetting.getUserAd()
   this.timer = setInterval(() => {
      if(this.adObj.adTime === 0) {
        clearInterval(this.timer)
        this.toNext()
        return
      }
     this.adObj.adTime--
    }, 1000)
  }
  aboutToDisappear() {
    clearInterval(this.timer)
  }
  // 去下一个页面
  toNext() {
    if(AppStorage.Get<string>(TOKEN_KEY)) {
      // 有token
      router.replaceUrl({
        url: 'pages/Index/Index'
      })
    }else {
      router.replaceUrl({
        url: 'pages/Login/Login'
      })
    }
  }
  build() {
   Stack({ alignContent: Alignment.TopEnd }) {
      Image(this.adObj.adImg)
        .objectFit(ImageFit.Cover)
     // 倒计时文本
     Text(`${this.adObj.adTime}秒后跳过`)
       .padding({
         left: 10,
         right: 10
       })
       .margin({
         top: 10,
         right: 10
       })
       .height(30)
       .fontSize(14)
       .borderRadius(15)
       .backgroundColor($r('app.color.background_page'))
       .textAlign(TextAlign.Center)
       .onClick(() => {
         this.toNext()
       })
   }
    .width('100%')
    .height('100%')
  }
}