# Sử dụng Python phiên bản nhẹ
FROM python:3.9-slim

# Đặt biến môi trường để cải thiện logging và không tạo file .pyc
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Cài đặt công cụ cần thiết
RUN apt-get update && apt-get install -y ffmpeg && rm -rf /var/lib/apt/lists/*

# Thiết lập thư mục làm việc
WORKDIR /app

# Sao chép file requirements.txt vào container
COPY requirements.txt /app/

# Cài đặt các thư viện cần thiết
RUN pip install --no-cache-dir -r requirements.txt

# Sao chép mã nguồn vào container
COPY . /app

# Expose cổng 3000
EXPOSE 3000

# Lệnh để chạy ứng dụng Flask
CMD ["python", "app.py"]