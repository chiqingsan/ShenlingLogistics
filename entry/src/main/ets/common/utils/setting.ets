// 用首选项读取广告 设置广告
import preferences from '@ohos.data.preferences'

export const USER_SETTING = "shenling_setting"

export const USER_SETTING_AD = "shenling_setting_ad"

// Token
export const TOKEN_KEY = "shenling_token"

// 用户广告只是用户设置的一种-还可以设置用户的其他行为

export class AdvertClass {
  showAd: boolean = false // 显示广告
  adTime: number = 5 // 广告倒计时
  adUrl?: string = ""
  adImg: ResourceStr = "" // 广告图片
}

// 默认广告数据
const defaultAd: AdvertClass = {
  showAd: true,
  adTime: 5,
  adImg: $r('app.media.start')
}

export class UserSettingClass {
  // 1. 获取首选项的仓库
  context: Context

  constructor(context: Context) {
    this.context = context
  }

  // 获取仓库
  getStore() {
    return preferences.getPreferences(this.context, USER_SETTING)
  }

  // 读取广告
  async getUserAd(): Promise<AdvertClass> {
    const adStore = await this.getStore()
    // 读取广告的配置
    // get的第二个参数是默认值
    return JSON.parse(await adStore.get(USER_SETTING_AD, JSON.stringify(defaultAd)) as string) as AdvertClass
  }

  // 设置广告
  async setUserAd(ad: AdvertClass) {
    const adStore = await this.getStore()
    await adStore.put(USER_SETTING_AD, JSON.stringify(ad))
    // 写入磁盘
    await adStore.flush()
  }

  // 读取token值
  async getUserToken(): Promise<string> {
    const adStore = await this.getStore()
    return await adStore.get(TOKEN_KEY, "") as string
  }

  // 设置token到首选项
  async setUserToken(token: string) {
    const adStore = await this.getStore()
    await adStore.put(TOKEN_KEY, token)
    // 写入磁盘
    await adStore.flush()
  }
}

export const PreferencesDefault = new UserSettingClass(getContext())