import { router } from '@kit.ArkUI'
import { SlRequest } from '../../common/utils/Request';


export interface userAccountSecrets {
  /**
   * 登录账号
   */
  account: string;

  /**
   * 登录密码
   */
  password: string;
}

@Entry
@Component
struct LoginPassword {
  @State userAccount: string = "xbsj001"
  @State userPassword: string = "123456"

  build() {
    Column() {
      Text($r("app.string.EntryAbility_label"))
        .fontSize(18)
        .fontWeight(600)
        .fontColor($r("app.color.majorCharacters"))
        .margin({ top: 9, bottom: 50 })
      Row() {
        Text("账号登录")
          .fontSize(24)
          .fontWeight(600)
          .fontColor($r("app.color.majorCharacters"))
        Blank()
        Row() {
          Text("手机号登录")
            .fontSize(16)
            .fontWeight(500)
            .fontColor("#EF4F3F")
            .margin({ left: 15, right: 6 })
          Text()
            .border({
              width: { left: 6, top: 4, bottom: 4 },
              color: { left: "#EF4F3F", top: "#00000000", bottom: "#00000000" }
            })
        }
        .onClick(() => {
          router.pushUrl({
            url: "pages/UserLogin/LoginPhone"
          },
            router.RouterMode.Single
          )
        })
      }.width("100%").alignItems(VerticalAlign.Bottom)

      Column({ space: 18 }) {
        TextInput({
          placeholder: "请输入账号",
          text: $$this.userAccount
        })
          .height(44)
          .backgroundColor("#00000000")
          .padding({ top: 0, bottom: 20, left: 0, right: 0 })
          .border({
            width: { bottom: 1 },
            color: "#F7F7F7",
            radius: 0
          })

        TextInput({
          placeholder: "请输入密码",
          text: $$this.userPassword
        })
          .height(44)
          .backgroundColor("#00000000")
          .padding({ top: 0, bottom: 20, left: 0, right: 0 })
          .type(InputType.Password)
          .passwordIcon({
            onIconSrc: $r("app.media.eyeon"),
            offIconSrc: $r("app.media.eyeoff")
          })
          .border({
            width: { bottom: 1 },
            color: "#F7F7F7",
            radius: 0
          })
      }
      .margin({ top: 45, bottom: 50 })

      Button("登录")
        .backgroundColor("#EF4F3F")
        .fontSize(18)
        .fontColor(Color.White)
        .fontWeight(400)
        .width("100%")
        .height(50)
        .onClick(async () => {
          const res = await SlRequest.post<string>("/driver/login/account", {
            account: this.userAccount,
            password: this.userPassword
          } as userAccountSecrets)

          console.log("res:", JSON.stringify(res))
          router.replaceUrl({
            url: "pages/Index"
          })
          router.clear()

        })
    }
    .width("100%")
    .height("100%")
    .padding({ left: 33, right: 33 })
  }
}