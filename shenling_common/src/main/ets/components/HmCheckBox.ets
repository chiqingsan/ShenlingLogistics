@Preview
@Component
struct HmCheckBox {
  title: string = "车辆违章"
  confirmText: string = "是"
  cancelText: string = '否'
  @Prop
  value: boolean

  checkChange: (value: boolean) => void = () => {}
  build() {
    Row() {
      Row() {
        // 左侧内容
        Text(this.title)
          .fontSize(14)
          .fontColor($r('app.color.text_primary'))
        // 右侧内容
        Row({ space: 20 }) {
          Row() {
            Image(this.value ? $r('app.media.ic_radio_true') : $r('app.media.ic_check_false'))
              .width(32)
              .height(32)
            Text(this.confirmText)
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
          }
          .onClick(() => {
            this.value = true
            this.checkChange(this.value)
          })
          Row() {
            Image(!this.value ? $r('app.media.ic_radio_true') : $r('app.media.ic_check_false'))
              .width(32)
              .height(32)
            Text(this.cancelText)
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
          }
          .onClick(() => {
            this.value = false
            this.checkChange(this.value)
          })
        }
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .height(60)
      .width('100%')
      .borderRadius(10)
      .padding({
        left: 15,
        right: 15
      })
      .backgroundColor($r('app.color.white'))
    }
    .width('100%')
    .padding({
      left: 15,
      right: 15
    })
    .margin({
      top: 15
    })
  }
}

export { HmCheckBox }