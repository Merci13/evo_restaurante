

class Config {

  final String basePath = "http://209.145.58.91/";
  final String apiKey = "mzZ58he3";



/*
*
* Para realizar una consulta al api se debe componer de la siguiene manera
* URL + tabla o Consula + filtro  + API key
*
* URL
* http://209.145.58.91/Pruebas/vERP_2_dat_dat/v1/
*   api key
* &api_key=mzZ58he3
*   Tabla de saloneros
* dep_t
*   Para filtrar es
* ?filter[campo]=valor
* donde campo es nombre del campo sobre cual quiere aplicar el filtro
* y valor es con lo que quieres filtral
* Ejemplo quieres filtar por nombre saloneros qu se llama oscar1
* ?filter[nombre]=oscar
*   http://209.145.58.91/Pruebas/vERP_2_dat_dat/v1/dep_t?filter[name]=oscar&api_key=mzZ58he3
*   eso seria un ejemplo
*   puedes usar el mesero Demo
*   http://209.145.58.91/Pruebas/vERP_2_dat_dat/v1/dep_t?filter[name]=Demo&api_key=mzZ58he3
*
* en resumen esto seria una  variable http://209.145.58.91/Pruebas/vERP_2_dat_dat/v1/
* {
*	"count": 1,
*	"total_count": 1,
*	"dep_t": [
*		{
*			"id": 1,
*			"emp": "1",
*			"emp_div": "1",
*			"name": "velneo",
*			"pwd": "1234",
*			"sup_dep": false
*		 }
*	 ]
* }
*
* */




}