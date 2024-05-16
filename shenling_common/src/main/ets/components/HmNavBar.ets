import router from '@ohos.router'

@Preview
@Component
struct HmNavBar {
  @StorageProp("topHeight") topHeight: number = 0
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
      if (this.showBackIcon) {
        Row() {
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
    .height(50 + this.topHeight)
    .backgroundColor($r('app.color.white'))
    .padding({ left: 10, right: 10, bottom: 10, top: this.topHeight + 10 })
  }
}

export { HmNavBar }