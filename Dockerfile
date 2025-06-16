# FROM python:3.9

# WORKDIR /app/backend

# COPY requirements.txt /app/backend
# RUN apt-get update \
#     && apt-get upgrade -y \
#     && apt-get install -y gcc default-libmysqlclient-dev pkg-config \
#     && rm -rf /var/lib/apt/lists/*

# RUN pip install mysqlclient
# RUN pip install --no-cache-dir -r requirements.txt

# COPY . /app/backend

# EXPOSE 8000

# CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]


FROM amazonlinux:2023

# Install Python 3.9 and necessary build tools
RUN dnf install -y \
    python3.9 \
    python3.9-devel \
    gcc \
    git \
    mysql-devel \
    pkgconf-pkg-config \
    && dnf clean all

# Set Python and Pip aliases
RUN alternatives --install /usr/bin/python python /usr/bin/python3.9 1 \
    && alternatives --install /usr/bin/pip pip /usr/bin/pip3.9 1

# Upgrade pip
RUN pip install --upgrade pip

# Create app directory
WORKDIR /app/backend

# Copy requirements and install
COPY requirements.txt /app/backend

RUN pip install mysqlclient \
    && pip install --no-cache-dir -r requirements.txt

# Copy rest of the code
COPY . /app/backend

# Expose Django port
EXPOSE 8000

# Default command
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
