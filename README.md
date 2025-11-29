# pfx2pem
<img src="https://img.shields.io/badge/PowerShell-000000?style=for-the-badge&logo=termius&logoColor=white"> 

PKCS#12(.pfx) 형식의 인증서를 개인 키와 함께 X.509(.crt, .pem) 형식의 인증서로 내보내는 Powershell 스크립트입니다.

## 시작하기
### OpenSSL 설치하기

Chocolatey가 설치 된 Windows에서 아래 명령을 입력하여 OpenSSL을 설치합니다:
```bash
choco install openssl
```

---
### 인증서 변환하기

스크립트가 있는 경로에서 Powershell을 열고 아래 명령을 입력하여 인증서 내보내기를 수행합니다:
```bash
./pfx2pem cert.pfx
```

PKCS#12 인증서의 암호를 입력하고 변환 결과를 확인합니다.
```bash
PS X:\certs> ./pfx2pem cert.pfx

Enter the passphrase for the PKCS#12 file: ****
Exporting PEM encoded certificate...
Exporting PKCS#8 private key...
Export completed.
Certificate: cert.crt
Private key: cert.key
PS X:\certs>
```
