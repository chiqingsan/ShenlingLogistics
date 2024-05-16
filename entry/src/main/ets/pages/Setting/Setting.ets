import router from '@ohos.router'
import { HmCard, HmCardItem, HmNavBar, HmConfirm, TOKEN_KEY, UserSettingClass } from 'shenling_common'
import { windowManager } from '../../common/utils/WindowManager'


@Entry
@Component
struct Setting {
  confirm: CustomDialogController = new CustomDialogController({
    builder: HmConfirm({
      message: '确定退出登录吗',
      buttonList: [{
        text: '取消'
      }, {
        text: '退出',
        fontColor: $r('app.color.primary'),
        action: () => {
          // 退出吗
          this.logout()
        }
      }]
    }), // 结构 CustomBuilder结构 可以传组件结构
    customStyle: true, // 自由设置样式-builder样式才不会受影响
    alignment: DialogAlignment.Center,
    autoCancel: false
  })

  // 删除token 同步之前的首选项
  logout() {
    AppStorage.set<string>(TOKEN_KEY, "")
    new UserSettingClass(getContext(this)).setUserToken("")
    router.replaceUrl({
      url: 'pages/Login/Login'
    })
    windowManager.enableFullScreen(false)

  }

  build() {
    Column() {
      HmNavBar({ title: '系统设置' })
      HmCard() {
        HmCardItem({
          leftTitle: '换绑手机', rightText: '', onRightClick: () => {
            router.pushUrl({
              url: 'pages/Setting/BindMobile'
            })
          }
        })
        HmCardItem({
          leftTitle: '修改密码', rightText: '', onRightClick: () => {
            router.pushUrl({
              url: 'pages/Setting/ChangePassword'
            })
          }
        })
        HmCardItem({
          leftTitle: '消息通知设置', rightText: '', onRightClick: () => {
            router.pushUrl({
              url: 'pages/Setting/MessageSend'
            })
          }
        })
        HmCardItem({ leftTitle: '清理缓存', rightText: '', showBottomBorder: false })
      }

      Row() {
        Button("退出", { type: ButtonType.Normal })
          .backgroundColor($r('app.color.white'))
          .fontColor($r("app.color.text_primary"))
          .width('100%')
          .height(60)
          .borderRadius(8)
          .onClick(() => {
            this.confirm.open() // 打开弹层
          })
      }
      .width('100%')
      .padding({
        left: 15,
        right: 15
      })

    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background_page'))
  }
}