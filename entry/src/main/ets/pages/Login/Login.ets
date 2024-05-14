import { TOKEN_KEY } from 'shenling_common'
import { LoginForm, LoginFormModel } from '../../models/user'
import { login } from '../../api'
import { UserSettingClass } from 'shenling_common'
import { router} from '@kit.ArkUI'

PersistentStorage.PersistProp(TOKEN_KEY, "")

@Entry
@Component
struct Login {
  @State
  showLoading: boolean = false
  // @State
  // accountForm: Partial<LoginForm>  = {}
  @State
  accountForm: LoginFormModel = new LoginFormModel({
    // account: 'harmonyos',
    account: 'laogao_next',
    password: '123456'
  })

  @Styles
  inputStyle2() {
    .backgroundColor('#fff')
    .border({ color: $r('app.color.background_divider'), width: { bottom: 1 } })
    .width('100%')
    .height(58)
    .borderRadius(0)
  }

  // 检查账户和密码的校验
  getFormValidate () {
    if(this.accountForm.account && this.accountForm.password) {
      return true
    }
    return false
  }
  async login () {
    try {
      this.showLoading = true
      const token = await login(this.accountForm)
      // 写入持久化
      AppStorage.Set<string>(TOKEN_KEY, token)
      new UserSettingClass(getContext(this)).setUserToken(token)
      router.pushUrl({
        url: 'pages/Index/Index'
      })
    }catch(error) {
    }
    finally {
      this.showLoading = false
    }
  
  }

  build() {
    Column() {
      // 顶部标题
      Text("神领快递").fontColor($r('app.color.text_primary')).fontSize(18).height(25)
      // 账号登录
      Row() {
        Text('账号登录').fontColor($r('app.color.text_primary')).fontSize(24).fontWeight(FontWeight.Bold)
        Row() {
          Text("账号登录").fontColor($r('app.color.primary')).fontSize(16).fontWeight(FontWeight.Bold)
          Image($r("app.media.ic_angle")).width(10).height(10).margin({ left: 5 })
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ top: 50, bottom: 50 })

      // 用户名输入框
      TextInput({ placeholder: '请输入账号', text: this.accountForm.account })
        .inputStyle2()
        .onChange(value => {
          this.accountForm.account = value
        })
        .onSubmit(() => {
          if(this.getFormValidate()) {
            this.login()
          }
        })

      // 密码框
      TextInput({ placeholder: '请输入密码', text: this.accountForm.password })
        .inputStyle2()
        .type(InputType.Password) // 密码框
        .showPasswordIcon(true) // 显示密码按钮
        .onChange(value => {
          this.accountForm.password = value
        })
        .onSubmit(() => {
          if(this.getFormValidate()) {
            this.login()
          }
        })
     // 登录按钮
      Button({ type: ButtonType.Capsule }) {
        Row() {
          if (this.showLoading) {
            LoadingProgress().width(20).height(20).margin({ right: 12 }).color($r('app.color.white'))
          }
          Text('登录').fontColor($r('app.color.white'))
        }
      }
      .backgroundColor(this.getFormValidate() ? $r('app.color.primary') :  $r('app.color.primary_disabled'))
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