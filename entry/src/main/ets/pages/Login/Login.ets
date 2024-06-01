import { TOKEN_KEY, UserSettingClass } from '@hm/basic/Index'
import { login } from '../../api/user'
import { LoginFormModel } from '../../models'
import { router } from '@kit.ArkUI'

@Entry
@Component
struct Login {
  // 控制登录动态组件
  @State showLoading: boolean = false
  // 账号 密码 todo 测试完成后需要删除账号密码
  @State
  accountForm: LoginFormModel = new LoginFormModel({
    account: 'chiqingsan',
    password: '123456'
  })

  // 调用登录接口
  async login() {
    if (!this.showLoading) {
      try {
        this.showLoading = true
        const token = await login(this.accountForm)
        AppStorage.setOrCreate(TOKEN_KEY, token) // 写入全局状态
        new UserSettingClass(getContext(this)).setUserToken(token) // 存入首选项
        router.replaceUrl({
          url: 'pages/Index'
        })
      } catch (error) {
        console.log("Login_error:", JSON.stringify(error))
      } finally {
        this.showLoading = false
      }
    }
  }

  // 输入合法判断
  getFormValidate() {
    return this.accountForm.account && this.accountForm.password ? true : false
  }

  @Styles
  loginStyle() {
    .backgroundColor('#fff')
    .border({ color: $r('app.color.background_divider'), width: { bottom: 1 } })
    .width('100%')
    .height(58)
    .borderRadius(0)
  }

  build() {
    Column() {
      // 顶部标题
      Text("神领物流").fontColor($r('app.color.text_primary')).fontSize(18).height(25)
      // 账号登录
      Row() {
        Text('账号登录').fontColor($r('app.color.text_primary')).fontSize(24).fontWeight(FontWeight.Bold)
        Row() {
          Text("手机号登录").fontColor($r('app.color.primary')).fontSize(16).fontWeight(FontWeight.Bold)
          Image($r("app.media.ic_angle")).width(10).height(10).margin({ left: 5 })
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ top: 50, bottom: 50 })

      // 用户名输入框
      TextInput({ placeholder: '请输入账号', text: this.accountForm.account })
        .loginStyle()
        .onChange((val) => {
          this.accountForm.account = val
        })

      // 密码框
      TextInput({ placeholder: '请输入密码', text: this.accountForm.password })
        .loginStyle()
        .type(InputType.Password)// 密码框
        .showPasswordIcon(true)// 显示密码按钮
        .passwordIcon({
          onIconSrc: $r("app.media.eye_a"),
          offIconSrc: $r("app.media.eye_b")
        })
        .cancelButton({
          style: CancelButtonStyle.INPUT,
          icon: { size: 18 }
        })
        .onSubmit(() => {
          if (this.getFormValidate()) {
            this.login()
          }
        })
        .onChange((val) => {
          this.accountForm.password = val
        })

      // 登录按钮
      Button({ type: ButtonType.Capsule }) {
        Row() {
          if (this.showLoading) {
            LoadingProgress().width(20).aspectRatio(1).margin({ right: 12 }).color($r('app.color.white'))
          }
          Text('登录')
            .fontColor($r('app.color.white'))
        }
      }
      .backgroundColor($r("app.color.btn_red"))
      .width('100%')
      .height(50)
      .margin({ top: 50 })
      .enabled(this.getFormValidate())
      .onClick(() => {
        this.login()
      })
    }
    .padding({ left: 32, right: 32 })
    .margin({ top: 40 })
  }
}