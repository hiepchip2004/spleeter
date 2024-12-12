# Sử dụng Python làm base image
FROM python:3.9-slim

# Cập nhật hệ thống và cài đặt ffmpeg
RUN apt-get update && apt-get install -y ffmpeg

# Thiết lập thư mục làm việc
WORKDIR 

# Copy file requirements.txt và cài đặt dependencies
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy toàn bộ mã nguồn vào container
COPY . .

# Mở cổng 3000 (dùng cho ứng dụng Flask)
EXPOSE 3000

# Chạy ứng dụng
CMD ["python", "main.py"]