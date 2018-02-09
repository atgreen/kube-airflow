# FROM rhscl/python-36-rhel7:latest
FROM centos/python-36-centos7:latest

MAINTAINER Anthony Green <green@redhat.com>

ARG AIRFLOW_VERSION=1.8.0.0
ENV AIRFLOW_HOME /opt/app-root/src

RUN ls -l /etc/scl/conf
RUN /usr/bin/scl enable rh-python35 true

RUN pip install pytz==2015.7 \
    && pip install cryptography \
    && pip install pyOpenSSL \
    && pip install ndg-httpsclient \
    && pip install pyasn1 \
    && pip install psycopg2-binary \
    && pip install airflow[celery,postgresql,hive]==$AIRFLOW_VERSION

ENV KUBECTL_VERSION %%KUBECTL_VERSION%%

RUN curl -L -o /opt/app-root/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl && chmod +x /opt/app-root/bin/kubectl

ADD script/entrypoint.sh ${AIRFLOW_HOME}/entrypoint.sh
ADD config/airflow.cfg ${AIRFLOW_HOME}/airflow.cfg

EXPOSE 8080 5555 8793

WORKDIR ${AIRFLOW_HOME}
ENTRYPOINT ["./entrypoint.sh"]
