# pull official base image
FROM python:3.11.4-slim-buster

# set work directory
WORKDIR /app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# install system dependencies
RUN apt-get update && apt-get install -y netcat

# install dependencies
RUN pip install --upgrade pip
COPY ./requirements.txt .
RUN pip install -r requirements.txt

# copy entrypoint.sh
COPY ./app/entrypoint.sh ./
RUN sed -i 's/\r$//g' /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# copy project
COPY ./app ./

# run entrypoint.sh
ENTRYPOINT ["/app/entrypoint.sh"]

# Tell what to do when it starts as a container
CMD ["uvicorn","dcrm.asgi:application","--host","0.0.0.0","--port","8000"]