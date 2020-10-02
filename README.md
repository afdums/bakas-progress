# BakaProgress
Bakas criados para acertos pontuais linguagem progress 4gl openedge datasul totvs

##### clientlog
	Ativação de clientlog
##### cria_op_altern (Padrão)
	Baka para criação de operacao alternativa, quando o item pode ser produzido em 2 GMs o programa faz a copia de uma GM para a outra e vice-versa
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
##### cm_qtidade_prod_niv_niv (Tuper)
	Baka para verificar a quantidade a produzir de determinado item do pedido analisando nivel a nivel, util quando questionada a quantidade a produzir de determinado item no CM
##### comandos_excel (Progress x Excel)
	Comandos uteis para geracao de planilhas excel
##### tipo_saldo-terc (Totvs)
	Tipos de saldo em terceiros (conteudo da ininc/i01404.i)
##### gera_senha_spp
	Gerador de senha para os programas especiais (SPP), a validade padrão de cada senha é na quinzena corrente
##### estorna_div_op (Tuper)
	Estorno movimentacao de DIVs geradas incorretamente para acerto de saldo em OP, as ordens de produção deve estar em um arquivo TXT com uma coluna que é o número da ordem de produção.
##### regera_boletos (GhelPlus / Totvs)
	Baka para apagar o boleto gerado e gerar novo boleto, assim como desmarcar como atualizado no EMS 5.
##### exemplo_geracao_xml (Progress)
	Baka com o exemplo da criação de um arquivo XML com tags.
##### consumo_json (Progress)
	Exemplo de consumo de api REST JSON
##### consumo_json_com_autenticacao
	Exemplo de consumo de api REST JSON com autenticacao
##### consumo_soap (Progress)
	Exemplo de consumo de webservice SOAP XML
##### killuser_windows (Progress)
	Programas para derrubar usuário em banco de dados windows
##### dependencia_entre_objetos (Progress)
	Lista as dependências entre os objetos progress
##### elimina_titulo_a_receber (Totvs)
	Elimina o titulo do contas a receber. ATENÇÃO: é a mesma rotina utilizada para eliminar o titulo quando a nota fiscal é cancelada
##### acerta_alocacao_ocs_em_massa (Totvs)	
	Verifica todas as OCs que possuem alocação na prazo-compra e tenta zera-las rodando o programa spp\ccp\spcc035rp.p em lote (sem pedir senha)
##### conferencia_entrada_escapamentos (Tuper)
	Regra para verificar se deve ou não gerar a pendencia de recebimento automatico na escapamentos, a pendencia deve ser gerada quando a quantidade faturada for menor ou igual a coletada no destino.
##### upc-captura-eventos.p (Totvs)
	UPC padrão para mapear os eventos disparados por um determinado programa
##### tree_view_em_browser.w (Totvs)
	Emula a criação de um treeview com base na tabela de estruturas em um browser
##### exporta_op_smi_manual (Tuper)
	Exporta OPs manualmente para o SMI da Tuper
##### script_compilacao.p (Progress)
	Gera um script para compilação de programas com base em busca de palavras chave, inclusive lendo estrutura onde includes são utilizadas
##### copia_item_uni-estab (Totvs)
	Copia os registros da tabela item-uni-estab de um estabelecimento para outro, também copia a fam-uni-estab
##### saldos_trimestrais (Serraltense)
	Recomposição de saldos trimestrais por ano
##### epc-captura-eventos (Totvs)
	EPC padrão para mapear os eventos disparados por um determinado programa
##### acerta_quantidade_emitente (Tuper)
	Baka para acertar a quantidade do emitente para retorno das notas para a Arcelor quando esta quantidade foi digitada incorretamente no lançamento da entrada da bobina na portaria fiscal (digitada em quilo e deveria ser em toneladas)
##### acerta_commisao (GhelPlus)
	Programa utilizado para acertar os parametros das comissões para que seja possível atualizar as comissões no contas a pagar
##### lista_funcionarios_desligados (HCM)
	Lista os funcionarios desligados nos últimos dias.
##### odbc_progress_64 (Progress)
	ODBC Progress para 64 bits
##### exemplo_cabecalho_rodape (Datasul)
	Exemplo de como criar um relatorio com FORMs utilizando cabeçalho e rodapé, sem includes
##### template_relatorio (Datasul)
	Template completo para criação de relatório nos padrões Datasul
##### consulta_ordem_subordem (Tuper)
	Consulta de relacionamento especifico de ordens x sub-ordens
##### altera_conexao_nfe_para_teste (Gati)
	Altera caminhos do Conexao NFe para caminhos de teste
##### create_esp-movto-nft (Tuper)
	Cria esp-movto-nft manualmente para ser consumida pelo programa ET3103
##### consuta_execucao_rpw (Datasul)
	Consulta frequencia de execucao de um programa no RPW
##### exporta_importa_especificos (Datasul)
	Programa que permite exportar/importar cadastro de UPC em programas e Tabelas
##### recalcula_pedidos_venda (Datasul)
	Recalcula o preço dos pedidos de venda (simula botão de cálculo do PD4000 e do PD4050). Criado para atender a GP que possuia problemas de alteração de MVA após a implantação do pedido.
##### altera_permite_saldo_negativo (Datasul)
	Permite alteração da permissão de saldo negativo para o item e para o item x estabelecimento de todos os itens de determinado grupo de estoque
##### acerta_ggf_interroga (Datasul)
	No cálculo do médio quando fica interroga (?) em algums movimentos não é possível dar sequencia com o cálculo
##### upc-ceapi001 (Datasul)
	Exemplo de UPC para tratamento de movimentações de estoque (validações)
##### busca_campo (Progress)
	Programa para encontrar em qual tabela determinado campo existe
##### transfere_entre_depositos (Datasul)
	Importa um arquivo CSV e realiza a transferencia entre os depósitos solicitados
