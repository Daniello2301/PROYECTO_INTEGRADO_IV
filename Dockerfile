FROM python

COPY ./  /app

RUN pip install --upgrade pip && pip install -r /app/requirements.txt