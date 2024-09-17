#!/bin/bash

BOLD='\033[1m'
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
CYAN='\033[36m'
MAGENTA='\033[35m'
NC='\033[0m'

# 한국어 체크하기
check_korean_support() {
    if locale -a | grep -q "ko_KR.utf8"; then
        return 0  # Korean support is installed
    else
        return 1  # Korean support is not installed
    fi
}

# 한국어 IF
if check_korean_support; then
    echo -e "${CYAN}한글있긔 설치넘기긔.${NC}"
else
    echo -e "${CYAN}한글없긔, 설치하겠긔.${NC}"
    sudo apt-get install language-pack-ko -y
    sudo locale-gen ko_KR.UTF-8
    sudo update-locale LANG=ko_KR.UTF-8 LC_MESSAGES=POSIX
    echo -e "${CYAN}설치 완료했긔.${NC}"
fi

# 리츄얼 기본파일 설치 및 계약
install_ritual() {

# 기본 패키지 설치하기
echo -e "${CYAN}sudo apt update${NC}"
sudo apt update

echo -e "${CYAN}sudo apt upgrade -y${NC}"
sudo apt upgrade -y

echo -e "${CYAN}sudo apt -qy install curl git jq lz4 build-essential screen${NC}"
sudo apt -qy install curl git jq lz4 build-essential screen

# docker / docker compose 설치하기
echo -e "${CYAN}curl -fsSL https://get.docker.com -o get-docker.sh${NC}"
curl -fsSL https://get.docker.com -o get-docker.sh 

echo -e "${CYAN}sudo sh get-docker.sh${NC}"
sudo sh get-docker.sh

echo -e "${CYAN}docker version${NC}"
docker version

echo -e "${CYAN}sudo apt-get update${NC}"
sudo apt-get update

echo -e "${CYAN}sudo curl -L https://github.com/docker/compose/releases/download/$(curl --silent https://api.github.com/repos/docker/compose/releases/latest | jq .name -r)/docker-compose-$(uname -s)-$(uname -m) -o /usr/bin/docker-compose${NC}"
sudo curl -L https://github.com/docker/compose/releases/download/$(curl --silent https://api.github.com/repos/docker/compose/releases/latest | jq .name -r)/docker-compose-$(uname -s)-$(uname -m) -o /usr/bin/docker-compose

echo -e "${CYAN}sudo chmod 755 /usr/bin/docker-compose${NC}"
sudo chmod 755 /usr/bin/docker-compose

echo -e "${CYAN}docker-compose version${NC}"
docker-compose version

# Ritual 설치하기

echo -e "${CYAN}git clone https://github.com/ritual-net/infernet-container-starter${NC}"
git clone https://github.com/ritual-net/infernet-container-starter

echo -e "${CYAN}cd ~/infernet-container-starter${NC}"
cd $HOME/infernet-container-starter

echo -e "${CYAN}config.json 수정 중...${NC}"
json_1=~/infernet-container-starter/projects/hello-world/container/config.json

# jq를 사용하여 rpc_url 값을 수정하고 임시 파일에 저장
jq '.chain.rpc_url = "https://mainnet.base.org/"' $json_1 > temp.json

# temp.json을 원본 파일로 덮어쓰고 임시 파일 삭제
mv temp.json $json_1 && rm -f temp.json

echo -e "${CYAN}rpc_url has been updated to https://mainnet.base.org/ in config.json${NC}"

echo -e "${MAGENTA}${BOLD}'screen -S ritual', 입력후에 'project=hello-world make deploy-container' 입력${NC}"
echo -e "${MAGENTA}${BOLD}큰 초록 RITUAL을 보면 컨트롤+A+D로 종료.${NC}"
}

# 메인 메뉴
echo && echo -e "${BOLD}${MAGENTA}Ritual Node 자동 설치 스크립트${NC} by 비욘세제발죽어
 ${CYAN}원하는 거 고르시고 실행하시고 그러세효. ${NC}
 ———————————————————————
 ${GREEN} 1. 기본파일 설치 및 Ritual Node 설치 ${NC}
 ${GREEN} 2. Ritual Node 구성파일 수정하기 ${NC}
 ${GREEN} 3. Ritual Node 계약하기(작업 완료) ${NC}
 ${GREEN} 4. Ritual Node가 멈췄어요! 재시작하기 ${NC}
 ${GREEN} 5. Ritual Node의 지갑주소를 바꾸고 싶어요 ${NC}
 ${GREEN} 6. Ritual Node의 RPC 주소를 바꾸고 싶어요 ${NC}
 ${GREEN} 7. Ritual Node를 업데이트하고 싶어요(9월 18일자 기준 미지원) ${NC}
 ${GREEN} 8. Ritual Node를 내 인생에서 지우고 싶어요 ${NC}
 ———————————————————————" && echo

# 사용자 입력 대기
echo -ne "${BOLD}${MAGENTA}어떤 작업을 수행하고 싶으신가요? 위 항목을 참고해 숫자를 입력해 주세요: ${NC}"
read -e num

case "$num" in
1)
    install_ritual
    ;;
2)
    install_ritual_2
    ;;
3)
    install_ritual_3
    ;;
4)
    restart_ritual
    ;;
5)
    change_Wallet_Address
    ;;
6)
    change_RPC_Address
    ;;
7)
    update_ritual
    ;;
8)
    update_ritual
    ;;
*)
    echo -e "${BOLD}${RED}에휴씨발이제욕도하기싫음죽어버려그냥${NC}"
    ;;
esac