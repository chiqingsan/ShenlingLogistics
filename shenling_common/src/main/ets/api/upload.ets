import { BASE_URL, TOKEN_KEY } from '../constants'
import request from '@ohos.request';
import { Request as RequestClass } from '../utils'
import {  ImageList } from '../models';

// 上传文件
export const uploadImage  = async (context: Context, files :request.File[]) => {
  //
  const config: request.UploadConfig = {
    url: `${BASE_URL}/files/imageUpload`,
    method: 'POST',
    header: {
      "Authorization": AppStorage.get<string>(TOKEN_KEY) || '',
      "Content-Type" : "multipart/form-data"  // formData类型
    },
    files,
    data: [] // data本意是 在传文件的过程中 传递一些其他表单数据
  }
  try {
    return new Promise<ImageList[]>(async (resolve, reject) => {
      const task = await request.uploadFile(context, config)
      // 执行到这里并不意味着上传完成， 只是意味着任务队列执行完成
      task.on("fail", () => {
        AlertDialog.show({
          message: "上传失败"
        })
        reject(new Error("图片上传失败"))
      })
      task.on("progress", (uploadedSize: number, totalSize: number) => {
         // promptAction.showToast({ message: (uploadedSize /totalSize) * 100 + "%" })
      })
      task.on("complete",  async (value) => {
        // 此时已经成功了 但是 需要请求地址
        const result = await Promise.all<string>(files.map(item => RequestClass.get<string>("/files/imageUrl", {
          imageName: item.filename.slice(0, item.filename.indexOf('.'))
        } as FileParams)))
        resolve(result.map(url => ({ url } as ImageList)))
      })
    })

  }catch (error) {
    AlertDialog.show({
      message: error.message
    })
    return Promise.reject(error)
  }
}
class FileParams {
  imageName: string = ""
}