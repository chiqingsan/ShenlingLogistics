import http from '@ohos.net.http'
import promptAction from '@ohos.promptAction'
import { returnsData } from '../../models/RequestReturn'
import { router } from '@kit.ArkUI'
import { BASE_URL } from '../constants/url_var'
import { PreferencesDefault, TOKEN_KEY } from './setting'


interface EmptyInterface {}

// 支持 get  post  put delete
// Next版本不支持在箭头函数上传递泛型

async function requestHttp<T>(url: string = "", method: http.RequestMethod = http.RequestMethod.GET, data?: object): Promise<T> {
  const httpRequest = http.createHttp() // 创建一个网络请求
  let urlStr = BASE_URL + url // 拼接地址
  // 参数放在哪里
  // Get时 自动拼入到url上
  if (method === http.RequestMethod.GET) {
    if (data && Object.keys(data).length) {
      // { a: 1, b: 2, c: 3 } = > ["a", "b, "c"]
      // url?a=1&b=2&c=3
      urlStr += "?" + Object.keys(data).map(key => {
        if (data[key]) {
          return `${key}=${data[key]}` // a=1 =>
        }
        return ""
      }).join("&") // ["a=1", "b=2", "c=3"]
    }
  }
  // 设置请求对象
  // 这里可以将返回结果制定成对象
  let config: http.HttpRequestOptions = {
    method,
    readTimeout: 10000, // 超时时间
    extraData: method === http.RequestMethod.GET ? "" : data || {} as EmptyInterface,
    expectDataType: http.HttpDataType.OBJECT,
    // 请求头
    header: {
      'Content-Type': 'application/json',
      "Authorization": AppStorage.get<string>(TOKEN_KEY) || ''
    }
  }
  try {
    // 发请求
    const res = await httpRequest.request(urlStr, config)
    if (res.responseCode === 401) {
      // token超时
      AppStorage.setOrCreate<string>(TOKEN_KEY, "") // Delete不可以 是个坑 删不掉持久化数据
      PreferencesDefault.setUserToken("") // 删除首选项的token
      promptAction.showToast({
        message: 'token超时了'
      })
      // 回登录
      router.replaceUrl({
        url: 'pages/UserLogin/LoginPhone'
      })
      // 返回错误 停止执行
      return Promise.reject(new Error("token超时了"))
    }
    else if (res.responseCode === 404) {
      promptAction.showToast({
        message: '请求地址不正确'
      })
      return Promise.reject(new Error("请求地址不正确"))
    } else {
      // res.result就是接口返回的结构
      const result = res.result as returnsData<T>
      // code值只要不是200都是失败的
      if (result.code === 200) {
        return result.data as T
      } else {
        promptAction.showToast({
          message: result.msg
        })
        return Promise.reject(new Error(result.msg))
      }
    }
  }
  catch (error) {
    promptAction.showToast({ message: error.message })
    return Promise.reject(error)
  }
  finally {
    httpRequest.destroy() // 销毁请求 请求结束了
  }
}

export class SlRequest {
  static async get<T>(url: string, data?: object): Promise<T> {
    const resData = await requestHttp<T>(url, http.RequestMethod.GET, data)
    console.info("get resData:", JSON.stringify(resData))
    return resData
  }

  static async post<T>(url: string, data?: object): Promise<T> {
    const resData = await requestHttp<T>(url, http.RequestMethod.POST, data)
    console.info("get resData:", JSON.stringify(resData))
    return resData
  }

  static async put<T>(url: string, data?: object): Promise<T> {
    const resData = await requestHttp<T>(url, http.RequestMethod.PUT, data)
    console.info("get resData:", JSON.stringify(resData))
    return resData
  }

  static async delete<T>(url: string, data?: object): Promise<T> {
    const resData = await requestHttp<T>(url, http.RequestMethod.DELETE, data)
    console.info("get resData:", JSON.stringify(resData))
    return resData
  }
}
