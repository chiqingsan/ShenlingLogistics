
import { UserCarDataTypeModel, LoginFormModel, UserInfoModel, UserTaskInfoModel, UserTaskInfoParamsModel } from '../models'
import { Request } from 'shenling_common'

// 登录接口实现
export const login = (data: LoginFormModel) => {
  return Request.post<string>("/login/account", data)
}

// 获取用户信息的接口

export const getUserInfo = () => {
   return Request.get<UserInfoModel>("/users")
}

// 获取用户任务数据
export const getUserTaskInfo = (data: UserTaskInfoParamsModel) => {
  return Request.get<UserTaskInfoModel>("/users/taskReport", data)
}

// 获取用户车辆信息
export const getUserCarInfo = () => {
  return Request.get<UserCarDataTypeModel>("/users/truck")
}