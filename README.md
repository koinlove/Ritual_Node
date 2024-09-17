# Ritual Node 설치하기

## Ritual Node 설치하는 방법
```bash
[ -f "Ritual.sh" ] && rm Ritual.sh; wget -q https://raw.githubusercontent.com/byonjuk/Ritual_Node/main/Ritual.sh && chmod +x Ritual.sh && ./Ritual.sh
```
위 명령어를 **로그인한 콘타보**에 입력하면

![image](https://github.com/user-attachments/assets/5c37541e-0ed0-4a0d-a384-938f1fc5cb7b)
이런 화면이 뜰 거에용. 여기서 1번 입력!

![image](https://github.com/user-attachments/assets/7f6fad66-14e0-447a-b5af-53f5d4a8501f)
이렇게 숫자만 입력하셔야 해요.

![image](https://github.com/user-attachments/assets/3c742c16-6062-4664-9ed3-ee863478410f)
이런 식으로 메세지가 뜨면 설치가 완료된 것!

그 이후에
```bash
screen -S ritual
```
을 입력한 뒤에
```bash
project=hello-world make deploy-container
```
를 입력해서 컨테이너 계약까지 끝마치기!
