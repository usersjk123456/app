import '../utils/toast_util.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../api/api.dart';

Map data = {};
openGallery(type, [changeLoading]) async {
  if (changeLoading != null) {
    changeLoading(type: 1, sent: 0, total: 100);
  }
  var dio = Dio();
  print('tokenUrl--->>>${Api.GET_OSS_INFO_URL}');
  Response response = await dio.get(Api.GET_OSS_INFO_URL);
  if (response.statusCode == 200) {
    if (response.data['errcode'] == 0) {
      data = response.data;
    } else {
      ToastUtil.showToast(response.data['errmsg']);
    }
  } else {
    //ToastUtil.showToast('网络连接超时');
  }
  print('data--->>>$data');

  final pickedFile = type == "img"
      ? await ImagePicker().getImage(source: ImageSource.gallery)
      : await ImagePicker().getVideo(source: ImageSource.gallery);
  if (pickedFile == null) {
    return;
  }
  File file = File(pickedFile.path);
  print('file-->>>$file');
  return uploadImage(file, data, changeLoading, type);
}

//上传图片
uploadImage(File file, obj, changeLoading, type) async {
  var _sign = obj['data'];
  //创建dio对象
  Dio dio = new Dio();
  //dio的请求配置
  dio.options.responseType = ResponseType.plain;
  // dio.options.contentType = ContentType.parse("multipart/form-data");
  //文件名
  String path = file.path;
  // print('arr--->>>$arr');
  String chuo = DateTime.now().millisecondsSinceEpoch.toString() +
      path.substring(path.lastIndexOf('.'));
  String fileNames = path.lastIndexOf('/') > -1
      ? path.substring(path.lastIndexOf('/') + 1)
      : path;
  if (type == "mp4") {
    fileNames = fileNames.substring(0, fileNames.lastIndexOf('.')) + ".mp4";
    chuo = chuo.substring(0, chuo.lastIndexOf('.')) + ".mp4";
  }
  //创建一个FormData，作为dio的参数
  FormData formData = new FormData.fromMap({
    'chunk': '0',
    'OSSAccessKeyId': _sign['accessid'].toString(),
    'policy': _sign['policy'].toString(),
    'Signature': _sign['signature'].toString(),
    'Expires': _sign['expire'].toString(),
    'key': _sign['dir'] + chuo,
    'success_action_status': '200',
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
// setState(() { showPro = false; Progress = 100; });
      } else {
// setState(() {
// Progress = int.parse(((sent / total) * 100).toStringAsFixed(0)); print(Progress); });
      }
    });

    print('response-->>>${response.statusCode}');
    print('url-->>>${_sign['host'] + '/' + _sign['dir'] + chuo}');
    if (changeLoading != null) {
      changeLoading(type: 2, sent: 0, total: 100);
    }
    if (response.statusCode == 200) {
      // print(_sign['host'] + '/' + _sign['dir'] + chuo);
      return {
        "errcode": 0,
        "url": _sign['host'] + '/' + _sign['dir'] + chuo,
      };
    } else {
      return {
        "errcode": 1,
        "msg": "上传失败",
      };
      // return {
      //   "errcode": 0,
      //   "url": _sign['host'] + '/' + _sign['dir'] + chuo,
      // };
    }
  } on DioError catch (e) {
    // Toast.show(context, '上传失败');
    print("get uploadImage error: $e");
  }
}
