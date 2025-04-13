FROM rocker/tidyverse:4.4.2
WORKDIR /app

# System dependencies
RUN apt-get update
RUN apt-get update && apt-get install -y \
	cmake \
	build-essential \
	libcurl4-openssl-dev \
	libssl-dev \
	libxml2-dev \
	python3 \
	python3-pip \
	dos2unix \
	python3-venv \
	vim \
	&& rm -rf /var/lib/apt/lists/*

# Install venv tool, create venv, activate, then install python libraries
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip3 install --upgrade pip setuptools wheel
COPY requirements-linux.txt .
RUN pip3 install --no-cache-dir -r requirements-linux.txt

# Install renv and restore R packages
COPY renv.lock .
RUN R -e "install.packages('renv')"
RUN R -e "renv::restore(repos = c(CRAN = 'https://cloud.r-project.org'))"

# Copy rest of directory into container
COPY . .

# Convert run.sh script to unix endings so we can run it
RUN dos2unix run.sh

# Create a non-privileged user that the app will run under.
# See https://docs.docker.com/go/dockerfile-user-best-practices/
# ARG UID=10001
# RUN adduser \
#     --disabled-password \
#     --gecos "" \
#     --home "/nonexistent" \
#     --shell "/sbin/nologin" \
#     --no-create-home \
#     --uid "${UID}" \
#     appuser

# Switch to the non-privileged user to run the application.
# USER appuser

# Launch bash terminal
CMD ["/bin/bash"]
