import 'package:evo_restaurant/global/api_source.dart';
import 'package:evo_restaurant/repositories/models/article.dart';
import 'package:evo_restaurant/repositories/models/response_object.dart';
import 'package:evo_restaurant/utils/db/sql_helper.dart';

class ArticleService {
  late ApiSource _apiSource;

  set apiSource(ApiSource value) {
    _apiSource = value;
  }

  Future<bool> chargeArticles() async {
    try {
      List<Map<String, dynamic>> listOfArticles = await SQLHelper.getArticles();
      if (listOfArticles.isNotEmpty) {
        //delete every article in the db
        bool fail = false;
        String id = "";
        for (Map<String, dynamic> element in listOfArticles) {
          if (element['id'] != null) {
            int res = await SQLHelper.deleteArticle("${element['id']}");
            if (res != 1) {
              fail = true;
              id = element['id'];
              break;
            }
            print("---> Article Deleted. Id=${element['id']}");
          }
        }
       listOfArticles = await SQLHelper.getArticles();
        print("---> Articles in db: ${listOfArticles.length}");
        if (fail && id != "") {
          print("Error in chargeArticles method in article_service.dart."
              " Error: element can't be deleted in DataBase, element id=$id");
          return false;
        }
        //listOfArticles.clear();
        listOfArticles = await SQLHelper.getArticles();
        print("---> Articles in data Base: ${listOfArticles.length}");

        ResponseObject resArticle = await _apiSource.getAllArticles();
        bool response = resArticle.status ?? false;
        if (response) {
          List<Article> articlesAPI =
              resArticle.responseObject as List<Article>;
          String idArticle = "";
          for (Article article in articlesAPI) {
            //check of the family id, if the id has length 4 is a sub-family

            //--------------TEST-----------//
              if((article.fam??"").length > 2){
                print(article);
              }
            //--------------TEST-----------//
            String va = "${article.fam}";
            int id = await SQLHelper.createArticle(
              idArticle: "${article.id}",
              idFamily: va.length == 4 ? null : va,
              img: article.img,
              name: article.name,
              codBar: article.codBar,
              regIvaVta: article.regIvaVta,
              pvp: article.pvp,
              beb: (article.beb ?? false),
              idSubfamily: va.length == 4 ? va : null,
            );
            if (id != 0) {
              print("--->>> Article was inserted in DB: id=${article.id}");
            } else {
              print("--->>> Error inserting article id = ${article.id}");
              idArticle = "${article.id}";
              break;
            }
          }
          List<Map<String,dynamic>> temp = await SQLHelper.getArticles();
          print("--->>> Agregados a bd:   ${temp.length} <<<---"); //id=303



          if (idArticle != "") {
            return false;
          } else {
            return true;
          }
        } else {
          print(
              "Error calling API in chargeArticles method in article_service.dart."
              " Error: ${resArticle.errorObject?.errorMessage ?? ""}");
          return false;
        }
      }
      //articles is empty
      else {
        ResponseObject resArticle = await _apiSource.getAllArticles();
        bool response = resArticle.status ?? false;
        if (response) {
          List<Article> articlesAPI =
              resArticle.responseObject as List<Article>;
          String idArticle = "";
          for (Article article in articlesAPI) {
            //check of the family id, if the id has length 4 is a sub-family
            String va = "${article.fam}";
            int id = await SQLHelper.createArticle(
              idArticle: "${article.id}",
              idFamily: va.length == 4 ? null : va,
              img: article.img,
              name: article.name,
              codBar: article.codBar,
              regIvaVta: article.regIvaVta,
              pvp: article.pvp,
              beb: (article.beb ?? false),
              idSubfamily: va.length == 4 ? va : null,
            );
            if (id != 0) {
              print("--->>> Article was inserted in DB: id=${article.id}");
            } else {
              print("--->>> Error inserting article id = ${article.id}");
              idArticle = "${article.id}";
              break;
            }
          }
          List<Map<String,dynamic>> temp = await SQLHelper.getArticles();
          print("--->>> Agregados a bd:   ${temp.length} <<<---"); //id=303



          if (idArticle != "") {
            return false;
          } else {
            return true;
          }
        } else {
          print(
              "Error calling API in chargeArticles method in article_service.dart."
              " Error: ${resArticle.errorObject?.errorMessage ?? ""}");
          return false;
        }
      }
    } catch (error) {
      print(
          "Error in article_service.dart in method chargeArticles. Error: $error");
      return false;
    }
  }
}
