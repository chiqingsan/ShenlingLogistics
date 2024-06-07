import { BASE_URL, TOKEN_KEY } from "../constants"
import { promptAction, router } from '@kit.ArkUI';
import { UserSettingClass } from '.';
import { ResponseData } from '../models'
import { http } from '@kit.NetworkKit';
import { Log } from '@abner/log';

// 请求工具 get/put/delete/post/patch
// url 类型 参数
// 任何对象都可以as object
async function requestHttp<T>(url: string = "", method: http.RequestMethod = http.RequestMethod.GET,
  data?: object): Promise<T> {
  // http需要创建一个请求对象
  const httpRequest = http.createHttp() // 创建一个请求对象- 如果你想用单例 那么请不要在请求时销毁
  let urlStr = BASE_URL + url // 基础地址拼接url地址
  // 进行处理
  // 官方文档上写的是ok的，但是运行有问题，虽然说了 如果get类型会进行拼接地址，但是实际并没有
  // get/post区别是什么
  if (method === http.RequestMethod.GET) {
    // data参数都拼接到地址上  ?a=1&b=2&c=3
    if (data && Object.keys(data).length) {
      urlStr += "?" + Object.keys(data).filter(key =>!!data[key]).map(key => {
        return `${key}=${data[key]}`
      }).join("&")
    }
  }
  // 组装参数
  const token = AppStorage.get(TOKEN_KEY) || ""
  Log.info(token as string, "request_token")
  const config: http.HttpRequestOptions = {
    extraData: method !== http.RequestMethod.GET ? data : "", // 当请求类型不等于get时 复制
    header: {
      "Content-Type": "application/json",
      Authorization: token, // 设置请求头的token 每个接口都有
    },
    method,
    readTimeout: 10000 // 如果多少秒没响应就断开
  }
  try {
    // 发请求
    const result = await httpRequest.request(urlStr, config) // 发请求
    // 这里要处理一些异常
    // 判断状态码 http状态码 业务状态码
    if (result.responseCode === 401) {
      // 401 就表示token失效 超时 或者没传
      // 移动端产品应该去做无感刷新
      // token refresh_token => 换取新的token => 重新发请求
      // 提示错误 -删除目前的token 跳到登录页
      promptAction.showToast({ message: '登录失效' })
      // 删除token - 删两个地址 首选项- 全局状态
      new UserSettingClass(getContext()).setUserToken("") // 清空首选项token
      AppStorage.set(TOKEN_KEY, "") // 只能设置 不能删除
      router.replaceUrl({
        url: 'pages/Login/Login' // 跳转到登录页
      })
      // Hap har
      return Promise.reject(new Error("登录失效"))
    } else if (result.responseCode === 404) {
      promptAction.showToast({ message: '请求地址错误' })
      return Promise.reject(new Error("请求地址错误"))
    } else {
      // 假设已经成功 此时不一定成功哦  还有业务状态码呢 只有业务状态码 200的时候才成功
      const res = JSON.parse(result.result as string) as ResponseData<T> // { code, data, msg }
      Log.info(res, "request_res")
      if (res.code === 200) {
        // 才认为这次请求真的成功了
        return res.data as T
      } else {
        // 业务错了
        promptAction.showToast({ message: "服务器异常" }) //  res.msg没处理好 有可能出来一堆服务器语言
        return Promise.reject(res) // 业务错误 请求终止
      }
    }
  } catch (error) {
    promptAction.showToast({ message: error.message }) //  res.msg没处理好 有可能出来一堆服务器语言
    return Promise.reject(error) // 业务错误 请求终止
  }

}

export class RequestModels {
  static get<T>(url: string, data?: object): Promise<T> {
    return requestHttp<T>(url, http.RequestMethod.GET, data)
  }

  static post<T>(url: string, data?: object): Promise<T> {
    return requestHttp<T>(url, http.RequestMethod.POST, data)
  }

  static delete<T>(url: string, data?: object): Promise<T> {
    return requestHttp<T>(url, http.RequestMethod.DELETE, data)
  }

  static put<T>(url: string, data?: object): Promise<T> {
    return requestHttp<T>(url, http.RequestMethod.PUT, data)
  }
}
