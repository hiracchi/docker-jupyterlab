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
# setup packages
# -----------------------------------------------------------------------------
RUN set -x && \
    apt-get update && \
    apt-get install -y \
    build-essential git \
    python-dev python-pip \
    python3-dev python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# -----------------------------------------------------------------------------
# Node.js
# -----------------------------------------------------------------------------
RUN set -x && \
    curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get update && \
    apt-get install -y \
    nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# -----------------------------------------------------------------------------
# JupyterLab
# -----------------------------------------------------------------------------
RUN set -x && \
    pip3 install --no-cache-dir \
    jupyterlab

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
    ipywidgets 

RUN set -x && \
    jupyter labextension install @jupyter-widgets/jupyterlab-manager && \
    jupyter nbextension enable --py widgetsnbextension 

# nglview
RUN set -x && \
    pip3 install --no-cache-dir \
    nglview==${NGLVIEW_VER} \
    && \
    jupyter nbextension install --py nglview && \
    jupyter nbextension enable  --py nglview && \
    jupyter labextension install nglview-js-widgets

# MDAnalysis
RUN set -x && \
    pip3 install --no-cache-dir \
    MDAnalysis MDAnalysisTests

# 
RUN set -x && \
    jupyter labextension install @lckr/jupyterlab_variableinspector && \
    jupyter labextension install @jupyterlab/toc

RUN set -x && \
    pip3 install --no-cache-dir \
    jupyterlab-git && \
    jupyter labextension install @jupyterlab/git && \
    jupyter serverextension enable --py jupyterlab_git

# RUN set -x && \
#     pip3 install --no-cache-dir \
#     autopep8 jupyterlab_code_formatter && \
#     jupyter labextension install @ryantam626/jupyterlab_code_formatter && \
#     jupyter serverextension enable --py jupyterlab_code_formatter

# RUN set -x && \
#    pip install jupyterlab-nvdashboard && \
#    jupyter labextension install --py jupyterlab-nvdashboard

# -----------------------------------------------------------------------------
# setup dirs
# -----------------------------------------------------------------------------
RUN set -x && \
    mkdir -p "${WORKDIR}" && \
    chown -R ${USER_NAME}:${GROUP_NAME} ${WORKDIR} && \
    chmod 777 "${WORKDIR}"
WORKDIR ${WORKDIR}
ENV WORKDIR="${WORKDIR}"

# -----------------------------------------------------------------------------
# entrypoint
# -----------------------------------------------------------------------------
# ENV PATH="${PATH}:/home/${USER_NAME}/.local/bin"
VOLUME ${WORKDIR}
EXPOSE 8888

COPY scripts/* /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]
CMD ["/usr/local/bin/run-jupyterlab.sh"]
