import { router } from '@kit.ArkUI'

@Entry
@Component
struct LoginPhone {
  @State logInOrSignUp:boolean = false

  build() {
     Column(){
       Text($r("app.string.EntryAbility_label"))
         .fontSize(18)
         .fontWeight(600)
         .fontColor($r("app.color.majorCharacters"))
         .margin({top:9,bottom:50})
       Row(){
         Text("手机号登录")
           .fontSize(24)
           .fontWeight(600)
           .fontColor($r("app.color.majorCharacters"))
         Blank()
         Row(){
           Text("账号登录")
             .fontSize(16)
             .fontWeight(500)
             .fontColor("#EF4F3F")
             .margin({left:15,right:6})
           Text()
             .border({
           width:{left:6,top:4,bottom:4},
           color:{left:"#EF4F3F",top:"#00000000",bottom:"#00000000"}
             })
         }
           .onClick( () => {
             router.pushUrl({
               url:"pages/UserLogin/LoginPassword"
             },
               router.RouterMode.Single
             )
           })

       }.width("100%").alignItems(VerticalAlign.Bottom)

       Column({space:18}){
         TextInput({
           placeholder:"请输入手机号"
         })
           .height(44)
           .backgroundColor("#00000000")
           .padding({top:0,bottom:20,left:0,right:0})
           .border({
             width:{bottom:1},
             color:"#F7F7F7",
             radius:0
           })

         Stack(){
           TextInput({
             placeholder:"请输入验证码"
           })
             .height(44)
             .backgroundColor("#00000000")
             .padding({top:0,bottom:20,left:0,right:0})
             .border({
               width:{bottom:1},
               color:"#F7F7F7",
               radius:0
             })
           Row(){
             Divider()
               .vertical(true)
               .height(26)
               .strokeWidth(1)
               .color("#F4F4F4")

             Text("获取验证码")
               .fontSize(14)
               .fontColor("#2A2929")
               .margin({left:15,top:3,bottom:3,right:10})
           }
            .margin({bottom:20})
         }
          .alignContent(Alignment.End)
       }
       .margin({top:45,bottom:50})

       Button("登录")
         .backgroundColor("#EF4F3F")
         .fontSize(18)
         .fontColor(Color.White)
         .fontWeight(400)
         .width("100%")
         .height(50)
     }
      .width("100%")
      .height("100%")
      .padding({left:33,right:33})
  }
}