# hybris-dev
## 基于Docker快速生成HYBRIS开发环境

### Environment
```
CODE_REPO: Code Git Repo
CONFIG_REPO: Config Git Repo
CODE_DIRECTORY: Code Storege Path (bin/custom/${CODE_DIRECTORY})
CODE_BRANCH: Code Git Branch
CONFIG_BRANCH: Config Git Branch
```

### Volume
```
/opt/hybris/data: Hybris Persistent Data
/u01/packages/binaries: Hybris Binaries Data (You should provider HYBRIS.zip,JREBEL.zip in this path)
/root/.ssh: If you use git protocol，you provide your ssh file in this path
```

### Demo
**Docke-Compose:**
> Base Uase
```
version: '2'
services:
    hybris:
      container_name:  base
      image: zqiannnn/hybris-dev:1.0-beta
      ports:
        - 8001:9002
      volumes:
        - /path/to/data:/opt/hybris/data
        - /path/to/binaries:/u01/packages/binaries
#        - $HOME/.ssh/:/root/.ssh
      environment:
        - CODE_REPO=https://xxx/xx.git
        - CONFIG_REPO=https://xxx/xx.git
        - CODE_DIRECTORY=hep
        - CODE_BRANCH=develop
        - CONFIG_BRANCH=develop
```


