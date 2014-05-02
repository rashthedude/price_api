# Basic environment specific configuration.

settings = {}

switch process.env.NODE_ENV
  when "production"
  
    
    settings.redis_url = "redis://:bfjejDsfew@RedisProduction-141732524.eu-west-1.elb.amazonaws.com:6379"
    settings.mongo_log_url     = "mongodb://veoo:hdsjfklh5EEGg@176.34.221.255/logs,mongodb://veoo:hdsjfklh5EEGg@54.217.85.148/logs,mongodb://veoo:hdsjfklh5EEGg@54.220.4.230/logs"
    settings.perform_deliveries = true
    settings.kannel_mo = "http://192.168.1.10"
    settings.mongo_smscs_url = "mongodb://veoo:hdsjfklh5EEGg@176.34.221.255/smscs,mongodb://veoo:hdsjfklh5EEGg@54.217.85.148/smscs,mongodb://veoo:hdsjfklh5EEGg@54.220.4.230/smscs"
    

  when "hlr"
  
    settings.teracomm_host = '82.103.69.146'
    settings.teracomm_user = 'veoo'
    settings.teracomm_password = 'bcw7w55d'
    settings.teracomm_database = 'lrcards2'
    
    settings.redis_url = "redis://:bfjejDsfew@RedisProduction-141732524.eu-west-1.elb.amazonaws.com:6379"
    settings.mongo_log_url     = "mongodb://veoo:hdsjfklh5EEGg@176.34.221.255/logs,mongodb://veoo:hdsjfklh5EEGg@54.217.85.148/logs,mongodb://veoo:hdsjfklh5EEGg@54.220.4.230/logs"
    settings.perform_deliveries = true
    settings.kannel_mo = "http://192.168.1.10"
    settings.mongo_smscs_url = "mongodb://veoo:hdsjfklh5EEGg@176.34.221.255/smscs,mongodb://veoo:hdsjfklh5EEGg@54.217.85.148/smscs,mongodb://veoo:hdsjfklh5EEGg@54.220.4.230/smscs"




    
  when "staging"
  
    settings.teracomm_host = 'somehost.com'
    settings.teracomm_user = 'veoo'
    settings.teracomm_password = '2jpoHIosds23poFk2'
    settings.teracomm_database = 'somedb'
  
    settings.redis_url = "redis://:bfjejDsfew@RedisStaging-437779657.eu-west-1.elb.amazonaws.com:6379"
    settings.mongo_log_url     = "mongodb://veoo:hdsjfklh5EEGg@176.34.214.3/logs,mongodb://veoo:hdsjfklh5EEGg@54.247.8.50/logs,mongodb://veoo:hdsjfklh5EEGg@79.125.81.130/logs"
    settings.perform_deliveries = true
    settings.kannel_mo = "http://127.0.0.1:8080"
    settings.mongo_smscs_url = "mongodb://veoo:hdsjfklh5EEGg@176.34.221.255/smscs,mongodb://veoo:hdsjfklh5EEGg@54.247.29.29/smscs"



  else
    
    settings.teracomm_host = '0.0.0.0'
    settings.teracomm_user = 'root'
    settings.teracomm_password = 'pa55wd'
    settings.teracomm_database = 'teracomm_test'
  
    settings.redis_url = 'redis://localhost:6379'
    settings.mongo_log_url = "mongodb://localhost/logs"
    settings.perform_deliveries = false
    settings.kannel_mo = "http://127.0.0.1:8080"
    settings.mongo_smscs_url = "mongodb://localhost/smscs"


    
# Application name is for logging purposes.
settings.application_name = 'price_api'
settings.application_port = 3355





settings.restler_timeout = 10000
 


module.exports = settings
