**Configure to work Verdaccion with Azure Active Directory**

 Problem is that we can able to install the AAD plugin in the verdaccion container directly due to permission issue. By using the docker file we can over come this. The step are 
 1) creating a docker file 
 2) Building the image from docker and push to registery
 3) Host the docker image in APP service and do APP registration in AAD

 Prerequisite:
 
 1)Docker and registery

 2)Azure tenant

 3)Permission to grant the admin consent

 Fisrt we need to build the docker image by using below docker file
 ```
 FROM verdaccio/verdaccio:4.2.2
USER root
RUN npm i && npm i verdaccio-azure-ad-login
USER verdaccio
```
We need to run the following cmd to run the docker compose file. Goto the file path and enter the below cmd
```
docker build .
```

After build is completed we need to tag that image 
```
docker tag <image id> <tag name>
```


Here I am using the docker registery. Now we will login to docker registery and push the build image to dockerhub.First we need to tag the image with hub username
```
docker tag <imageid> <hubusername>/<tagname>
```
After tag we need to push the image to docker hub
```
docker push <hubusername>/<tagname>
```
Now login to Azure AD. And create APP service and give WEBAPP name, select publish as **Docker Container**. 

Now goto docker selecting and give the details as shown below. Click on review+create.

After app service is created, goto configuration and add new **Application String** . After giving below details save it.

```
Name: WEBSITES_PORT
Value: 4873
```


Now create App Registration for users authentication with AAD. Here just give the name and leave remaining things empty and click on register.

Go to the App Registration and click on **API  permission**. Now click on **Grant Admin Consent to abc.com**. Now goto **certificate & secrets** and create a new secret. Copy the secret valure and mention in the config file.

Now create a storage account and in that create file share to store the config file. Below is the config sile save it as **config.yaml** and upload to file share. In config file you need to change the tenant id, client id(which is app registration client id), secret id, organization_domain name.

```
#
# This is the config file used for the docker images.
# It allows all users to do anything, so don't use it on production systems.
#
# Do not configure host and port under `listen` in this file
# as it will be ignored when using docker.
# see https://verdaccio.org/docs/en/docker#docker-and-custom-port-configuration
#
# Look here for more config file examples:
# https://github.com/verdaccio/verdaccio/tree/master/conf
#

# path to a directory with all packages
storage: /verdaccio/storage/data
# path to a directory with plugins to include
plugins: /verdaccio/plugins

web:
  # WebUI is enabled as default, if you want disable it, just uncomment this line
  #enable: false
  title: Verdaccio
  # gravatar: false
  # sort_packages: asc

auth:
  #htpasswd:
   # file: /verdaccio/storage/htpasswd
    # max_users: 1000
  azure-ad-login:
    # REQUIRED, Azure application tenant
    tenant: "8**************************************9"
    # REQUIRED, Azure client_id
    client_id: "3***********************************0"
    # REQUIRED, Azure application client_secret
    client_secret: "Z*********************************V"
    # OPTIONAL, default email domain for accounts, example: organization.com
    organization_domain: "abc.com"
    scope: ""
    #allow_groups:
    #  - "Developer"        

security:
  api:
    jwt:
      sign:
        expiresIn: 60d
        notBefore: 1
  web:
    sign:
      expiresIn: 7d
      notBefore: 1

# a list of other known repositories we can talk to
uplinks:
  npmjs:
    url: https://registry.npmjs.org/

packages:
  '@*/*':
    # scoped packages
    access: $authenticated
    publish: $authenticated
    unpublish: $authenticated
    proxy: npmjs

  '**':
    access: $authenticated

    # allow all known users to publish/publish packages
    # (anyone can register by default, remember?)
    publish: $authenticated
    unpublish: $authenticated

    # if package is not available locally, proxy requests to 'npmjs' registry
    proxy: npmjs

middlewares:
  audit:
    enabled: true

# log settings
logs:
  - { type: stdout, format: pretty, level: http }
  #- {type: file, path: verdaccio.log, level: info}
```
In APP service configuration settings goto path mapping and click on **New Azure Storage Mount** and give config as shown below. After that restart the **APP service** and now you login to verdaccio using the Azure AD credentials.



