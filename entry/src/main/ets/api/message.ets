import { RequestModels } from '@hm/basic/Index'
import { MessageQueryTypeModel, MessageDataModel } from '../models'

// 获取信息
export const getMessage = (params: MessageQueryTypeModel) => {
  return RequestModels.get<MessageDataModel>("/messages/page", params)
}

// 标记已读
export const readMessage = (id: string) => {
  return RequestModels.put<null>(`/messages/${id}`)
}

// 全部已读
export const readAllMessage = (contentType: string) => {
  return RequestModels.put<null>(`/messages/readAll/${contentType}`)
}