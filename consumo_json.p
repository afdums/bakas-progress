/*D:\Totvs\Progress\dlc11\gui\netlib\OpenEdge.Net.pl*/

block-level on error undo, throw.

/** Carrega bibliotecas necessarias **/
using OpenEdge.Net.HTTP.IHttpClientLibrary.
using OpenEdge.Net.HTTP.ConfigBuilder.
using OpenEdge.Net.HTTP.ClientBuilder.
using OpenEdge.Net.HTTP.Credentials.
using OpenEdge.Net.HTTP.IHttpClient.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.RequestBuilder.
using OpenEdge.Net.URI.
using OpenEdge.Net.HTTP.IHttpResponse.

using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.JsonArray.

def var oClient        as IHttpClient        no-undo.
def var oUri           as URI                no-undo.
def var oReq           as IHttpRequest       no-undo.
def var oResp          as IHttpResponse      no-undo.
def var oCreds         as Credentials        no-undo.
        
def var oJsonRespObj   as JsonObject         no-undo.        
def var oJsonRespArray as JsonArray          no-undo.
def var oJsonObj       as JsonObject         no-undo.
def var oJsonArray     as JsonArray          no-undo.
        
def var i              as int                no-undo.

   
def temp-table tt-rastreio
    field id as char format "x(60)"
    field nr_hawb as char format "x(60)"
    field data as char format "x(60)"
    field descricao as char format "x(60)"
    field remetente as char format "x(60)"
    field destinatario as char format "x(60)".    
    

/* *************************** GET *************************** */
/*************************************************************************
    URL Destino: GET http://scmdex.azurewebsites.net/api/Ocorrencias/123456/570792038/false
 *************************************************************************/

/* INI - requisicao web */
assign oClient   = ClientBuilder:Build():Client       
       oUri      = new URI("http", "") /* URI("metodo", "dominio", "porta") */
       oUri:Path = "".                                       /* URI:Path: demais partes da URL destino */
       
/* Faz a requisicao utilizando GET */
oReq  = RequestBuilder:Get(oUri):Request.
oResp = oClient:Execute(oReq).
/* FIM - requisicao web */

/* trata o retorno */
empty temp-table tt-rastreio.

/* valida o tipo de retorno, se for Json processa normalmente */
if type-of(oResp:Entity, JsonArray) then do:
    
    oJsonRespArray = cast(oResp:Entity, JsonArray).
    
    oJsonArray = oJsonRespArray.        
	
	/* Mostra o total de registros retornados */
    message oJsonArray:length
        view-as alert-box.
    
	/* Converte de Json para Registros na temp-table */
	Loop1:
    do i=1 to oJsonArray:length on error undo, next:
        oJsonObj = oJsonArray:GetJsonObject(i).
        
        create tt-rastreio.
        assign tt-rastreio.id        = string(oJsonObj:GetInt64("id"))
               tt-rastreio.nr_hawb = oJsonObj:GetCharacter("nr_hawb")
               tt-rastreio.data  = oJsonObj:GetCharacter("data")
               tt-rastreio.descricao  = oJsonObj:GetCharacter("descricao")
               tt-rastreio.remetente  = oJsonObj:GetCharacter("remetente")
               tt-rastreio.destinatario  = oJsonObj:GetCharacter("destinatario").
    end.    
end.

/** Abaixo regras de negocio e tratamentos necessarios **/
for each tt-rastreio no-lock:
    disp tt-rastreio
    with 1 col side-labels width 80.
end.
