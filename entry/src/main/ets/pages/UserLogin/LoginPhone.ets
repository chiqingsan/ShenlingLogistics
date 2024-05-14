import { router } from '@kit.ArkUI'


const checkTheRegex:RegExp = /^1[3456789]\d{9}$/

@Entry
@Component
struct LoginPhone {
  @State phoneNum:string = ''
  @State captcha:string = ''
  // 控制输入框变色的状态
  @State enterTheStatus:boolean = true
  // 倒计时
  @State countdown:number = 60
  // 验证图片的二进制
  @State ImageShow:boolean = false
  //key验证码刷新
  @State ImgKey:number = 0
  timerId:number = -1

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
         Column({space:5}){
           TextInput({
             placeholder:"请输入手机号",
             text:this.phoneNum
           })
             .maxLength(11)
             .type(InputType.Number)
             .height(44)
             .backgroundColor("#00000000")
             .padding({top:0,bottom:20,left:0,right:0})
             .border({
               width:{bottom:1},
               color:this.enterTheStatus?  "#F7F7F7" : "#EF4F3F",
               radius:0
             })
             .onChange( (val) => {
               this.phoneNum = val
               if (val.length === 11) {
                 if (!checkTheRegex.test(val)) {
                   this.enterTheStatus = false
                 }
               }else {
                 this.enterTheStatus = true
               }
             })
           Text("手机号输入有误! 请重新输入")
             .fontColor("#EF4F3F")
             .width("100%")
             .fontSize(14)
             .visibility(this.enterTheStatus?  Visibility.Hidden : Visibility.Visible)

         }

         Column({space:5}){
           Stack(){
             TextInput({
               placeholder:"请输入验证码",
               text:this.captcha
             })
               .maxLength(6)
               .type(InputType.Number)
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

               Text(this.countdown < 60 ?`${this.countdown}s后重新获取`:"获取验证码")
                 .fontSize(14)
                 .fontColor(this.countdown < 60 ? "#818181": "#2A2929")
                 .margin({left:15,top:3,bottom:3,right:10})
             }
             .enabled(this.countdown === 60)
             .margin({bottom:20})
             .onClick(async () => {
               clearInterval(this.timerId)
               this.ImgKey = Date.now()
               this.ImageShow = true
               this.countdown--
               this.timerId = setInterval( () => {
                 this.countdown--
                 if (this.countdown <= 0) {
                   this.countdown = 60
                   clearInterval(this.timerId)
                 }
               },1000)
             })
           }
           .alignContent(Alignment.End)

           Text("验证码输入有误! 请重新输入")
             .fontColor("#EF4F3F")
             .width("100%")
             .fontSize(14)
             .visibility(Visibility.Hidden)
           if (this.ImageShow){
             Image(`https://slwl-api.itheima.net/driver/register/captcha/?key=${this.ImgKey.toString()}`)
               .width("100%")
           }
         }
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