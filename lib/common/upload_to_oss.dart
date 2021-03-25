import 'package:client/service/service.dart';
import '../utils/toast_util.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../api/api.dart';

Map data = {};
String suffix = '';
String getFile = '';
File file;

openGallery(type, [changeLoading]) async {
  if (changeLoading != null) {
    changeLoading(type: 1, sent: 0, total: 100);
  }

  Map<String, dynamic> map = Map();
  if (type == 'image') {
    suffix = 'jpg';
  } else if (type == 'mp4') {
    suffix = 'mp4';
  }

  map.putIfAbsent("type", () => type);
  map.putIfAbsent("suffix", () => suffix);
  print('map------------------------------------>>>>>>>>>>>>>>$map');
  Service().getData(map, Api.GET_OSS_INFO_URL, (success) async {
    print('获取filename成功');
    data = success;
    print('data===$data');
    getFile = success['filename'];
  }, (onFail) async {
    ToastUtil.showToast(onFail);
  });

  final pickedFile = type == "image"
      ? await ImagePicker().getImage(source: ImageSource.gallery)
      : await ImagePicker().getVideo(source: ImageSource.gallery);
  if (pickedFile == null) {
    return;
  }
  file = File(pickedFile.path);
  print('file-->>>$file');

  return uploadImage(file, data, changeLoading, type);
}

//上传图片
uploadImage(File file, obj, changeLoading, type) async {
  var _sign = obj['data'];
  print('sign====$_sign');
  //创建dio对象
  Dio dio = new Dio();
  //dio的请求配置
  dio.options.responseType = ResponseType.plain;
  // dio.options.contentType = ContentType.parse("multipart/form-data");
  //文件名
  String path = file.path;
  String chuo = getFile;
  String fileNames = getFile;

  //创建一个FormData，作为dio的参数
  FormData formData = new FormData.fromMap({
    'chunk': '0',
    'OSSAccessKeyId': _sign['accessid'].toString(),
    'policy': _sign['policy'].toString(),
    'Signature': _sign['signature'].toString(),
    'Expires': _sign['expire'].toString(),
    'key': _sign['dir'] + chuo,
    'success_action_status': '200',
    'callback': _sign['callback'],
    'Access-Control-Allow-Origin': '*',
    'file': await MultipartFile.fromFile(path.toString(), filename: fileNames)
  });

  try {
    Response response = await dio.post(_sign['host'], data: formData,
        onSendProgress: (int sent, int total) {
      print("上传进度=======$sent--->>$total");
      changeLoading(type: 1, sent: sent, total: total);
      if (sent == total) {
        print('百分之百');
      }
    });

    print('response-->>>${response.data}');
    print('url-->>>${_sign['host'] + '/' + _sign['dir'] + fileNames}');
    if (changeLoading != null) {
      changeLoading(type: 2, sent: 0, total: 100);
    }
    if (response.statusCode == 200) {
      print('response====$response');
      return {
        "errcode": 0,
        "url": _sign['host'] + '/' + _sign['dir'] + fileNames,
      };
    } else {
      return {
        "errcode": 1,
        "msg": "上传失败",
      };
      // return {
      //   "errcode": 0,
      //   "url": _sign['host'] + '/' + _sign['dir'] + fileNames,
      // };
    }
  } on DioError catch (e) {
    // Toast.show(context, '上传失败');
    print("get uploadImage error: $e");
  }
}
