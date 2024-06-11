import 'package:testapp/response.dart';

class ApiResponse<T> {
  Status? status;
  T? data;
  String? message;

  ApiResponse({this.status, this.data, this.message});

  ApiResponse.loading() : status = Status.LOADED;
  ApiResponse.completed() : status = Status.COMPLETE;
  ApiResponse.error() : status = Status.ERROR;

  @override
  String toString() {
    return 'Status $status \n Message $message \n Data $data';
  }
}
