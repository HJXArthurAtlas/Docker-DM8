FROM centos:7.9.2009
LABEL authors="hjxarthuratlas"

COPY .init /opt

ENV SYSDBA_PWD=SYSDBA001
ENV SYSAUDITOR_PWD=SYSAUDITOR001
ENV CASE_SENSITIVE=1
ENV CHARSET=1
ENV PAGE_SIZE=8
ENV EXTENT_SIZE=16

RUN export LANG=en_US.UTF-8 &&  \
    groupadd dinstall &&  \
    useradd -g dinstall -m -d /home/dmdba -s /bin/bash dmdba

WORKDIR /opt

RUN export LANG=en_US.UTF-8 && ./DMInstall.bin -i < run.txt

WORKDIR /opt/dmdbms/bin

RUN ./dminit \
      PATH=/opt/dmdbms/data  \
      SYSDBA_PWD=${SYSDBA_PWD}  \
      SYSAUDITOR_PWD=${SYSAUDITOR_PWD} \
      CASE_SENSITIVE=${CASE_SENSITIVE}  \
      CHARSET=${CHARSET}  \
      PAGE_SIZE=${PAGE_SIZE} \
      EXTENT_SIZE=${EXTENT_SIZE} && \
    rm /opt/DMInstall.bin /opt/run.txt

CMD ["/opt/dmdbms/bin/dmserver" , "path=/opt/dmdbms/data/DAMENG/dm.ini"]

