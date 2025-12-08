# Julia + JupyterLab + Gridap + GridapGmsh + Gmsh.jl
FROM julia:1.11-bullseye

# System deps for JupyterLab
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-pip git ca-certificates tini \
 && rm -rf /var/lib/apt/lists/*

# Install JupyterLab via pip
RUN pip3 install --no-cache-dir jupyterlab

# Let IJulia use this Jupyter
ENV JUPYTER=/usr/local/bin/jupyter

# Preinstall Julia packages (Plots added here)
RUN julia -e 'using Pkg; Pkg.add(["IJulia","Gridap","GridapGmsh","Gmsh","Plots"]); Pkg.precompile()'

WORKDIR /work
EXPOSE 8888

# Start JupyterLab bound to all interfaces 
# Disable token/password, local use only.
ENTRYPOINT ["/usr/bin/tini","--"]
CMD ["jupyter","lab","--ip=0.0.0.0","--no-browser","--NotebookApp.token=","--NotebookApp.password=","--notebook-dir=/work"]


