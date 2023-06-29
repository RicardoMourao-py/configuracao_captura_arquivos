# PROJETO DE CAPTURA DE ARQUIVOS

Basicamente, o projeto tem o escopo de implementar uma Cloud Function responsável por maior parte do processamento dos dados.

## Introdução

Foi implentado a Cloud Function `cf_configuracao_captura_arquivos` que terá o papel detectar objeto que chegam no bucket `staging-provider-bucket` (trigger).

Para continuar o processamento normal, foi criado um novo bucket de backup, `staging-provider-bucket-bkp`, para receber os arquivos processados e não ficar acionando desnecessariamente o bucket triggado. 

Além disso, para uma melhor leitura da pela Cloud Function, foi criado uma tabela de configuração no Big Query, `staging-provider/DS_CONFIGURACAO/TB_CONFIGURACAO`, em que nela é possível configurar todos os campos do arquivo de configuração antigo e com o adicional do campo de talskflow.

Sendo assim, o processamento normal continua, ou seja, o arquivo é mandado para o bucket de destino, salvo é em um bucket de backup que adiciona no nome do arquivo `DATA_HORA`. Caso haja talkflow para ser exucutado, ele é disparado, **EXCETO**, quando no nome do bucket de destino tem `trigger`, o que é entendido que não deve ser disparado, pois já existe um detector de eventos responsável por algo.

Portanto, observe a infraestrutura abaixo para um melhor entendimento:

![image](https://github.com/RicardoMourao-py/configuracao_captura_arquivos/assets/72896483/89f5d7d1-90bf-422d-9f07-2fbabdc25b7e)

## INFORMAÇÕES

- Se configurar um arquivo como `.csv`, ele **DEVE** vir como `.csv` no bucket triggado. Valendo para outras extensões.
- O arquivo tem que estar na pasta `STAGE_AREA` para ser processado adequadamente.
