# 매드업 SRE 과제

## 과제 설명
- nginx 이미지를 AWS EKS 환경에 배포할 수 있도록 Terraform 코드를 작성하세요. 
- AWS가 익숙하지 않으시다면 Google Cloud, Microsoft Azure 기준으로 작성하셔도 무방합니다.


## 개발 조건
- Public module(e.g. terraform-aws-modules)을 사용하지 마세요
- terraform apply를 실행하지 않아도 됩니다. 즉, 실제 구동하지 않는 코드여도 괜찮습니다. 
- 매드업은 본 과제로 인해 후보자님의 개인 클라우드 계정에서 비용이 발생하지 않기를 바랍니다. 
- 단, 코드가 실제 구동되지 않더라도 terraform plan 실행 시 오류가 발생하지 않도록 해야 합니다. 


## 요구 조건
- 과제 설명에 제시된 내용을 완수하기 위해 필요한 부수적인 리소스 생성도 모두 포함해야 합니다.
- 고가용성(High Availability)과 확장성(Scalability)을 고려하여 작성하시길 바랍니다. 
- 코드 재사용성(Reusability)을 고려해서 작성하시길 바랍니다.
- Node Group(Pool) 버전 업그레이드 시 서비스가 중단되지 않도록 작성하시길 바랍니다. 
- host는 nginx.example.com로 설정하고 123.123.123.123 에서만 접근이 가능하도록 설정하시길 바랍니다

## 사용 방법
**terraform plan --var-file="./madup.tfvars"**


**terraform apply --var-file="./madup.tfvars"**

- Terraform 변수 파일을 사용해서 환경마다 달라질 수 있는 값(예: VPC 이름, 인스턴스 타입, 노드 수 등)을 분리해 관리 할 수 있게 했다.
- 코드(.tf 파일)는 고정된 로직만 담고, 값은 외부에서 주입하여 여러 환경에서 코드를 재사용할 수 있게 했다. 

## 각 파일 설명
- **version.tf** : terraform aws 프로바이더 버전 지정
- **password.tf** : aws 계정에 접근할 accessKey, secretKey 지정
- **provider.tf** : aws 계정을 사용하기 위해 설정한 프로바이터 지정
- **variables.tf** : madup.tfvars 테라폼 변수 파일의 값을 불러오기 위한 변수 정의 파일
- **vpc.tf** : vpc, subnet, internet gateway, 외부통신을 위한 route table 설정, node group에 적용할 ssh 키 지정
- **iam.tf** : eks, node group에 지정할 role, policy 지정
- **eks.tf** : eks, eks 생성 후 접속하기 위한 kubeconfig, node group template, node group 적용
- **loadbalancer.tf** : application lb, target group, listener 생성, lb와 node group 연결, listener rule을 이용해 호스트 명 지정
- **securitygroup.tf** : lb에 접근할 수 있는 ip 제한, nodegroup에 lb 연결 허가
- **Kubernetes.tf** : nginx 이미지를 띄우기 위한 kuberntes 리소스를 terraform 리소스로 지정
- **yaml 디렉토리** : kubernetes.tf의 리소스들을 yaml로 적용한 것, 같은 맥락

## kuberntes.tf 리소스 설명
- **provider** : eks에 접근하기 위한 endpoint, ca, token 지정
- **namespace**
- **deployment** : nginx 파드를 배포하기 위해 사용, 고가용성을 위해 replicas 2개 지정, 컨테이너 상태를 체크하여 서비스의 안정성과 가용성을 높이기 위해 파드의 준비상태(readiness_probe)와 생존상태(liveness_probe) 확인
- **podDisruptionBudget**: 노드 종료나 업그레이드 같은 상황에서 서비스의 중단을 예방하기 위해 떠있어야할 파드의 최소 갯수를 지정
- **horizontalPodAutoscaler** : 워크로드의 부하가 증가하거나 감소할 때, Pod의 수를 자동으로 조정하여 애플리케이션의 성능을 최적화하기 위해 사용
- **service** : 외부에서 파드와 연결되기 위해 사용, nodeport를 사용하여 애플리케이션 로드밸런서와 연결되어 사용
- **ingress(사용안함)** : nginx ingress controller를 사용할 때 배포하는 ingress 리소스, 여기서는 사용하지 않고 alb와 nodeport로 연결해서 사용한다.

## 서비스 접근
1. application loadbalancer : 123.123.123.123에서 nginx.example.com:80으로 접근
2. loadbalancer의 리스너가 80으로 들어오는 트래픽을 target group (node group)의 30080으로 전달
3. node group은 nodeport로 30080 포트가 열려 있고, nginx service로 트래픽을 받아 nginx pod로 전달한다.

## 고가용성, 확장상, 안정성 충족 여부
- az1, az2에 서브넷 생성 
- eks_nodegroup에서 subnet_ids = [subnet-az1, subnet-az2] 
- eks_nodegroup에서 scaling_config { min=1, max=4, desired=2 } 
- ALB는 퍼블릭 서브넷에 Multi-AZ로 생성
- ALB 보안그룹은 접근 허용 IP만 열어둠 (123.123.123.123/32)
- horizontalPodAutoscaler : Pod의 수를 자동으로 조정하여 애플리케이션의 성능을 최적화
- PodDisruptionBudget : Pod 강제종료 시 최소 가용성 확보해 서비스가 중단 방지
- create_before_destroy	: 새 Node Group 생성 후 기존 삭제해 중단 방지
- replicas >= 2	다중 Pod로 부하 분산
- Cluster Autoscaler : node의 부하 방지 및 성능 최적화

