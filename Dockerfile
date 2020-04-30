FROM hiracchi/ubuntu-ja:latest

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/hiracchi/docker-jupyterlab" \
    org.label-schema.version=$VERSION \
    maintainer="Toshiyuki Hirano <hiracchi@gmail.com>"

ARG NGLVIEW_VER=2.7.5
ARG WORKDIR="/work"

# -----------------------------------------------------------------------------
#setup packages
# -----------------------------------------------------------------------------
RUN set -x \
    && apt-get update \
    && apt-get install -y \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# -----------------------------------------------------------------------------
# System Python3
# -----------------------------------------------------------------------------
RUN set -x && \
    apt-get update && \
    apt-get install -y \
    build-essential \
    python3-dev python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# RUN set -x && \
#     pip3 install --no-cache-dir \
#     jupyter \
#     jupyter_contrib_nbextensions \
#     jupyter_nbextensions_configurator \
#     ipywidgets \
#     pytraj \
#     nglview==${NGLVIEW_VER}

# RUN set -x && \
#     jupyter contrib nbextension install && \
#     jupyter nbextensions_configurator enable && \
#     jupyter nbextension enable widgetsnbextension && \
#     jupyter-nbextension enable nglview


# -----------------------------------------------------------------------------
# for JupyterLab
# -----------------------------------------------------------------------------
RUN set -x && \
    curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get update && \
    apt-get install -y \
    nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN set -x && \
    pip3 install --no-cache-dir \
    jupyterlab

# jupyter labextension install @jupyter-widgets/jupyterlab-manager

# -----------------------------------------------------------------------------
# python packages
# -----------------------------------------------------------------------------
RUN set -x && \
    pip3 install --no-cache-dir \
    msgpack-python pyyaml \
    numpy scipy sympy pandas xlrd xlwt \
    matplotlib  bokeh \
    scikit-learn \
    h5py tqdm \
    requests beautifulsoup4

RUN set -x && \
    pip3 install --no-cache-dir \
    ipywidgets \
    nglview==${NGLVIEW_VER} && \
    nglview enable

RUN set -x && \
    jupyter labextension install @jupyter-widgets/jupyterlab-manager && \
    jupyter nbextension enable --py --sys-prefix widgetsnbextension && \
    jupyter labextension install  nglview-js-widgets

# -----------------------------------------------------------------------------
# setup dirs
# -----------------------------------------------------------------------------

#   && mv /root/.jupyter "${WORKDIR}" \
#   && ln -s "${WORKDIR}/.jupyter" /root/.jupyter


# -----------------------------------------------------------------------------
# entrypoint
# -----------------------------------------------------------------------------
# COPY jupyter_notebook_config.py /jupyter_notebook_config.py
RUN set -x && \
    mkdir -p "${WORKDIR}" && \
    chown -R ${USER_NAME}:${GROUP_NAME} ${WORKDIR} && \
    chmod 777 "${WORKDIR}"
WORKDIR ${WORKDIR}
ENV WORKDIR="${WORKDIR}"

VOLUME ${WORKDIR}
EXPOSE 8888

COPY scripts/* /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]
CMD ["/usr/local/bin/run-jupyterlab.sh"]
