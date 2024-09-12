FROM ubuntu:20.04

# OpenJDK 11
RUN apt-get update && \
    apt-get install -y software-properties-common openjdk-11-jdk && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64	
ENV PATH $JAVA_HOME/bin:$PATH

# Python 3.9.18
RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y python3.9 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
ENV PYTHON_HOME /usr/bin/python3.9
ENV PATH $PYTHON_HOME/bin:$PATH

# Additional tools and packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    build-essential \
    wget \
    dos2unix \
    libopenblas-dev \
    git \
    gcc \
    python3-pip \
    libxdamage1 \
    libgbm1 \
    libxkbcommon0 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Miniconda
RUN wget -P /tmp \
    "https://repo.anaconda.com/miniconda/Miniconda3-py39_24.7.1-0-Linux-x86_64.sh" \
    && bash /tmp/Miniconda3-py39_24.7.1-0-Linux-x86_64.sh -b -p /opt/conda \
    && rm /tmp/Miniconda3-py39_24.7.1-0-Linux-x86_64.sh
ENV PATH /opt/conda/bin:$PATH
RUN conda init bash

# Set up the working directory
WORKDIR /opt

# KNIME conda environment
COPY environment.yml .
RUN export CONDA_DEFAULT_ENV=KNIME && \
    conda env create -f environment.yml && \
    echo "conda run -n KNIME /bin/bash -c 'source activate KNIME'" >> ~/.bashrc && \
    export PATH=/opt/conda/envs/KNIME/bin:$PATH

# KNIME
ADD http://download.knime.org/analytics-platform/linux/knime_5.3.2.linux.gtk.x86_64.tar.gz .
RUN tar -xvf knime_5.3.2.linux.gtk.x86_64.tar.gz
RUN chmod +x /opt/knime_5.3.2/knime
RUN ln -s /opt/knime_5.3.2/knime /usr/local/bin/knime
RUN rm knime_5.3.2.linux.gtk.x86_64.tar.gz

# KNIME extensions
RUN knime -application org.eclipse.equinox.p2.director \
	 -consolelog \
	 -nosplash \
	 -r https://update.knime.com/analytics-platform/5.3/ \
	 -i org.knime.features.ext.weka_3.7.feature.group,org.knime.features.python2.feature.group,org.knime.features.python3.scripting.feature.group,org.knime.features.virtual.feature.group,org.knime.features.stats.feature.group,org.knime.features.stats2.feature.group,org.knime.features.mli.feature.group,org.knime.features.buildworkflows.feature.group,org.knime.features.ext.h2o.feature.group,org.knime.features.optimization.feature.group,org.knime.features.datageneration.feature.group,org.knime.features.xgboost.feature.group

RUN grep -qxF '-Dknime.python.connecttimeout=1728000000' /opt/knime_5.3.2/knime.ini || echo '-Dknime.python.connecttimeout=1728000000' >> /opt/knime_5.3.2/knime.ini
RUN grep -qxF '-Xmx180g' /opt/knime_5.3.2/knime.ini || echo '-Xmx180g' >> /opt/knime_5.3.2/knime.ini
RUN grep -qxF '-Dorg.eclipse.swt.browser.IEVersion=11001' /opt/knime_5.3.2/knime.ini || echo '-Dorg.eclipse.swt.browser.IEVersion=11001' >> /opt/knime_5.3.2/knime.ini
RUN grep -qxF '-Dsun.awt.noerasebackground=true' /opt/knime_5.3.2/knime.ini || echo '-Dsun.awt.noerasebackground=true' >> /opt/knime_5.3.2/knime.ini
RUN grep -qxF '-Dequinox.statechange.timeout=30000' /opt/knime_5.3.2/knime.ini || echo '-Dequinox.statechange.timeout=30000' >> /opt/knime_5.3.2/knime.ini

COPY knime_preferences.epf .
COPY classification-QSAR-bioKom.knwf .
COPY run_workflow.sh .
RUN dos2unix run_workflow.sh

CMD ["/bin/bash"]