# BakaProgress
Bakas criados para acertos pontuais

##### clientlog
	Ativação de clientlog
##### HD132600 (Padrão)
	Baka para criação de operacao alternativa
##### obsoleta (Padrão)
	Obsoleta itens com base em uma lista txt (um item abaixo do outro)
##### alocacao_cm (Tuper)
	Lista pedidos de determinada GM e calcula o tempo de alocação por período
##### elimina_div_op (Padráo)
	Elimina movimento de div (apenas de valor) de uma ordem de produção (Obs: baka não valida se o período está aberto ou não)
##### delete_inv_col (Tuper)
	Elimina os registros de leitura de inventario (elimina apenas a leitura, não as fichas)
##### gera_qrcode
	Geração de QRCode em arquivo png
##### alteracao_situacao_MDFe (GhelPlus)
	Altera situação do MDFe para reenvio para autorização da receita
##### inclui_negativo_estrutura (Tuper)
	Inclui sobra como negativo na estrutura do produto pela GM
##### upc-men702dc(Padrão)
	UPC para controlar acesso a mesma tela simultaneamente na mesma sessão
	A UPC controla pela validação do handle de uma variável global da tela, pode ser variável padrão ou especifica
	1. Cadastrar a UPC no programa fnc_executar_programa (men/men702dc.w)
	2. Acertar o VALID-HANDLE pela variável global que deseja utilizar no controle
	
	
	