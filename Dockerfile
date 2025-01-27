# Use the official Python image
FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /app

# Create a virtual environment
RUN python -m venv venv

# Activate the virtual environment
ENV PATH="/app/venv/bin:$PATH"

# Copy the requirements file and install Python dependencies
COPY requirements.txt /app/
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy the rest of the application code
COPY . /app/

# Expose port 8000
EXPOSE 8000

# Default command to run the application
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
