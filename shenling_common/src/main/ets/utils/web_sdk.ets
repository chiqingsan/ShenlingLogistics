import promptAction from '@ohos.promptAction'
import geoLocationManager from '@ohos.geoLocationManager'
import webview from '@ohos.web.webview'

export class WebSdkClass {
  static controller : webview.WebviewController | null = null
  static context: Context | null = null
  alert(msg: string) {
     AlertDialog.show({ message: msg })
  }
  toast (msg: string) {
    promptAction.showToast({ message: msg })
  }
  async getLocation (funcName: string) {
    try {
      const result = await geoLocationManager.getCurrentLocation()
      WebSdkClass.controller!.runJavaScript(`${funcName}(${result.longitude},${result.latitude})`)
    }catch (error) {
      AlertDialog.show({
        message: "获取位置失败:" + JSON.stringify(error)
      })
    }

  }
  receiveData(eventName: string, json: string) {
    WebSdkClass.context?.eventHub?.emit(eventName, json)
  }
}