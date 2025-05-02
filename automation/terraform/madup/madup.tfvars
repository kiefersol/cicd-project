region = "ap-northeast-2" # 서울 리전

# VPC
vpc_cidr = "10.0.0.0/16"  

# vpc 이름 - vpc 내의 전체 리소스 이름에 영향
vpc_name    = "madup" 
# 생성될 서브넷 갯수 - eks는 최소 2개의 다른 가용 영역의 서브넷이 필요
subnet_count = 2 
# vpc (16) + subnet (8) => 최종적인 서브넷 마스크 /24    
subnet_mask = 8     

# eks

# eks의 버전
eks_version = "1.30" 
# 노드 그룹의 버전, eks 버전보다 낮거나 같아야 한다.
nodegroup_version = "1.30" 
# 노드그룹 인스턴스 타입 - vCPU 4EA, Memory 16GB
nodegroup_instance_type = "t3.xlarge" 
# 노드그룹 인스턴스 기본 볼륨 크기
nodegroup_volume_size = 50 
# 노드 그룹은 자동 확장되어 크기 지정 필요
k8s_node_worker_size = { 
  desired = 2
  min     = 1
  max     = 4
}

#loadbalancer

# nginx에 접근 가능한 ip 목록
nginx_allow_ip = ["123.123.123.123/32"] 
# 로드밸런서로 접근할 포트 지정
nginx_listener_port = 80 
# 로드밸런서가 실제로 바라보고 있을 포트, 노드포트 
nginx_target_group_port = 30080 
# 로드밸런서가 헬스체크할 포트
nginx_target_group_health_check_port = 30080 
