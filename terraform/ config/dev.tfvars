function_name = "cf_configuracao_captura_arquivos"
project = "staging-provider"
trigger_type = "google.storage.object.finalize"
trigger_resource = "staging-provider-bucket"
service_account_email = "ricardomrf@al.insper.edu.br"
available_memory = 2048
environment_variables = {PROJECT_ID = "abc-staging-provider",
                         DATASET_ID = "DS_CONFIGURACAO",
                         TABLE_ID = "TB_CONFIGURACAO"
                         EMAIL = "ricardomrf@al.insper.edu.br"}
