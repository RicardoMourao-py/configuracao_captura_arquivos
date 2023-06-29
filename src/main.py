from google.cloud import bigquery
from google.cloud import storage
from datetime import datetime
import requests
from requests.auth import HTTPBasicAuth
import pandas_gbq
import fnmatch
import os

# Configurações do projeto
PROJECT_ID = os.environ['PROJECT_ID']
DATASET_ID = os.environ['DATASET_ID']
TABLE_ID = os.environ['TABLE_ID']
EMAIL = os.environ['EMAIL']

# Cria um cliente BigQuery
bq_client = bigquery.Client()

# Cria um cliente Cloud Storage
storage_client = storage.Client()

# Função verifica os filenames semelhantes no BQ
def filename_like(palavra, lista_palavras):
    for padrao in lista_palavras:
        if fnmatch.fnmatch(palavra, padrao):
            return padrao
    return None

# Função principal do Cloud Function
def main(event, context):
    try:
        # Obtém o nome do arquivo recém-chegado no Cloud Storage
        file_name, folder_name, file_name_complete = event['name'].split('/')[-1], event['name'].split('/')[0], event['name']
        
        # Data do processamento e hora
        data_atual = datetime.now()
        data_atual_formatada =   data_atual.strftime("%Y%m%d_%H%M%S")

        # Consulta o BigQuery para obter as informações de destino do bucket e do bucket de backup
        query = f"SELECT NOME_ARQUIVO, BUCKET_DESTINO, BUCKET_BKP, TASKFLOW FROM `{PROJECT_ID}.{DATASET_ID}.{TABLE_ID}`"
        df = pandas_gbq.read_gbq(query, project_id = PROJECT_ID)
        
        # Encontra configuração relacionada ao filename
        palavra_semelhante = filename_like(file_name, list(df.NOME_ARQUIVO))
        df_selecionado = df.loc[df.NOME_ARQUIVO == palavra_semelhante, :]
        rows = list(df_selecionado.iterrows())
        
        # Verifica se existe arquivo na tabela configurado e se está na pasta correta
        if len(rows) > 0 and folder_name == "STAGE_AREA":
            row = rows[0][1]
            destino_bucket_name = row['BUCKET_DESTINO'].split('/')[0]
            bkp_bucket_name = row['BUCKET_BKP'].split('/')[0]
            taskflow = row['TASKFLOW']
            
            # Copia o arquivo para o bucket de destino
            source_bucket_name = event['bucket']
            source_bucket = storage_client.get_bucket(source_bucket_name)
            dest_bucket = storage_client.get_bucket(destino_bucket_name)
            blob = source_bucket.blob(file_name_complete)
            if '/' not in row['BUCKET_DESTINO']:
                dest_blob = source_bucket.copy_blob(blob, dest_bucket, file_name)
            else:
                dest_blob = source_bucket.copy_blob(blob, dest_bucket,row['BUCKET_DESTINO'].split(destino_bucket_name+'/')[-1]+'/'+file_name)
            
            # Salva o arquivo processado no bucket de backup
            dest_bucket_bkp = storage_client.get_bucket(bkp_bucket_name)
            if '/' not in row['BUCKET_BKP']:
                dest_blob_2 = source_bucket.copy_blob(blob, dest_bucket_bkp, file_name + f'_{data_atual_formatada}')
            else:
                dest_blob_2 = source_bucket.copy_blob(blob, dest_bucket_bkp,row['BUCKET_BKP'].split(bkp_bucket_name+'/')[-1]+'/'+ file_name + f'_{data_atual_formatada}')
            
            # Verifica se há uma taskflow associada e se não possui trigger
            if taskflow and destino_bucket_name.find('trigger') < 0:
                # Pode executar algo por meio de requests
                print(f'Taskflow executado: {taskflow}')
            
            print(f"Arquivo {file_name} processado com sucesso!")

        else:
            if folder_name != "STAGE_AREA":
                print(f"Arquivo {file_name} não encontrado na pasta STAGE_AREA")
            else:
                print(f"Arquivo {file_name} não encontrado na tabela.")

    except Exception as e:
            print(f"ERRO!!!: {file_name_complete} - {str(e)} - {r.text}")

    return 
