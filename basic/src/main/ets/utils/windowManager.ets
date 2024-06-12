import { window } from '@kit.ArkUI'
import { deviceInfo } from '@kit.BasicServicesKit'


export class windowManager {
  // 是否开启沉浸式状态栏
  static enableFullScreen(isOn: boolean) {
    window.getLastWindow(getContext())
      .then((win) => {
        win.setWindowLayoutFullScreen(isOn)

        if (isOn) {

          if (deviceInfo.deviceType === "2in1") {
            return
          }

          // 如果开启,则获取安全区的高度, 转换为vp
          const topArea = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)

          // 顶部安全区的高度
          const hvp = px2vp(topArea.topRect.height)
          AppStorage.setOrCreate("topHeight", hvp)

          // 获取底部安全区域
          const bottomArea = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR)
          // 底部安全区的高度
          const bvp = px2vp(bottomArea.bottomRect.height)
          AppStorage.setOrCreate("bottomHeight", bvp)
        } else {
          // 如果关闭这设置top为0
          AppStorage.setOrCreate("topHeight", 0)
          AppStorage.setOrCreate("bottomHeight", 0)
        }
      })
  }

  // 设定状态栏的颜色
  // true = 白 false = 黑
  static settingStatusBar(LorD: boolean = false) {
    window.getLastWindow(getContext())
      .then((win) => {
        win.setWindowSystemBarProperties({
          statusBarContentColor: LorD ? "#ffffff" : "#000000"
        })
      })
  }
}