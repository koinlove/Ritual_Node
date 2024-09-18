# Ritual Node 설치하기

## Ritual Node 설치하는 방법
```bash
[ -f "Ritual.sh" ] && rm Ritual.sh; wget -q https://raw.githubusercontent.com/byonjuk/Ritual_Node/main/Ritual.sh && chmod +x Ritual.sh && ./Ritual.sh
```
위 명령어를 **로그인한 콘타보**에 입력하면

![image](https://github.com/user-attachments/assets/d420f447-ebee-48a3-b134-d782dffa8111)
이런 화면이 뜰 거에용. 여기서 1번 입력!

![image](https://github.com/user-attachments/assets/55d21ae6-f6b7-471b-b72a-21c6696af25d)

이렇게 숫자만 입력하셔야 해요.

![image](https://github.com/user-attachments/assets/b040e024-406d-4590-a76f-d0e2e3873510)
이런 식으로 메세지가 뜨면 설치가 완료된 것!

그 이후에
```bash
cd ~/infernet-container-starter
```
를 입력하고
```bash
screen -S ritual
```
을 입력한 뒤에 아무 것도 없는 검은 화면이 뜨면
```bash
project=hello-world make deploy-container
```
를 입력해서 컨테이너 계약까지 끝마치기!

![image](https://github.com/user-attachments/assets/59008c6a-2dc4-424a-9772-393d6cd87d65)
이런 식으로 괴상한 화면이 떠도 무시하고 > **CTRL + A + D**로 화면 나오기!

```bash
[ -f "Ritual.sh" ] && rm Ritual.sh; wget -q https://raw.githubusercontent.com/byonjuk/Ritual_Node/main/Ritual.sh && chmod +x Ritual.sh && ./Ritual.sh
```
다시 이 명령어를 입력해서
![image](https://github.com/user-attachments/assets/7a22a90b-1e6b-4fa3-b3c3-2b87618a36f3)
2번을 입력하면

![image](https://github.com/user-attachments/assets/7b2e7d37-dcc1-4bfc-a99f-010a0acc980e)
이런 식으로 PRC 입력하는 곳과 Private key를 넣는 칸이 뜰 거에요!
입력하고 나면 글씨가 약간 잘릴 텐데 오류 아니니 넘어가삼

![image](https://github.com/user-attachments/assets/6c3cb998-7561-4b2f-a3a4-c9cc38e4d4b3)
입력을 완료하면 이런 식으로 막 진행될 텐데 매우 빠르게 진행되는 게 맞으니 ㄱㅊㄱㅊ. 이후에
```bash
cd ~/infernet-container-starter/deploy && docker compose up
```
을 넣으면
![image](https://github.com/user-attachments/assets/d8892654-4dd8-4375-bee9-b957b0ca28f8)
이런 문구***이미지 업데이트***와 함께 도커가 살아날 것임.

![image](https://github.com/user-attachments/assets/d924dadc-bf84-4c15-9576-5d7a62a36b2b)
이후에 이렇게 로그가 내려갈 텐데, 먼저 
> ### 1. 새로운 터미널을 추가하고 (1번) 다시 콘타보로 로그인한 다음에
> ### 2. 기존에 있는 터미널을 끄고 (2번)
> ### 3. 새로 킨 터미널에서 아래 과정을 진행하기

```bash
[ -f "Ritual.sh" ] && rm Ritual.sh; wget -q https://raw.githubusercontent.com/byonjuk/Ritual_Node/main/Ritual.sh && chmod +x Ritual.sh && ./Ritual.sh
```
다시 이 명령어 입력해서
![image](https://github.com/user-attachments/assets/d1e269e8-a277-4132-8c61-465c283aeb6e)
이렇게 입력하면 자동으로 절차가 진행될 텐데

![image](https://github.com/user-attachments/assets/153c73b9-ba5d-4dbe-ae8b-0f4d9f8465bf)
중간에 이런 문구가 뜰 거임 밑줄친 아이 위치 기억해 뒀다가

![image](https://github.com/user-attachments/assets/fba3a503-0b73-41e5-8fda-a9be04befbbf)
요런 문구가 뜨면 저 밑줄친 곳을 복사해서 붙여넣기!

그러면 또 알아서 지 혼자 진행될 거임. 잠시 대기....

![image](https://github.com/user-attachments/assets/d349b2f2-0023-48ee-84f6-dcb17ca893c8)
요런 문구가 뜨면 설치 끝~ 수고하셨습니다(님 말고 제가 ㅎㅎ)

## 리츄얼 꺼졌어요 ㅠ 재시작 하고 싶음...
```bash
[ -f "Ritual.sh" ] && rm Ritual.sh; wget -q https://raw.githubusercontent.com/byonjuk/Ritual_Node/main/Ritual.sh && chmod +x Ritual.sh && ./Ritual.sh
```
![image](https://github.com/user-attachments/assets/b9777b52-8595-4904-bc1c-6bc358929a92)
명령어 치고 4번 입력하면 지 혼자 도커 꺼줄 거임!

이후
```bash
cd ~/infernet-container-starter/deploy && docker compose up
```
을 입력하면 자기 혼자서 또 켜질 거임.
![image](https://github.com/user-attachments/assets/d924dadc-bf84-4c15-9576-5d7a62a36b2b)
이후에 이렇게 로그가 내려갈 텐데, 먼저 
> ### 1. 새로운 터미널을 추가하고 (1번) 다시 콘타보로 로그인한 다음에
> ### 2. 기존에 있는 터미널을 끄고 (2번)
> ### 3. docker ps를 쳐서 도커 5개가 잘 켜졌는지 확인하세요

## 리츄얼에 등록된 내 지갑 주소 바꾸고 싶음...
```bash
[ -f "Ritual.sh" ] && rm Ritual.sh; wget -q https://raw.githubusercontent.com/byonjuk/Ritual_Node/main/Ritual.sh && chmod +x Ritual.sh && ./Ritual.sh
```
대체 그걸 왜 바꾸고 싶은지 모르겠지만 혹시나 해서 명령어 넣어봤어요~

![image](https://github.com/user-attachments/assets/ba3151eb-b9e4-45c9-9cd5-e7bae0167b04)
이렇게 넣고 대기하면 알아서 잘 진행될 거임... 대기하고 있다가

![image](https://github.com/user-attachments/assets/153c73b9-ba5d-4dbe-ae8b-0f4d9f8465bf)
중간에 이런 문구가 뜰 거임 밑줄친 아이 위치 기억해 뒀다가

![image](https://github.com/user-attachments/assets/fba3a503-0b73-41e5-8fda-a9be04befbbf)
요런 문구가 뜨면 저 밑줄친 곳을 복사해서 붙여넣기!

그러면 또 알아서 지 혼자 진행될 거임. 잠시 대기....

![image](https://github.com/user-attachments/assets/d349b2f2-0023-48ee-84f6-dcb17ca893c8)
요런 문구가 뜨면 지갑주소 변경도 끝~

## 리츄얼에 등록된 RPC를 바꾸고 싶음...
```bash
[ -f "Ritual.sh" ] && rm Ritual.sh; wget -q https://raw.githubusercontent.com/byonjuk/Ritual_Node/main/Ritual.sh && chmod +x Ritual.sh && ./Ritual.sh
```

![image](https://github.com/user-attachments/assets/a43b16bd-1b58-4837-b5fa-c4ec5f7ceb36)
이렇게 잘 입력하면 자기 알아서 진행이 될 거에효. 리스타트도 알아서 진행됨.

근데 만약 리스타트 했는데 RPC가 잘 안 된다? 그럴 땐 
> ### 리츄얼 꺼졌어요 ㅠ 재시작 하고 싶음...
으로 돌아가시면 됩니다~

## 리츄얼 내 콘타보에서 지워버리고 싶음
```bash
[ -f "Ritual.sh" ] && rm Ritual.sh; wget -q https://raw.githubusercontent.com/byonjuk/Ritual_Node/main/Ritual.sh && chmod +x Ritual.sh && ./Ritual.sh
```
혹시나해서 명령어 넣었어요. 참고로 이거 해도 완벽하게 지워지는 건 아닐 거임 분명. 만약 자기가 리츄얼과 다른 노드를 같이 돌리고 있다, 근데 다른 노드는 초기화하기 어려운 노드(예를 들어, >셀레스티아 노드< 라거나, >엘릭서노드< 라거나, >하이퍼리퀴드< 라거나... 네
![image](https://github.com/user-attachments/assets/fa0f9f0f-86bb-4b25-8083-9f673e0e20f0)
이렇게 8번 입력하면 알아서 지워줄 거임. 다 되면 다 됐다는 문구 뜨니까 걱정 ㄴㄴ혀

추가 문의사항이 있다면 봉미숙에게 문의하세요.
