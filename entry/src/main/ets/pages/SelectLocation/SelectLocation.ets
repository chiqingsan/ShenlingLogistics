import { HmNavBar, HmCard, HmCardItem } from '@hm/basic'
import { MapComponent } from '@hms.core.map.MapComponent'
import { geoLocationManager } from '@kit.LocationKit'
import { map, site } from '@kit.MapKit'
import { router } from '@kit.ArkUI'

class SiteClass {
  name: string = ""
  distance: number = 0
}

interface mapCoordinates {
  latitude: number
  longitude: number
}

// 初始化ui状态持久化
PersistentStorage.persistProp("mapCoordinates", {})

@Entry
@Component
struct SelectLocation {
  @State list: SiteClass[] = []
  mapController: map.MapComponentController = new map.MapComponentController()
  @StorageLink("mapCoordinates") latitudeAndLongitude: mapCoordinates = {
    latitude: 39.9,
    longitude: 116.4
  }

  async aboutToAppear() {

  }

  async getLocation() {
    try {
      const rightPostion = await geoLocationManager.getCurrentLocation()
      // let wgs84Position: mapCommon.LatLng = {
      //   latitude: result.latitude,
      //   longitude: result.longitude
      // };
      // let rightPostion: mapCommon.LatLng = await map.convertCoordinate(mapCommon.CoordinateType.WGS84,
      //   mapCommon.CoordinateType.GCJ02, wgs84Position);

      // 保存这一次的经纬度,提供给下一次使用
      this.latitudeAndLongitude.latitude = rightPostion.latitude
      this.latitudeAndLongitude.longitude = rightPostion.longitude

      this.mapController.moveCamera(map.newCameraPosition({
        target: {
          longitude: rightPostion.longitude,
          latitude: rightPostion.latitude
        },
        zoom: 16 // 缩放级别
      }))

      await this.mapController.addPointAnnotation({
        position: {
          longitude: rightPostion.longitude,
          latitude: rightPostion.latitude
        },
        titles: [{
          content: '您当前的位置'
        }],
      })

      const res = await site.nearbySearch({
        location: {
          longitude: rightPostion.longitude,
          latitude: rightPostion.latitude
        },
        pageSize: 4,
        pageIndex: 1,
        radius: 50
      })
      this.list = res.sites?.slice(0, 4) as SiteClass[] // 只拿4条数据

    } catch (error) {
      AlertDialog.show({
        message: error.message
      })
    }

  }

  build() {
    Column() {
      HmNavBar({ title: '当前位置' })
      Stack({ alignContent: Alignment.Bottom }) {
        //  地图区域
        MapComponent({
          mapOptions: {
            position: {
              target: {
                latitude: this.latitudeAndLongitude.latitude,
                longitude: this.latitudeAndLongitude.longitude
              },
              zoom: 16
            }
          },
          mapCallback: (err, controller) => {
            if (!err) {
              this.mapController = controller
              this.getLocation()
            }
          }
        })
          .width('100%')
          .height('100%')
        Column() {
          HmCard() {
            ForEach(this.list, (item: SiteClass) => {
              HmCardItem({
                leftTitle: item.name, rightText: `${item.distance}m`,
                onRightClick: () => {
                  router.back({
                    url: "pages/ExceptionReport/ExceptionReport",
                    params: {
                      location: item.name
                    }
                  })
                }
              })
            })
          }
        }
        .padding({
          bottom: 60
        })
      }
    }
    .height('100%').backgroundColor($r('app.color.background_page'))
  }
}