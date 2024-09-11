FROM osgeo/gdal:ubuntu-full-3.6.2

USER root

RUN rm -f /etc/apt/sources.list.d/*arrow* \
    && sed -i '/https:\/\/apache.jfrog.io\/artifactory\/arrow/ s/^/#/' /etc/apt/sources.list

# Install necessary system dependencies
RUN apt-get update && apt-get install -y \
    libpq-dev \
    python3-pip \
    build-essential

# Install Python libraries
RUN pip install --upgrade pip && \
    pip install pandas geopandas shapely sqlalchemy psycopg2-binary \
                matplotlib plotly keplergl scikit-learn rasterio seaborn

# Create necessary directories and set permissions
RUN mkdir -p /home/nobody/work /home/nobody/.local/share/jupyter && \
    chown -R nobody:nogroup /home/nobody && \
    chmod -R 777 /home/nobody/work

# Set the working directory to /home/nobody/work
WORKDIR /home/nobody/work

# Switch to the nobody user
USER nobody

# Set environment variables for the nobody user
ENV HOME=/home/nobody
ENV XDG_RUNTIME_DIR=/home/nobody/.local/share/jupyter

# Start Jupyter Notebook
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--no-browser", "--allow-root", "--NotebookApp.token=''"]