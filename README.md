# PROJETO DE CAPTURA DE ARQUIVOS

Processamento de dados adequado para mover arquvios chegados a um Cloud Storage para outros buckets de destino, de acordo com uma configuração. Este projeto é fundamental para o ganho de logs e boas práticas adequadas antes de chegar no serviço de ETL (caso exista). Por isso, nele é implementado uma CloudFunction responsável por mover arquivos que chegam em um determinado CS para outro bucket de destino e outro bucket de backup (com os horários de processamento). Além disso, caso haja a necessidade do disparo de um taskflow para o serviço de ETL, ele já possui a funcionalidade.

Portanto, observe a infraestrutura abaixo para um melhor entendimento:

![image](https://github.com/RicardoMourao-py/configuracao_captura_arquivos/assets/72896483/89f5d7d1-90bf-422d-9f07-2fbabdc25b7e)

## Execução

Em primeiro momento, crie todos os serviços necessários antes da implementação da Cloud Function. **É válido ressaltar** que a CF vai ser criada com IaC (terraform), enquanto os outros produtos serão criados no próprio console do GCP, devido a sua facilidade de criação.

1. Crie um projeto para seu ambiente de trabalho chamado `staging-provider`.
2. No projeto, crie um Cloud Storage com o nome `staging-provider-bucket`, e crie a pasta STAGE_AREA dentro dele, pois ela que estará sendo analisada para a detecção dos eventos pela Cloud Function.
3. Ainda no projeto, crie um Cloud Storage com o nome `bucket-bkp` com as pastas `STAGE_AREA/PROCESSADOS`, na qual ela será responsável por armazenar o nome dos arquivos juntamente com sua hora de processamento.
4. Criando uma Tabela de Configuração no Big Query. <br>
   É necessário criar uma tabela de configuração que vai ser lida pela Cloud Function no momento da transferência dos arquivos e enviá-los para seus determinados buckets configurados. Além disso, ter um campo de taskflow caso o usuário queira inserir. Sendo assim, é importante ter os seguintes campos de preenchimento, **com essa determinada ordem**: `NOME_ARQUIVO`, `BUCKET_DESTINO`, `BUCKET_BKP`, `TASKFLOW`. **Insira a tabela no seguinte caminho:** `staging-provider/DS_CONFIGURACAO/TB_CONFIGURACAO`. Veja o exemplo abaixo:
   
   ![image](https://github.com/RicardoMourao-py/configuracao_captura_arquivos/assets/72896483/f7aea842-9603-45c5-bfcb-ba5daca0a9b2)

   A imagem acima configura o arquivo `filename.csv`, em que quando ele chega no `staging-provider/staging-provider-bucket/STAGE_AREA`, deve ser movido para os buckets `staging-destino/bucket-destino` (observe que staging-destino é outro projeto, mas poderia ser qualquer um outro) e `staging-provider/bucket-bkp/STAGE_AREA/PROCESSADOS`, respectivamente. Além disso, ele deve disparar o taskflow `tkf_teste` para a ETL continuar o processamento **(não obrigatório)**. 

5. Antes de implementar a Cloud Function, garanta um bucket, em outro projeto, que seja responsável por armazenar arquivos `.tfstate` do terraform. Portanto, crie um projeto com o nome `datalake-terraform`. Não se preocupe com o nome do bucket pois ele será criado automaticamente na execução do IaC.
6. Agora basta clonar o repositório e executar os comandos abaixo em sequência:
```
export GOOGLE_APPLICATION_CREDENTIALS=${caminho do diretório onde você guardou suas chaves de segurança}
```
```
cd terraform
```
```
terraform init -backend-config=config/dev.gcs.tfbackend
```
```
terraform plan -var-file="config/dev.tfvars" -out=.terraform_tmp/plan.create -no-color
```
```
terraform apply .terraform_tmp/plan.create
```

7. Por fim, basta testar seu projeto.
 
## INFORMAÇÕES

- Se configurar um arquivo como `.csv`, ele **DEVE** vir como `.csv` no bucket triggado. Valendo para outras extensões.
- O arquivo tem que estar na pasta `STAGE_AREA` para ser processado adequadamente.
