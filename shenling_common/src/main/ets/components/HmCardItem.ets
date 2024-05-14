@Preview
@Component
struct HmCardItem {
  onRightClick: () => void = () => {}
   // 左侧显示文本
  leftTitle: string = ""
  // 右侧显示文本
  @Prop
  rightText: string
  // 控制显示右侧按钮
  showRightIcon: boolean = true
  // 控制是否显示下边框
  showBottomBorder: boolean = true
  build() {
    // Row组件默认垂直方向居中
    Row () {
     Text(this.leftTitle)
       .fontSize(14)
       .fontColor($r('app.color.text_primary'))
      .layoutWeight(1)
      .textOverflow({
        overflow: TextOverflow.Ellipsis
      })
      .maxLines(1)
      Row () {
        // 右侧显示内容
        if(this.rightText) {
          Text(this.rightText)
            .fontColor($r('app.color.text_secondary'))
            .fontSize(14)
        }
        if(this.showRightIcon) {
          Image($r('app.media.ic_btn_more'))
            .width(24)
            .height(24)
        }
      }
      .onClick(() => {
        // 调用传入的方法函数
          this.onRightClick()
      })
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
    .height(60)
    .border({
      color: $r('app.color.background_divider'),
      width: {
        bottom: this.showBottomBorder ? 1 : 0
      }
    })
  }
}

export  { HmCardItem }