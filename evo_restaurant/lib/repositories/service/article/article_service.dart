


import 'package:evo_restaurant/global/api_source.dart';
import 'package:evo_restaurant/repositories/models/family.dart';
import 'package:evo_restaurant/repositories/models/response_object.dart';
import 'package:evo_restaurant/utils/db/sql_helper.dart';

class ArticleService{

  late ApiSource _apiSource;

  set apiSource(ApiSource value) {
    _apiSource = value;
  }

  Future<bool> chargeArticles() async{
    try{

     List<Map<String, dynamic>> listOfFamilies = await SQLHelper.getFamilies();
     List<Map<String, dynamic>> listOfSubFamilies = await SQLHelper.getSubFamilies();

     for(int i =0; listOfFamilies.length > i; i ++){
       Map<String, dynamic> family = listOfFamilies[i];
       String idFamily = listOfFamilies[i]['id'];
       /// check of subfamilies already exist in subfamilies
       /// a flag of subfamily is the id of a subfamily has 4 digits



       //if res is empty,


     }











    }catch(error){
      print(
          "Error in article_service.dart in method chargeArticles. Error: $error");
      return false;
    }
  }



}