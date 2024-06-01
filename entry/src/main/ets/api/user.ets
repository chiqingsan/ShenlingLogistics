import { RequestModels } from '@hm/basic/Index'
import { LoginFormModel } from '../models'

// 登录接口实现
export const login = (data: LoginFormModel) => {
  return RequestModels.post<string>("/login/account", data)
}