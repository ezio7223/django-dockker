# Use an Ubuntu base image
FROM ubuntu:20.04

# Set environment variables to avoid Python writing .pyc files and enable unbuffered stdout
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install Python and dependencies
RUN apt-get update \
    && apt-get install -y \
    python3 \
    python3-pip \
    python3-dev \
    build-essential \
    libpq-dev \
    && apt-get clean

# Set the working directory inside the container
WORKDIR /app

# Copy requirements file and install dependencies
COPY requirements.txt /app/
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . /app/

# Expose the port the app will run on
EXPOSE 8000

# Default command to run the application
CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000"]
