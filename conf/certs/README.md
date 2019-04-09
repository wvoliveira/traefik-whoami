# Generate wildcard cert

```bash
openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout wildcard.<domain>.com.br.key -out wildcard.<domain>.com.br.crt
chmod 600 wildcard.<domain>.com.br.key
chmod 644 wildcard.<domain>.com.br.crt
```
