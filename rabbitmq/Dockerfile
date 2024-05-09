FROM rabbitmq:3.11.20-management

ENV RABBITMQ_SERVER_ADDITIONAL_ERL_ARGS="-rabbitmq_management load_definitions '/etc/rabbitmq/definitions.json'"

COPY --chown=rabbitmq definitions.json /etc/rabbitmq/

RUN rabbitmq-plugins enable --offline rabbitmq_management

