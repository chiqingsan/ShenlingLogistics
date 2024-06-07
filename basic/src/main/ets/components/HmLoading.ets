@CustomDialog
@Component
@Preview
struct HmLoading {
  controller: CustomDialogController
  title: string = '数据处理中...'

  build() {
    Row({ space: 6 }) {
      Row() {
        Text(this.title)
          .fontColor($r("app.color.white"))
          .fontSize(16)
        LoadingProgress()
          .color($r("app.color.white"))
          .width(30)
          .height(30)
      }
      .padding({
        left: 23,
        right: 23,
        top: 12,
        bottom: 12
      })
      .backgroundColor("rgba(0,0,0,0.5)")
      .borderRadius(10)
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')

    // .backgroundColor("rgba(0,0,0,0.1)")
  }
}

export { HmLoading }