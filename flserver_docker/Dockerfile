#FROM python:3.9-slim as base
#FROM tensorflow/tensorflow:2.10.0
#FROM fbarilla/arm64-tensorflow:latest
FROM sonoisa/deep-learning-coding:pytorch1.12.0_tensorflow2.9.1

RUN sudo apt-get update && sudo apt-get install -y jq

RUN pip install awscli

COPY examples /examples
WORKDIR /examples/advanced_tensorflow/
RUN pip install flwr==0.19.0
CMD ["./run_server.sh"]