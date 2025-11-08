#!/bin/bash
echo "=== Bắt đầu dịch vụ SSH ==="
service ssh start

# Đăng nhập vào Ngrok bằng token môi trường
ngrok config add-authtoken $NGROK_AUTH_TOKEN

# Tạo tunnel TCP (port 22)
ngrok tcp 22 --region ap > /dev/null &
sleep 5

# Hiển thị thông tin kết nối SSH
echo "=== Thông tin SSH của bạn ==="
curl -s localhost:4040/api/tunnels | grep -Eo "tcp://[0-9a-zA-Z.-]+:[0-9]+"

# Giữ container chạy bằng web service dummy
python3 -m http.server 8080
