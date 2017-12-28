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
> Docke-Compose
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
> Kubernetes
```
---
kind: Deployment
apiVersion: apps/v1beta2
metadata:
  name: {{ name }}
  namespace: hybris-app
spec:
  replicas: 1
  selector:
    matchLabels:
      name: {{ name }}
  minReadySeconds: 10
  strategy:
    rollingUpdate:
        maxUnavailable: 1
        maxSurge: 3
  template:
    metadata:
      labels:
        name: {{ name }}
    spec:
      containers:
      - name: {{ name }}
        image: zqiannnn/hybris-dev:1.0
        imagePullPolicy: Always
        env:
        - name: CODE_REPO
          value: https://xx.git
        - name: CONFIG_REPO
          value: https://xx.git
        - name: CODE_BRANCH
          value: develop/{{ name }}
        - name: CONFIG_BRANCH
          value: develop/{{ name }}
        - name: CODE_DIRECTORY
          value: hep
        - name: BUILD_NUMBER
          value: "{{ build }}"
        ports:
        - containerPort: 9002
          protocol: TCP
        - containerPort: 7800
          protocol: TCP
        readinessProbe:
          httpGet:
            scheme: HTTPS
            path: /hac
            port: 9002
          initialDelaySeconds: 300
          periodSeconds: 10
        volumeMounts:
        - name: data-volume
          mountPath: /opt/hybris/data
        - name: binaries-volume
          mountPath: /u01/packages/binaries
        - name: lt-config
          mountPath: /etc/localtime
        - name: tz-config
          mountPath: /etc/timezone
      volumes:
      - name: data-volume
        persistentVolumeClaim:
          claimName: hybris-pvc
      - name: binaries-volume
        persistentVolumeClaim:
          claimName: hybris-binaries-pvc
      - name: lt-config
        hostPath:
          path: /usr/share/zoneinfo/Asia/Shanghai
      - name: tz-config
        hostPath:
          path: /etc/timezone


```


