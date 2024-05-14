import { Request } from 'shenling_common'
import {ExceptionParamsTypeModel, DelayParamsTypeModel, DeliverParamsTypeModel, TaskListDataModel, TaskListParamsModel, TaskDetailInfoModel, PickUpParamsModel, CarRecordTypeModel } from '../models'

// 类型传值时 既可以用interface 也可以用class
export const getTaskList = (params: TaskListParamsModel) => {
  console.log("getTaskList:",)
  return Request.get<TaskListDataModel>("/tasks/list", params)
}
// 获取任务详情的接口
export const  getTaskDetail = (id: string) => {
  return Request.get<TaskDetailInfoModel>(`/tasks/details/${id}`)
}
// 提货
export const pickUp = (data: PickUpParamsModel) => {
  return Request.post<null>("/tasks/takeDelivery", data)
}
// 交货
export const deliver = (data: DeliverParamsTypeModel) => {
  return Request.post<null>("/tasks/deliver", data)
}
// 回车登记
export const carRecord = (data: CarRecordTypeModel) => {
  return Request.post<null>("/tasks/truckRegistration", data)
}
// 延迟提货
export const delay = (data: DelayParamsTypeModel) => {
  return Request.put<null>("/tasks/delay", data)
}
// 上报异常
export const exception = (data: ExceptionParamsTypeModel) => {
  return Request.post<null>("/tasks/reportException", data)
}