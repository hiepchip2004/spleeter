# Sử dụng hình ảnh Python chính thức
FROM python:3.9-slim

# Đặt biến môi trường để tránh tạo file .pyc và đảm bảo log được in ra console
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Cài đặt các công cụ cần thiết
RUN apt-get update && apt-get install -y ffmpeg && rm -rf /var/lib/apt/lists/*

# Tạo thư mục làm việc cho ứng dụng
WORKDIR /app

# Sao chép file requirements.txt và cài đặt các thư viện
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Sao chép mã nguồn vào container
COPY . /app/

# Expose cổng 3000 (hoặc cổng được Railway chỉ định)
EXPOSE 3000

# Lệnh để chạy ứng dụng Flask
CMD ["python", "app/app.py"]