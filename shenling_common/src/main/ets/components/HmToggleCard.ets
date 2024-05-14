@Preview
@Component
struct HmToggleCard {
  title: string = "测试"
  @State
  toggleCard: boolean = true // 默认是展开的
  @BuilderParam
  CardContent: () => void
  build() {
    Column() {
      Row() {
        Text(this.title)
          .fontSize(16)
          .fontColor($r('app.color.text_primary'))
          .fontWeight(600)
        Image(this.toggleCard ? $r("app.media.ic_btn_cut") :
        $r("app.media.ic_btn_add"))
          .width(24)
          .height(24)
          .onClick(() => {
            animateTo({ duration: 300 }, () => {
              this.toggleCard = !this.toggleCard
            })

          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .height(50)

      // 放置传入的内容
      if(this.CardContent && this.toggleCard) {
        this.CardContent()
      }
    }
    .padding({
      left: 19.5,
      right: 19.5,
      bottom: 18.5
    })
    .margin({
      left: 15,
      right: 15,
      top: 15
    })
    .backgroundColor($r('app.color.white'))
    .borderRadius(10)
  }
}

export  { HmToggleCard }