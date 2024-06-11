abstract class BaseApiResponse {
  Future<dynamic> getApiRespinse(String url);
  Future<dynamic> getPostResponse(String url, dynamic data);
}
