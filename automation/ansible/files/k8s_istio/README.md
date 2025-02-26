
### 설치 바이너리 다운로드 
- curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.7.0 sh -


### 설치 스크립트


```
#!/usr/bin/env bash

pushd istio-1.7.0
export PATH=$PWD/bin:$PATH

istioctl install --set profile=bxcr --manifests manifests

kubectl label namespace default istio-injection=enabled
popd
```

### 수정사항
- istio-1.7.0/manifests/profiles/bxk.ymal 추가
- default.yaml 복사 후 내용 수정

```
    ingressGateways:
    - name: istio-ingressgateway
            - port: 80
              targetPort: 8080
              nodePort: 30080 << 추가


      istio-ingressgateway:
        autoscaleEnabled: true
        applicationPorts: ""
        debug: info
        domain: ""
        type: NodePort << 변경
```
