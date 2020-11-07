# Iron Forge
Iron Forge is a Kubernetes native cloud IDE.

It provides an OAuth 2 wrapper around a customized set of Theia workspaces. 

Deployment can be done via Helm for a single instance or an Operator for managing multiple user instances. 

# Goals
The overarching goal of this project is to provide a simple method for deploying and recreating a development environment for multiple languages.

## Limitations
* Python workspace only, others TBD
* Only IronRain images will work as non-root
* Only Keycloak OAuth is integrated, others TBD

# Thanks and Acknowledgements
Theia IDE source: https://github.com/theia-ide
OAuth2 Proxy: https://github.com/oauth2-proxy/oauth2-proxy