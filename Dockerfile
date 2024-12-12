# Sử dụng Python 3.8 làm base image
FROM python:3.8-slim

# Cập nhật hệ thống và cài đặt ffmpeg, libavcodec-extra
RUN apt-get update && apt-get install -y ffmpeg libavcodec-extra

# Nâng cấp pip
RUN pip install --upgrade pip

WORKDIR /app

# Copy file requirements.txt và cài đặt dependencies
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy toàn bộ mã nguồn vào container
COPY . .

# Thiết lập biến môi trường để giảm mức sử dụng tài nguyên
ENV TF_NUM_INTEROP_THREADS=1
ENV TF_NUM_INTRAOP_THREADS=1

# Mở cổng 3000 (dùng cho ứng dụng Flask)
EXPOSE 3000

# Chạy ứng dụng
CMD ["python", "app/app.py"]
