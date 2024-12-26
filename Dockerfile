# Use a specific Python version
FROM python:3.10-slim-buster

# Set the working directory inside the container
WORKDIR /src

# Copy the requirements.txt from the analytics folder
COPY ./analytics/requirements.txt requirements.txt

# Install the required Python packages
RUN pip install -r requirements.txt

# Copy the rest of the application files from the analytics folder
COPY ./analytics .

# Start the Flask application using python -m flask run
CMD python app.py