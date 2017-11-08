# ElastAlert

ElastAlert is a simple framework for alerting on anomalies, spikes, or other patterns of interest from data in Elasticsearch. Documentation for elastalert can be found at https://elastalert.readthedocs.io/en/latest/elastalert.html. 
This project create an elastalert rpm by using elastalert python module. Reference from github amine7536.
## Required Stack
- Elastalert [http://elastalert.readthedocs.io/en/latest/](http://elastalert.readthedocs.io/en/latest/)
- FPM Packaging tool : [http://fpm.readthedocs.io/en/latest/](http://fpm.readthedocs.io/en/latest/)

## Usage
The build script build.sh create a python virtualenv to install elastalert then uses fpm to package the entire virtualenv into an RPM. The script works on centos7. Expected elastAlert version can be passed into the build.sh script. 

### Build
Build docker container using Dockerfile
```
docker build -t elastalert:v1 --build-arg Version=<specify elastalert py module version> .
``` 
### Create RPM
Use this image to create elastalert rpm.
```
docker run -v $(pwd):/build -it elastalert:v1 /build/build.sh
``` 

### Configuration

Edit the file `/etc/elastalert/config.yml` :

```yml
rules_folder: /etc/elastalert/rules
es_host: < provide elasticsearch host >
es_port: 9200
writeback_index: elastalert_status
run_every:
  minutes: 1
buffer_time:
  minutes: 10
```

Don't forget to run for the 1st run : `elastalert-create-index`  
[http://elastalert.readthedocs.io/en/latest/running_elastalert.html](http://elastalert.readthedocs.io/en/latest/running_elastalert.html)

### Start Elastalert Service

```
systemctl start elastalert
```
