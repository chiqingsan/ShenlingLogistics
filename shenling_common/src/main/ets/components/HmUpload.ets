import picker from '@ohos.file.picker'
import fs from '@ohos.file.fs'
import util from '@ohos.util'
import request from '@ohos.request';
import { uploadImage } from '../api/upload';
import { ImageList } from '../models'
import { HmLoading } from './HmLoading'
import { HmPreview } from './HmPreview'
import { promptAction } from '@kit.ArkUI';

@Preview
@Component
struct HmUpload {
  @Prop
  canUpload: boolean = true // 默认可上传
  title: string = ""
  maxNumber: number = 3
  onListChange: (list: ImageList[]) => void = () => {}

  // 声明两个状态变量
  @State
  index: number = -1
  @Prop
  imgList: ImageList[] = []
  preview: CustomDialogController = new CustomDialogController({
    autoCancel: false,
    customStyle: true,
    alignment: DialogAlignment.Center,
    builder: HmPreview({
      urls: this.imgList.map(item => item.url),
      selectIndex: this.index
    })
  })

  async selectImage() {
    const photoPicker = new picker.PhotoViewPicker()
    const result = await photoPicker.select({
      MIMEType: picker.PhotoViewMIMETypes.IMAGE_TYPE,
      maxSelectNumber: this.maxNumber - this.imgList.length
    })

    // 循环数组
    if (result.photoUris?.length) {
      this.imgList = this.imgList.concat(result.photoUris.map(url => {
        return { url } as ImageList
      }))
      this.onListChange(this.imgList)
    }
    // this.layer.open()
    // const addFolderName = "laogao"
    // const defaultDir = getContext(this).cacheDir + '/' + addFolderName
    // let files: request.File[] = [] // 声明参数列表
    // result.photoUris.forEach(url => {
    //   // url是media的地址
    //   // fs 是操作文件的对象
    //   // 使用fs读文件
    //   // 读取沙箱路径
    //   const file = fs.openSync(url, fs.OpenMode.READ_ONLY) // 得到文件对象
    //   // 拷贝到沙箱目录下 cache/
    //   // 起一个唯一的文件名 ！！！！
    //   if(!fs.listFileSync(getContext(this).cacheDir).includes(addFolderName)) {
    //     // 判断有没有老高的目录
    //     fs.mkdirSync(defaultDir)
    //   }
    //   const tempFileName = util.generateRandomUUID() + '.jpg'
    //   const fileUri = defaultDir + "/" + tempFileName
    //   fs.copyFileSync(file.fd, fileUri) // 沙箱路径
    //   files.push({
    //     name: 'file', // 和接口对应的
    //     filename: tempFileName,
    //     type: 'jpg',
    //     uri: `internal://cache/${addFolderName}/${tempFileName}`
    //   })
    // })
    // const  images =  await uploadImage(getContext(this),files)
    // this.upClass.images = this.upClass.images.concat(images as ImageList[]) //连接图片
    // this.layer.close()
  }

  build() {
    Column() {
      Text(this.title)
        .fontSize(14)
        .fontColor($r('app.color.text_secondary'))
        .margin({
          top: 16,
          bottom: 16
        })
      // 渲染图片
      Grid() {
        ForEach(this.imgList, (item: ImageList, index: number) => {
          GridItem() {
            Stack({ alignContent: Alignment.TopEnd }) {
              Image(item.url)
                .width(95)
                .height(95)
                .borderRadius(4)
                .onClick(() => {
                  this.index = index
                  this.preview.open()
                })
              if(this.canUpload) {
                Image($r('app.media.ic_btn_delete')).width(30).height(30)
                  .onClick(() => {
                    this.imgList.splice(index)
                  })
              }
            }.margin({ right: 15, bottom: 10 })
          }
        })
        if (this.imgList.length < this.maxNumber && this.canUpload) {
          GridItem() {
            Row() {
              Image($r("app.media.ic_add_img")).width(30).height(30)
            }
            .width(95)
            .height(95)
            .backgroundColor($r("app.color.upload_panel"))
            .alignItems(VerticalAlign.Center)
            .justifyContent(FlexAlign.Center)
            .onClick(() => {
              this.selectImage()
            })
          }
        }
      }
      .height(Math.ceil(this.maxNumber / 3) * 105)
      .columnsTemplate("1fr 1fr 1fr")
      .rowsGap(10)

    }

    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}
const UploadFile = async (list: ImageList[]) => {
  const addFolderName = "laogao"
  const defaultDir = getContext().cacheDir + '/' + addFolderName
  let files: request.File[] = [] // 声明参数列表
  list.forEach(item => {
    // url是media的地址
    // fs 是操作文件的对象
    // 使用fs读文件
    // 读取沙箱路径
    const file = fs.openSync(item.url, fs.OpenMode.READ_ONLY) // 得到文件对象
    // 拷贝到沙箱目录下 cache/
    // 起一个唯一的文件名 ！！！！
    if(!fs.listFileSync(getContext().cacheDir).includes(addFolderName)) {
      // 判断有没有老高的目录
      fs.mkdirSync(defaultDir)
    }
    const tempFileName = util.generateRandomUUID() + '.jpg'
    const fileUri = defaultDir + "/" + tempFileName
    fs.copyFileSync(file.fd, fileUri) // 拷贝到沙箱路径
    files.push({
      name: 'file', // 和接口对应的
      filename: tempFileName,
      type: 'jpg',
      uri: `internal://cache/${addFolderName}/${tempFileName}`
    })
    fs.closeSync(file.fd)
  })
  return await uploadImage(getContext(), files) // 上传图片
}
export { HmUpload, UploadFile }