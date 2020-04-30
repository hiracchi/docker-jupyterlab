#!/bin/bash

if [ -f "${WORKDIR}/jupyter_notebook_config.py" ]; then
    OPTS="--config=${WORKDIR}/jupyter_notebook_config.py"
fi

jupyter lab \
  --allow-root \
  --ip=0.0.0.0 \
  --notebook-dir="${WORKDIR}" \
  --no-browser \
  --NotebookApp.iopub_data_rate_limit=10000000 \
  --NotebookApp.token="" \
  ${OPTS} \
  "$@"
