block-level on error undo, throw.

using OpenEdge.Net.HTTP.ClientBuilder.
using OpenEdge.Net.HTTP.Credentials.
using OpenEdge.Net.HTTP.IHttpClient.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.RequestBuilder.
using OpenEdge.Net.URI.
using OpenEdge.Net.HTTP.IHttpResponse.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.JsonArray.



/* ***************************  Main Block  *************************** */
define variable oClient as IHttpClient no-undo.
define variable oUri as URI no-undo.
define variable oReq as IHttpRequest no-undo.
define variable oResp as IHttpResponse no-undo.
define variable oCreds as Credentials no-undo.
define variable oJson as JsonObject no-undo.
define variable oJsonArray as JsonArray no-undo.
define variable oJsonObj as JsonObject no-undo.

def var oJsonRespObj   as JsonObject         no-undo.        

DEF VAR i AS INTEGER NO-UNDO.
DEF VAR i2 AS INTEGER NO-UNDO.
DEF VAR i3 AS INTEGER NO-UNDO.

DEFINE VARIABLE oJsonArrayProdutos AS JsonArray NO-UNDO.
DEFINE VARIABLE oJsonProduto AS CLASS JsonObject NO-UNDO.

DEFINE VARIABLE oJsonArrayClientes AS JsonArray NO-UNDO.
DEFINE VARIABLE oJsonCliente AS CLASS JsonObject NO-UNDO.

DEFINE VARIABLE oJsonArrayEnderecosEntrega AS JsonArray NO-UNDO.
DEFINE VARIABLE oJsonEnderecoEntrega AS CLASS JsonObject NO-UNDO.

oClient = ClientBuilder:Build():Client.


oCreds = new Credentials('tipo', 'usuario', 'senha').

oUri = new URI('http', 'www.endereco.com.br', 8080).
oUri:Path = 'restante_do_endereco?parametro=2020-01-01&parametro2=84parametrox=3410&$format=json'.
     oReq = RequestBuilder:Get(oUri,oJson)
            :AcceptJson()
            :UsingBasicAuthentication(oCreds)
            :Request.

oResp = oClient:Execute(oReq).

DEF VAR c-caminho AS CHAR NO-UNDO.
ASSIGN c-caminho = "X:\baka-progress\".

IF TYPE-OF(oResp:Entity, JsonObject) THEN DO:
    MESSAGE "jsonObject"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    oJsonRespObj = CAST(oResp:Entity, JsonObject).

    CAST(oResp:Entity, JsonObject):WriteFile(c-caminho + 'teste-neivaldo-objeto.json', true).

    oJsonArray = oJsonRespObj:getJsonArray('value') NO-ERROR.
    
    MESSAGE 'achou: ' oJsonArray <> ?
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

    IF oJsonArray = ? OR oJsonArray:LENGTH <= 0 THEN DO:
        MESSAGE "vaziooo"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
    ELSE DO:

        MESSAGE "Registros: " oJsonArray:LENGTH
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

    	/* Converte de Json para Registros na temp-table */
        Loop1:
        do i=1 to oJsonArray:length on error undo, next:
            oJsonObj = oJsonArray:GetJsonObject(i).

            oJsonArrayClientes = oJsonObj:getJSONArray("cliente").

            LoopCliente:
            DO i2 = 1 TO oJsonArrayClientes:LENGTH ON ERROR UNDO, NEXT:

                oJsonCliente = oJsonArrayClientes:GetJsonObject(i2).

                MESSAGE "nome cliente: " string(oJsonCliente:GetCharacter("nome")) SKIP
                        "email cliente: " oJsonCliente:GetCharacter("e_mail") 
                VIEW-AS ALERT-BOX INFO BUTTONS OK.

                oJsonArrayEnderecosEntrega = oJsonCliente:getJSONArray("endereco_entrega").

                LoopEnderecoEntrega:
                DO i3 = 1 TO oJsonArrayEnderecosEntrega:LENGTH ON ERROR UNDO, NEXT:

                    oJsonEnderecoEntrega = oJsonArrayEnderecosEntrega:GetJsonObject(i3).

                    MESSAGE "lagradouro endereco entrega: " string(oJsonEnderecoEntrega:GetCharacter("logradouro")) SKIP
                            "cidade endereco entrega: " oJsonEnderecoEntrega:GetCharacter("cidade") 
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.

                END.



            END.

           
            oJsonArrayProdutos = oJsonObj:getJSONArray("produtos").
            
            LoopProdutos:
            DO i2 = 1 TO oJsonArrayProdutos:LENGTH ON ERROR UNDO, NEXT:

                oJsonProduto = oJsonArrayProdutos:GetJsonObject(i2).

                MESSAGE "produto: " string(oJsonProduto:GetInt64("produto")) SKIP
                    "sku: " oJsonProduto:GetCharacter("sku") 
                VIEW-AS ALERT-BOX INFO BUTTONS OK.

            END.

   
            MESSAGE "saida: " string(oJsonObj:GetInt64("saida")) SKIP
                    "tipo_operacao: " oJsonObj:GetCharacter("tipo_operacao") SKIP
                    "romaneio: " oJsonObj:GetCharacter("romaneio") SKIP
                    "nf: " oJsonObj:GetCharacter("nf") skip 
                    "cancelado:" oJsonObj:GetLogical("cancelado") skip
                    //"Produtos: " oJsonProdutos 
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
           
        end.
    END.


END.
