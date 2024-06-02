import { RequestModels } from '@hm/basic/Index'
import { LoginFormModel, UserInfoModel } from '../models'

// 登录接口实现
export const login = (data: LoginFormModel) => {
  return RequestModels.post<string>("/login/account", data)
}


// 获取用户信息
export const getUserInfo = () => {
  return RequestModels.get<UserInfoModel>("/users")
}