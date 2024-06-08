@Preview
@CustomDialog
@Component
struct HmSelectCard {
  controller: CustomDialogController
  title: string = "请选择" // 显示标题
  showClose: boolean = true // 显示关闭按钮
  showButton: boolean = true // 显示底部按钮
  buttonText: string = "确定" // 底部按钮文本
  @BuilderParam
  cardContent: () => void
  confirm: () => void = () => {
  }

  build() {
    Column() {
      Row() {
        Text(this.title).fontSize(16).fontColor($r('app.color.text_primary'))
        if (this.showClose) {
          Image($r("app.media.ic_btn_close")).width(13).height(13)
            .onClick(() => {
              this.controller.close()
            })
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .height(60)
      .borderRadius({
        topLeft: 16,
        topRight: 16
      })

      // 渲染内容
      if (this.cardContent) {
        this.cardContent()
      }
      if (this.showButton) {
        Row() {
          Button(this.buttonText, { type: ButtonType.Capsule })
            .width(200)
            .backgroundColor($r('app.color.primary'))
            .height(45)
            .onClick(() => {
              this.confirm()
            })
        }.width('100%').justifyContent(FlexAlign.Center)
      }
    }
    .backgroundColor($r('app.color.white'))
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({
      left: 21.36,
      right: 21.36,
      bottom: 25
    })
  }
}

export { HmSelectCard }