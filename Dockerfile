# Use Python 3.8 as the base image
FROM python:3.8-slim

# Update and install necessary libraries
RUN apt-get update && apt-get install -y ffmpeg libavcodec-extra

# Upgrade pip to the latest version
RUN pip install --upgrade pip

# Set the working directory
WORKDIR /app

# Copy the requirements file and install dependencies
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Expose port 3000 for the Flask app
EXPOSE 3000

# Set environment variables to reduce TensorFlow resource usage
ENV TF_NUM_INTEROP_THREADS=1
ENV TF_NUM_INTRAOP_THREADS=1

# Run the application
CMD ["python", "app/app.py"]
