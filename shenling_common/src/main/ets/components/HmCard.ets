@Preview
@Component
struct HmCard {

  @BuilderParam
HmCardFn: () => void

  build() {
    Column() {
      Column() {
        // 应该是传入的
        if(this.HmCardFn) {
          this.HmCardFn()
        }
      }
      .backgroundColor($r('app.color.white'))
      .borderRadius(10)
      .width('100%')
      .padding({
        left: 15,
        right: 15
      })
    }
    .width('100%')
    .padding(15)
  }
}

export  { HmCard }