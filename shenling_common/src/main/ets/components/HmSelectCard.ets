@Preview
@CustomDialog
@Component
struct HmSelectCard {
  controller: CustomDialogController

  title: string = "请选择"
  buttonText: string  = "确定"
  showClose: boolean = true
  showButton: boolean = true
  confirm: () => void = () => {}
  @BuilderParam
  cardContent: () => void  //  builderParams修饰的的函数给初始值的时候 必须给@Builder修饰的函数  但是实际传值时 可以给普通箭头函数
  build() {
     Column() {
       Row() {
         Text(this.title)
           .fontSize(16)
           .fontColor($r('app.color.text_primary'))
         if(this.showClose) {
           Image($r('app.media.ic_btn_close'))
             .width(13)
             .height(13)
             .onClick(() => {
               this.controller.close()
             })
         }
       }
       .borderRadius({
         topLeft:16,
         topRight: 16
       })
       .width('100%')
       .justifyContent(FlexAlign.SpaceBetween)
       .alignItems(VerticalAlign.Center)
       .height(60)
       // 插槽内容
       if(this.cardContent) {
         this.cardContent()
       }

       if(this.showButton) {
         Row () {
           Button(this.buttonText)
             .backgroundColor($r('app.color.primary'))
             .height(50)
             .width(207)
             .onClick(() => {
               // 告诉外界 我点了确定了
               this.confirm()
               this.controller.close()
             })
         }
         .width('100%')
         .height(70)
         .backgroundColor($r('app.color.white'))
         .justifyContent(FlexAlign.Center)
       }

     }
     .backgroundColor($r('app.color.white'))
    .padding({
      left: 21,
      right:21
    })
  }
}
export { HmSelectCard }