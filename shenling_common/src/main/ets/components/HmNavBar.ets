import router from '@ohos.router'
@Preview
@Component
struct HmNavBar {
  title: string = "系统设置"
  showBackIcon: boolean = true
  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Row() {
        Text(this.title)
          .fontColor($r('app.color.text_primary'))
          .fontSize(18)
          .fontWeight(600)
      }
      .height('100%')
      .width('100%')
      .justifyContent(FlexAlign.Center)
      // 显示图标
      if(this.showBackIcon) {
        Row () {
          Image($r('app.media.ic_btn_nav_back'))
            .width(44)
            .height(44)
            .fillColor($r('app.color.text_primary'))
            .onClick(() => {
              router.back()
            })
        }.alignItems(VerticalAlign.Center)
      }
    }
    .height(50)
    .backgroundColor($r('app.color.white'))
    .padding(10)
  }
}

export { HmNavBar }