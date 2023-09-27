



import 'package:evo_restaurant/global/api_source.dart';
import 'package:evo_restaurant/repositories/models/family.dart';
import 'package:evo_restaurant/repositories/models/response_object.dart';

class SubFamilyService {
  late ApiSource _apiSource;


  set apiSource(ApiSource value) {
    _apiSource = value;
  }

  Future<ResponseObject> getSubfamily(Family family) async{
    return await _apiSource.getSubfamily(family);

  }

  Future<ResponseObject> getArticlesOfSubfamily(String id, String idFamily) async {

    return await _apiSource.getArticlesOfSubfamily(id, idFamily);


  }

  Future<ResponseObject> getArticlesAsFamily(Family family)async {

    return await _apiSource.getArticlesAsFamily(family);
  }





}