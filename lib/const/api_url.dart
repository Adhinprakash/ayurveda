
final String baseurl="https://flutter-amr.noviindus.in/api/";

Uri buildBaseUrl(String endPoint) {
  Uri url = Uri.parse(endPoint);
  if (!endPoint.startsWith('http')) url = Uri.parse('$baseurl$endPoint');


  return url;
}