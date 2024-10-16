# Use a base image with Java installed
FROM openjdk:11-jdk

# Install curl for downloading Ant and Ivy
RUN apt-get update && \
    apt-get install -y curl && \
    apt-get clean

# Download and install Ant 1.9.6
RUN curl -O https://archive.apache.org/dist/ant/binaries/apache-ant-1.9.6-bin.tar.gz && \
    tar -xzf apache-ant-1.9.6-bin.tar.gz -C /opt/ && \
    rm apache-ant-1.9.6-bin.tar.gz

# Set environment variables for Ant
ENV ANT_HOME=/opt/apache-ant-1.9.6
ENV PATH=$ANT_HOME/bin:$PATH

# Download and install Ivy 2.5.2 into Ant's lib directory using a mirror
RUN curl -O https://downloads.apache.org//ant/ivy/2.5.2/apache-ivy-2.5.2-bin.tar.gz && \
    tar -xzf apache-ivy-2.5.2-bin.tar.gz -C $ANT_HOME/lib/ --strip-components=1 && \
    mv $ANT_HOME/lib/ivy-2.5.2.jar $ANT_HOME/lib/ivy.jar && \
    rm apache-ivy-2.5.2-bin.tar.gz

# Set the working directory
WORKDIR /app

# Copy the project files
COPY . /app

# Build the project using Ant
RUN ant

# Default command for the container
CMD ["sh", "-c", "ls -l /app && cd dist && ls"]
