FROM python:3.10-bullseye

WORKDIR /app
COPY ./requirements.txt /app/requirements.txt

RUN pip install --no-cache-dir -r /app/requirements.txt

EXPOSE 8000

CMD ["otree", "prodserver", "8000"]
