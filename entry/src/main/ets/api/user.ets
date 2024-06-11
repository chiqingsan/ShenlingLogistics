import { RequestModels } from '@hm/basic/Index'
import {
  LoginFormModel,
  UserCarDataTypeModel,
  UserInfoModel,
  UserTaskInfoModel,
  UserTaskInfoParamsModel
} from '../models'

// 登录接口实现
export const login = (data: LoginFormModel) => {
  return RequestModels.post<string>("/login/account", data)
}


// 获取用户信息
export const getUserInfo = () => {
  return RequestModels.get<UserInfoModel>("/users")
}

// 获取用户任务数据
export const getUserTaskInfo = (data: UserTaskInfoParamsModel) => {
  return RequestModels.get<UserTaskInfoModel>("/users/taskReport", data)
}

// 获取用户车辆信息
export const getUserCarInfo = () => {
  return RequestModels.get<UserCarDataTypeModel>("/users/truck")
}