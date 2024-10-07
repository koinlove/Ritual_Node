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
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

echo -e "${CYAN}sudo apt update${NC}"
sudo apt update

echo -e "${CYAN}sudo apt upgrade -y${NC}"
sudo apt upgrade -y

echo -e "${CYAN}sudo apt -qy install curl git jq lz4 build-essential screen${NC}"
sudo apt -qy install curl git jq lz4 build-essential screen

echo -e "${BOLD}${CYAN}Checking for Docker installation...${NC}"
if ! command_exists docker; then
    echo -e "${RED}Docker is not installed. Installing Docker...${NC}"
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    echo -e "${CYAN}Docker installed successfully.${NC}"
else
    echo -e "${CYAN}Docker is already installed.${NC}"
fi

echo -e "${CYAN}docker version${NC}"
docker version

echo -e "${CYAN}sudo apt-get update${NC}"
sudo apt-get update

if ! command_exists docker-compose; then
    echo -e "${RED}Docker Compose is not installed. Installing Docker Compose...${NC}"
    # Docker Compose의 최신 버전 다운로드 URL
    sudo curl -L https://github.com/docker/compose/releases/download/$(curl --silent https://api.github.com/repos/docker/compose/releases/latest | jq .name -r)/docker-compose-$(uname -s)-$(uname -m) -o /usr/bin/docker-compose
    sudo chmod 755 /usr/bin/docker-compose
    echo -e "${CYAN}Docker Compose installed successfully.${NC}"
else
    echo -e "${CYAN}Docker Compose is already installed.${NC}"
fi

echo -e "${CYAN}docker-compose version${NC}"
docker-compose version

# Ritual 설치하기
echo -e "${CYAN}git clone https://github.com/ritual-net/infernet-container-starter${NC}"
git clone https://github.com/ritual-net/infernet-container-starter

echo -e "${CYAN}config.json 수정 중...${NC}"
json_1=~/infernet-container-starter/projects/hello-world/container/config.json

# jq를 사용하여 rpc_url 값을 수정하고 임시 파일에 저장
jq '.chain.rpc_url = "https://mainnet.base.org/"' $json_1 > temp.json

# temp.json을 원본 파일로 덮어쓰고 임시 파일 삭제
mv temp.json $json_1 && rm -f temp.json

echo -e "${CYAN}rpc_url has been updated to https://mainnet.base.org/ in config.json${NC}"

echo -e "${MAGENTA}${BOLD}'cd ~/infernet-container-starter'를 입력하고, 'screen -S ritual', 입력후에 'project=hello-world make deploy-container' 입력${NC}"
echo -e "${MAGENTA}${BOLD}큰 초록 RITUAL을 보면 컨트롤+A+D로 종료.${NC}"
}

install_ritual_2() {

# 사용자로부터 새로운 RPC URL과 Private Key 입력 받기
echo -ne "${BOLD}${MAGENTA}새로운 RPC URL을 입력하세요: ${NC}"
read -e rpc_url1

echo -ne "${BOLD}${MAGENTA}새로운 Private Key를 입력하세요(앞에 0x붙이세요): ${NC}"
read -e private_key1

# 수정할 파일 경로
json_1=~/infernet-container-starter/deploy/config.json
json_2=~/infernet-container-starter/projects/hello-world/container/config.json

# 임시 파일 생성
temp_file=$(mktemp)

# jq를 사용하여 RPC URL과 Private Key를 수정하고 임시 파일에 저장
jq --arg rpc "$rpc_url1" --arg priv "$private_key1" \
    '.chain.rpc_url = $rpc |
     .chain.wallet.private_key = $priv |
     .containers[0].image = "ritualnetwork/hello-world-infernet:1.2.0" |
     .chain.snapshot_sync.sleep = 3 |
     .chain.snapshot_sync.batch_size = 9500' $json_2 > $temp_file

# temp_file을 원본 파일로 덮어쓰고 임시 파일 삭제
mv $temp_file $json_1

# 두 번째 파일에도 같은 변경 사항 적용
jq --arg rpc "$rpc_url1" --arg priv "$private_key1" \
    '.chain.rpc_url = $rpc |
     .chain.wallet.private_key = $priv |
     .containers[0].image = "ritualnetwork/hello-world-infernet:1.2.0" |
     .chain.snapshot_sync.sleep = 3 |
     .chain.snapshot_sync.batch_size = 9500' $json_2 > $temp_file

mv $temp_file $json_2

# 임시 파일 삭제
rm -f $temp_file

echo -e "${BOLD}${MAGENTA}RPC URL and Private key have been updated${NC}"

# 수정할 파일 경로
makefile=~/infernet-container-starter/projects/hello-world/contracts/Makefile 

# sed 명령어를 사용하여 sender와 RPC_URL 값을 수정
sed -i "s|sender := .*|sender := $private_key1|" "$makefile"
sed -i "s|RPC_URL := .*|RPC_URL := $rpc_url1|" "$makefile"

echo -e "${BOLD}${CYAN}Makefile has been updated${NC}"

# deploy.s.sol 수정하기
deploy_s_sol=~/infernet-container-starter/projects/hello-world/contracts/script/Deploy.s.sol
old_registry="0x663F3ad617193148711d28f5334eE4Ed07016602"
new_registry="0x3B1554f346DFe5c482Bb4BA31b880c1C18412170"

echo -e "${CYAN}deploy.s.sol 수정 완료${NC}"
sed "s/$old_registry/$new_registry/" "$deploy_s_sol" | sudo tee "$deploy_s_sol" > /dev/null

# docker-compose_yaml 설정하기
docker_yaml=~/infernet-container-starter/deploy/docker-compose.yaml
sed -i 's/image: ritualnetwork\/infernet-node:1.0.0/image: ritualnetwork\/infernet-node:1.2.0/' "$docker_yaml"
echo -e "${BOLD}${CYAN}docker-compose.yaml has been updated to 1.2.0${NC}"

echo -e "${CYAN}docker compose down${NC}"
cd $HOME/infernet-container-starter/deploy
docker compose down

echo -e "${BOLD}${MAGENTA}docker ps${NC}"
docker ps

echo -e "${BOLD}${MAGENTA}이제 터미널에 'cd ~/infernet-container-starter/deploy && docker compose up'을 입력하세요${NC}"
echo -e "${BOLD}${MAGENTA}명령어를 입력하고 문구들이 주르륵 나오면 아무런 키도 누르지 말고 터미널을 종료한 뒤, 새로운 터미널을 켜서 다시 콘타보에 로그인하세요${NC}"
}

install_ritual_3() {
# foundry 설치하기
echo -e "${CYAN}cd $HOME${NC}"
cd $HOME

echo -e "${CYAN}mkdir foundry${NC}"
mkdir foundry

echo -e "${CYAN}cd $HOME/foundry${NC}"
cd $HOME/foundry

echo -e "${CYAN}curl -L https://foundry.paradigm.xyz | bash${NC}"
curl -L https://foundry.paradigm.xyz | bash

export PATH="/root/.foundry/bin:$PATH"

echo -e "${CYAN}source ~/.bashrc${NC}"
source ~/.bashrc

echo -e "${CYAN}foundryup${NC}"
foundryup

echo -e "${CYAN}cd ~/infernet-container-starter/projects/hello-world/contracts${NC}"
cd ~/infernet-container-starter/projects/hello-world/contracts

echo -e "${CYAN}rm -rf lib${NC}"
rm -rf lib

echo -e "${CYAN}forge install --no-commit foundry-rs/forge-std${NC}"
forge install --no-commit foundry-rs/forge-std

echo -e "${CYAN}forge install --no-commit ritual-net/infernet-sdk${NC}"
forge install --no-commit ritual-net/infernet-sdk

export PATH="/root/.foundry/bin:$PATH"

# 최종 계약하기
echo -e "${CYAN}cd $HOME/infernet-container-starter${NC}"
cd $HOME/infernet-container-starter

echo -e "${CYAN}project=hello-world make deploy-contracts${NC}"
project=hello-world make deploy-contracts

# call-contract 수정하기
echo -e "${CYAN}스크롤 위로 올려서 Logs 확인${NC}"
echo -ne "${CYAN}deployed Sayshello 정확히 입력 Sayshello: ${NC}"
read -e says_gm

callcontractpath="$HOME/infernet-container-starter/projects/hello-world/contracts/script/CallContract.s.sol"

echo -e "${CYAN}/root/infernet-container-starter/projects/hello-world/contracts/script/CallContract.s.sol 수정${NC}"
sed "s|SaysGM saysGm = SaysGM(.*)|SaysGM saysGm = SaysGM($says_gm)|" "$callcontractpath" | sudo tee "$callcontractpath" > /dev/null

# 계약 완료하기
echo -e "${CYAN}project=hello-world make call-contract${NC}"
project=hello-world make call-contract

echo -e "${BOLD}${MAGENTA}리츄얼 설치가 완료됐습니다. 수고하셨습니다. (솔직히 님들이 무슨 수고를 함? 수고는 내가 한 거 아닌가 ㅋㅋ;;)${NC}"
}

restart_ritual() {
echo -e "${CYAN}docker compose down${NC}"
cd $HOME/infernet-container-starter/deploy
docker compose down

echo -e "${BOLD}${MAGENTA}docker ps${NC}"
docker ps

echo -e "${BOLD}${MAGENTA}이제 터미널에 'cd ~/infernet-container-starter/deploy && docker compose up'을 입력하세요${NC}"
echo -e "${BOLD}${MAGENTA}명령어를 입력하고 문구들이 주르륵 나오면 아무런 키도 누르지 말고 터미널을 종료하세요${NC}"
}

change_Wallet_Address() {
# 사용자로부터 새로운 Private key 입력받기
echo -ne "${BOLD}${MAGENTA}새로운 Private Key를 입력하세요(앞에 0x붙이세요): ${NC}"
read -e private_key1

# 수정할 파일 경로
json_1=~/infernet-container-starter/deploy/config.json
json_2=~/infernet-container-starter/projects/hello-world/container/confi
makefile=~/infernet-container-starter/projects/hello-world/contracts/Makefile 

# 임시 파일 생성
temp_file=$(mktemp)

# jq를 사용하여 RPC URL과 Private Key를 수정하고 임시 파일에 저장
jq --arg priv "$private_key1" \
	'.chain.wallet.private_key = $priv' $json_1 > $temp_file

# temp_file을 원본 파일로 덮어쓰고 임시 파일 삭제
mv $temp_file $json_1

# 두 번째 파일에도 같은 변경 사항 적용
jq --arg priv "$private_key1" \
	'.chain.wallet.private_key = $priv' $json_2 > $temp_file

mv $temp_file $json_2

# 임시 파일 삭제
rm -f $temp_file

echo -e "${BOLD}${MAGENTA} Private key has been updated ${NC}"

# sed 명령어를 사용하여 sender의 값을 수정
sed -i "s|sender := .*|sender := $private_key1|" "$makefile"

echo -e "${BOLD}${MAGENTA} makefile's Private Key has been updated ${NC}"

# 계약 다시 하기
echo -e "${CYAN}cd $HOME/infernet-container-starter${NC}"
cd $HOME/infernet-container-starter

echo -e "${CYAN}project=hello-world make deploy-contracts${NC}"
project=hello-world make deploy-contracts

# call-contract 수정하기
echo -e "${CYAN}스크롤 위로 올려서 Logs 확인${NC}"
echo -ne "${CYAN}deployed Sayshello 정확히 입력 Sayshello: ${NC}"
read -e says_gm

callcontractpath="$HOME/infernet-container-starter/projects/hello-world/contracts/script/CallContract.s.sol"

echo -e "${CYAN}/root/infernet-container-starter/projects/hello-world/contracts/script/CallContract.s.sol 수정${NC}"
sed "s|SaysGM saysGm = SaysGM(.*)|SaysGM saysGm = SaysGM($says_gm)|" "$callcontractpath" | sudo tee "$callcontractpath" > /dev/null

# 계약 완료하기
echo -e "${CYAN}project=hello-world make call-contract${NC}"
project=hello-world make call-contract

echo -e "${BOLD}$M{MAGENTA}지갑 주소 변경이 완료됐습니다.${NC}"
}

change_RPC_Address() {
# 사용자로부터 새로운 RPC URL 입력받기
echo -ne "${BOLD}${MAGENTA}새로운 RPC URL을 입력하세요: ${NC}"
read -e rpc_url1

# 수정할 파일 경로
json_1=~/infernet-container-starter/deploy/config.json
json_2=~/infernet-container-starter/projects/hello-world/container/config.json
makefile=~/infernet-container-starter/projects/hello-world/contracts/Makefile 

# 임시 파일 생성
temp_file=$(mktemp)

# jq를 사용하여 RPC URL과 Private Key를 수정하고 임시 파일에 저장
jq --arg rpc "$rpc_url1" \
	'.chain.rpc_url = $rpc' $json_1 > $temp_file

# temp_file을 원본 파일로 덮어쓰고 임시 파일 삭제
mv $temp_file $json_1

# 두 번째 파일에도 같은 변경 사항 적용
jq --arg rpc "$rpc_url1" \
	'.chain.rpc_url = $rpc' $json_2 > $temp_file

mv $temp_file $json_2

# 임시 파일 삭제
rm -f $temp_file

echo -e "${BOLD}${MAGENTA} RPC URL has been updated ${NC}"

# sed 명령어를 사용하여 RPC_URL 값을 수정
sed -i "s|RPC_URL := .*|RPC_URL := $rpc_url1|" "$makefile"

echo -e "${BOLD}${MAGENTA} makefile's RPC URL has been updated ${NC}"

echo -e  "${CYAN}docker restart infernet-anvil${NC}"
docker restart infernet-anvil

echo -e  "${CYAN}docker restart hello-world${NC}"
docker restart hello-world

echo -e  "${CYAN}docker restart infernet-node${NC}"
docker restart infernet-node

echo -e  "${CYAN}docker restart deploy-fluentbit-1${NC}"
docker restart deploy-fluentbit-1

echo -e  "${CYAN}docker restart deploy-redis-1${NC}"
docker restart deploy-redis-1

echo -e "${BOLD}${MAGENTA} PRC URL 수정 완료. ${NC}"
echo -e "${BOLD}${MAGENTA} RPC URK 수정하고도 안 되면 명령어 다시 쳐서 4번 실행하삼 ${NC}"
}

update_ritual() {
echo -e "${BOLD}${RED} 리츄얼 업데이트(10/7) batch_size 업데이트 시작합니다.${NC}"

# 수정할 파일 경로
json_1=~/infernet-container-starter/deploy/config.json
json_2=~/infernet-container-starter/projects/hello-world/container/config.json

# 임시 파일 생성
temp_file=$(mktemp)

# jq를 사용하여 RPC URL과 Private Key를 수정하고 임시 파일에 저장
jq '.chain.snapshot_sync.batch_size = 9500' $json_1 > $temp_file

# temp_file을 원본 파일로 덮어쓰고 임시 파일 삭제
mv $temp_file $json_1

# 두 번째 파일에도 같은 변경 사항 적용
jq '.chain.snapshot_sync.batch_size = 9500' $json_2 > $temp_file

mv $temp_file $json_2

# 임시 파일 삭제
rm -f $temp_file

echo -e  "${CYAN}docker restart infernet-anvil${NC}"
docker restart infernet-anvil

echo -e  "${CYAN}docker restart hello-world${NC}"
docker restart hello-world

echo -e  "${CYAN}docker restart infernet-node${NC}"
docker restart infernet-node

echo -e  "${CYAN}docker restart deploy-fluentbit-1${NC}"
docker restart deploy-fluentbit-1

echo -e  "${CYAN}docker restart deploy-redis-1${NC}"
docker restart deploy-redis-1

echo -e "${BOLD}${MAGENTA} 리츄얼 업데이트 완료 ${NC}"
echo -e "${BOLD}${MAGENTA} 재시작 안 되면 재시작 명령어 4번 입력해서 실행하세요. ${NC}"
}

uninstall_ritual() {

# docker들 모두 삭제하기
echo -e "${BOLD}${CYAN}Remove Ritual dockers...${NC}"
docker stop infernet-anvil
docker stop infernet-node
docker stop hello-world
docker stop deploy-redis-1
docker stop deploy-fluentbit-1

docker rm -f infernet-anvil
docker rm -f infernet-node
docker rm -f hello-world
docker rm -f deploy-redis-1
docker rm -f deploy-fluentbit-1

echo -e "${BOLD}${CYAN}Removing ritual docker images...${NC}"
docker image ls -a | grep "infernet" | awk '{print $3}' | xargs docker rmi -f
docker image ls -a | grep "infernet" | awk '{print $3}' | xargs docker rmi -f
docker image ls -a | grep "fluent-bit" | awk '{print $3}' | xargs docker rmi -f

# foundry 파일 삭제하기
echo -e "${CYAN}rm -rf $HOME/foundry${NC}"
rm -rf $HOME/foundry

echo -e "${CYAN}sed -i '/\/root\/.foundry\/bin/d' ~/.bashrc${NC}"
sed -i '/\/root\/.foundry\/bin/d' ~/.bashrc

echo -e "${CYAN}rm -rf ~/infernet-container-starter/projects/hello-world/contracts/lib${NC}"
rm -rf ~/infernet-container-starter/projects/hello-world/contracts/lib

echo -e "${CYAN}forge clean${NC}"
forge clean

# 리츄얼 노드 파일 지우기
echo -e "${BOLD}${CYAN}Removing infernet-container-starter directory...${NC}"
cd $HOME
sudo rm -rf infernet-container-starter
cd $HOME

echo -e "${BOLD}${CYAN} Ritual Node와 관련된 파일들이 삭제됐습니다. 혹시 몰라서 도커 명령어는 삭제 안 했음 ㅎㅎ 다른 도커가 깔려있을 수도 있으니 ${NC}"
echo -e "${BOLD}${RED} 웬만하면 리츄얼 다시 깔겠다고 리인스톨 안 한 상태에서 명령어 다시 실행하진 마셈! 권장 안 함(해 보니까 되긴 하는데 뭔가 얼레벌레 되는 느낌) ${NC}"
}
# 메인 메뉴
echo && echo -e "${BOLD}${MAGENTA}Ritual Node 자동 설치 스크립트${NC} by 비욘세제발죽어
 ${CYAN}원하는 거 고르시고 실행하시고 그러세효. ${NC}
 ———————————————————————
 ${GREEN} 1. 기본파일 설치 및 Ritual Node 설치 1번 ${NC}
 ${GREEN} 2. Ritual Node 설치 2번 ${NC}
 ${GREEN} 3. Ritual Node 설치 3번(최종) ${NC}
 ${GREEN} 4. Ritual Node가 멈췄어요! 재시작하기 ${NC}
 ${GREEN} 5. Ritual Node의 지갑주소를 바꾸고 싶어요 ${NC}
 ${GREEN} 6. Ritual Node의 RPC 주소를 바꾸고 싶어요 ${NC}
 ${GREEN} 7. Ritual Node를 업데이트하고 싶어요(10월 7일자 업데이트) ${NC}
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
    uninstall_ritual
    ;;
*)
    echo -e "${BOLD}${RED}에휴씨발이제욕도하기싫음죽어버려그냥${NC}"
    ;;
esac