@Entry
@Component
struct Listen {
  @StorageProp("orderId")
  orderId: number  = 0

  build() {
    Column({ space: 20 }) {
      Text(`单号：${this.orderId}`)
      .fontSize(20)
      Row() {
        Button("去接单")
          .backgroundColor($r('app.color.primary'))
          .width('100%')
      }.padding({
        left: 20,
        right: 20
      })

    }
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .height('100%')
    .width('100%')
  }
}